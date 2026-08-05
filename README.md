# The Centrality of Cultural Worldviews in the Climate Change Belief System Network

Manuscript and reproducible analysis examining the climate change belief system
as a network. Using original quota-based US survey data, the analysis fits a
Gaussian graphical model (GGM) over cultural worldviews, political ideology,
partisanship, environmental orientation, perceived scientific consensus, and
climate policy preferences, then compares betweenness, closeness, and strength
centrality to identify which beliefs are structurally most central.

**Status**: Major revision requested — response to reviewers in progress (see `reviews/`).

## Layout

```
climate-beliefs.Rproj
_quarto.yaml                         Quarto project config
renv.lock                             Pinned package versions (renv)
LOG.md                                Running session log (newest entry first)
manuscript/
  climate-beliefs.qmd                Manuscript source (renders to HTML, PDF, DOCX)
  custom-reference-doc.docx          Word reference template used for the DOCX output
  centralPlots.png                   Main centrality figure (tracked, used by the qmd)
  _output/                           Rendered HTML/PDF/DOCX (moved here manually after each render)
scripts/
  manuscript-prep.R                  Sources the analysis pipeline below in order
  create-dataset.R                   Builds data/beliefDataRep.csv from data/nationalData.csv
  centrality-measures.R              Main GGM + bootstrap centrality analysis (feeds the qmd)
  climate_ggm.R                      Extended GGM robustness checks (added for the R&R response)
  bayes-net.R                        Bayesian network robustness check, companion to the GGM
  high-low-egal-graphs.R             Subgroup centrality comparison (not yet standalone-reproducible)
  export-cited-refs.R                Pre-render step: trims the master .bib to cited keys
data/                                 Survey data and replication objects (tracked in git)
outputs/                              Figures from the GGM/Bayesian-network robustness checks
reviews/                              Decision letter, extracted reviews, response-to-reviewers plan
```

## Reproducing the analysis

Package versions are pinned with [`renv`](https://rstudio.github.io/renv/).
On a fresh clone, open the project in R (this triggers `renv/activate.R` via
`.Rprofile`) and run `renv::restore()` to install the exact versions recorded
in `renv.lock` (`bootnet` 1.8, `qgraph` 1.9.8, `bnlearn`, `huge`, `tidyverse`,
`egg`, `car`, `ppcor`, `modelsummary`, `networktools`,
`NetworkComparisonTest`, `psy`, and their dependencies) into an isolated
project-local library. This exists because a mid-2026 `dplyr`/`bootnet`
upgrade silently changed GGM edge-selection results (see `LOG.md` Session
11) — pinning versions keeps that from recurring.

- **Manuscript:** `quarto render` → HTML, PDF, and DOCX (the DOCX uses
  `manuscript/custom-reference-doc.docx`). Quarto writes these next to the
  qmd by default; move them into `manuscript/_output/` afterward (a project
  `output-dir` isn't used here — for a nested qmd like this one, Quarto
  mirrors the full source path under `output-dir`, which produced a
  duplicated `manuscript/_output/manuscript/...` nested path rather than a
  flat one, so this stays a manual step).
- **Analysis pipeline only:** `Rscript scripts/manuscript-prep.R` reproduces
  the replication dataset, the main GGM/centrality figures, and the extended
  robustness checks without rendering the manuscript.

## Data

The `data/` folder **is tracked in git** (this is the replication data
underlying a paper currently under review):

- `data/nationalData.csv` — raw survey data
- `data/beliefDataRep.csv` — derived replication dataset (built by `create-dataset.R`)
- `data/network_data_for_replication.RData` — bootstrap centrality object loaded directly by the manuscript
- `data/ggm_centrality_table.csv` — centrality ranks exported by `climate_ggm.R`
- `data/ggm_robustness_results.RData` — CS coefficients, EBIC gamma sweep, CV-LASSO, and pairwise difference-test results, cached by `climate_ggm.R` and loaded directly by the manuscript's "GGM Robustness Checks" section
- `data/bn_results.RData` — Bayesian-network robustness check results, cached by `bayes-net.R` and loaded directly by the manuscript
- `data/OCFnationalCodebook.docx`, `data/partial-correlations.docx` — codebook and supporting documentation

## Notes

- `references.bib` and the local `.csl` are generated at render time in
  `manuscript/` by the pre-render step (`export-cited-refs.R`) from the
  master bibliography, so they are git-ignored.
- Quarto's freeze cache (`_freeze/`) is enabled (`execute: freeze: auto` in
  `_quarto.yaml`), so code chunks are only re-executed when the qmd or its
  upstream R sources change.
- `LOG.md` records what changed and why for each work session; add a new
  entry at the top rather than editing manuscript prose notes into commit
  messages.
- See `LOG.md`'s "Open Items" for known loose ends (`high-low-egal-graphs.R`
  missing its intermediate bootstrap objects).
