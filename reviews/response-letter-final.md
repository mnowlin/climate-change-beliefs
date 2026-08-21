---
title: "Response to Reviewers"
subtitle: "What Beliefs are Central in the Climate Change Belief System Network? (previously submitted as \"The Centrality of Cultural Worldviews in the Climate Change Belief System Network\")"
---

Dear Editor and Reviewers,

Thank you for the constructive and detailed feedback on my manuscript. I
have revised the manuscript substantially in response, and I am grateful
for the care both reviewers took in engaging with the analysis.

The most consequential change concerns the overall framing of the paper.
Both reviewers, in different ways, pushed back on treating this analysis as
a test of competing hypotheses. Reviewer 2 found it difficult to locate a
single, convincing takeaway among three hypotheses, several belief types,
and three network measures, and read the paper as a laundry list of
findings; Reviewer 1 was similarly skeptical of language that treated the
network results as confirming or disconfirming specific causal predictions,
given the cross-sectional, undirected design. In direct response, I moved
away from a confirmatory hypothesis-testing structure -- the manuscript no
longer presents three hypotheses to be supported or rejected. Instead, the
same three theoretical accounts (a hierarchical account centered on deep
core beliefs, the gateway belief model centered on perceived scientific
consensus, and a solution-aversion account centered on policy preferences)
now serve as theoretical anchors that informed which beliefs I included in
the network and how I interpret their structural positions, within an
explicitly exploratory analysis of which beliefs, and which types of
beliefs, occupy the most structurally important positions in the network.
This reframing let me organize the paper around a single, specific finding
rather than a per-hypothesis scorecard -- individualism, perceived climate
risk, and support for an international climate agreement are robustly
central regardless of whether the network is modeled as undirected (a
Gaussian graphical model) or directed (a companion Bayesian network),
while egalitarianism's apparent centrality holds only in the undirected
model. I have retitled the manuscript from "The Centrality of Cultural
Worldviews in the Climate Change Belief System Network" to "What Beliefs
are Central in the Climate Change Belief System Network?" to reflect this
shift, from a title asserting a specific belief's centrality to a title
posing the open, exploratory question the paper now investigates.

Beyond this reframing, I made the following major changes. I reinterpreted
the gateway belief model finding to distinguish structural centrality from
causal gateway status, engaging recent work on the model's boundary
conditions (R1-1); added a paragraph justifying the continued relevance of
the 2017 data (R1-2); revised causal language throughout to reflect the
cross-sectional, undirected design (R1-3); added a transparency statement
covering preregistration, power analysis, and data/code availability, plus
new robustness analyses (R1-4); restructured the literature review to
integrate the hierarchical and network perspectives directly, rather than
presenting them as parallel traditions (R1-5); streamlined the methods
section for readability (R1-7); sharpened the discussion's articulation of
the paper's contribution to policy process research and climate
communication (R1-8); estimated a companion Bayesian network alongside the
Gaussian graphical model to assess whether my conclusions depend on the
choice of an undirected model (R2-2); added discussion of how my
scientific-consensus measure differs from the standard operationalization
used elsewhere in the gateway-belief-model literature (R2-3); added an
EBIC regularization-sensitivity sweep and a cross-validated LASSO
comparison (R2-4); and conducted pairwise bootstrap significance tests for
all three centrality measures, revising "most central" language throughout
to reflect where those tests show ranks are not statistically
distinguishable (R2-5).

Reviewer comments are reproduced in italics below, followed by my
response.

---

## Reviewer 1

I thank the reviewer for a thorough and constructive reading of the
manuscript, and for pointing me toward literature that substantially
strengthened my treatment of the gateway belief model.

### Gateway belief model framing

*"...the theoretical and empirical implications of the model are not
sufficiently developed... This creates a conceptual mismatch: centrality in
a partial-correlation network does not directly correspond to causal
'gateway' status. The current interpretation... is therefore too strong."*

