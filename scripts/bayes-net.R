# =============================================================================
# Bayesian Network Analysis of Climate Change Belief System
# =============================================================================
# Companion analysis to GGM reported in the manuscript.
# Goal: (1) explore directed/causal structure among belief nodes;
#       (2) compare to undirected GGM as a robustness check.
#
# Data: quota-based U.S. survey, October 2017 (N = 1,409; complete N = 1,123)
# Variables: 17 composite belief nodes matching the GGM analysis
#
# Packages required:
#   bnlearn    -- structure learning and bootstrap stability
#   Rgraphviz  -- DAG visualization (via Bioconductor)
#   ggplot2    -- plotting centrality and edge stability
#   dplyr      -- data wrangling
#   mice       -- multiple imputation (sensitivity check)
#   tidyr      -- reshaping for plots
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Install / load packages
# -----------------------------------------------------------------------------

# Uncomment to install on first run:
#install.packages(c("bnlearn", "ggplot2", "dplyr", "mice", "tidyr"))
#if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("Rgraphviz")

library(bnlearn)
library(ggplot2)
library(dplyr)
library(mice)
library(tidyr)

# Rgraphviz is used only for plotting; load conditionally
has_rgraphviz <- requireNamespace("Rgraphviz", quietly = TRUE)
if (has_rgraphviz) library(Rgraphviz)


# -----------------------------------------------------------------------------
# 1. Load and prepare data
# -----------------------------------------------------------------------------

df_raw <- read.csv("data/beliefDataRep.csv", row.names = 1)
df_raw$nepScale <- round((df_raw$nep2+df_raw$nep3+df_raw$nep6)/3, 0)

# Select the 17 composite nodes that match the GGM
nodes <- c("hier", "egal", "indiv", "fatal",   # deep core: cultural worldviews
           "nepScale",                           # deep core: environmental orientation
           "ideology", "partisan",              # deep core: political beliefs
           "happening", "risk", "sciconsensus", # policy core: climate beliefs
           "IntAgree", "Renew", "Nuclear",      # secondary: policy preferences
           "Tax", "EPA", "CapTrade", "GeoEng")

df <- df_raw[, nodes]

cat("-- Data dimensions:", nrow(df), "rows,", ncol(df), "columns\n")
cat("-- Complete cases:", sum(complete.cases(df)), "\n")
cat("-- Missing by variable:\n")
print(colSums(is.na(df)))


# -----------------------------------------------------------------------------
# 2. Discretization
# -----------------------------------------------------------------------------
# bnlearn's score-based algorithms require discrete data (or Gaussian/mixed).
# Strategy:
#   - 1–7 ordinal scales  -> 3 ordered levels (low / mid / high)
#     using tertile-based cuts so each level has roughly equal frequency.
#   - 'happening' (-4 to 4) -> 3 levels (negative / neutral / positive)
#   - 'risk' (0–10)         -> 3 levels (low / moderate / high) at 0–3, 4–7, 8–10
#   - 'sciconsensus' (0/1)  -> 2 levels, kept as-is
#
# NOTE: Discretization loses information. The Gaussian assumption (see
# Section 6 below) is an alternative that avoids this tradeoff. Both
# approaches are run and compared.

discretize_tertile <- function(x) {
  all_labels <- c("low", "mid", "high")
  
  # Try tertile (equal-frequency) breaks first
  breaks <- unique(quantile(x, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE))
  
  # If tertiles collapse (skewed variable), fall back to equal-width breaks
  if (length(breaks) < 3) {
    breaks <- unique(seq(min(x, na.rm = TRUE),
                         max(x, na.rm = TRUE),
                         length.out = 4))
  }
  
  # Number of intervals = number of unique breaks minus 1
  n_intervals <- length(breaks) - 1
  labels <- all_labels[seq_len(n_intervals)]
  
  cut(x, breaks = breaks, labels = labels,
      include.lowest = TRUE, right = TRUE)
}

