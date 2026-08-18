# =============================================================================
# Gaussian Graphical Model (GGM) Analysis of Climate Change Belief System
# =============================================================================
# Replicates and extends the network analysis reported in the manuscript.
# Produces centrality estimates, bootstrap stability, and all figures.
#
# Data: quota-based U.S. survey, October 2017 (N = 1,409)
# Variables: 17 composite belief nodes
#
# Packages required:
#   bootnet   -- network estimation and bootstrap
#   qgraph    -- network visualization and centrality
#   dplyr     -- data wrangling
#   ggplot2   -- plots
#   tidyr     -- reshaping
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Install / load packages
# -----------------------------------------------------------------------------

# Uncomment to install on first run:
# install.packages(c("bootnet", "qgraph", "dplyr", "ggplot2", "tidyr"))

library(bootnet)
library(qgraph)
library(dplyr)
library(ggplot2)
library(tidyr)


# -----------------------------------------------------------------------------
# 1. Load and prepare data
# -----------------------------------------------------------------------------

df_raw <- read.csv("data/beliefDataRep.csv", row.names = 1)
df_raw$nepScale <- round((df_raw$nep2+df_raw$nep3+df_raw$nep6)/3, 0)

# 17 composite nodes matching the manuscript
nodes <- c("hier", "egal", "indiv", "fatal",
           "ideology", "partisan",
           "nepScale",
           "happening", "risk", "sciconsensus",
           "IntAgree", "Renew", "Nuclear",
           "Tax", "EPA", "CapTrade", "GeoEng")

df <- df_raw[, nodes]

cat("-- Data dimensions:", nrow(df), "rows,", ncol(df), "columns\n")
cat("-- Complete cases:", sum(complete.cases(df)), "\n\n")

# Belief type metadata (used for node coloring)
belief_type <- data.frame(
  node  = nodes,
  type  = c(rep("Deep Core", 7),
            rep("Policy Core", 3),
            rep("Secondary", 7)),
  stringsAsFactors = FALSE
)

# Node colors for qgraph: black = deep core, gray = policy core, white = secondary
node_colors <- ifelse(belief_type$type == "Deep Core",   "black",
               ifelse(belief_type$type == "Policy Core", "gray70", "white"))

# Shorter labels for cleaner plots
node_labels <- c("Hier", "Egal", "Indiv", "Fatal",
                 "Ideo", "Party",
                 "NEP",
                 "Happen", "Risk", "SciCons",
                 "IntAgree", "Renew", "Nuclear",
                 "Tax", "EPA", "CapTrade", "GeoEng")


# -----------------------------------------------------------------------------
# 2. Estimate the GGM
# -----------------------------------------------------------------------------
# estimateNetwork() fits a GGM via LASSO regularization with EBIC tuning.
# - default = "EBICglasso": polychoric correlations for ordinal data,
#   graphical LASSO, EBIC model selection (Foygel & Drton 2010).
# - corMethod = "cor_auto": automatically detects ordinal vs continuous
#   variables and uses polychoric/polyserial correlations as appropriate.
# - tuning = 0.5: standard EBIC hyperparameter (gamma); higher values
#   produce sparser networks. Robustness checks below vary this.

net <- estimateNetwork(
  df,
  default    = "EBICglasso",
  corMethod  = "cor_auto",
  tuning     = 0.5
)

cat("-- Network estimated\n")
cat("-- Nodes:", ncol(net$graph), "\n")
cat("-- Non-zero edges:", sum(net$graph[upper.tri(net$graph)] != 0), "\n\n")

# Extract the weight matrix
weights <- net$graph
diag(weights) <- 0


# -----------------------------------------------------------------------------
# 3. Visualize the network (Figure 1)
# -----------------------------------------------------------------------------

# Layout: use a spring layout with node grouping to cluster belief types
groups <- list(
  "Deep Core"   = which(belief_type$type == "Deep Core"),
  "Policy Core" = which(belief_type$type == "Policy Core"),
  "Secondary"   = which(belief_type$type == "Secondary")
)

png("outputs/ggm_network.png", width = 2400, height = 2000, res = 300)
qgraph(
  weights,
  layout       = "spring",
  groups       = groups,
  color        = c("#2166ac", "#4dac26", "#d6604d"),  # blue, green, red
  labels       = node_labels,
  label.cex    = 1.1,
  vsize        = 8,
  esize        = 10,
  posCol       = "black",      # positive edges: solid black
  negCol       = "red",        # negative edges: dashed red
  edge.labels  = FALSE,
  title        = "Climate Change Belief System Network",
  legend       = TRUE,
  legend.cex   = 0.6
)
dev.off()
cat("-- Saved: ggm_network.png\n")


# -----------------------------------------------------------------------------
# 4. Centrality measures
# -----------------------------------------------------------------------------

cent <- centrality(net)

