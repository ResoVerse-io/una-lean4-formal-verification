-- ============================================================================
-- UNA-1 LEAN 4 COMPARATOR CANDIDATE SOLUTION (PASTE IN RIGHT PANE)
-- Matches `UNA1_Comparator_Challenge.lean` declaration-for-declaration with
-- zero `sorry` and zero `#print` side-effect commands.
-- ============================================================================

theorem yang_mills_su3_b0 : 11 * 3 / 3 = 11 := rfl

theorem fermat_k3_euler_chi : 1 - 0 + 22 - 0 + 1 = 24 := rfl

theorem fermat_k3_h11_lefschetz : 22 - 2 = 20 := rfl

theorem hasse_bound_p7_sq : (0 : Int) * 0 <= 4 * 7 := by decide

theorem unsat_3var_hypercube (b1 b2 b3 : Bool) :
    ((b1 || b2 || b3) && (b1 || b2 || !b3) && (b1 || !b2 || b3) && (b1 || !b2 || !b3) &&
     (!b1 || b2 || b3) && (!b1 || b2 || !b3) && (!b1 || !b2 || b3) && (!b1 || !b2 || !b3)) = false := by
  cases b1 <;> cases b2 <;> cases b3 <;> rfl

def valid_k4_3coloring (c1 c2 c3 c4 : Fin 3) : Bool :=
  (c1 != c2) && (c1 != c3) && (c1 != c4) &&
  (c2 != c3) && (c2 != c4) && (c3 != c4)

theorem k4_not_3colorable (c1 c2 c3 c4 : Fin 3) : valid_k4_3coloring c1 c2 c3 c4 = false := by
  revert c1 c2 c3 c4
  decide

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
  intro x y
  cases x <;> cases y <;> rfl

theorem magma_idempotent : ∀ (x : M3), op x x = x := by
  intro x
  cases x <;> rfl

theorem magma_not_associative : ∃ (x y z : M3), op (op x y) z ≠ op x (op y z) :=
  ⟨e0, e2, e1, by decide⟩

theorem cospectral_graphs_distinct_max_degree : (4 : Nat) ≠ 2 := by decide

theorem stern_5777_a1_composite : 5777 - 2 * (1 ^ 2) = 3 * 1925 := rfl

theorem stern_5777_a2_composite : 5777 - 2 * (2 ^ 2) = 3 * 1923 := rfl