df_disc <- df %>%
  mutate(
    # 1–7 scales: tertile discretization
    across(c(hier, egal, indiv, fatal, nepScale,
             ideology, partisan,
             IntAgree, Renew, Nuclear, Tax, EPA, CapTrade, GeoEng),
           discretize_tertile),
    # happening: -4 to 4 -> negative / neutral / positive
    happening = cut(happening,
                    breaks = c(-5, -1, 1, 5),
                    labels = c("negative", "neutral", "positive"),
                    include.lowest = TRUE),
    # risk: 0–10 -> low (0-3) / moderate (4-7) / high (8-10)
    risk = cut(risk,
               breaks = c(-1, 3, 7, 11),
               labels = c("low", "moderate", "high"),
               include.lowest = TRUE),
    # sciconsensus: binary factor
    sciconsensus = factor(sciconsensus, levels = c(0, 1),
                          labels = c("no", "yes"))
  )

# Complete-case subset for main analysis
df_disc_cc <- df_disc[complete.cases(df_disc), ]
cat("\n-- Discretized complete cases:", nrow(df_disc_cc), "\n")

# Verify all columns are factors (required by bnlearn discrete learners)
stopifnot(all(sapply(df_disc_cc, is.factor)))


# -----------------------------------------------------------------------------
# 3. Define belief-type metadata
# -----------------------------------------------------------------------------
# Used for coloring plots and interpreting results

belief_type <- data.frame(
  node = nodes,
  type = c(rep("Deep Core", 7),          # hier, egal, indiv, fatal, nep, ideology, partisan
           rep("Policy Core", 3),         # happening, risk, sciconsensus
           rep("Secondary", 7)),          # policy preferences
  stringsAsFactors = FALSE
)

type_colors <- c("Deep Core" = "#2166ac",
                 "Policy Core" = "#4dac26",
                 "Secondary" = "#d6604d")


# -----------------------------------------------------------------------------
# 4. Structure learning — hill-climbing with BIC (main analysis)
# -----------------------------------------------------------------------------
# Hill-climbing (hc) is a score-based greedy search. BIC penalizes complexity
# and is the standard choice for this type of exploratory analysis.
#
# We also run the PC algorithm (constraint-based) for comparison; agreement
# between the two approaches increases confidence in recovered edges.

set.seed(42)

# 4a. Hill-climbing
dag_hc <- hc(df_disc_cc, score = "bic")
cat("\n-- HC DAG: arcs learned\n")
print(arcs(dag_hc))

# 4b. PC algorithm (constraint-based; uses conditional independence tests)
dag_pc <- pc.stable(df_disc_cc, test = "mi", alpha = 0.05)
cat("\n-- PC CPDAG: arcs learned\n")
print(arcs(dag_pc))

# 4c. Tabu search (alternative score-based; useful for checking HC stability)
dag_tabu <- tabu(df_disc_cc, score = "bic")
cat("\n-- Tabu DAG: arcs learned\n")
print(arcs(dag_tabu))


# -----------------------------------------------------------------------------
# 5. Bootstrap stability analysis
# -----------------------------------------------------------------------------
# We resample the data 500 times and re-learn the structure each time.
# The "strength" of an edge = proportion of bootstrap samples in which
# it appears. Edges with strength >= 0.50 are considered stable.
#
# This directly addresses R2's concern about robustness and also produces
# the averaged network (CPDAG) for reporting.

cat("\n-- Running bootstrap (500 resamples) — this may take a few minutes...\n")
set.seed(42)
boot_strength <- boot.strength(df_disc_cc,
                               R = 500,
                               algorithm = "hc",
                               algorithm.args = list(score = "bic"))

# Averaged network: keep edges with strength >= 0.50 and direction >= 0.50
avg_dag <- averaged.network(boot_strength, threshold = 0.50)

cat("\n-- Averaged DAG (threshold = 0.50): arcs\n")
print(arcs(avg_dag))