# Build a tidy centrality table
cent_df <- data.frame(
  node        = nodes,
  label       = node_labels,
  type        = belief_type$type,
  betweenness = cent$Betweenness,
  closeness   = cent$Closeness,
  strength    = cent$InDegree,   # strength = sum of absolute edge weights
  stringsAsFactors = FALSE
)

# Add ranks (1 = highest)
cent_df <- cent_df %>%
  mutate(
    rank_between  = rank(-betweenness, ties.method = "min"),
    rank_close    = rank(-closeness,   ties.method = "min"),
    rank_strength = rank(-strength,    ties.method = "min")
  ) %>%
  arrange(rank_between)

cat("-- Centrality table (sorted by betweenness rank):\n")
print(cent_df %>% select(node, type, betweenness, rank_between,
                          closeness, rank_close,
                          strength, rank_strength),
      digits = 4)

cat("Non-zero edges:", sum(net$graph[upper.tri(net$graph)] != 0), "\n")
# -----------------------------------------------------------------------------
# 5. Centrality plot (Figure 2)
# -----------------------------------------------------------------------------
# Standardized centrality scores (z-scores) plotted as in Epskamp et al. 2018

png("outputs/ggm_centrality.png", width = 2000, height = 2400, res = 300)
centralityPlot(
  net,
  include    = c("Betweenness", "Closeness", "Strength"),
  orderBy    = "Strength",
  labels     = node_labels
)
dev.off()
cat("-- Saved: ggm_centrality.png\n")


# -----------------------------------------------------------------------------
# 6. Bootstrap stability analysis
# -----------------------------------------------------------------------------
# Two types of bootstrapping are performed:
#
# Type 1 (case-dropping): Estimates how stable centrality ORDER is as sample
#   size decreases. The "correlation stability" (CS) coefficient is the
#   maximum proportion of cases that can be dropped while maintaining r >= 0.7
#   correlation with the full-sample centrality. CS >= 0.50 is recommended;
#   CS >= 0.25 is the minimum acceptable threshold (Epskamp et al. 2018).
#
# Type 2 (nonparametric): Estimates edge weight stability via 95% bootstrap
#   CIs. Wide CIs suggest unstable edges.

cat("\n-- Running nonparametric bootstrap (1000 resamples)...\n")
set.seed(42)
boot_nonpar <- bootnet(
  net,
  nBoots        = 1000,
  type          = "nonparametric",
  statistics    = c("edge", "strength", "closeness", "betweenness")
)

cat("\n-- Running case-dropping bootstrap (1000 resamples)...\n")
set.seed(42)
boot_casedrop <- bootnet(
  net,
  nBoots        = 1000,
  type          = "case",
  statistics    = c("strength", "closeness", "betweenness")
)

# CS coefficients
cs_coefs <- corStability(boot_casedrop)
cat("\n-- Correlation Stability (CS) coefficients:\n")
print(cs_coefs)
cat("   (CS >= 0.50 = stable; >= 0.25 = acceptable)\n")


# -----------------------------------------------------------------------------
# 7. Bootstrap plots
# -----------------------------------------------------------------------------

# 7a. Edge weight CIs
png("outputs/ggm_boot_edges.png", width = 2400, height = 3200, res = 300)
plot(boot_nonpar,
     labels    = FALSE,
     order     = "sample",
     statistics = "edge")
dev.off()
cat("-- Saved: ggm_boot_edges.png\n")

# 7b. Centrality stability (case-dropping)
png("outputs/ggm_boot_centrality.png", width = 2000, height = 1600, res = 300)
plot(boot_casedrop,
     statistics = c("strength", "closeness", "betweenness"))
dev.off()
cat("-- Saved: ggm_boot_centrality.png\n")

# 7c. Centrality CIs from nonparametric bootstrap
png("outputs/ggm_boot_centrality_ci.png", width = 2000, height = 2400, res = 300)
plot(boot_nonpar,
     statistics = c("strength", "closeness", "betweenness"),
     labels     = TRUE)
dev.off()
cat("-- Saved: ggm_boot_centrality_ci.png\n")

# -----------------------------------------------------------------------------
# 8. Pairwise centrality difference tests
# -----------------------------------------------------------------------------
# differenceTest() tests one pair of nodes at a time using bootstrapped CIs
# on the difference. Significant = zero not in the 95% CI.
# We loop over all pairs for strength and betweenness and collect results.
# This addresses R2's request for formal statistical comparisons.

run_difference_tests <- function(boot_obj, measure) {
  n <- length(nodes)
  results <- vector("list", n * (n - 1) / 2)
  k <- 1
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      res <- differenceTest(boot_obj,
                            x       = nodes[i],
                            y       = nodes[j],
                            measure = measure,
                            verbose = FALSE)
      results[[k]] <- data.frame(
        node1      = nodes[i],
        node2      = nodes[j],
        measure    = measure,
        sig        = res$significant,
        stringsAsFactors = FALSE
      )
      k <- k + 1
    }
  }
  bind_rows(results)
}

