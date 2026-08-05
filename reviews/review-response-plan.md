# Response-to-Reviews Plan
## *The Centrality of Cultural Worldviews in the Climate Change Belief System Network*
by RA Claude


## Reviewer 1

### 1. Gateway Belief Model (GBM) — *Major*

This is the most substantive theoretical critique. R1 correctly identifies a mismatch: the GBM is a causal/interventional framework tested via experiments and longitudinal designs, but your study uses cross-sectional, undirected network data. Your current framing says the low centrality of *sciconsensus* provides "limited support" for H2 — R1 says that's too strong a claim.

**What to do:** Add a paragraph (in Discussion or Limitations) explicitly decoupling "structural centrality in a cross-sectional network" from "causal gateway status." Frame your finding positively: scientific consensus may not be *structurally embedded* at the core of the belief network, but this doesn't preclude it functioning as a causal lever under targeted informational interventions. Engage the three suggested papers — at least the 2022 pre-registered replication and the 2023 metacognition moderator paper, which together establish that the GBM's effects are conditional and context-dependent. This actually *strengthens* your paper by positioning it as complementary, not contradictory.

---

### 2. Temporal Relevance of 2017 Data — *Major*

R1 notes the paper cites work through the mid-2020s but the data are from 2017.

**What to do:** Add a paragraph in the Data section or Limitations justifying why 2017 data remain informative. Two angles: (a) structural properties of belief systems are theorized to be relatively stable over time — deep core beliefs like cultural worldviews are specifically characterized as resistant to change; (b) you can note that the key network studies you compare against (Verschoor et al. 2020; Lee et al. 2024) also use data from comparable or earlier periods. Acknowledge that the 2017 context (early Trump administration, pre-Paris-withdrawal debate) may have specific features and flag this as a limitation alongside calls for replication with newer data.

---

### 3. Centrality ≠ Causal Influence — *Major*

R1 flags language like "drive" and "shape" as unwarranted given the undirected, cross-sectional design.

**What to do:** Do a targeted word-search-and-replace pass on the manuscript. Replace causal language ("drives," "shapes," "influences") with structural language ("is associated with," "is central to," "connects"). Add a sentence in the Methods or Discussion noting that centrality reflects structural prominence, not causal direction, and that causal inference would require longitudinal or experimental designs.

---

### 4. Open Science / Transparency — *Major*

No preregistration statement, no power analysis, no data/code availability statement.

**What to do:** Add a brief transparency statement. If the study wasn't preregistered, say so explicitly (this is increasingly standard and reviewers appreciate honesty over silence). On data/code: if you can share the R code and (anonymized) survey data, do so and add a data availability statement. If not, explain why. Add robustness checks on the LASSO tuning parameter (see also R2 below).

---

### 5. Literature Review Focus and Hypothesis Precision — *Minor*

**What to do:** Consider restructuring the theory section so hierarchical and network perspectives are synthesized rather than presented as parallel alternatives. Tighten each hypothesis to specify which centrality metric(s) it pertains to — e.g., does H1 predict high betweenness, closeness, strength, or all three? R2 raises the same issue.

---

## Reviewer 2

### 1. Weak "One-Sentence Takeaway" / Laundry List of Findings — *Major*

R2 finds the paper lacks a single compelling takeaway and reads as a list: 3 hypotheses × many beliefs × 3 centrality measures.

**What to do:** This is a framing/rhetorical fix more than an analytical one. Identify your single strongest finding — arguably: *egalitarianism is the most structurally central belief by bridging metrics (betweenness, closeness), while EPA policy support dominates strength centrality, suggesting deep core and secondary beliefs serve distinct structural functions.* Build the abstract and discussion around that narrative. Consider streamlining results: either explain upfront what substantively different information each metric provides (with concrete interpretation), or acknowledge when they converge and focus on divergences.

---

### 2. Network Methodology vs. Hierarchy — *Major*

R2 questions whether rejecting a hierarchical structure is an artifact of using an undirected method. They raise Bayesian networks as an alternative.

**What to do:** You don't need to actually run a Bayes net, but you should address this directly in the Methods. Add a paragraph explaining why an undirected GGM was chosen (it's the standard for exploratory belief system network research; directed methods require strong theoretical priors on edge direction that don't yet exist for this belief set). Acknowledge the limitation: the undirected model cannot adjudicate between hierarchical and network structure by design. Frame your contribution as: the network approach reveals *which* beliefs are structurally prominent, which complements but doesn't replace hierarchical accounts. Also address the "fuzziness" point from R1 more directly — a network doesn't eliminate definitional fuzziness; it sidesteps the need to classify beliefs into hierarchical tiers before analysis.

---

### 3. Scientific Consensus Operationalization — *Moderate*

R2 notes your *sciconsensus* measure (a forced-choice agreement item) differs from the standard GBM operationalization (explicit "97% of scientists agree" framing).

**What to do:** Add a footnote or paragraph in the Measures section acknowledging this difference and discussing its implications. The standard operationalization arguably primes consensus; yours is more naturalistic. This could actually be framed as a contribution — you're testing whether consensus beliefs matter structurally even when not experimentally highlighted. But be explicit about the tradeoff.

---

### 4. LASSO Tuning / Cross-Validation — *Minor*

R2 notes cross-validation is now the preferred approach for LASSO tuning, and flags that 89 non-zero edges from 17 nodes seems high for a LASSO-regularized network.

**What to do:** Add a robustness check comparing EBIC-tuned results against cross-validated LASSO. If they produce substantially similar networks, report this in a footnote or supplement. If not, discuss what differs. Also briefly justify the EBIC choice (standard in the psychological network literature; Foygel & Drton 2010) while acknowledging CV as an alternative.

---

### 5. Statistical Tests for Centrality Comparisons — *Minor*

R2 asks for formal tests when comparing centrality values across nodes.

**What to do:** The bootstrapped CIs you already report partly address this. You could add explicit overlap tests (do the 95% CIs of the top nodes overlap?) or note that the bootstrap procedure provides the inferential basis for the comparisons you make. If egalitarianism's betweenness CI clearly doesn't overlap with the next node, say so explicitly.

---

## Summary Priority List

| Priority | Issue | Reviewer |
|---|---|---|
| 1 | Reframe GBM interpretation; cite new boundary-condition literature | R1 |
| 2 | Clarify structural vs. causal language throughout | R1, R2 |
| 3 | Develop a single clear narrative/takeaway; streamline results | R2 |
| 4 | Address undirected method's limits re: hierarchy; discuss Bayes net alternative | R2 |
| 5 | Justify 2017 data's continued relevance; add to Limitations | R1 |
| 6 | Add transparency/open science statement | R1 |
| 7 | Address *sciconsensus* operationalization difference | R2 |
| 8 | Add LASSO robustness check; formalize centrality comparisons | R2 |