# Inspect full strength table — useful for manuscript reporting
cat("\n-- Edge strength summary (strength >= 0.30):\n")
boot_strength %>%
  filter(strength >= 0.30) %>%
  arrange(desc(strength)) %>%
  head(40) %>%
  print()


# -----------------------------------------------------------------------------
# 6. Gaussian BN (sensitivity check — avoids discretization)
# -----------------------------------------------------------------------------
# Treat all variables as continuous (Gaussian BN). This is an approximation
# for ordinal data but avoids information loss from discretization.
# sciconsensus (binary) is coerced to numeric 0/1.

df_gauss <- df %>%
  mutate(sciconsensus = as.numeric(sciconsensus)) %>%
  filter(complete.cases(.))

df_gauss[] <- lapply(df_gauss, as.numeric)

set.seed(42)
dag_gauss <- hc(df_gauss, score = "bic-g")
cat("\n-- Gaussian HC DAG: arcs\n")
print(arcs(dag_gauss))


# -----------------------------------------------------------------------------
# 7. Multiple imputation sensitivity check
# -----------------------------------------------------------------------------
# Re-run HC on 5 imputed datasets and pool arc frequencies.
# If the main results hold after imputation, missing data is not driving
# conclusions.

cat("\n-- Running multiple imputation (m = 5)...\n")
set.seed(42)
imp <- mice(df, m = 5, method = "pmm", printFlag = FALSE)

# Learn structure on each imputed dataset and collect arc strengths
imp_strengths <- lapply(1:5, function(i) {
  d <- complete(imp, i)
  # Discretize each imputed dataset
  d_disc <- d %>%
    mutate(
      across(c(hier, egal, indiv, fatal, nepScale,
               ideology, partisan,
               IntAgree, Renew, Nuclear, Tax, EPA, CapTrade, GeoEng),
             discretize_tertile),
      happening = cut(happening, breaks = c(-5,-1,1,5),
                      labels = c("negative","neutral","positive"),
                      include.lowest = TRUE),
      risk = cut(risk, breaks = c(-1,3,7,11),
                 labels = c("low","moderate","high"),
                 include.lowest = TRUE),
      sciconsensus = factor(sciconsensus, levels = c(0,1), labels = c("no","yes"))
    )
  hc(d_disc, score = "bic")
})

# Summarize: how often does each arc appear across imputed datasets?
all_arcs_imp <- bind_rows(lapply(imp_strengths, function(dag) {
  as.data.frame(arcs(dag))
})) %>%
  count(from, to, name = "freq") %>%
  mutate(prop = freq / 5) %>%
  arrange(desc(prop))

cat("\n-- Arc frequency across 5 imputed datasets:\n")
print(head(all_arcs_imp, 40))


# -----------------------------------------------------------------------------
# 8. Node-level metrics: Markov blankets and in/out-degree
# -----------------------------------------------------------------------------
# In a DAG, the Markov blanket of a node (its parents, children, and
# co-parents) captures all the information needed to predict that node.
# Large Markov blankets indicate structurally important nodes — analogous
# to high centrality in the GGM.

cat("\n-- Markov blankets (averaged DAG):\n")
mb_sizes <- sapply(nodes, function(n) {
  tryCatch(length(mb(avg_dag, n)), error = function(e) NA_integer_)
})
mb_df <- data.frame(node = names(mb_sizes), mb_size = mb_sizes) %>%
  left_join(belief_type, by = "node") %>%
  arrange(desc(mb_size))
print(mb_df)

cat("\n-- In-degree and out-degree (averaged DAG):\n")
degree_df <- data.frame(
  node     = nodes,
  in_deg   = sapply(nodes, function(n) sum(arcs(avg_dag)[, "to"] == n)),
  out_deg  = sapply(nodes, function(n) sum(arcs(avg_dag)[, "from"] == n))
) %>%
  mutate(total_deg = in_deg + out_deg) %>%
  left_join(belief_type, by = "node") %>%
  arrange(desc(total_deg))