I agree, and have revised my interpretation accordingly. The Discussion
now explicitly distinguishes structural centrality, which is what my
network models measure, from the causal, interventional claims at the
center of the gateway belief model, which is typically tested through
experimental or longitudinal designs rather than the cross-sectional data
used here. I reframe the low centrality of perceived scientific consensus
as consistent with, rather than contradicting, a gateway belief model whose
effects are conditional rather than universal, drawing on the literature
the reviewer suggested -- Göbel et al. (2026) on the specific mechanisms and
boundary conditions of consensus messaging, and Said et al. (2022, 2023) on
the model's preregistered replication and its dependence on respondents'
engagement with the consensus message. I now state plainly that a belief
can serve as a causal entry point for belief change without also being
central to how beliefs are structurally organized at a given point in
time, and that this reflects the difference between what a cross-sectional
network can and cannot show, not a challenge to the gateway belief model
itself.

### Temporal relevance of the 2017 data

*"...the manuscript situates itself within a rapidly evolving literature on
climate belief systems, including studies from the mid-2020s... the authors
should more explicitly justify the continued relevance of these data."*

I have added a paragraph to the Data and Analysis section addressing this
directly. Deep core beliefs such as cultural worldviews are theorized to be
especially resistant to change, so the overall organization of the belief
network should likely be comparatively stable even as specific policy
debates evolve. This expectation is consistent with Lee et al. (2024), who
find that the structure of the climate change belief network is largely
consistent over time, particularly among Republicans and Democrats
considered separately. I am careful not to overstate this point. Whether
more recent shifts in polarization and climate discourse have altered the
network's structure remains an open question, and I now explicitly call
for replication of this analysis with more recent data.

### Centrality is not causal influence

*"...it nonetheless employs language suggesting that certain beliefs
'drive' or 'shape' others. Given the cross-sectional and undirected nature
of the model, such claims are not empirically warranted."*

I have revised this language throughout the manuscript. Centrality is now
described consistently in structural terms -- beliefs "occupy structurally
important positions" or are "structurally connected" to other beliefs --
rather than as beliefs that "drive" or "shape" one another, reflecting the
cross-sectional, undirected nature of the Gaussian graphical model. Where
I discuss the companion Bayesian network's directed edges, I am
similarly explicit that "upstream" and "downstream" describe an estimated
ordering under the model's search criteria, not a causal claim, since
cross-sectional survey data of this kind cannot identify edge direction
causally.

### Open science and transparency

*"There is no indication of preregistration, no a priori power analysis,
and no clear statement regarding data and code availability... the
manuscript should... include robustness checks or stability analyses beyond
the reported bootstrap confidence intervals."*

I have added a footnote to the Data and Analysis section disclosing that
the study was not preregistered and that no a priori power analysis was
conducted. As a post hoc check on whether the sample size supports stable
centrality estimates, I report bootstrap correlation-stability
coefficients for each centrality measure, all at or above the 0.50
threshold Epskamp et al. (2018) recommend. The same footnote commits to
making the survey data, analysis scripts, and manuscript source available
in a version-controlled GitHub repository upon publication, with package
versions pinned via `renv` to support exact reproducibility. I have also
added robustness analyses beyond the bootstrap confidence intervals,
reported directly alongside the centrality results -- an EBIC
regularization-sensitivity sweep across five tuning values, which shows
non-zero edge counts ranging from 79 to 105 while the node with the highest
point-estimated strength, betweenness, and closeness centrality remains
unchanged at every value tested; and a cross-validation-selected network
(via the `huge` package), which has a materially similar level of sparsity
to the EBIC-selected network (87 vs. 85 edges).

### Literature review integration

*"...the literature review is comprehensive but could be more focused,
particularly in integrating hierarchical and network perspectives rather
than presenting them in parallel."*

I have restructured the "Belief Systems and Belief System Networks"
section accordingly. It now introduces the hierarchical and network
traditions together at the outset, then, for each type of belief (deep
core, policy core, and secondary), presents how that belief is understood
under a hierarchical account immediately alongside how the same belief is
instead treated under a network account, rather than presenting a full
hierarchical block followed by a full network block. This also let me
address a related point raised later in the review, about the fuzziness of
category boundaries in a hierarchical account -- I now illustrate this
concretely, noting that I treat environmental orientation as a deep core
belief because it could plausibly shape views across several environmental
issues, but that other scholars could reasonably treat it as a policy core
belief instead, with "the environment" itself seen as a policy issue. A
network approach avoids needing to resolve this classification question,
since a belief's structural importance is determined empirically from its
connections rather than assigned from its category.

