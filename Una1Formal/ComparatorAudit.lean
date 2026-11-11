import Lean
import Una1Formal.Challenge
import Una1Formal.Solution

open Lean

def theoremNames : List String := [
  "yang_mills_su3_b0",
  "fermat_k3_euler_chi",
  "fermat_k3_h11_lefschetz",
  "hasse_bound_p7_sq",
  "unsat_3var_hypercube",
  "k4_not_3colorable",
  "magma_left_stabilizes",
  "magma_idempotent",
  "magma_not_associative",
  "cospectral_graphs_distinct_max_degree",
  "stern_5777_a1_composite",
  "stern_5777_a2_composite"
]

#eval show MetaM Unit from do
  let env ← getEnv
  IO.println "========================================================================"
  IO.println "  LEAN 4 KERNEL COMPARATOR & AXIOM AUDITOR (Challenge vs. Solution)"
  IO.println "========================================================================"
  let mut allPassed := true
  for tName in theoremNames do
    let cName := Name.mkSimple "Una1Formal" |>.str "Challenge" |>.str tName
    let sName := Name.mkSimple "Una1Formal" |>.str "Solution" |>.str tName
    match env.find? cName, env.find? sName with
    | some cInfo, some sInfo =>
      let typeMatch := cInfo.type == sInfo.type
      let cAxioms ← collectAxioms cName
      let sAxioms ← collectAxioms sName
      let sZeroAxioms := sAxioms.isEmpty
      let cUsesSorry := cAxioms.contains ``sorryAx
      if !typeMatch || !sZeroAxioms || !cUsesSorry then
        allPassed := false
      IO.println s!"  • {tName}: TypeMatch={typeMatch} | ChallengeAxioms={cAxioms.toList} | SolutionAxioms={sAxioms.toList} (ZeroAxioms={sZeroAxioms})"
    | _, _ =>
      allPassed := false
      IO.println s!"  • ERROR: Missing declaration for {tName}"
  if !allPassed then
    throwError "Lean 4 Kernel Comparator failed!"
  IO.println "------------------------------------------------------------------------"
  IO.println "  STATUS: PASS_ALL_12_THEOREMS_TYPE_MATCHED_AND_ZERO_AXIOM_VERIFIED"
  IO.println "========================================================================"

def main : IO Unit := do
  IO.println "PASS_UNA1_LEAN4_COMPARATOR_EXECUTABLE"
