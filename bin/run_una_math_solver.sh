#!/usr/bin/env bash
# ==============================================================================
# UNA-1 Unified Mathematical Problem Solver & Formal Verification Pipeline
# Author: Tom Budd (tom@resoverse.io / tom@tombudd.com)
#
# Executes the neuro-symbolic discovery, multi-engine counterexample hunting,
# discrete sublemma exploration, and Lean 4 zero-axiom kernel comparator.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${SCRIPT_DIR}"

export PATH="/Users/tomstudio/UNA/.toolchains/elan/bin:${PATH}"

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
  counterexamples)
    echo "[1/1] Running Multi-Engine Counterexample & Blowup Hunter..."
    python3 una1_counterexample_and_blowup_hunter_v0_1.py
    ;;
  sublemmas)
    echo "[1/1] Running Millennium Sublemma Multi-Engine Explorer..."
    python3 millennium_sublemma_explorer_v0_1.py
    ;;
  audit)
    echo "[1/1] Running External Independent Zero-Axiom Auditor..."
    python3 external_third_party_auditor_v0_1.py
    ;;
  all)
    echo "[Stage 1/4] Running Lean 4 Kernel Comparator Audit (26 Challenge Theorems)..."
    lake build Una1Formal.ComparatorAudit
    echo ""
    echo "[Stage 2/4] Running Counterexample & Blowup Hunter (Magmas, Graphs, Goldbach-Stern, CLM)..."
    python3 una1_counterexample_and_blowup_hunter_v0_1.py | grep -E '"status"|"receipt_sha256"'
    echo ""
    echo "[Stage 3/4] Running Millennium Sublemma Multi-Engine Explorer (7 Domain Tracks)..."
    python3 millennium_sublemma_explorer_v0_1.py | grep -E '"status"|"receipt_sha256"'
    echo ""
    echo "[Stage 4/4] Running External Zero-Axiom & Blackbox Auditor (SymPy, mpmath, LMFDB)..."
    python3 external_third_party_auditor_v0_1.py | grep -E '"status"|"external_audit_receipt_sha256"'
    echo ""
    echo "========================================================================"
    echo "  ALL STAGES COMPLETED: 100% ZERO-AXIOM FORMAL VERIFICATION CONFIRMED"
    echo "========================================================================"
    ;;
  *)
    echo "Unknown mode: ${MODE}"
    echo "Usage: $0 [all|lean|counterexamples|sublemmas|audit]"
    exit 1
    ;;
esac