print(degree_df)


# -----------------------------------------------------------------------------
# 9. Visualizations
# -----------------------------------------------------------------------------

# ---- 9a. Averaged DAG plot (base Rgraphviz) ---------------------------------

if (has_rgraphviz) {
  # graphviz.plot does not support per-node fill via highlight$fill.
  # Instead, build a graphNEL object and set node attributes manually.
  g <- bnlearn::as.graphNEL(avg_dag)

  node_fill <- setNames(
    type_colors[belief_type$type[match(nodes, belief_type$node)]],
    nodes
  )

  nAttrs <- list()
  nAttrs$fillcolor <- node_fill
  nAttrs$fontsize  <- setNames(rep("10", length(nodes)), nodes)

  graph::nodeRenderInfo(g) <- list(fill = node_fill)

  laid_out <- Rgraphviz::layoutGraph(g, layoutType = "dot")
  plot_attrs <- list(
    graph = list(main = "Averaged Bayesian Network (threshold = 0.50)"),
    node  = list(shape = "ellipse", fixedsize = FALSE)
  )

  Rgraphviz::renderGraph(laid_out, nodeAttrs = nAttrs, attrs = plot_attrs)

  png("outputs/bn_dag.png", width = 2400, height = 2000, res = 300)
  Rgraphviz::renderGraph(laid_out, nodeAttrs = nAttrs, attrs = plot_attrs)
  dev.off()
  cat("-- Saved: outputs/bn_dag.png\n")

  # Also save directly into manuscript/ (mirrors how centrality-measures.R
  # saves manuscript/centralPlots.png) so the qmd can reference it with a
  # plain relative path, avoiding cross-directory image-path resolution
  # issues between knitr (root.dir = project root) and pandoc/LaTeX (resolves
  # relative to the qmd's own directory).
  png("manuscript/bn_dag.png", width = 2400, height = 2000, res = 300)
  Rgraphviz::renderGraph(laid_out, nodeAttrs = nAttrs, attrs = plot_attrs)
  dev.off()
  cat("-- Saved: manuscript/bn_dag.png\n")
} else {
  message("Install Rgraphviz (BiocManager::install('Rgraphviz')) for DAG plot.")
}


# ---- 9b. Edge strength heatmap ----------------------------------------------
# Shows bootstrap stability for all edges with strength >= 0.20

p_heatmap <- boot_strength %>%
  filter(strength >= 0.20) %>%
  mutate(
    from_type = belief_type$type[match(from, belief_type$node)],
    to_type   = belief_type$type[match(to,   belief_type$node)]
  ) %>%
  ggplot(aes(x = reorder(to, strength),
             y = reorder(from, strength),
             fill = strength)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(strength, 2)), size = 2.8) +
  scale_fill_gradient2(low = "white", mid = "#fddbc7", high = "#d6604d",
                       midpoint = 0.5, limits = c(0.2, 1),
                       name = "Bootstrap\nstrength") +
  geom_hline(yintercept = 0.5, linetype = "dashed", color = "gray40") +
  labs(title = "Bootstrap Edge Stability",
       subtitle = "Proportion of 500 resamples in which edge appears (threshold ≥ 0.20)",
       x = "To (child node)", y = "From (parent node)") +
  theme_minimal(base_size = 11) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank())

print(p_heatmap)
ggsave("outputs/bn_edge_stability.png", p_heatmap, width = 10, height = 8, dpi = 300)


# ---- 9c. Node degree bar chart ----------------------------------------------