### Precision linking theoretical expectations to centrality metrics

*"The hypotheses would benefit from greater precision, especially in
linking theoretical expectations to specific centrality metrics."*

In connection with the exploratory reframing described above, the
"Theoretical Expectations" section now states explicitly which centrality
measures most directly reflect each theoretical account. Betweenness and
closeness centrality, which capture a belief's role in bridging and
quickly reaching other beliefs, most directly reflect the constraining,
foundational role a hierarchical account attributes to deep core beliefs.
Strength centrality, which reflects the number and magnitude of a belief's
direct connections, more directly reflects the pattern a solution-aversion
account would predict for policy preferences.

### Methods section readability

*"The methods section is technically sound but could be streamlined for
readability..."*

I have streamlined the "Belief System Network Analysis" section. The
opening discussion of general network-theory definitions was trimmed
substantially, since it had largely repeated ground already covered
earlier in the paper. Algorithm-specific technical detail on the Bayesian
network's structure-learning procedure was moved to footnotes, mirroring a
footnote already used for a related discretization detail. No substantive
methodological content was removed; the trims either eliminated material
duplicated elsewhere or relocated technical detail out of the main text.

### Discussion's articulation of contribution

*"...the discussion would benefit from a clearer articulation of how the
findings advance debates within both policy process research and climate
communication."*

I have sharpened the Discussion's closing paragraphs to tie my
contribution to the paper's specific organizing finding, rather than
stating it at a general level. For policy process research, I note that
structural importance in the climate change belief network does not track
the deep core/policy core/secondary ordering a hierarchical account
predicts, since individualism, perceived climate risk, and support for an
international agreement are robustly central regardless of whether the
network is modeled as undirected or directed. I suggest policy process
scholars would benefit from treating belief systems as networks alongside
the hierarchical approach, particularly when the goal is to identify which
beliefs are most structurally consequential rather than assuming that
answer from belief type alone. For climate communication research, I note
that consensus messaging campaigns may be better understood as targeted
causal interventions than as efforts to shift a structurally central
belief, following from my reframing of the gateway belief model finding
above.

---

## Reviewer 2

I thank the reviewer for the positive assessment of the paper's writing
and methods, and for pushing me to sharpen the paper's central
contribution.

### A single, clear takeaway

*"...the impact of the paper is relatively muted. I find it difficult to
find the one sentence takeaway from the paper that's particularly
convincing and, to some extent, the paper reads as a laundry list of
findings. There are 3 hypotheses, many types of beliefs, and three network
measures."*

As described above, I addressed this at the structural level rather than
by rewriting a single framing sentence. I removed the confirmatory
hypothesis-testing structure and reframed the paper as an exploratory
analysis organized around a single finding -- individualism, perceived
climate risk, and support for an international agreement are robustly
central regardless of whether the network is modeled as undirected or
directed, while egalitarianism's centrality does not survive the directed
model. This claim now organizes the Introduction, Results, and Discussion,
and motivated the manuscript's new title. I also address the reviewer's
specific question about whether the three centrality measures teach me
something substantively different, and they do. Egalitarianism has the
highest betweenness and closeness centrality, indicating it serves as a
bridge connecting other beliefs, while support for EPA regulations has the
highest strength centrality, indicating it has the strongest direct
connections in the network. I now discuss this divergence directly rather
than treating agreement across measures as the expected default.

### Whether the network method drives the rejection of hierarchy

*"...I am not convinced that the rejection of the hierarchical structure is
not due to the methods that are chosen... If you were to use a Bayes net...
would you reach different conclusions...? ...there is a discussion on pg.
5 about fuzziness in hierarchical belief structures and it's unclear to me
how that is solved by the network."*

