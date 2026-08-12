# Response to Reviewers (DRAFT SKELETON)
## *What Beliefs are Central in the Climate Change Belief System Network?*
### (submitted as *The Centrality of Cultural Worldviews in the Climate Change Belief System Network*; retitled Session 22)

**Status**: All items now have manuscript prose or an explicit flagged
determination point. Every item R1-1 through R1-8 and R2-1 through R2-5 has
been incorporated as plain, final prose directly into
`manuscript/climate-beliefs.qmd` — none of it is still tagged `[DRAFT ...]`
or italicized (that convention, used through Session 20, has been fully
retired). As of Session 22, **R1-5 is fully resolved** (the user directed a
restructuring pass; see below) and **R2-4/R2-5's rank-claim-hedging
determination is also resolved** (the user directed the fix; see below). For
the remaining items where the prose makes a genuine judgment call — tone,
framing, or emphasis — user determinations are now in: **R1-6 and R2-3 were
confirmed as-is by the user** (no further edit needed), while **R1-4 and
R1-8 remain open**, marked with an in-source HTML comment
(`<!-- NEEDS YOUR DETERMINATION: ... -->`), invisible in all three rendered
formats, at the exact paragraph in question. One item (R1-7) remains an
open-ended trimming request with no specific target the user has not yet
acted on; it is still flagged (`<!-- FLAGGED, NOT EDITED: ... -->`) rather
than edited unilaterally.
See `reviews/review-response-plan.md` for the original point-by-point plan
this letter is built from, and `LOG.md` Sessions 13-21 for exactly what was
added and why, session by session.