p_degree <- degree_df %>%
  pivot_longer(cols = c(in_deg, out_deg), names_to = "direction", values_to = "degree") %>%
  mutate(direction = recode(direction, in_deg = "In-degree", out_deg = "Out-degree"),
         degree_signed = ifelse(direction == "Out-degree", degree, -degree)) %>%
  ggplot(aes(x = reorder(node, total_deg), y = degree_signed, fill = type)) +
  geom_col() +
  geom_hline(yintercept = 0, color = "gray30") +
  coord_flip() +
  scale_fill_manual(values = type_colors, name = "Belief type") +
  scale_y_continuous(labels = abs,
                     breaks = seq(-6, 6, by = 2)) +
  annotate("text", x = 0.5, y = -1, label = "← In-degree", size = 3, color = "gray40") +
  annotate("text", x = 0.5, y =  1, label = "Out-degree →", size = 3, color = "gray40") +
  labs(title = "Node In- and Out-Degree (Averaged Bayesian Network)",
       subtitle = "Out-degree = node has directed edges TO others; In-degree = edges coming IN",
       x = NULL, y = "Degree") +
  theme_minimal(base_size = 11)

print(p_degree)
ggsave("outputs/bn_node_degree.png", p_degree, width = 9, height = 6, dpi = 300)


# ---- 9d. Markov blanket size bar chart --------------------------------------

p_mb <- mb_df %>%
  ggplot(aes(x = reorder(node, mb_size), y = mb_size, fill = type)) +
  geom_col() +
  coord_flip() +
  scale_fill_manual(values = type_colors, name = "Belief type") +
  labs(title = "Markov Blanket Size (Averaged Bayesian Network)",
       subtitle = "Larger blanket = node is more conditionally dependent on others",
       x = NULL, y = "Markov blanket size") +
  theme_minimal(base_size = 11)

print(p_mb)
ggsave("outputs/bn_markov_blanket.png", p_mb, width = 8, height = 5, dpi = 300)


# ---- 9e. GGM vs BN comparison table ----------------------------------------
# Loads centrality ranks saved by climate_ggm.R. Run that script first.

if (file.exists("data/ggm_centrality_table.csv")) {
  ggm_ranks <- read.csv("data/ggm_centrality_table.csv") %>%
    select(node, ggm_between = rank_between,
           ggm_closeness = rank_close,
           ggm_strength  = rank_strength)
  cat("-- Loaded GGM centrality ranks from data/ggm_centrality_table.csv\n")
} else {
  message("data/ggm_centrality_table.csv not found. Run climate_ggm.R first, or ",
          "enter ranks manually here.")
  ggm_ranks <- data.frame(node = nodes,
                           ggm_between   = NA_integer_,
                           ggm_closeness = NA_integer_,
                           ggm_strength  = NA_integer_)
}

comparison <- degree_df %>%
  select(node, type, in_deg, out_deg, total_deg) %>%
  left_join(mb_df %>% select(node, mb_size), by = "node") %>%
  left_join(ggm_ranks, by = "node") %>%
  arrange(desc(total_deg))

cat("\n-- GGM vs BN comparison:\n")
print(comparison)


# -----------------------------------------------------------------------------
# 10. Fit assessment
# -----------------------------------------------------------------------------
# Fit the parameters of the averaged DAG on the complete-case data.
# This allows computation of log-likelihood and BIC for the final structure.

fitted_bn <- bn.fit(avg_dag, data = df_disc_cc)

cat("\n-- Fitted BN: conditional probability tables for selected nodes\n")
cat("   (egalitarianism — deep core belief):\n")
print(fitted_bn$egal)
cat("   (EPA — secondary belief with highest GGM strength):\n")
print(fitted_bn$EPA)

# BIC score of the final averaged network
bic_score <- score(avg_dag, data = df_disc_cc, type = "bic")
cat("\n-- BIC score of averaged network:", round(bic_score, 2), "\n")


# -----------------------------------------------------------------------------
# 11. Formal comparison: HC vs Tabu vs PC
# -----------------------------------------------------------------------------
# Count arc agreement across the three algorithms.
# High agreement = more confidence in recovered structure.