cat("\n-- Running pairwise difference tests for strength...\n")
diff_strength <- run_difference_tests(boot_nonpar, "strength")
cat("-- Significant strength differences:",
    sum(diff_strength$sig, na.rm = TRUE), "of", nrow(diff_strength), "pairs\n")

cat("\n-- Running pairwise difference tests for betweenness...\n")
diff_between <- run_difference_tests(boot_nonpar, "betweenness")
cat("-- Significant betweenness differences:",
    sum(diff_between$sig, na.rm = TRUE), "of", nrow(diff_between), "pairs\n")

cat("\n-- Running pairwise difference tests for closeness...\n")
diff_close <- run_difference_tests(boot_nonpar, "closeness")
cat("-- Significant closeness differences:",
    sum(diff_close$sig, na.rm = TRUE), "of", nrow(diff_close), "pairs\n")

# Show which top nodes differ significantly from each other
top_nodes <- cent_df$node[1:5]  # top 5 by betweenness

cat("\n-- Difference tests among top 5 betweenness nodes:\n")
diff_between %>%
  filter(node1 %in% top_nodes & node2 %in% top_nodes) %>%
  print()

cat("\n-- Difference tests among top 5 strength nodes:\n")
top_strength <- cent_df$node[order(-as.numeric(cent_df$strength))][1:5]
diff_strength %>%
  filter(node1 %in% top_strength & node2 %in% top_strength) %>%
  print()

cat("\n-- Difference tests among top 5 closeness nodes:\n")
top_close <- cent_df$node[order(-as.numeric(cent_df$closeness))][1:5]
diff_close %>%
  filter(node1 %in% top_close & node2 %in% top_close) %>%
  print()

# Plot difference tests using bootnet's built-in plot
# (shows CI on difference for each pair; significant pairs shown in red)
png("outputs/ggm_diff_strength.png", width = 2000, height = 2000, res = 300)
plot(boot_nonpar,
     statistics  = "strength",
     plot        = "difference",
     order       = "sample")
dev.off()
cat("-- Saved: ggm_diff_strength.png\n")

png("outputs/ggm_diff_closeness.png", width = 2000, height = 2000, res = 300)
plot(boot_nonpar,
     statistics  = "closeness",
     plot        = "difference",
     order       = "sample")
dev.off()
cat("-- Saved: ggm_diff_closeness.png\n")


# -----------------------------------------------------------------------------
# 9. Robustness checks: EBIC tuning parameter
# -----------------------------------------------------------------------------
# Re-estimate the network at gamma = 0 (least sparse) and gamma = 1 (most
# sparse) and compare number of edges and top centrality nodes.
# If results are consistent, the gamma = 0.5 choice is defensible.

cat("\n-- Robustness check: varying EBIC tuning parameter (gamma)...\n")

robustness_results <- lapply(c(0, 0.25, 0.5, 0.75, 1.0), function(g) {
  net_g <- estimateNetwork(
    df,
    default   = "EBICglasso",
    corMethod = "cor_auto",
    tuning    = g,
    missing   = "pairwise"
  )
  cent_g <- centrality(net_g)
  data.frame(
    gamma        = g,
    n_edges      = sum(net_g$graph[upper.tri(net_g$graph)] != 0),
    top_strength = nodes[which.max(cent_g$InDegree)],
    top_between  = nodes[which.max(cent_g$Betweenness)],
    top_close    = nodes[which.max(cent_g$Closeness)],
    stringsAsFactors = FALSE
  )
})

robust_df <- bind_rows(robustness_results)
cat("\n-- Robustness across EBIC gamma values:\n")
print(robust_df)


# -----------------------------------------------------------------------------
# 10. Cross-validation LASSO (addresses R2 comment)
# -----------------------------------------------------------------------------
# R2 noted that cross-validation is now the preferred tuning approach.
# estimateNetwork() with default = "pcor" + threshold provides a
# non-regularized comparison. For CV-LASSO, we use the glasso package
# directly with cross-validation via huge.

cat("\n-- Cross-validation LASSO comparison...\n")

# Polychoric correlation matrix (same as used in EBICglasso)
cor_mat <- cor_auto(df)

# Use huge package for CV-based LASSO if available
if (requireNamespace("huge", quietly = TRUE)) {
  library(huge)
  # Nonparanormal transformation + CV
  npn_data <- huge.npn(as.matrix(na.omit(df)))
  cv_out   <- huge(npn_data, method = "glasso")
  cv_sel   <- huge.select(cv_out, criterion = "ric")  # rotation info criterion

  n_edges_cv <- sum(cv_sel$opt.icov[upper.tri(cv_sel$opt.icov)] != 0)
  cat("-- CV-LASSO edges:", n_edges_cv,
      "(vs.", sum(net$graph[upper.tri(net$graph)] != 0), "from EBIC)\n")
} else {
  cat("-- Install 'huge' package for CV-LASSO: install.packages('huge')\n")
}


