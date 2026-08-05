# =============================================================================
# manuscript-prep.R
# =============================================================================
# Reproduces the analysis objects/figures used by manuscript/climate-beliefs.qmd
# and its companion reviewer-response robustness checks, by sourcing the
# existing analysis scripts in dependency order. This file does not contain
# new analysis code itself -- it documents and runs the pipeline.
#
# Run from the project root (working directory = climate-beliefs/).
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Build the replication dataset
# -----------------------------------------------------------------------------
# data/nationalData.csv -> data/beliefDataRep.csv
source("scripts/create-dataset.R")

# -----------------------------------------------------------------------------
# 2. Main GGM + bootstrap centrality analysis (as reported in the manuscript)
# -----------------------------------------------------------------------------
# data/beliefDataRep.csv -> data/network_data_for_replication.RData
#                        -> manuscript/centralPlots.png
# The manuscript's own code chunks re-run the network estimation and load
# network_data_for_replication.RData directly, so this step just needs to
# have been run at least once (the .RData is checked into data/).
source("scripts/centrality-measures.R")

# -----------------------------------------------------------------------------
# 3. Extended GGM robustness checks (added for the R&R response)
# -----------------------------------------------------------------------------
# data/beliefDataRep.csv -> outputs/ggm_*.png, data/ggm_centrality_table.csv
# Bootstrap stability (CS coefficients), EBIC gamma sensitivity, CV-LASSO
# comparison, and pairwise centrality difference tests.
source("scripts/climate_ggm.R")

# -----------------------------------------------------------------------------
# 4. Bayesian network robustness check (added for the R&R response)
# -----------------------------------------------------------------------------
# data/beliefDataRep.csv -> outputs/bn_*.png
# Directed/causal-structure comparison via bnlearn; compares against the GGM
# centrality ranks in data/ggm_centrality_table.csv (step 3 above), so this
# must run after climate_ggm.R.
source("scripts/bayes-net.R")

# -----------------------------------------------------------------------------
# Not sourced here -- see LOG.md "Open Items"
# -----------------------------------------------------------------------------
# scripts/high-low-egal-graphs.R
#   Subgroup (low/high egalitarian, low/high risk) centrality comparison.
#   Depends on data/network_data_for_replication2.RData and ...3.RData,
#   which are not currently present -- the bootnet() calls that generate
#   them are commented out in the script. Regenerate those first.