arcs_hc   <- as.data.frame(arcs(dag_hc))   %>% mutate(method = "HC")
arcs_tabu <- as.data.frame(arcs(dag_tabu)) %>% mutate(method = "Tabu")
arcs_pc   <- as.data.frame(arcs(dag_pc))   %>% mutate(method = "PC")

all_arcs <- bind_rows(arcs_hc, arcs_tabu, arcs_pc)

consensus_arcs <- all_arcs %>%
  count(from, to) %>%
  filter(n == 3) %>%
  arrange(from, to)

cat("\n-- Arcs agreed upon by all three algorithms (HC, Tabu, PC):\n")
print(consensus_arcs)

one_method <- all_arcs %>%
  count(from, to) %>%
  filter(n == 1)
cat("\n-- Arcs found by only one algorithm (weakest evidence):", nrow(one_method), "\n")


# -----------------------------------------------------------------------------
# 12. Summary output for manuscript
# -----------------------------------------------------------------------------

cat("\n", strrep("=", 70), "\n")
cat("SUMMARY FOR MANUSCRIPT\n")
cat(strrep("=", 70), "\n\n")

cat("Sample:\n")
cat("  Total N =", nrow(df), " | Complete cases =", nrow(df_disc_cc), "\n\n")

cat("Structure learning algorithms:\n")
cat("  HC (BIC):    ", nrow(arcs(dag_hc)),   "arcs\n")
cat("  Tabu (BIC):  ", nrow(arcs(dag_tabu)), "arcs\n")
cat("  PC (MI):     ", nrow(arcs(dag_pc)),   "arcs\n")
cat("  Gaussian HC: ", nrow(arcs(dag_gauss)),"arcs\n\n")

cat("Averaged network (bootstrap threshold = 0.50):\n")
cat("  Arcs retained:", nrow(arcs(avg_dag)), "\n\n")

cat("Nodes with highest out-degree (most 'parent-like'):\n")
print(head(degree_df %>% arrange(desc(out_deg)) %>% select(node, type, out_deg), 5))

cat("\nNodes with highest Markov blanket size:\n")
print(head(mb_df %>% arrange(desc(mb_size)) %>% select(node, type, mb_size), 5))

cat("\nConsensus arcs (all 3 algorithms):", nrow(consensus_arcs), "\n")
cat("\nImputation sensitivity: arcs stable across all 5 imputed datasets:\n")
print(all_arcs_imp %>% filter(prop == 1.0))

cat("\n", strrep("=", 70), "\n")
cat("Output files saved:\n")
cat("  bn_dag.png\n")
cat("  bn_edge_stability.png\n")
cat("  bn_node_degree.png\n")
cat("  bn_markov_blanket.png\n")
cat(strrep("=", 70), "\n")


# -----------------------------------------------------------------------------
# 13. Save summary results for the manuscript
# -----------------------------------------------------------------------------
# Bundles the objects the qmd needs to report the BN analysis without
# re-running the full structure-learning + bootstrap + imputation pipeline
# (~1-2 minutes) on every render, mirroring how the GGM's bootstrap results
# are cached in data/network_data_for_replication.RData.

bn_summary <- list(
  n_total         = nrow(df),
  n_complete      = nrow(df_disc_cc),
  n_arcs_hc       = nrow(arcs(dag_hc)),
  n_arcs_tabu     = nrow(arcs(dag_tabu)),
  n_arcs_pc       = nrow(arcs(dag_pc)),
  n_arcs_gauss    = nrow(arcs(dag_gauss)),
  n_arcs_avg      = nrow(arcs(avg_dag)),
  n_consensus     = nrow(consensus_arcs),
  n_imputation_stable = sum(all_arcs_imp$prop == 1.0),
  bic_score       = bic_score,
  degree_df       = degree_df,
  mb_df           = mb_df,
  comparison      = comparison,
  consensus_arcs  = consensus_arcs
)

save(bn_summary, file = "data/bn_results.RData")
cat("\n-- Saved: data/bn_results.RData (for manuscript reporting)\n")