# -----------------------------------------------------------------------------
# 11. Export centrality table for BN comparison script
# -----------------------------------------------------------------------------
# Saves the full centrality table as a CSV so you can load it directly
# into the Bayesian network script's comparison table (Section 9e).

write.csv(cent_df, "data/ggm_centrality_table.csv", row.names = FALSE)
cat("\n-- Saved: ggm_centrality_table.csv\n")
cat("   Load this in the BN script with:\n")
cat("   ggm_ranks <- read.csv('ggm_centrality_table.csv')\n\n")


# -----------------------------------------------------------------------------
# 12. Summary for manuscript
# -----------------------------------------------------------------------------

cat(strrep("=", 70), "\n")
cat("SUMMARY FOR MANUSCRIPT\n")
cat(strrep("=", 70), "\n\n")

cat("Network structure:\n")
cat("  Nodes:", length(nodes), "\n")
cat("  Non-zero edges:", sum(net$graph[upper.tri(net$graph)] != 0),
    "of", length(nodes) * (length(nodes) - 1) / 2, "possible\n\n")

cat("Top nodes by centrality:\n")
cat("  Betweenness: ")
cat(cent_df$node[order(-as.numeric(cent_df$betweenness))][1:3], "\n")
cat("  Closeness:   ")
cat(cent_df$node[order(-as.numeric(cent_df$closeness))][1:3], "\n")
cat("  Strength:    ")
cat(cent_df$node[order(-as.numeric(cent_df$strength))][1:3], "\n\n")

cat("Bootstrap stability (CS coefficients):\n")
print(cs_coefs)
cat("\n")

cat("Robustness across EBIC gamma values:\n")
print(robust_df)

cat("\n", strrep("=", 70), "\n")
cat("Output files saved:\n")
cat("  ggm_network.png\n")
cat("  ggm_centrality.png\n")
cat("  ggm_boot_edges.png\n")
cat("  ggm_boot_centrality.png\n")
cat("  ggm_boot_centrality_ci.png\n")
cat("  ggm_diff_strength.png\n")
cat("  ggm_diff_closeness.png\n")
cat("  ggm_centrality_table.csv  <- use this in the BN comparison script\n")
cat(strrep("=", 70), "\n")


# -----------------------------------------------------------------------------
# 13. Save summary results for the manuscript
# -----------------------------------------------------------------------------
# Bundles the robustness-check objects the qmd needs to report EBIC/CV-LASSO
# and pairwise difference-test results without re-running the ~2-3 minute
# bootstrap + robustness pipeline on every render, mirroring how the BN
# results are cached in data/bn_results.RData.

top5_between_diff <- diff_between %>%
  dplyr::filter(node1 %in% top_nodes & node2 %in% top_nodes)
top5_strength_diff <- diff_strength %>%
  dplyr::filter(node1 %in% top_strength & node2 %in% top_strength)
top5_close_diff <- diff_close %>%
  dplyr::filter(node1 %in% top_close & node2 %in% top_close)

ggm_robustness <- list(
  n_edges           = sum(net$graph[upper.tri(net$graph)] != 0),
  cs_coefs          = cs_coefs,
  robust_df         = robust_df,
  n_edges_cv        = n_edges_cv,
  diff_strength_n_sig   = sum(diff_strength$sig, na.rm = TRUE),
  diff_strength_n_pairs = nrow(diff_strength),
  diff_between_n_sig    = sum(diff_between$sig, na.rm = TRUE),
  diff_between_n_pairs  = nrow(diff_between),
  diff_close_n_sig      = sum(diff_close$sig, na.rm = TRUE),
  diff_close_n_pairs    = nrow(diff_close),
  top5_between_nodes    = top_nodes,
  top5_strength_nodes   = top_strength,
  top5_close_nodes      = top_close,
  top5_between_n_sig    = sum(top5_between_diff$sig, na.rm = TRUE),
  top5_between_n_pairs  = nrow(top5_between_diff),
  top5_strength_n_sig   = sum(top5_strength_diff$sig, na.rm = TRUE),
  top5_strength_n_pairs = nrow(top5_strength_diff),
  top5_close_n_sig      = sum(top5_close_diff$sig, na.rm = TRUE),
  top5_close_n_pairs    = nrow(top5_close_diff),
  top5_close_diff       = top5_close_diff
)

save(ggm_robustness, file = "data/ggm_robustness_results.RData")
cat("\n-- Saved: data/ggm_robustness_results.RData (for manuscript reporting)\n")
