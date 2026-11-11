-- ============================================================================
-- UNA-1 LEAN 4 COMPARATOR CHALLENGE SPECIFICATION (PASTE IN LEFT PANE)
-- In comparator.live.lean-lang.org:
--   1. Click the "No challenge" dropdown at top-left and choose "Custom challenge".
--   2. Paste this Challenge Specification into the LEFT pane.
-- ============================================================================

theorem yang_mills_su3_b0 : 11 * 3 / 3 = 11 := by sorry

theorem fermat_k3_euler_chi : 1 - 0 + 22 - 0 + 1 = 24 := by sorry

theorem fermat_k3_h11_lefschetz : 22 - 2 = 20 := by sorry

theorem hasse_bound_p7_sq : (0 : Int) * 0 <= 4 * 7 := by sorry

theorem unsat_3var_hypercube (b1 b2 b3 : Bool) :
    ((b1 || b2 || b3) && (b1 || b2 || !b3) && (b1 || !b2 || b3) && (b1 || !b2 || !b3) &&
     (!b1 || b2 || b3) && (!b1 || b2 || !b3) && (!b1 || !b2 || b3) && (!b1 || !b2 || !b3)) = false := by
  sorry

def valid_k4_3coloring (c1 c2 c3 c4 : Fin 3) : Bool :=
  (c1 != c2) && (c1 != c3) && (c1 != c4) &&
  (c2 != c3) && (c2 != c4) && (c3 != c4)

theorem k4_not_3colorable (c1 c2 c3 c4 : Fin 3) : valid_k4_3coloring c1 c2 c3 c4 = false := by
  sorry

inductive M3 where
  | e0 : M3
  | e1 : M3
  | e2 : M3
  deriving DecidableEq, Repr

open M3

def op : M3 → M3 → M3
  | e0, e0 => e0
  | e0, e1 => e1
  | e0, e2 => e0
  | e1, e0 => e0
  | e1, e1 => e1
  | e1, e2 => e0
  | e2, e0 => e0
  | e2, e1 => e0
  | e2, e2 => e2

theorem magma_left_stabilizes : ∀ (x y : M3), op x (op x y) = op x y := by
  sorry

theorem magma_idempotent : ∀ (x : M3), op x x = x := by
  sorry

theorem magma_not_associative : ∃ (x y z : M3), op (op x y) z ≠ op x (op y z) := by
  sorry

theorem cospectral_graphs_distinct_max_degree : (4 : Nat) ≠ 2 := by sorry

theorem stern_5777_a1_composite : 5777 - 2 * (1 ^ 2) = 3 * 1925 := by sorry

theorem stern_5777_a2_composite : 5777 - 2 * (2 ^ 2) = 3 * 1923 := by sorry
