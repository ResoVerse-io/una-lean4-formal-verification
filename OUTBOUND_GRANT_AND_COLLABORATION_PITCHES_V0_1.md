# Outbound Grant Proposals & Community Collaboration Pitches (V0.1)

**Public Repository:** [https://github.com/ResoVerse-io/una-lean4-formal-verification](https://github.com/ResoVerse-io/una-lean4-formal-verification)  
**Google DeepMind `formal-conjectures` Live Pull Request:** [https://github.com/google-deepmind/formal-conjectures/pull/7917](https://github.com/google-deepmind/formal-conjectures/pull/7917)  
**Lean FRO `comparator.live.lean-lang.org` Validated Challenge SHA-256:** `ff3e2ea45dfdb5caa5081a082244d349c79a2ec1699b334c631e084a337b3fda`  
**Verified Theorem Count:** **26 Formal Theorems (`TypeMatch=true`, `SolutionAxioms=[]`, `ZeroAxioms=true`)**

---

## Pitch 1: Renaissance Philanthropy — *AI for Math Fund* (Concept Note / Application Pitch)

**Subject:** AI for Math Fund Concept Note — *Weight-Independent Conjecture-Generator & 4-Engine Formal Verification Pipeline (`Lean 4`) for Existence ($\exists$) Counterexample Discovery and Fail-Closed Verification*

**To:** AI for Math Fund Review Committee (Renaissance Philanthropy)

Dear AI for Math Fund Review Committee,

I am submitting for your consideration an open-source, weight-independent formal verification and counterexample-discovery system I built, paired with an independently auditable **Lean 4** benchmark package:
* **GitHub Repository:** [https://github.com/ResoVerse-io/una-lean4-formal-verification](https://github.com/ResoVerse-io/una-lean4-formal-verification)
* **Upstream `google-deepmind/formal-conjectures` Pull Request:** [https://github.com/google-deepmind/formal-conjectures/pull/7917](https://github.com/google-deepmind/formal-conjectures/pull/7917)
* **Zero-Trust Verification:** Validated in the Lean FRO's `leanprover/comparator` (`comparator.live.lean-lang.org`, Challenge SHA-256: `ff3e2ea45dfdb5caa5081a082244d349c79a2ec1699b334c631e084a337b3fda`) across Lean `v4.32.2`, `v4.35.0`, and `v4.36.0-rc2` with **26 formal theorems** (`TypeMatch = true`, `SolutionAxioms = []`).

### 1. The Core Bottleneck This System Solves
Current LLM-based autoformalization pipelines suffer from two structural vulnerabilities:
1. **Conflation of heuristic search with universal ($\forall$) proof**, frequently smuggling unproved claims via `sorryAx`, altered theorem types, or unexamined axiom assumptions.
2. **Neglect of the formal asymmetry between $\forall$ and $\exists$**: whereas proving a universal Millennium-class theorem requires infinite-dimensional analytic closure, *refuting* an auxiliary conjecture ($\exists x, \neg P(x)$) requires only **one finite counterexample witness** that can be proved with 100% deductive certainty (`SolutionAxioms = []`) inside the Lean 4 kernel.

### 2. What I Have Built and Verified
My repository (`ResoVerse-io/una-lean4-formal-verification`) demonstrates a complete, reproducible 4-engine verification pipeline (**Native Python + `mpmath` 50-decimal-place precision + `SymPy` symbolic CAS + `Lean 4` dependent-type kernel**):
* **Formal Conjecture Disproofs (`google-deepmind/formal-conjectures` & `teorth/equational_theories`):**
  * **Goldbach–Euler (1752) Twice-a-Square Disproofs & Hodges' Conjecture (OEIS `A060003` / Guy Problem A19):** Complete zero-axiom Lean 4 proofs (`goldbach_1752_full_disproof_5777` and `goldbach_1752_full_disproof_5993`) verifying compositeness and exhausting all $0 \le a \le 54$ cases, submitted upstream in [`google-deepmind/formal-conjectures` PR `#7917`](https://github.com/google-deepmind/formal-conjectures/pull/7917).
  * **Terence Tao's Equational Theories (`teorth/equational_theories`):** Three distinct order-3 magma (`M3`) non-implication counterexamples verified with zero axioms (`magma_not_associative`, `rps_magma_not_associative` for the Steiner quasigroup, and `left_zero_magma_not_commutative` for the 81-case 4-variable Medial Law).
  * **Spectral Graph Theory & Blowup ODEs:** Explicit 5-vertex tree/disconnected graph pair disproving *"Can you hear the shape of a graph?"* (`cospectral_graphs_distinct_max_degree`, identical characteristic polynomial $\lambda^5 - 4\lambda^3 = 0$) and symbolic `SymPy` verification of Constantin–Lax–Majda 1D vortex-stretching finite-time singularity at $t_* = 1$.
* **Fail-Closed Epistemic Abstention Gate (`fail_closed_abstention_gate`):** Automatic refusal to claim universal ($\forall$) proofs when only finite-cutoff or sub-lemma evidence exists (`unproved_millennium_breakthrough_claimed = false`).

### 3. Proposed 12-Month Milestones for AI for Math Fund Support
1. **Automated Counterexample Synthesis for `teorth/equational_theories` & `google-deepmind/formal-conjectures`:** Scale the system's finite-model and algebraic counterexample search to automatically emit `comparator`-verified Lean 4 disproof certificates (`SolutionAxioms = []`) for open non-implication pairs and OEIS number-theoretic conjectures.
2. **Native `Lean.MetaM` Comparator & Axiom-Hygiene CI Action:** Package `Una1Formal/ComparatorAudit.lean` as a zero-dependency GitHub Action for the Lean 4 community to prevent reward-hacking in AI-generated proofs.

I would welcome the opportunity to submit a full proposal and demonstrate the live verification suite.

Respectfully,  
**Tom Budd**  
Founder, ResoVerse  
Repository: [https://github.com/ResoVerse-io/una-lean4-formal-verification](https://github.com/ResoVerse-io/una-lean4-formal-verification)

---

## Pitch 2: Lean FRO (`lean-beam` / Year 4 Roadmap) & Lean Prover Zulip (`#Formal conjectures` / `#AI`) Post

**Topic:** `PR #7917: OEIS A060003 (Stern-Goldbach odd composites) — review & verification request`

**Message Body (Copy-Paste for Lean Zulip `#Formal conjectures` or `#AI`):**

Hi everyone! 👋

I just opened **[PR `#7917` on `google-deepmind/formal-conjectures`](https://github.com/google-deepmind/formal-conjectures/pull/7917)** adding `FormalConjectures/OEIS/60003.lean` (Hodges' Conjecture / Richard K. Guy's *Unsolved Problems in Number Theory* Problem A19 on odd composite Stern numbers not of the form $p + 2a^2$, together with `decide +kernel` proofs for the two known counterexamples $5777$ and $5993$ and the formal disproof of Goldbach's 1752 conjecture).

This counterexample search, formalization, and zero-axiom verification were produced by an automated mathematical discovery and multi-engine formal verification system I built, which pairs a candidate conjecture generator with a 4-engine deterministic verification pipeline (`Lean 4` kernel + `SymPy` symbolic CAS + `mpmath` 50-decimal-place analysis + native Python) and a fail-closed epistemic abstention gate.

Alongside PR `#7917`, I also open-sourced my system's standalone, zero-dependency Lean 4 verification benchmark and native `Lean.MetaM` comparator auditor (`26` formal theorems verified with `TypeMatch = true` and `SolutionAxioms = []`):
https://github.com/ResoVerse-io/una-lean4-formal-verification

I am looking for independent community verification and review of the system's formalizations and zero-axiom proofs—both on [PR `#7917`](https://github.com/google-deepmind/formal-conjectures/pull/7917) and across the 26-theorem comparator suite (`lake build Una1Formal.ComparatorAudit` or via `comparator.live.lean-lang.org`). Any feedback, edge-case critiques, or verification checks from the community would be greatly appreciated!

---

## Pitch 3: DARPA I2O — `expMath` (Exponential Mathematics) Program Manager Executive Abstract Email

**Subject:** DARPA `expMath` Executive Abstract — *Weight-Independent Conjecture-Generator & 4-Engine Formal Verification Pipeline (`PASS_ALL_26_THEOREMS_TYPE_MATCHED_AND_ZERO_AXIOM_VERIFIED`)*

**To:** DARPA I2O `expMath` Program Manager

Dear Program Manager,

Attached / linked below is my technical proposal and reproducible verification artifact for **DARPA `expMath`**:
* **Full Technical Proposal (Heilmeier Catechism & Non-Serial MECE Aims):** [`DARPA_EXPMATH_AND_AI_FOR_MATH_GRANT_PROPOSAL_V0_1.md`](https://github.com/ResoVerse-io/una-lean4-formal-verification/blob/main/DARPA_EXPMATH_AND_AI_FOR_MATH_GRANT_PROPOSAL_V0_1.md)
* **Public Reproducible Verification Package:** [https://github.com/ResoVerse-io/una-lean4-formal-verification](https://github.com/ResoVerse-io/una-lean4-formal-verification)
* **Upstream `google-deepmind/formal-conjectures` Pull Request:** [https://github.com/google-deepmind/formal-conjectures/pull/7917](https://github.com/google-deepmind/formal-conjectures/pull/7917)

### Key Technical Differentiators Aligned with `expMath`:
1. **Weight-Independent 4-Engine Verification Pipeline:** Decouples candidate hypothesis generation (`conjecture_generator`) from deterministic multi-engine verification (`formal_verifier`: Native Python + `mpmath` 50-decimal-place numerical analysis + `SymPy` symbolic CAS + `Lean 4` dependent-type proof kernel).
2. **Zero-Trust Anti-Reward-Hacking (`Lean.collectAxioms` & `leanprover/comparator`):** Every emitted Lean 4 proof is audited against a frozen `Challenge` specification (`cInfo.type == sInfo.type`, `SolutionAxioms = []`). All **26 benchmark theorems** build and verify from scratch in under 5 seconds via `lake build Una1Formal.ComparatorAudit`.
3. **Fail-Closed Epistemic Abstention (`fail_closed_abstention_gate`):** Formally separates finite-dimensional sub-lemma verification and existence ($\exists$) counterexample disproofs from open universal ($\forall$) continuum conjectures, eliminating mathematical hallucination at the architectural boundary.

I would welcome a brief technical briefing with the `expMath` team at your convenience.

Respectfully,  
**Tom Budd**  
Principal Investigator / Founder, ResoVerse  
GitHub: [https://github.com/ResoVerse-io/una-lean4-formal-verification](https://github.com/ResoVerse-io/una-lean4-formal-verification)
