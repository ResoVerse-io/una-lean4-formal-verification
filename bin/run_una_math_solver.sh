#!/usr/bin/env bash
# ==============================================================================
# UNA-1 Unified Mathematical Problem Solver & Formal Verification Pipeline
# Author: Tom Budd (tom@resoverse.io / tom@tombudd.com)
#
# Executes the neuro-symbolic discovery, multi-engine counterexample hunting,
# discrete sublemma exploration, and Lean 4 zero-axiom kernel comparator.
# ==============================================================================

set -euo pipefail

REVOCATION_MARKER="${HOME}/Library/Application Support/UNA Revocation/REVOKED"
if [[ -e "${REVOCATION_MARKER}" || -L "${REVOCATION_MARKER}" ]]; then
  echo "HOLD_REVOCATION_MARKER_ACTIVE: ${REVOCATION_MARKER}" >&2
  exit 2
fi

PYTHON_BIN="$(which python3 || echo "python3")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${SCRIPT_DIR}"

if [ -d "${HOME}/.elan/bin" ]; then
  export PATH="${HOME}/.elan/bin:${PATH}"
elif [ -d "${HOME}/UNA/.toolchains/elan/bin" ]; then
  export PATH="${HOME}/UNA/.toolchains/elan/bin:${PATH}"
fi

echo "========================================================================"
echo "  UNA-1 MATHEMATICAL REASONING & VERIFICATION ENGINE (Terminal Runner)"
echo "  Working Directory: ${SCRIPT_DIR}"
echo "  Timestamp: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo "========================================================================"

MODE="${1:-all}"

case "${MODE}" in
  lean)
    echo "[1/1] Running Lean 4 Kernel Comparator Audit..."
    lake build Una1Formal.ComparatorAudit
    ;;
  rns)
    echo "[1/1] Running Lean 4 Veritas-M1 Compact CRT/RNS Zero-Axiom Proofs..."
    lean Una1Formal/VeritasM1CompactRNS.lean
    ;;
  hardware)
    echo "[1/1] Running Veritas-M1 Compact VLSI-1 RTL & Testbench..."
    "${PYTHON_BIN}" hardware/test_veritas_m1_rns_ntt_alu.py
    ;;
  security)
    echo "[1/1] Running UNA-1 Workspace Security & Custody Guard..."
    "${PYTHON_BIN}" security/una1_workspace_security_guard_v1.py --verify
    ;;
  counterexamples)
    echo "[1/1] Running Multi-Engine Counterexample & Blowup Hunter..."
    "${PYTHON_BIN}" una1_counterexample_and_blowup_hunter_v0_1.py
    ;;
  sublemmas)
    echo "[1/1] Running Millennium Sublemma Multi-Engine Explorer..."
    "${PYTHON_BIN}" millennium_sublemma_explorer_v0_1.py
    ;;
  audit)
    echo "[1/1] Running External Independent Zero-Axiom Auditor..."
    "${PYTHON_BIN}" external_third_party_auditor_v0_1.py
    ;;
  all)
    echo "[Stage 1/7] Running Lean 4 Kernel Comparator Audit (26 Challenge Theorems)..."
    lake build Una1Formal.ComparatorAudit
    echo ""
    echo "[Stage 2/7] Running Lean 4 Veritas-M1 Compact CRT/RNS Zero-Axiom Proofs..."
    lean Una1Formal/VeritasM1CompactRNS.lean
    echo ""
    echo "[Stage 3/7] Running Counterexample & Blowup Hunter (Magmas, Graphs, Goldbach-Stern, CLM)..."
    "${PYTHON_BIN}" una1_counterexample_and_blowup_hunter_v0_1.py | grep -E '"status"|"receipt_sha256"'
    echo ""
    echo "[Stage 4/7] Running Millennium Sublemma Multi-Engine Explorer (7 Domain Tracks)..."
    "${PYTHON_BIN}" millennium_sublemma_explorer_v0_1.py | grep -E '"status"|"receipt_sha256"'
    echo ""
    echo "[Stage 5/7] Running External Zero-Axiom & Blackbox Auditor (SymPy, mpmath, LMFDB)..."
    "${PYTHON_BIN}" external_third_party_auditor_v0_1.py | grep -E '"status"|"external_audit_receipt_sha256"'
    echo ""
    echo "[Stage 6/7] Running Veritas-M1 Compact VLSI-1 SystemVerilog RTL Testbench..."
    "${PYTHON_BIN}" hardware/test_veritas_m1_rns_ntt_alu.py | grep -E '"status"|"receipt_sha256"'
    echo ""
    echo "[Stage 7/7] Running Workspace Security & Custody Guard..."
    "${PYTHON_BIN}" security/una1_workspace_security_guard_v1.py --verify | grep -E '"status"|"manifest_intact"'
    echo ""
    echo "========================================================================"
    echo "  ALL 7 STAGES COMPLETED: ZERO-AXIOM FORMAL, RTL & SECURITY CONFIRMED"
    echo "========================================================================"
    ;;
  *)
    echo "Unknown mode: ${MODE}"
    echo "Usage: $0 [all|lean|rns|hardware|security|counterexamples|sublemmas|audit]"
    exit 1
    ;;
esac
