# DARPA `expMath` & AI-for-Mathematics Technical Proposal (V0.1)

**Title:** *UNA-1 Weight-Independent Conjecture-Generator and 4-Engine Formal Verification Pipeline (`Lean 4 + SymPy + mpmath`) for Sub-Lemma Verification, Existence ($\exists$) Counterexample Discovery, and Fail-Closed Epistemic Abstention*  
**Principal Investigator / Founder:** Tom Budd (ResoVerse / UNA)  
**Methodology:** Donald E. Stokes (*Pasteur's Quadrant* Use-Inspired Basic Research) · George H. Heilmeier (*DARPA Heilmeier Catechism*) · Barbara Minto (*SCQA & Non-Serial MECE Specific Aims*)  
**Verification & Epistemic Tier:** `CANDIDATE_DETERMINISTIC_VERIFIER` (`unproved_millennium_breakthrough_claimed = false`; all boundaries enforced via `fail_closed_abstention_gate`).

---

## 1. Executive Summary & DARPA Heilmeier Catechism

1. **What are we trying to do? (No Jargon)**
   Current Large Language Models hallucinate mathematical proofs because they treat mathematics as next-token text prediction without an independent deductive kernel or an epistemic abstention gate. **UNA-1** separates **candidate conjecture generation (`conjecture_generator` / `competing_hypothesis_lattice`)** from **4-engine deterministic & formal verification (`formal_verifier`: Native Python Verifier + `mpmath` 50-decimal-place numerical analysis + `SymPy` symbolic CAS + `Lean 4` dependent-type proof kernel)** and enforces a **fail-closed epistemic abstention gate (`fail_closed_abstention_gate` + `calibration_overconfidence_audit`)** that refuses to conflate finite simulation with universal ($\forall$) proof.
2. **How is it done today, and what are the limits of current practice?**
   * Pure LLM approaches produce plausible-looking steps containing subtle logical gaps, altered theorem types, or false universality claims.
   * Standalone proof assistants (`Lean 4`, `Coq`, `Isabelle`) guarantee deductive validity only *after* a human manually translates every lemma, and they do not automatically audit whether the chosen axioms faithfully model the continuum mathematical problem (e.g., continuum 4D Yang–Mills vs. UV-cutoff lattice reductions).
3. **What is new in our approach and why do we think it will be successful?**
   * **Weight-Independent Verification Pipeline (`cognition/`):** Every mathematical claim is bound to a `cryptographic_provenance_attestation` (`thought_packet_v0_1.py`, `disagreement_vector_v0_1.py`, `bipartite_counterfactual_hold`, and `proof_weave_v0_1.py`).
   * **Asymmetry of $\forall$ vs. $\exists$:** While universal ($\forall$) Millennium theorems require infinite-dimensional analytical proofs, **refuting an auxiliary conjecture ($\exists x, \neg P(x)$)** requires only **one finite counterexample witness** verified in `Lean 4` + `SymPy`. UNA-1 systematically searches for and formally certifies these exact witnesses with zero axioms (`SolutionAxioms = []`).
4. **Clay Mathematics Institute (CMI) Legal & Epistemic Governance Enforced by UNA-1:**
   Even after a complete universal proof is discovered, CMI rules require:
   1. **Publication in a peer-reviewed mathematics journal of worldwide repute.**
   2. **A 2-year waiting period of general acceptance by the global mathematics community.**
   3. **Formal verification and recommendation by the CMI Scientific Advisory Board and specialist committee.**
   UNA-1 enforces `"unproved_millennium_breakthrough_claimed": false` across all runtime channels via `epistemic_uncertainty_gate`.

---

## 2. Non-Serial MECE Specific Aims

### Specific Aim 1: 4-Engine Millennium Sub-Lemma Verification (`millennium_sublemma_explorer_v0_1.py`)
Independently verify and cross-check foundational sub-lemmas across all 7 Clay Millennium Prize domains using **Native Python + `mpmath` (50-dps) + `SymPy` CAS + `Lean 4` (`/Users/tomstudio/UNA/.toolchains/elan/bin/lean`)**:
* **4D Yang–Mills & Mass Gap:** 1-loop $\mathrm{SU}(3)$ UV asymptotic freedom ($b_0 = 11.0$), 6-step Bałaban dyadic RG decay ($g^2(a_0) = 3.231822 \to g^2(a_5) = 1.262216$), $\mathrm{SU}(2)$ Wilson plaquette positivity ($S_W = 0.09120242 > 0$), Osterwalder–Schrader reflection positivity ($\langle \Theta F, F \rangle_E = 0.5872 > 0$), and BPST self-dual instanton topological charge ($Q = 1$).
* **Riemann Hypothesis:** 64-term Euler–Wijngaarden Dirichlet $\eta(s)$ + Hardy $Z(t)$ Bolzano sign-change bisection isolating $\gamma_1 = 14.1347251417$, $\gamma_2 = 21.0220396388$, $\gamma_3 = 25.0108575802$, cross-checked against `mpmath` at 50 decimal places ($\max |Z(\gamma_k)| = 2.37 \times 10^{-50}$).
* **3D Navier–Stokes Regularity:** Symbolic `SymPy` and numerical verification of $\nabla \cdot u = 0$, 2D enstrophy conservation ($\langle (\omega \cdot \nabla)u, \omega \rangle_{2\mathrm{D}} = 0$), and 3D strained-Beltrami vortex stretching ($\langle (\omega \cdot \nabla)u, \omega \rangle_{3\mathrm{D}} = 85.40635441$, strain eigenvalue $\alpha = 1.5$, Beale–Kato–Majda $\|\omega\|_\infty = 2.0$).
* **Birch & Swinnerton-Dyer Conjecture:** Exact $\mathbb{F}_p$ point counting and Hasse bound $|a_p| \le 2\sqrt{p}$ across 43 primes ($7 \le p \le 199$) showing strict Goldfeld product ordering by Mordell–Weil rank: rank 0 ($1.198089$) $<$ rank 1 ($4.166569$) $<$ rank 2 ($11.242204$).
* **$\mathrm{P}$ vs. $\mathrm{NP}$:** Exact DPLL 3-SAT witness discovery and `Lean 4` + `SymPy` proof of the 8-clause 3-variable contradiction hypercube (`UNSAT`), paired with Relativization, Natural Proofs, and Algebrization barrier checks.
* **Hodge & Poincaré Conjectures:** Fermat quartic $K3$ Hodge diamond ($\chi = 24$, $h^{1,1} = \rho = 20$ via Lefschetz $(1,1)$) and 3D $S^3$ Hamilton–Perelman Ricci flow scalar curvature blowup ($R(0) = 1.5 \to R(0.6) = 3.75$).

### Specific Aim 2: Existence ($\exists$) Counterexample & Self-Similar Blowup Hunter (`una1_counterexample_and_blowup_hunter_v0_1.py`)
Deploy UNA-1's `Conjecture Generator + Formal Verifier + Lean 4` pipeline on problems where a **single finite witness constitutes a complete 100% rigorous proof**:
* **Track A (Tao *Equational Theories* Finite Magma Disprover):** Discovers minimal order-3 finite magmas $M_3$ refuting non-universal implications (left-stabilizing idempotent non-associative magma `op`, Steiner quasigroup `rpsOp`, and 81-case 4-variable Medial Law non-commutative magma `leftZeroOp`), formally type-checked in `Lean 4` with zero axioms.
* **Track B (Spectral Graph Theory Isomorphism Disprover):** Proves in `SymPy` that $G_1 = K_{1,4}$ and $G_2 = C_4 \cup K_1$ share the exact characteristic polynomial $x^5 - 4x^3$ (`diff = 0`) while having distinct degree sequences (`[4, 1, 1, 1, 1]` vs. `[2, 2, 2, 2, 0]`).
* **Track C (Goldbach–Euler 1752 Twice-a-Square Disprover, OEIS `A060003`):** Scans 2,217 odd composite integers to isolate the exact two Stern–Hodges counterexamples below 6,000 ($n = 5777$ and $n = 5993$) that cannot be written as $p + 2a^2$, and formally certifies both in `Lean 4` (`goldbach_1752_full_disproof_5777`, `goldbach_1752_full_disproof_5993`, submitted upstream in [`google-deepmind/formal-conjectures` PR `#7917`](https://github.com/google-deepmind/formal-conjectures/pull/7917)).
* **Track D (Constantin–Lax–Majda Self-Similar Vortex-Stretching Blowup Auditor):** Proves symbolically in `SymPy` (`residual == 0`) and at 50 decimal places in `mpmath` (`8.35e-52`) that $\Omega(y) = \frac{2y}{1+y^2}$ and its Hilbert transform $H(\Omega)(y) = \frac{2}{1+y^2}$ satisfy the exact self-similar finite-time blowup ODE $\Omega(y) + y\Omega'(y) - \Omega(y)H(\Omega)(y) = 0$.

### Specific Aim 3: Fail-Closed Epistemic Governance & Cryptographic Provenance Attestation (`cognition/`)
Guarantee that every mathematical candidate produced by an AI proposer is accompanied by:
1. A hash-chained `cryptographic_provenance_attestation` (`receipt_chain_v0_1.py` and `proof_weave_v0_1.py`).
2. A `fail_closed_abstention_gate` + `calibration_overconfidence_audit` that blocks premature breakthrough claims (`HOLD_CONFLICT` / `bipartite_counterfactual_hold`).
3. Explicit enforcement of the three CMI legal verification requirements.

---

## 3. Independent Zero-Trust External Verification & Reproducibility Appendix

To provide reviewers, program managers, and journal referees with **zero-trust outside confirmation** that does not depend on any internal UNA module (`una_modules_imported_by_auditor == 0`), all formal proofs and numerical/symbolic claims have been verified across four independent external authorities:

### 3.1 Official Lean 4 Kernel, `live.lean-lang.org` & `comparator.live.lean-lang.org` Audit
* **`leanprover/comparator` Paired Artifacts:**
  * `UNA1_Comparator_Challenge.lean` (`comparator.live.lean-lang.org` Challenge SHA-256: `ff3e2ea45dfdb5caa5081a082244d349c79a2ec1699b334c631e084a337b3fda`)
  * `UNA1_Comparator_Solution.lean`
* **External Remote Validation on `comparator.live.lean-lang.org`:**
  Verified with a green checkmark (`✓`) across **three official Lean 4 toolchains** (`Latest Mathlib with Lean v4.36.0-rc2`, `Latest Release v4.36.0-rc2`, and `Stable Release v4.35.0`).
* **Local Lean 4 (`v4.32.2`) & Lake Package (`Una1Formal/ComparatorAudit.lean`) 26-Theorem Audit:**
  `lake build Una1Formal.ComparatorAudit` verifies `cInfo.type == sInfo.type` and `Lean.collectAxioms == []` (`ZeroAxioms=true`) across all **26 formal theorems**.

### 3.2 Zero-UNA-Dependency Third-Party Black-Box Auditor (`external_third_party_auditor_v0_1.py`)
* **Auditor Receipt SHA-256:** `65f4affc166deee72bec5c9a2c91b09a462ef7911012fb1308ebdbb7227caad1`
* **External Reference Database Matches:**
  1. **Odlyzko / `mpmath` 50-Decimal-Place Riemann Zeros (`zetazero(1..3)`):** Confirmed within $|\Delta \gamma_1| = 3.5 \times 10^{-11}$, $|\Delta \gamma_2| = 2.8 \times 10^{-11}$, $|\Delta \gamma_3| = 5.4 \times 10^{-11}$.
  2. **OEIS Sequences `A060003` & `A058320` (Stern–Goldbach Odd Composites Not of the Form $p + 2a^2$):** Exact match on minimal counterexamples `[5777, 5993]`, with every residue $n - 2a^2$ ($1 \le a \le \lfloor\sqrt{n/2}\rfloor$) independently proved composite in `Lean 4` and `SymPy`.
  3. **LMFDB (L-functions and Modular Forms Database) / Cremona Elliptic Curve Tables:** Exact Frobenius trace $a_p$ ($p \in \{7, 11, 13, 17, 19\}$) match against LMFDB curve **`32a2`** ($y^2 = x^3 - x$: `0, 0, 6, 2, 0`) and LMFDB curve **`64a4`** ($y^2 = x^3 - 2x$: `0, 0, -4, -2, 0`).
  4. **`SymPy` 1.14.0 Symbolic CAS Audit:** Exact `0` symbolic residual for $\Omega(y) + y\Omega'(y) - \Omega(y)H(\Omega)(y) = 0$ on the Constantin–Lax–Majda blowup profile $\Omega(y) = \frac{2y}{y^2+1}$ and exact `0` characteristic polynomial difference for cospectral non-isomorphic graphs $K_{1,4}$ vs. $C_4 \cup K_1$.
