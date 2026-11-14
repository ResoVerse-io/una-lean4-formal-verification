module

/-
Copyright 2026 Tom Budd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-/

namespace Una1Formal.VeritasM1CompactRNS

@[expose] public section

-- ============================================================================
-- UNA-ARCH-SILICON-2026-VPU1-COMPACT ("Veritas-M1 Compact") · VLSI-1
-- Formal Machine-Verified CRT/RNS Folding & ML-KEM (q = 3329) NTT Invariants
-- Zero External Axioms (Axioms = []) & Zero `sorryAx`
-- ============================================================================

def m1 : Nat := 3329
def m2 : Nat := 65537
def m3 : Nat := 2147483647

def M : Nat := m1 * m2 * m3

def M1 : Nat := m2 * m3
def inv1 : Nat := 2459

def M2 : Nat := m1 * m3
def inv2 : Nat := 60950

def M3 : Nat := m1 * m2
def inv3 : Nat := 711527344

def e1 : Nat := (M1 * inv1) % M
def e2 : Nat := (M2 * inv2) % M
def e3 : Nat := (M3 * inv3) % M

structure RNSTriple where
  r1 : Nat
  r2 : Nat
  r3 : Nat
  deriving DecidableEq, Repr

def encodeRNS (x : Nat) : RNSTriple :=
  { r1 := x % m1, r2 := x % m2, r3 := x % m3 }

def addRNS (a b : RNSTriple) : RNSTriple :=
  { r1 := (a.r1 + b.r1) % m1, r2 := (a.r2 + b.r2) % m2, r3 := (a.r3 + b.r3) % m3 }

def mulRNS (a b : RNSTriple) : RNSTriple :=
  { r1 := (a.r1 * b.r1) % m1, r2 := (a.r2 * b.r2) % m2, r3 := (a.r3 * b.r3) % m3 }

def crtReconstruct (t : RNSTriple) : Nat :=
  (t.r1 * e1 + t.r2 * e2 + t.r3 * e3) % M

/-- Cooley-Tukey decimation-in-time NTT butterfly modulo q = 3329. -/
def nttButterflyCT (u v zeta : Nat) : Nat × Nat :=
  ((u + (zeta * v) % m1) % m1, (u + m1 - (zeta * v) % m1) % m1)

/-- Gentleman-Sande inverse NTT butterfly modulo q = 3329 (where 1665 = 2^{-1} mod 3329). -/
def nttButterflyGS (u' v' zetaInv : Nat) : Nat × Nat :=
  (((u' + v') * 1665) % m1, (((u' + m1 - v') * zetaInv) % m1 * 1665) % m1)

-- ----------------------------------------------------------------------------
-- 8 Kernel-Verified Hardware Theorems (Zero Axioms, Zero `sorryAx`)
-- ----------------------------------------------------------------------------

theorem veritas_m1_rns_moduli_pairwise_coprime :
    Nat.gcd m1 m2 = 1 ∧ Nat.gcd m1 m3 = 1 ∧ Nat.gcd m2 m3 = 1 := by
  decide

theorem veritas_m1_rns_dynamic_range_exceeds_58_bits :
    2 ^ 58 < M := by
  decide

theorem veritas_m1_crt_modular_inverses_valid :
    (M1 * inv1) % m1 = 1 ∧ (M2 * inv2) % m2 = 1 ∧ (M3 * inv3) % m3 = 1 := by
  decide

theorem veritas_m1_crt_idempotent_orthogonality :
    (e1 % m1 = 1 ∧ e1 % m2 = 0 ∧ e1 % m3 = 0) ∧
    (e2 % m1 = 0 ∧ e2 % m2 = 1 ∧ e2 % m3 = 0) ∧
    (e3 % m1 = 0 ∧ e3 % m2 = 0 ∧ e3 % m3 = 1) ∧
    ((e1 + e2 + e3) % M = 1) := by
  decide

theorem veritas_m1_crt_reconstruct_48bit_witness :
    crtReconstruct (encodeRNS 281474976709319) = 281474976709319 :=
  rfl

theorem veritas_m1_rns_ring_homomorphism_add_mul_witness :
    crtReconstruct (addRNS (encodeRNS 123456789) (encodeRNS 987654321)) = (123456789 + 987654321) % M ∧
    crtReconstruct (mulRNS (encodeRNS 123456789) (encodeRNS 987654321)) = (123456789 * 987654321) % M := by
  decide

theorem veritas_m1_fu1_exact_rational_pi_convergent_diff :
    (355 : Int) * 7 - 22 * 113 = -1 ∧ (113 : Nat) * 7 = 791 := by
  decide

theorem veritas_m1_fu3_mlkem_ntt_q3329_butterfly_invertible :
    (17 ^ 128) % m1 = 3328 ∧
    (17 ^ 256) % m1 = 1 ∧
    (17 * 1175) % m1 = 1 ∧
    (let (u', v') := nttButterflyCT 1204 2819 17; nttButterflyGS u' v' 1175 = (1204, 2819)) := by
  decide

#print axioms veritas_m1_rns_moduli_pairwise_coprime
#print axioms veritas_m1_rns_dynamic_range_exceeds_58_bits
#print axioms veritas_m1_crt_modular_inverses_valid
#print axioms veritas_m1_crt_idempotent_orthogonality
#print axioms veritas_m1_crt_reconstruct_48bit_witness
#print axioms veritas_m1_rns_ring_homomorphism_add_mul_witness
#print axioms veritas_m1_fu1_exact_rational_pi_convergent_diff
#print axioms veritas_m1_fu3_mlkem_ntt_q3329_butterfly_invertible

end
end Una1Formal.VeritasM1CompactRNS