This is a fair concern, and I addressed it directly by estimating a
companion Bayesian network over the same 17 belief nodes, using
hill-climbing, tabu search, and constraint-based structure-learning
algorithms, with stability assessed via a nonparametric bootstrap (500
resamples) and robustness to missing data checked via multiple imputation.
The comparison shows the answer is not uniform. Individualism and
perceived climate risk rank highly on both the Gaussian graphical model's
centrality measures and the Bayesian network's out-degree and Markov
blanket size, indicating their structural importance is likely not an
artifact of either model; support for an international climate agreement
has the highest out-degree of any node in the directed network, a stronger
challenge to a hierarchical account than any finding from the undirected
model alone. Egalitarianism, by contrast, ranks highest on betweenness and
closeness in the undirected model but ranks well outside the top nodes on
every Bayesian network measure, indicating its apparent centrality is
specific to the undirected model rather than a general property of the
belief. I report this divergence directly in the Discussion rather than
treating the Gaussian graphical model's conclusions as method-independent.
On the fuzziness point, I added a concrete illustration to the passage in
question -- I treat environmental orientation as a deep core belief because
it could plausibly shape views across several environmental issues, but it
could reasonably be classified as a policy core belief instead. The
network approach does not resolve this classification question so much as
sidestep it, since a belief's structural importance is determined
empirically from its connections rather than assigned from a category.

### Scientific consensus operationalization and the gateway belief model

*"...the question that is asked about consensus is quite different from
the way consensus is operationalized in the literature (where 97% or 99%
of scientists are said to agree)... H2 could use more justification. The
GBM is hierarchical, and it would be useful to better translate between
that hierarchical structure and the flattened network."*

I have added a paragraph to the Belief Measures section acknowledging
this difference directly. My scientific-consensus item asks respondents
for their own belief about whether a scientific consensus exists, rather
than presenting them with an explicit consensus estimate before asking
about downstream beliefs, as much of the gateway belief model literature
does. I describe this as a more conservative measure, in the sense that
it does not prime respondents with the consensus estimate itself, and note
that it is similar to the measure used by Lee et al. (2024). On
translating between the gateway belief model's hierarchical structure and
the network, the network approach retains the same deep core, policy core,
and secondary belief vocabulary the hierarchical account uses, treating
perceived scientific consensus as the policy core belief that operationalizes
the gateway belief model's causal entry point, but leaves open, as an
empirical question, whether that belief occupies a structurally important
position, rather than assuming it does because of its hierarchical role.

### LASSO tuning and cross-validation

*"...the general approach now is to use cross-validation. The number of
nodes and non-zero edges is a bit surprising for LASSO on data of this
size. It would be nice to see the robustness to different specifications."*

I conducted both checks the reviewer requested. Re-estimating the network
across a range of EBIC tuning values (gamma = 0 to 1) produces non-zero
edge counts ranging from 79 to 105, but the node with the highest
point-estimated strength, betweenness, and closeness centrality is
unchanged at every value tested. A cross-validation-selected network,
estimated via the `huge` package, retains 87 edges, a materially similar
level of sparsity to the 85 edges selected by my reported EBIC-tuned
network. Both checks are now reported alongside the centrality results.

### Statistical tests for centrality comparisons

*"When comparing the centrality measures across variables, statistical
tests should be done."*

I conducted pairwise bootstrap difference tests for all 136 possible node
pairs, for each of the three centrality measures, and report the results
directly alongside each measure's centrality ranking rather than in a
separate subsection. The results counsel caution in how I describe my
top-ranked beliefs. For betweenness, only 31 of 136 pairwise comparisons
are significant overall, and none of the 10 comparisons among the five
top-ranked nodes reach significance, so egalitarianism's rank as most
central on betweenness is a point estimate rather than a statistically
distinguishable difference from the next four nodes. For closeness, 54 of
136 comparisons are significant overall, and only 1 of the 10 comparisons
among the top five nodes does, egalitarianism's closeness centrality
against fatalism's; egalitarianism is not significantly different from
support for an international agreement, a carbon tax, or climate change
risk on this measure. For strength, 82 of 136 comparisons are significant
overall, the highest rate of the three measures, but still only 1 of the
10 comparisons among the top five nodes reaches significance, EPA
regulations against a carbon tax, so the strength ranking of EPA
regulations, climate change risk, and support for an international
agreement should likewise be read with caution. I have revised "most
central" language throughout the Introduction, Results, and Discussion to
describe point estimates rather than statistically distinguishable ranks,
consistent with these results.

---

I thank both reviewers again for their careful engagement with the
manuscript. I believe the revisions described above, and in particular
the shift to an explicitly exploratory framing organized around a single
finding, have substantially strengthened the paper, and I hope the
revised manuscript addresses the concerns raised.
