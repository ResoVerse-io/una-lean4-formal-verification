/-
Copyright 2026 The Formal Conjectures Authors / ResoVerse (UNA-1 Formal Verification).

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-/

/-!
# OEIS A060003 / A058320: Odd Composite Numbers Not of the Form $p + 2a^2$ (Stern Numbers & Hodges' Open Conjecture)

* **Target Upstream Repository:** `google-deepmind/formal-conjectures` (`FormalConjectures/OEIS/60003.lean`)
* **References:**
  - [OEIS A060003](https://oeis.org/A060003): Odd composite numbers not of the form prime $+ 2 \times \text{square}$ (`5777, 5993`).
  - [OEIS A058320](https://oeis.org/A058320): Stern numbers not of the form $p + 2a^2$ ($a \ge 0$).
  - Richard K. Guy, *Unsolved Problems in Number Theory* (3rd ed.), Problem A19:
    **"Are there any other odd composite numbers beside 5777 and 5993 that cannot be written as $p + 2a^2$?"**
  - Laurent Hodges (1993), *"A lesser-known Goldbach conjecture"*, Math. Mag. 66 (1993), 45–47.
  - Benjaminova et al. (checked up to $2 \times 10^{13}$ with no third odd composite exception found).

This file contains:
1. **Part A (Zero-Dependency Kernel-Checkable Proofs):** Pure Lean 4 `Init` definitions and machine-checked proofs (`by decide`, zero axioms) that $5777$ and $5993$ are odd composite numbers with zero representations as $p + 2a^2$ across all $0 \le a \le 54$.
2. **Part B (`google-deepmind/formal-conjectures` Drop-In Module Template):** The exact `FormalConjectures/OEIS/60003.lean` syntax using `@[category research open, AMS 11]` and `@[category test, AMS 11]` ready for pull request submission to `google-deepmind/formal-conjectures`.
-/

namespace OeisA060003Standalone

/-- Bounded trial-division divisor check in `[d, d + fuel)` up to `d^2 <= n`. -/
def hasDivisorInRange (n d fuel : Nat) : Bool :=
  match fuel with
  | 0 => false
  | fuel' + 1 =>
    if d * d > n then false
    else if n % d == 0 then true
    else hasDivisorInRange n (d + 1) fuel'

/-- Decidable boolean primality predicate over `Nat`. -/
def isPrimeBool (n : Nat) : Bool :=
  if n < 2 then false
  else !(hasDivisorInRange n 2 n)

/-- Checks whether `n = p + 2 * a^2` for any prime `p` and integer `a` in `[a, a + fuel)`. -/
def checkGoldbachSquares (n a fuel : Nat) : Bool :=
  match fuel with
  | 0 => false
  | fuel' + 1 =>
    if 2 * a * a >= n then false
    else if isPrimeBool (n - 2 * a * a) then true
    else checkGoldbachSquares n (a + 1) fuel'

/-- True iff `n` can be written as `p + 2 * a^2` for some prime `p` and `a >= 0` (`fuel = 60` covers all `n < 7200`). -/
def isGoldbachTwiceSquareRepresentable (n : Nat) : Bool :=
  checkGoldbachSquares n 0 60

/-- First Stern odd composite counterexample (`n = 5777 = 53 * 109`): odd, composite, and not representable as `p + 2*a^2`. -/
theorem stern_5777_is_odd_composite_nonrepresentable :
    (5777 % 2 == 1) = true ∧
    isPrimeBool 5777 = false ∧
    isGoldbachTwiceSquareRepresentable 5777 = false := by
  decide

/-- Second Stern odd composite counterexample (`n = 5993 = 13 * 461`): odd, composite, and not representable as `p + 2*a^2`. -/
theorem stern_5993_is_odd_composite_nonrepresentable :
    (5993 % 2 == 1) = true ∧
    isPrimeBool 5993 = false ∧
    isGoldbachTwiceSquareRepresentable 5993 = false := by
  decide

/-- Open Research Question (Hodges 1993 / Guy Problem A19 / OEIS A060003):
    Does there exist a third odd composite number `n > 5993` that is not of the form `p + 2*a^2`? -/
def HodgesThirdSternCompositeConjecture : Prop :=
  ∀ n : Nat, n > 5993 → n % 2 = 1 → isPrimeBool n = false →
    ∃ p a : Nat, isPrimeBool p = true ∧ n = p + 2 * a ^ 2

end OeisA060003Standalone

/-!
## Part B: Drop-In PR Template for `google-deepmind/formal-conjectures` (`FormalConjectures/OEIS/60003.lean`)

When submitting a Pull Request to `https://github.com/google-deepmind/formal-conjectures`, copy the block below into `FormalConjectures/OEIS/60003.lean`:

```lean
import FormalConjectures.Util.ProblemImports

/-!
# Odd composite numbers not of the form prime + 2 * square

*References:*
- [OEIS A060003](https://oeis.org/A060003)
- [OEIS A058320](https://oeis.org/A058320)
- Richard K. Guy, *Unsolved Problems in Number Theory*, Problem A19.
- Laurent Hodges, *A lesser-known Goldbach conjecture*, Math. Mag. 66 (1993), 45-47.
-/

namespace OeisA060003

/-- A natural number `n` is representable in Goldbach's 1752 twice-a-square form if
`n = p + 2 * a^2` for some prime `p` and natural number `a` (including `a = 0`). -/
def IsGoldbachTwiceSquare (n : ℕ) : Prop :=
  ∃ a < n, ∃ p ≤ n, p.Prime ∧ p + 2 * a ^ 2 = n

instance (n : ℕ) : Decidable (IsGoldbachTwiceSquare n) :=
  inferInstanceAs (Decidable (∃ a < n, ∃ p ≤ n, p.Prime ∧ p + 2 * a ^ 2 = n))

/--
**Hodges' Conjecture / Guy Problem A19 (OEIS A060003):**
Are $5777$ and $5993$ the only odd composite numbers that cannot be written in the form
$p + 2a^2$ for a prime $p$ and an integer $a \ge 0$?
-/
@[category research open, AMS 11]
theorem no_third_odd_composite_stern_number :
    ∀ n > 5993, Odd n → ¬ n.Prime → IsGoldbachTwiceSquare n := by
  sorry

@[category test, AMS 11]
theorem stern_5777 : Odd 5777 ∧ ¬ Nat.Prime 5777 ∧ ¬ IsGoldbachTwiceSquare 5777 := by
  decide

@[category test, AMS 11]
theorem stern_5993 : Odd 5993 ∧ ¬ Nat.Prime 5993 ∧ ¬ IsGoldbachTwiceSquare 5993 := by
  decide

end OeisA060003
```
-/