> ℹ️ **Session 22 — R1-5 and R2-4/R2-5 resolved; manuscript retitled; BN
> methods citations expanded.** The user made a hands-on editing pass over
> the manuscript (retitling it, trimming/adding prose, and leaving inline
> comments with explicit instructions) and asked for those instructions to
> be carried out:
> - **R1-5** (literature review integration) — the "Belief Systems and
>   Belief System Networks" section was restructured to introduce the
>   hierarchical and network traditions together up front, then interleave
>   their treatment of deep core, policy core, and secondary beliefs
>   paragraph-by-paragraph, rather than presenting a full hierarchical block
>   followed by a full network block. All original citations were preserved.
>   See the R1-5 entry below for detail.
> - **R2-4/R2-5 rank-claim hedging** — the pairwise bootstrap difference-test
>   paragraph was moved out of "## GGM Robustness Checks" and into the main
>   centrality-results discussion, immediately after the betweenness/
>   closeness/strength paragraphs it qualifies. "Most central" language was
>   then softened throughout the Introduction, Results, and Discussion (e.g.,
>   "egalitarianism is the node with the highest betweenness centrality, by a
>   wide margin" → "...has the highest point estimate for betweenness
>   centrality") to reflect that top-ranked nodes are frequently not
>   statistically distinguishable from several others. See the R2-5 entry
>   below for detail.
> - **Manuscript retitled** from "The Centrality of Cultural Worldviews in
>   the Climate Change Belief System Network" to "What Beliefs are Central in
>   the Climate Change Belief System Network?" (user's own edit).
> - **BN methods citations expanded**: the companion Bayesian-network Methods
>   paragraph, previously citing only `@scutariLearningBayesianNetworks2010`,
>   now also cites `@brigantiTutorialBayesianNetworks2023` (BN tutorial for
>   psychopathology/psych-network researchers, closest methodological
>   analogue to this paper's use case), `@scutariWhoLearnsBetter2019`
>   (structure-learning algorithm comparison), `@friedmanDataAnalysisBayesian2013`
>   (bootstrap edge-stability procedure), `@kollerProbabilisticGraphicalModels2010`
>   and `@pearlProbabilisticReasoningIntelligent2014` (DAG/Markov-blanket
>   foundations), `@chickeringOptimalStructureIdentification2002` and
>   `@spirtesCausationPredictionSearch2000` (Markov-equivalence caveat), and
>   `@buurenMiceMultivariateImputation2011` (multiple-imputation procedure).
>   All eight are now in the master bib and the user's Zotero library.

> ℹ️ **Draft prose added (Session 13) + bnlearn citation fixed (Session 14).**
> `manuscript/climate-beliefs.qmd` now contains draft, italicized responses to
> R1-1 (Discussion), R1-2 (Data and Analysis), and R2-2 (new Methods
> paragraph + new "Bayesian Network Robustness Check" Results subsection with
> @fig-bn-dag and @tbl-bn-comparison + a Discussion paragraph). All three are
> marked with `[DRAFT -- ...]` tags for easy review. The BN Methods
> paragraph's package citation, previously flagged as missing, is now
> `[@scutariLearningBayesianNetworks2010]` (added to the master bib directly —
> **not yet in your actual Zotero library**, since I have no Zotero
> integration; add it there too so it survives a future Better BibTeX
> re-export). All three formats re-rendered clean with 81/81 citations
> matched. See the per-item sections below for exactly what changed.

> ℹ️ **Resolved — 85 vs. 89 edge count, and manuscript now updated to 85.**
> A fresh re-run of the GGM under today's package versions (bootnet 1.8,
> qgraph 1.9.8, R 4.6.0) produces 85 non-zero edges instead of the
> manuscript's originally reported 89. Traced to a real, dated toolchain
> change: `dplyr` 1.2.0 (released 2026-02-03, two days before the
> manuscript's initial commit) removed `dplyr::id()`, which `bootnet` ≤1.6
> depended on; `bootnet` wasn't patched for that until 1.7.1 (2026-02-07).
> The manuscript's 89-edge network was almost certainly estimated on the
> pre-upgrade toolchain, which is no longer installable today (confirmed —
> see `LOG.md` Session 11). Along the way, a second, unrelated bug was found
> and fixed: `scripts/centrality-measures.R` and `scripts/bayes-net.R` were
> both loading `data/beliefDataRep.csv` without recomputing `nepScale` from
> `nep2`/`nep3`/`nep6` the way the manuscript's own qmd chunk and
> `scripts/climate_ggm.R` do — the raw column is only 67%-correlated with
> the correct one and produced a badly distorted network when used as-is.
> Both scripts are now fixed. **With that fix in place, the fresh 85-edge
> network reproduces the manuscript's exact reported rank order for every
> centrality metric** (betweenness: egal>risk>fatal>indiv; closeness:
> egal>IntAgree; strength: EPA>risk>IntAgree) — the edge-count difference is
> genuinely cosmetic. The manuscript's `manuscript/climate-beliefs.qmd`
> network figure/data and the "89 (of 136) non-zero edges" line have been
> updated to reflect the corrected, current-toolchain 85-edge result (see
> `LOG.md`). The project also now uses `renv` (`renv.lock`) to pin package
> versions going forward, so this class of drift shouldn't recur. All
> robustness numbers below (CS coefficients, EBIC gamma sweep, CV-LASSO,
> pairwise difference tests, BN comparison) are from the current, renv-pinned
> toolchain and can be cited as final; the BN numbers were re-run after the
> `nepScale` fix (see R2-2 below for the corrected figures — they differ
> slightly from an earlier draft of this section).

---

## Cover paragraph (placeholder)

```
Dear Editor and Reviewers,

Thank you for the constructive and detailed feedback on our manuscript,
now retitled "What Beliefs are Central in the Climate Change Belief System
Network?" (previously "The Centrality of Cultural Worldviews in the Climate
Change Belief System Network"). We have revised the manuscript to address
each point below. A summary of major changes: reframed the gateway-belief-
model discussion (R1-1) and added a paragraph justifying the continued
relevance of the 2017 data (R1-2); adopted an exploratory framing in place
of the original confirmatory hypotheses, better reflecting the paper's
single organizing contribution (R2-1); added a Bayesian-network robustness
check as a companion to the GGM, addressing the concern that the
network-vs-hierarchy conclusion might be an artifact of the undirected
model (R2-2); restructured the literature review to integrate the
hierarchical and network perspectives directly rather than presenting them
as parallel traditions (R1-5); revised causal language throughout to reflect
the cross-sectional, undirected design (R1-3); added LASSO and centrality
robustness analyses, including pairwise significance tests, and revised
"most central" language throughout to reflect where those tests show ranks
are not statistically distinguishable (R2-4, R2-5) [PLACEHOLDER — extend
once R1-4's data/code access-mechanism decision, R1-7's Methods trimming,
and R1-8's contribution-paragraph tone are finalized].

Reviewer comments are reproduced in italics below, followed by our response.
```

---

## Reviewer 1

### R1-1 — Gateway belief model (GBM) framing — *Major*

> *"...the theoretical and empirical implications of the model are not
> sufficiently developed... This creates a conceptual mismatch: centrality
> in a partial-correlation network does not directly correspond to causal
> 'gateway' status. The current interpretation... is therefore too strong."*

**Status**: DRAFT PROSE ADDED — pending your review and rewrite into final voice.

A paragraph is now in the Discussion, immediately after the existing H2
paragraph ("However, less support is found for the scientific consensus as a
gateway belief expectation...") and before the egalitarianism paragraph. It
decouples structural centrality (what the GGM measures) from causal gateway
status, and engages all three suggested papers (Göbel et al. 2026; Said et
al. 2022, 2023) to reframe the low centrality of `sciconsensus` as consistent
with — not contradicting — a conditional/context-dependent GBM. Marked
`[DRAFT -- R1-1 response, please revise into your own voice]` in italics.

**Response**: [PLACEHOLDER — once you've finalized the Discussion paragraph,
adapt its core argument for the response-letter reply here]
**Manuscript changes**: Discussion section, `manuscript/climate-beliefs.qmd`
— one new paragraph (draft) after the H2 finding.

---

### R1-2 — Temporal relevance of 2017 data — *Major*

> *"...the manuscript situates itself within a rapidly evolving literature
> on climate belief systems, including studies from the mid-2020s... the
> authors should more explicitly justify the continued relevance of these
> data."*

**Status**: DRAFT PROSE ADDED — pending your review and rewrite into final voice.

A paragraph is now in Data and Analysis, immediately after the data
description ("...their ideological and partisan attachments.") and before
"## Belief Measures." It cites deep core beliefs' theorized stability over
time (Converse 1964, already cited elsewhere in the manuscript), notes the
comparator network studies also draw on similar/earlier-period data
(Verschoor et al. 2020), and leads with Lee et al. (2024)'s finding of
temporal consistency in network structure — particularly for Republicans and
Democrats considered separately — as the most direct evidence. Still
acknowledges the 2017/early-Trump-administration context as a limitation and
calls for replication. Marked `[DRAFT -- R1-2 response, please revise into
your own voice]` in italics.

**Response**: [PLACEHOLDER — once finalized, adapt for the response-letter
reply here]
**Manuscript changes**: Data and Analysis section, `manuscript/climate-beliefs.qmd`
— one new paragraph (draft) after the data description.

---

### R1-3 — Centrality ≠ causal influence — *Major*

> *"...it nonetheless employs language suggesting that certain beliefs
> 'drive' or 'shape' others. Given the cross-sectional and undirected nature
> of the model, such claims are not empirically warranted."*

**Status**: DONE — prose added directly (Session 21), no flag needed (this
was a mechanical language-consistency fix, not a judgment call).

Two Discussion sentences reworded from causal to structural language:
"cultural worldviews... influence other beliefs" → "...are structurally
connected to other beliefs"; "driving forces in the belief system" →
"occupying structurally important positions in the belief system." This is
consistent with, and an extension of, the causal-directionality caveat
already added in Session 17 for the BN section.

**Response**: The manuscript's language describing centrality has been
revised throughout to avoid implying causal direction; centrality is now
consistently described in structural terms (structural connection,
structural importance/position) rather than as beliefs "driving" or
"shaping" others, reflecting the cross-sectional, undirected nature of the
GGM.
**Manuscript changes**: Discussion section, `manuscript/climate-beliefs.qmd`
— two sentences reworded (Session 21).

---

### R1-4 — Open science / transparency — *Major*

> *"There is no indication of preregistration, no a priori power analysis,
> and no clear statement regarding data and code availability... the
> manuscript should... include robustness checks or stability analyses
> beyond the reported bootstrap confidence intervals."*

**Status**: DONE — prose added (Session 21), one point flagged for your
determination.

- **Robustness/stability checks beyond bootstrap CIs** — DONE, both
  analytically and in prose. See the new "## GGM Robustness Checks" Results
  subsection (R2-4/R2-5 below) reporting CS coefficients, the EBIC gamma
  sweep, and the CV-LASSO comparison.
- **Preregistration and a priori power analysis** — DONE in prose. A new
  "## Data and Code Availability" subsection (end of "## Belief System
  Network Analysis") states plainly that the study was not preregistered
  and no a priori power analysis was conducted, and offers the CS
  coefficients as the closest available substitute adequacy check, citing
  Epskamp et al. (2018).
- **Data/code availability statement** — prose added, but **flagged
  `NEEDS YOUR DETERMINATION`** in the manuscript: the same new subsection
  states that data/code are version-controlled with `renv`-pinned packages,
  but stops short of committing to a specific access mechanism (public repo
  URL vs. available-on-request) since that's a decision about what you want
  to commit to publicly, not something to decide unilaterally.

**Response**: We have added a new "Data and Code Availability" subsection
disclosing that the study was not preregistered and no a priori power
analysis was conducted (offering bootstrap correlation-stability
coefficients as the standard adequacy check for this literature instead),
and describing the version-controlled, reproducible analysis pipeline. We
have also added a new robustness section reporting CS coefficients, an EBIC
regularization-sensitivity sweep, and a cross-validated LASSO comparison, as
requested.
**Manuscript changes**: New "## Data and Code Availability" subsection
(end of "## Belief System Network Analysis"); new "## GGM Robustness Checks"
subsection (Results) — both added in Session 21.

---

### R1-5 — Literature review integration (hierarchical vs. network) — *Minor*

> *"...the literature review is comprehensive but could be more focused,
> particularly in integrating hierarchical and network perspectives rather
> than presenting them in parallel."*

**Status**: DONE (Session 22). Flagged, not edited, through Session 21 for
the reasons above; the user then reviewed the flagged section and directed a
restructuring pass. The "Belief Systems and Belief System Networks" section
now opens with a paragraph naming both traditions together ("Two traditions
have developed to characterize how these connections are structured and how
a belief's importance...should be understood"), then interleaves the
hierarchical and network treatment of deep core, policy core, and secondary
beliefs paragraph-by-paragraph — e.g., the deep-core paragraph states the
hierarchical claim (deep core beliefs are resistant to change and act as
filters) immediately followed by the network's empirical reframing of the
same claim (deep core beliefs are important only if they are, in fact,
highly central), with the ANES/Brandt evidence for the latter folded in
directly rather than presented three paragraphs later as a separate
"network approach" block. The subsequent center-periphery/betweenness/
closeness/degree material (which is inherently network-specific and has no
hierarchical analogue) was left as a technical block, with one added
sentence tying betweenness back to the hierarchical "filtering" concept. All
original citations were preserved; none were dropped or added. The in-source
`FLAGGED, NOT EDITED` comment has been updated to `DONE` with a summary of
the restructuring, and a note that this changes argument flow, not just
wording, so it is worth the user's own close read.

**Response**: In response to this comment, we restructured the "Belief
Systems and Belief System Networks" section to integrate the hierarchical
and network perspectives directly, rather than presenting them as two
parallel traditions. The section now introduces both perspectives together
at the outset and, for each type of belief (deep core, policy core, and
secondary), presents how it is understood under a hierarchical account
immediately alongside how the same belief is instead treated under a network
account, before turning to the network-specific centrality measures used in
the analysis.
**Manuscript changes**: "# Belief Systems and Belief System Networks"
section, `manuscript/climate-beliefs.qmd` — restructured across six
paragraphs (Session 22).

---

### R1-6 — Hypothesis precision re: centrality metrics — *Minor*

> *"The hypotheses would benefit from greater precision, especially in
> linking theoretical expectations to specific centrality metrics."*

**Status**: DONE and CONFIRMED (Session 21 prose; user confirmed Session 22).
Two sentences appended to the end of "## Theoretical Expectations" map
betweenness/closeness centrality (bridging/reaching roles) to the
hierarchical, deep-core-belief account, and strength centrality
(direct-connection count/magnitude) to the solution-aversion, policy-belief
account. Flagged `NEEDS YOUR DETERMINATION` since this specific
metric-to-theory mapping is an interpretive call; the user has since
reviewed the paragraph, made light edits of their own, and confirmed they
are happy with the mapping as stated. No longer an open determination.

**Response**: We have added language explicitly linking our theoretical
expectations to specific centrality metrics: betweenness and closeness
centrality are identified as the metrics most directly reflecting a
hierarchical/deep-core-belief account, while strength centrality is
identified as most directly reflecting a solution-aversion account for
policy-specific beliefs.
**Manuscript changes**: "## Theoretical Expectations" section,
`manuscript/climate-beliefs.qmd` — two sentences appended (Session 21).

---

### R1-7 — Methods section readability — *Minor*

> *"The methods section is technically sound but could be streamlined for
> readability..."*

**Status**: FLAGGED, NOT EDITED (Session 21). "Streamline" isn't specific
enough to act on safely — cutting content risks removing something you want,
with no clear target for what to trim vs. keep. An HTML comment (invisible
in rendered output) is inserted at the "## Belief System Network Analysis"
heading for your own read-through with an eye toward tightening. No text
was changed or cut.

**Response**: [PLACEHOLDER — write once you've done your own tightening
pass, or decide this doesn't need one]

---

### R1-8 — Discussion's articulation of contribution — *Minor*

> *"...the discussion would benefit from a clearer articulation of how the
> findings advance debates within both policy process research and climate
> communication."*

**Status**: DONE — prose added (Session 21), flagged `NEEDS YOUR
DETERMINATION`. A new Discussion paragraph connects the findings to policy
process research and climate communication debates directly. Flagged
because the right tone/emphasis for a contribution claim like this is a
judgment call, not something to assert with high confidence on your behalf.

**Response**: We have added a paragraph to the Discussion explicitly
articulating how these findings speak to debates in both policy process
research and climate communication scholarship.
**Manuscript changes**: Discussion section, `manuscript/climate-beliefs.qmd`
— one new paragraph (Session 21).

---

## Reviewer 2

*(Opens positively: "I found the paper to be clearly written and the
methods to be well done" — worth acknowledging in the cover letter.)*

### R2-1 — Weak single takeaway / "laundry list" of findings — *Major*

> *"...the impact of the paper is relatively muted. I find it difficult to
> find the one sentence takeaway... the paper reads as a laundry list of
> findings."*

**Status**: DRAFT PROSE ADDED — pending your review and rewrite into final
voice. Went further than "a single organizing narrative" — the user opted to
sketch, and then commit to drafting, a full **exploratory reframing** that
drops the H1/H2/H3 confirmatory hypothesis-testing structure entirely,
directly addressing the "laundry list" complaint at its structural root
rather than just rewriting the framing sentence.

Three draft passages are now in `manuscript/climate-beliefs.qmd`, each
tagged `[DRAFT -- R2-1 response, please revise into your own voice]`:

- **Introduction**: an alternative closing paragraph (added after the
  existing one, not replacing it) framing the paper as exploratory —
  mapping structural importance across three theoretical traditions rather
  than adjudicating between them as hypotheses to confirm/disconfirm.
- **"## Hypotheses"**: a full alternative section, **"## Theoretical
  Expectations,"** placed directly after the existing H1/H2/H3 blockquotes,
  reframing the same three theoretical threads as interpretive anchors.
  Tagged with a note that it would replace the "## Hypotheses" heading,
  prose, and blockquotes above if adopted (the existing hypotheses are left
  untouched for comparison, not yet deleted).
- **Discussion**: an alternative to the "these findings support H1... H3...
  less support for H2" paragraph, explicitly incorporating the R2-5
  pairwise-difference-test results (most top-ranked beliefs are not
  statistically distinguishable from each other) rather than asserting
  confirmatory rank claims.

**Why this is defensible against pushback**: assessed with the user before
drafting — neither reviewer demands hypothesis-testing rigor, R1 is
skeptical of confirmatory language throughout, and the R2-5 difference-test
results genuinely don't support strong "H1 supported / H2 not" claims. The
one risk flagged: R2's real ask is a single clear organizing narrative, not
just "fewer hypotheses" — the exploratory framing only fully resolves R2-1
if the replacement narrative (centered on which specific beliefs are
structurally distinctive) reads as tighter than what it replaces, not just
different.

**Response**: [PLACEHOLDER — once you've decided whether to adopt this
framing (and finished any remaining downstream Discussion edits — see
`LOG.md` Session 16 for paragraphs not yet touched), adapt the core argument
for the response-letter reply here]
**Manuscript changes**: Introduction (new paragraph), "## Hypotheses" →
optionally "## Theoretical Expectations" (new alternative section),
Discussion (new paragraph) in `manuscript/climate-beliefs.qmd`. See `LOG.md`
Sessions 16-18.

---

### R2-2 — Network method vs. hierarchy; Bayes net alternative — *Major*

> *"I am not convinced that the rejection of the hierarchical structure is
> not due to the methods that are chosen... If you were to use a Bayes net
> ...would you reach different conclusions...? ...there is a discussion on
> pg. 5 about fuzziness in hierarchical belief structures and it's unclear
> to me how that is solved by the network."*

**Status**: DONE analytically AND prose DRAFTED — pending your review and
rewrite into final voice.

`scripts/bayes-net.R` now runs a full Bayesian-network robustness check
(`bnlearn`): four structure-learning algorithms (HC/BIC: 27 arcs, Tabu/BIC:
28 arcs, PC/MI: 26 arcs, Gaussian HC: 59 arcs), a bootstrap-averaged
consensus network (threshold 0.50, 23 arcs retained from 500 bootstrap
replicates), and a direct comparison table against the GGM centrality
ranks. Headline result — **the two methods disagree about the single
most-central node**:

- GGM (undirected): **egal** is most central by betweenness and closeness.
- BN (directed): **egal** ranks low on out-degree (1) and is tied with
  several other nodes at Markov blanket size 3 (well below **risk** and
  **IntAgree** at 6) — it is *not* prominent in the directed structure.
- **indiv**, **IntAgree**, and **risk** are the nodes that rank highly on
  *both* the GGM's betweenness/closeness/strength ranks *and* the BN's
  out-degree/Markov-blanket size (top out-degree: IntAgree 6, risk 4,
  indiv 3; top Markov blanket: risk 6, IntAgree 6, indiv 5) — i.e., the two
  methods substantially agree on these three, but diverge sharply on
  egalitarianism.
- 8 arcs are consensus arcs across all three non-averaged algorithms
  (HC/Tabu/PC); 20 arcs are stable across all 5 multiple-imputation
  datasets.

*(Note: an earlier draft of this section, generated before this bug was
found, reported a slightly different consensus-arc count (9) and Markov
blanket ranking (indiv briefly appeared as the top node at 8) — that
version used a raw `nepScale` column that was never recomputed from
`nep2`/`nep3`/`nep6`, unlike the GGM scripts and the manuscript's own qmd
chunk. Fixed in `scripts/bayes-net.R`; the numbers above are from the
corrected re-run and are the ones to cite.)*

This is a genuinely useful answer to R2's question: the hierarchical vs.
network conclusion is *not* uniformly an artifact of the undirected method —
some nodes' prominence replicates under a directed model, but egalitarianism
specifically does not, which is worth discussing rather than glossing over.

**What's now in the manuscript** (all draft, italicized, tagged `[DRAFT --
R2-2 response, please revise into your own voice]`):

- **Methods** (`## Belief System Network Analysis`): a new paragraph, right
  after the existing centrality-bootstrap paragraph, justifying the
  undirected GGM as the exploratory-network default and introducing the BN
  companion approach — algorithms, bootstrap-averaged network, Gaussian and
  multiple-imputation sensitivity checks, and out-degree/Markov blanket as
  BN analogues to centrality. Cites [@scutariLearningBayesianNetworks2010]
  for the `bnlearn` package (added to the master bib in Session 14).
- **Results**: a new "## Bayesian Network Robustness Check" subsection
  (after the strength-centrality paragraph, before Discussion) with the
  averaged DAG figure (@fig-bn-dag) and the full 17-node GGM-vs-BN
  comparison table (@tbl-bn-comparison), plus discussion of the IntAgree/
  indiv/risk/egal pattern described above.
- **Discussion**: a paragraph appended after the existing "egal as bridge /
  EPA as driving force" paragraph (not replacing it), revising that
  interpretation: egal's betweenness-as-hierarchy reading doesn't survive
  the BN, while `IntAgree`'s high BN out-degree is a stronger, more direct
  counter-hierarchical finding than the GGM strength-centrality evidence
  alone. This also serves as the response to R2's "fuzziness" point (the
  network sidesteps needing to pre-classify beliefs into tiers, rather than
  resolving the fuzziness directly).

**Response**: [PLACEHOLDER — once finalized, adapt the Discussion paragraph's
argument for the response-letter reply here]
**Manuscript changes**: Methods (new paragraph), Results (new subsection +
figure + table), Discussion (new paragraph) in
`manuscript/climate-beliefs.qmd`. See `LOG.md` Session 13 for full detail,
including a debugging note on figure-embedding that isn't relevant to the
response letter itself.

---

### R2-3 — Scientific-consensus operationalization; H2 justification — *Moderate*

> *"...the question that is asked about consensus is quite different from
> the way consensus is operationalized in the literature (where 97% or 99%
> of scientists are said to agree)... H2 could use more justification. The
> GBM is hierarchical, and it would be useful to better translate between
> that hierarchical structure and the flattened network."*

**Status**: DONE and CONFIRMED (Session 21 prose; user confirmed Session 22).
A new paragraph in "## Belief Measures" (right after the `sciconsensus`
bullet) acknowledges the item's naturalistic, non-primed wording differs
from the standard 97%-consensus framing, citing van der Linden et al. (2019)
on the gateway belief model, and now also notes the measure's similarity to
the one used by Lee et al. (2024). Flagged `NEEDS YOUR DETERMINATION` on how
far to lean into "deliberate contribution" framing vs. a more cautious
limitations framing; the user has since reviewed the paragraph, made light
edits of their own, and confirmed they are happy with the framing as stated.
No longer an open determination.

**Response**: We have added a paragraph acknowledging that our measure of
perceived scientific consensus differs from the standard "97%" framing used
elsewhere in the gateway-belief-model literature, and discuss the
implications of that distinction for interpreting the null finding for this
belief.
**Manuscript changes**: "## Belief Measures" section,
`manuscript/climate-beliefs.qmd` — one new paragraph after the
`sciconsensus` bullet (Session 21).

---

### R2-4 — LASSO tuning / cross-validation — *Minor*

> *"...the general approach now is to use cross-validation. The number of
> nodes and non-zero edges is a bit surprising for LASSO on data of this
> size. It would be nice to see the robustness to different specifications."*

**Status**: DONE — both analytically and in prose (Session 21).

The new "## GGM Robustness Checks" Results subsection reports, via inline R
(not hardcoded, so it stays in sync with `data/ggm_robustness_results.RData`):

- **EBIC gamma sweep** (γ = 0 / 0.25 / 0.5 / 0.75 / 1.0): edge counts of
  105 / 87 / 85 / 85 / 79 respectively, with the top node by strength (EPA),
  betweenness (egal), and closeness (egal) unchanged across all five — the
  ranking is stable even though edge count varies.
- **CV-LASSO** (via `huge`): 86 edges vs. 85 from the EBIC-selected network
  — materially the same sparsity.

Note: the "dense regularized network" `qgraph`/`glasso` warning at some
gamma values was not turned into an explicit footnote in this pass — worth
deciding whether that caveat needs its own sentence or is adequately covered
by reporting the full gamma range.

**Response**: In response to this comment, we conducted an EBIC
regularization-sensitivity sweep across five gamma values and a
cross-validated LASSO comparison (via the `huge` package); both are reported
in a new "GGM Robustness Checks" subsection. Node rankings by centrality are
stable across all specifications tested.
**Manuscript changes**: New "## GGM Robustness Checks" subsection (Results),
`manuscript/climate-beliefs.qmd` — added Session 21 (see R2-5 immediately
below, part of the same subsection).

---

### R2-5 — Formal statistical tests for centrality comparisons — *Minor*

> *"When comparing the centrality measures across variables, statistical
> tests should be done."*

**Status**: DONE — both analytically and in prose (Session 21); the
downstream rank-claim-hedging determination flagged in Session 21 was
resolved by the user in Session 22 (see below).

`scripts/climate_ggm.R` runs pairwise bootstrap difference tests
(`differenceTest()`, nonparametric bootstrap) for every node pair, for both
strength and betweenness, now reported directly in the main centrality
results discussion (moved there in Session 22 — see "Manuscript changes"
below):

- **Strength**: 82 of 136 pairs are significantly different.
- **Betweenness**: 31 of 136 pairs are significantly different.
- **Among the top-5 betweenness nodes** (egal, indiv, fatal, risk,
  IntAgree): **none** of the 10 pairwise comparisons reach significance —
  their bootstrap CIs overlap. Point estimates rank egal highest, but this
  cannot be stated as a statistically distinguishable difference from the
  next four nodes.
- **Among the top-5 strength nodes** (egal, risk, IntAgree, Tax, EPA):
  **only Tax vs. EPA** reaches significance; the rest do not.

**Resolved (Session 22)**: through Session 21, the "## GGM Robustness
Checks" subsection reported these difference-test counts as a fact but did
not itself soften "most central" rank-claims made elsewhere in the paper.
The user directed two changes: (1) the difference-test paragraph was moved
out of the Robustness Checks subsection and into the main centrality-results
discussion, immediately after the betweenness/closeness/strength paragraphs
it qualifies, so the caveat sits right next to the claims it bears on rather
than several paragraphs later; and (2) "most central" language was softened
at every point in the document where it appeared — Introduction summary
("...have the highest point estimates for centrality..., though pairwise
comparisons show these ranks are not always statistically distinguishable
from several other beliefs"), Results ("egalitarianism has the highest point
estimate for betweenness centrality" rather than "...by a wide margin"), and
Discussion ("egalitarianism had the highest point estimate...though, as
noted above, this rank is not statistically distinguishable from several
other nodes"). The strength-centrality claims were hedged consistently with
the betweenness claims (few of the top-5 pairwise comparisons reach
significance for strength either, so that ranking is flagged with the same
caution) rather than treated as more solid just because more pairs overall
were significant in the full 136-pair comparison.

**Response**: We conducted pairwise bootstrap difference tests for all
node pairs on both strength and betweenness centrality, as requested. The
results show that most pairwise differences among the top-ranked nodes do
not reach statistical significance; we report this finding directly
alongside our centrality results (rather than in a separate robustness
subsection) and have revised "most central" language throughout the
Introduction, Results, and Discussion to describe point estimates rather
than statistically distinguishable ranks.
**Manuscript changes**: pairwise difference-test paragraph moved from "##
GGM Robustness Checks" into the main centrality-results discussion; "most
central" language softened in the Introduction summary paragraph, the
betweenness/closeness/strength paragraphs, and the Discussion,
`manuscript/climate-beliefs.qmd` (Session 22).

---

## Cross-Reviewer Patterns

| Issue | Raised by | Notes |
|---|---|---|
| Causal language ("drive," "shape") unwarranted given cross-sectional/undirected design | R1-3, (implicit in R1-1) | Single search-and-replace pass covers both |
| Hypothesis precision re: which centrality metric each H predicts | R1-6, R2 (§2 of raw review) | Same fix serves both |
| Undirected network vs. hierarchical fuzziness | R1-5, R2-2 | R2-2's Bayes-net analysis (done) directly informs R1-5's integration ask |
| Single clear takeaway / contribution to the field | R1-8, R2-1 | R2-5's difference-test results should inform how strongly this takeaway is stated |

## Suggested Revision Order — all items now addressed

All items below have manuscript prose as of Session 21. Everything is
**done** in the sense that the manuscript is no longer in draft/skeleton
state anywhere — but items marked "flagged" below still have an in-source
`NEEDS YOUR DETERMINATION` or `FLAGGED, NOT EDITED` HTML comment at the
relevant spot, since those involve a genuine judgment call this letter
can't make for you. Search the qmd for `<!--` to find all of them, or see
the per-item sections above for exact locations.

1. ~~**R1-1, R1-2**~~ — finalized as plain prose (Session 20).
2. ~~**R2-2**~~ — finalized as plain prose (Session 20).
3. ~~**R2-5 → R2-1**~~ — R2-1's exploratory framing adopted, hypotheses
   section removed (Session 20); R2-5's difference-test results now reported
   alongside the main centrality results, and the document-wide rank-claim
   hedging pass flagged in Session 21 is done (Session 22).
4. ~~**R1-3**~~ — causal-language pass done (Session 21).
5. ~~**R2-3**~~ — prose added (Session 21), confirmed by user (Session 22).
6. ~~**R1-4**~~ — transparency statement added, **still flagged** for
   access-mechanism determination (Session 21) — not yet resolved.
7. ~~**R1-6**~~ — prose added (Session 21), confirmed by user (Session 22).
   ~~**R1-8**~~ — prose added, **still flagged** for tone determination
   (Session 21) — not yet resolved. ~~**R1-5**~~ — restructured per user
   direction (Session 22). **R1-7** — still flagged, not edited (Session
   21); needs the user's own read-through, not just a confirmation.
8. ~~**R2-4**~~ — LASSO robustness comparison reported (Session 21).

*(The 85-vs-89 edge count is resolved and the manuscript already updated to
85 — see the note at the top of this document and `LOG.md` Session 12.)*

---

## Reference: Robustness Numbers Quick-Reference

*(For pasting into text once drafted. All figures below are from the
2026-08-04 pipeline run, current toolchain (bootnet 1.8, qgraph 1.9.8,
R 4.6.0) — see the resolved edge-count note at the top of this document.)*

| Check | Result |
|---|---|
| CS coefficient — betweenness | 0.517 (stable, ≥0.50) |
| CS coefficient — closeness | 0.750 (highest level tested) |
| CS coefficient — strength | 0.750 (highest level tested) |
| EBIC gamma sweep, edge counts (γ=0/.25/.5/.75/1) | 105 / 87 / 85 / 85 / 79 |
| EBIC gamma sweep, top node stability | EPA (strength), egal (betweenness), egal (closeness) — unchanged across all γ |
| CV-LASSO edges vs. EBIC | 86 vs. 85 |
| Pairwise diff. test, strength — significant pairs | 82 / 136 |
| Pairwise diff. test, betweenness — significant pairs | 31 / 136 |
| Top-5 betweenness nodes — pairwise significance | 0 / 10 pairs significant |
| Top-5 strength nodes — pairwise significance | 1 / 10 pairs significant (Tax vs. EPA) |
| BN averaged network (bootstrap threshold 0.50) | 23 arcs retained |
| BN consensus arcs (HC + Tabu + PC agree) | 8 |
| BN arcs stable across all 5 imputations | 20 |
| GGM–BN agreement | indiv, IntAgree, risk prominent in both; egal prominent in GGM only |
