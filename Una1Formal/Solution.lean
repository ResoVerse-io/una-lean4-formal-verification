import Una1Formal.Challenge

namespace Una1Formal.Solution
open Una1Formal
open Una1Formal.M3

theorem yang_mills_su3_b0 : 11 * 3 / 3 = 11 := rfl
theorem fermat_k3_euler_chi : 1 - 0 + 22 - 0 + 1 = 24 := rfl
theorem fermat_k3_h11_lefschetz : 22 - 2 = 20 := rfl
theorem hasse_bound_p7_sq : (0 : Int) * 0 <= 4 * 7 := by decide

theorem unsat_3var_hypercube (b1 b2 b3 : Bool) :
    ((b1 || b2 || b3) && (b1 || b2 || !b3) && (b1 || !b2 || b3) && (b1 || !b2 || !b3) &&
     (!b1 || b2 || b3) && (!b1 || b2 || !b3) && (!b1 || !b2 || b3) && (!b1 || !b2 || !b3)) = false := by
  cases b1 <;> cases b2 <;> cases b3 <;> rfl

theorem k4_not_3colorable (v1 v2 v3 v4 : Color3) : valid_k4_3coloring v1 v2 v3 v4 = false := by
  cases v1 <;> cases v2 <;> cases v3 <;> cases v4 <;> rfl

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

end Una1Formal.Solution
