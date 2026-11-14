#!/opt/homebrew/bin/python3
"""UNA-1 Lean 4 Community Package Workspace Security & Custody Guard (V1).

Enforces 5 fail-closed gates:
1. Global UNA revocation kill-switch check via `os.path.lexists()`.
2. Secret token, private key, and protected UNA core path leak scan.
3. Lean 4 zero-axiom & zero-`sorry` kernel verification (`VeritasM1CompactRNS.lean`).
4. SystemVerilog RTL structural & cycle-accurate testbench gate (`hardware/test_veritas_m1_rns_ntt_alu.py`).
5. Restrictive `.git` (`0700`) permission & SHA-256 custody manifest verification (`--seal` / `--verify`).
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import stat
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

REPO_ROOT = Path(__file__).resolve().parent.parent
SECURITY_DIR = Path(__file__).resolve().parent
MANIFEST_PATH = SECURITY_DIR / "WORKSPACE_CUSTODY_AND_PREIMAGE_MANIFEST_V1.json"
REVOCATION_MARKER = Path(os.environ.get("REVOCATION_MARKER", str(Path.home() / "Library/Application Support/UNA Revocation/REVOKED")))
_lean_which = shutil.which("lean") or str(Path.home() / ".elan/bin/lean")
if not Path(_lean_which).is_file() and (Path.home() / "UNA/.toolchains/elan/bin/lean").is_file():
    _lean_which = str(Path.home() / "UNA/.toolchains/elan/bin/lean")
LEAN_BIN = Path(_lean_which)

SOLUTION_LEAN_FILES = (
    "Solution.lean",
    "Una1Formal/Solution.lean",
    "Una1Formal/VeritasM1CompactRNS.lean",
    "UNA1_Comparator_Solution.lean",
    "UNA1_Millennium_And_Counterexample_Proofs.lean",
)

VERITAS_M1_THEOREMS = (
    "veritas_m1_rns_moduli_pairwise_coprime",
    "veritas_m1_rns_dynamic_range_exceeds_58_bits",
    "veritas_m1_crt_modular_inverses_valid",
    "veritas_m1_crt_idempotent_orthogonality",
    "veritas_m1_crt_reconstruct_48bit_witness",
    "veritas_m1_rns_ring_homomorphism_add_mul_witness",
    "veritas_m1_fu1_exact_rational_pi_convergent_diff",
    "veritas_m1_fu3_mlkem_ntt_q3329_butterfly_invertible",
)

SKIP_DIRS = {".git", ".lake", "build", "__pycache__"}
SCAN_EXTENSIONS = {".lean", ".py", ".sv", ".sh", ".md", ".txt", ".tex", ".yaml", ".yml", ".toml", ".json"}


def _canonical_json(obj: Any) -> bytes:
    return json.dumps(obj, sort_keys=True, separators=(",", ":")).encode("utf-8")


def _sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def check_revocation_gate() -> dict[str, Any]:
    active = os.path.lexists(str(REVOCATION_MARKER))
    return {
        "gate": "1_revocation_kill_switch",
        "marker": str(REVOCATION_MARKER),
        "revoked": active,
        "status": "HOLD_REVOCATION_MARKER_ACTIVE" if active else "PASS_NO_REVOCATION_MARKER",
    }


def _iter_workspace_files(*, include_manifest: bool = False) -> list[Path]:
    files: list[Path] = []
    for root, dirs, filenames in os.walk(REPO_ROOT):
        dirs[:] = sorted(d for d in dirs if d not in SKIP_DIRS)
        root_p = Path(root)
        for fname in sorted(filenames):
            if fname == ".DS_Store" or fname.endswith(".pyc"):
                continue
            p = root_p / fname
            if not include_manifest and p == MANIFEST_PATH:
                continue
            files.append(p)
    return files


def check_secret_and_protected_path_scan() -> dict[str, Any]:
    # Build patterns dynamically so this guard does not trigger on its own source text.
    pem_hdr = "-----BEGIN "
    secret_regexes = [
        ("private_key_pem", re.compile(pem_hdr + r"(?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----")),
        ("api_key_sk", re.compile(r"\bsk-(?:ant-|proj-)[A-Za-z0-9_-]{12,}")),
        ("github_token", re.compile(r"\b(?:ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,})")),
        ("slack_token", re.compile(r"\bxox[baprs]-[A-Za-z0-9-]{12,}")),
        ("aws_access_key", re.compile(r"\bAKIA[0-9A-Z]{16}\b")),
    ]
    protected_paths = [
        str(Path.home() / "UNA/credentials"),
        str(Path.home() / "UNA/secrets"),
        str(Path.home() / "UNA/founder_packets"),
        str(Path.home() / "UNA/identity"),
        str(Path.home() / "Library/Application Support/UNA UltraCode Enrollment"),
        "UNA UltraCode Enrollment",
        "founder_packets/",
    ]
    self_rel = Path(__file__).resolve().relative_to(REPO_ROOT).as_posix()

    findings: list[dict[str, str]] = []
    scanned_count = 0
    for p in _iter_workspace_files(include_manifest=False):
        rel = p.relative_to(REPO_ROOT).as_posix()
        if p.suffix.lower() not in SCAN_EXTENSIONS and p.name not in {".gitignore", "LICENSE"}:
            continue
        if rel == self_rel:
            continue
        scanned_count += 1
        try:
            text = p.read_text(encoding="utf-8", errors="ignore")
        except Exception:
            continue
        for rule_name, rx in secret_regexes:
            if rx.search(text):
                findings.append({"file": rel, "finding": rule_name})
        if p.name != ".gitignore":
            for prot in protected_paths:
                if prot in text:
                    findings.append({"file": rel, "finding": f"protected_path_reference:{prot}"})
        if re.match(r"^\.env($|\.)", p.name) or p.suffix.lower() in {".pem", ".key", ".p12"}:
            findings.append({"file": rel, "finding": "sensitive_credential_file_present"})

    passed = len(findings) == 0
    return {
        "gate": "2_secret_and_protected_path_scan",
        "files_scanned": scanned_count,
        "findings": findings,
        "status": "PASS_ZERO_SECRETS_AND_PROTECTED_PATH_LEAKS" if passed else "HOLD_SECRET_OR_PATH_LEAK",
    }


def _strip_lean_comments(src: str) -> str:
    src_no_block = re.sub(r"/-.*?-/", " ", src, flags=re.DOTALL)
    return re.sub(r"--[^\n]*", "", src_no_block)


def check_lean4_zero_axiom_gate() -> dict[str, Any]:
    sorry_violations: list[str] = []
    for rel in SOLUTION_LEAN_FILES:
        p = REPO_ROOT / rel
        if not p.is_file():
            sorry_violations.append(f"missing:{rel}")
            continue
        stripped = _strip_lean_comments(p.read_text(encoding="utf-8"))
        if re.search(r"\b(?:sorry|sorryAx)\b", stripped):
            sorry_violations.append(rel)

    lean_target = REPO_ROOT / "Una1Formal/VeritasM1CompactRNS.lean"
    lean_proc = subprocess.run(
        [str(LEAN_BIN), str(lean_target)],
        cwd=str(REPO_ROOT),
        capture_output=True,
        text=True,
        check=False,
    )
    out = lean_proc.stdout
    theorems_verified = all(
        f"'Una1Formal.VeritasM1CompactRNS.{thm}' does not depend on any axioms" in out
        for thm in VERITAS_M1_THEOREMS
    )
    sorry_ax_absent = "sorryAx" not in out
    kernel_ok = (lean_proc.returncode == 0) and theorems_verified and sorry_ax_absent

    passed = (len(sorry_violations) == 0) and kernel_ok
    return {
        "gate": "3_lean4_zero_axiom_and_sorry_gate",
        "lean_binary": str(LEAN_BIN),
        "solution_files_checked": list(SOLUTION_LEAN_FILES),
        "sorry_violations": sorry_violations,
        "veritas_m1_theorems_verified": theorems_verified,
        "lean_returncode": lean_proc.returncode,
        "status": "PASS_ZERO_SORRY_AND_ZERO_AXIOM_VERIFIED" if passed else "HOLD_LEAN4_AXIOM_OR_SORRY_FAILURE",
    }


def check_hardware_rtl_gate() -> dict[str, Any]:
    tb_path = REPO_ROOT / "hardware/test_veritas_m1_rns_ntt_alu.py"
    proc = subprocess.run(
        [sys.executable, str(tb_path)],
        cwd=str(REPO_ROOT),
        capture_output=True,
        text=True,
        check=False,
    )
    parsed: dict[str, Any] = {}
    ok = False
    if proc.returncode == 0:
        try:
            parsed = json.loads(proc.stdout)
            ok = parsed.get("status") == "PASS_VERITAS_M1_RNS_NTT_ALU_RTL_AND_TESTBENCH_VERIFIED"
        except Exception:
            ok = False
    return {
        "gate": "4_hardware_rtl_and_testbench_gate",
        "testbench": "hardware/test_veritas_m1_rns_ntt_alu.py",
        "rtl_sha256": (parsed.get("rtl") or {}).get("rtl_sha256"),
        "receipt_sha256": parsed.get("receipt_sha256"),
        "simulation": parsed.get("simulation"),
        "status": "PASS_VERITAS_M1_RNS_NTT_ALU_RTL_AND_TESTBENCH_VERIFIED" if ok else "HOLD_HARDWARE_RTL_GATE_FAILED",
    }


def _check_git_permissions() -> dict[str, Any]:
    git_dir = REPO_ROOT / ".git"
    if not git_dir.is_dir():
        return {"git_dir_exists": False, "mode_octal": None, "owner_only_0700": False}
    mode = stat.S_IMODE(git_dir.stat().st_mode)
    return {
        "git_dir_exists": True,
        "mode_octal": f"{mode:04o}",
        "owner_only_0700": (mode & 0o077) == 0,
    }


def _snapshot_governed_files() -> dict[str, dict[str, Any]]:
    snapshot: dict[str, dict[str, Any]] = {}
    for p in _iter_workspace_files(include_manifest=False):
        rel = p.relative_to(REPO_ROOT).as_posix()
        raw = p.read_bytes()
        snapshot[rel] = {"sha256": _sha256_bytes(raw), "bytes": len(raw)}
    return snapshot


def seal_manifest(prereq_gates: list[dict[str, Any]]) -> dict[str, Any]:
    git_perm = _check_git_permissions()
    files_map = _snapshot_governed_files()
    manifest: dict[str, Any] = {
        "schema": "UNA1_LEAN4_WORKSPACE_CUSTODY_MANIFEST_V1",
        "sealed_utc": datetime.now(timezone.utc).isoformat(),
        "repo_root": ".",
        "git_permissions": git_perm,
        "file_count": len(files_map),
        "prerequisite_gates": {g["gate"]: g["status"] for g in prereq_gates},
        "files": files_map,
    }
    manifest["manifest_sha256"] = _sha256_bytes(_canonical_json(manifest))
    MANIFEST_PATH.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    return {
        "gate": "5_custody_and_preimage_manifest_gate",
        "mode": "seal",
        "manifest_path": MANIFEST_PATH.relative_to(REPO_ROOT).as_posix(),
        "manifest_sha256": manifest["manifest_sha256"],
        "file_count": manifest["file_count"],
        "git_permissions": git_perm,
        "status": (
            "PASS_CUSTODY_MANIFEST_SEALED"
            if git_perm["owner_only_0700"]
            else "HOLD_GIT_PERMISSIONS_NOT_OWNER_ONLY_0700"
        ),
    }


def verify_custody_manifest(*, strict_drift: bool) -> dict[str, Any]:
    git_perm = _check_git_permissions()
    if not strict_drift:
        return {
            "gate": "5_custody_and_preimage_manifest_gate",
            "mode": "verify-pre-commit",
            "manifest_present": MANIFEST_PATH.is_file(),
            "git_permissions": git_perm,
            "status": (
                "PASS_PRE_COMMIT_GIT_PERMS_AND_GATES_OK"
                if git_perm["owner_only_0700"]
                else "HOLD_GIT_PERMISSIONS_NOT_OWNER_ONLY_0700"
            ),
        }

    if not MANIFEST_PATH.is_file():
        return {
            "gate": "5_custody_and_preimage_manifest_gate",
            "mode": "verify",
            "git_permissions": git_perm,
            "status": "HOLD_CUSTODY_MANIFEST_MISSING",
        }

    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    recorded_sha = manifest.get("manifest_sha256")
    body = {k: v for k, v in manifest.items() if k != "manifest_sha256"}
    computed_sha = _sha256_bytes(_canonical_json(body))
    manifest_intact = (recorded_sha == computed_sha)

    expected = manifest.get("files") or {}
    observed = _snapshot_governed_files()
    modified = [k for k in sorted(expected.keys() & observed.keys()) if expected[k] != observed[k]]
    missing = sorted(set(expected.keys()) - set(observed.keys()))
    unexpected = sorted(set(observed.keys()) - set(expected.keys()))

    clean = manifest_intact and git_perm["owner_only_0700"] and not (modified or missing or unexpected)
    return {
        "gate": "5_custody_and_preimage_manifest_gate",
        "mode": "verify",
        "manifest_intact": manifest_intact,
        "file_count_verified": len(expected),
        "modified_files": modified,
        "missing_files": missing,
        "unexpected_files": unexpected,
        "git_permissions": git_perm,
        "status": "PASS_CUSTODY_MANIFEST_ZERO_DRIFT" if clean else "HOLD_WORKSPACE_CUSTODY_DRIFT",
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="UNA-1 Lean 4 Workspace Security & Custody Guard V1")
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--seal", action="store_true", help="Verify gates 1-4 and seal SHA-256 custody manifest.")
    group.add_argument("--verify", action="store_true", help="Enforce all 5 gates strictly (default).")
    group.add_argument(
        "--verify-pre-commit",
        action="store_true",
        help="Run gates 1-4 and .git 0700 permission checks cleanly during git commit.",
    )
    args = parser.parse_args(argv)

    g1 = check_revocation_gate()
    if g1["revoked"]:
        report = {
            "schema": "UNA1_WORKSPACE_SECURITY_GUARD_REPORT_V1",
            "status": "HOLD_REVOCATION_MARKER_ACTIVE",
            "gates": [g1],
        }
        print(json.dumps(report, indent=2))
        return 2

    g2 = check_secret_and_protected_path_scan()
    g3 = check_lean4_zero_axiom_gate()
    g4 = check_hardware_rtl_gate()
    prereqs = [g1, g2, g3, g4]
    prereqs_ok = all(g["status"].startswith("PASS_") for g in prereqs)

    if args.seal:
        if not prereqs_ok:
            report = {
                "schema": "UNA1_WORKSPACE_SECURITY_GUARD_REPORT_V1",
                "status": "HOLD_CANNOT_SEAL_PREREQUISITE_GATE_FAILED",
                "gates": prereqs,
            }
            print(json.dumps(report, indent=2))
            return 1
        g5 = seal_manifest(prereqs)
    else:
        g5 = verify_custody_manifest(strict_drift=(not args.verify_pre_commit))

    gates = prereqs + [g5]
    all_passed = all(g["status"].startswith("PASS_") for g in gates)
    report = {
        "schema": "UNA1_WORKSPACE_SECURITY_GUARD_REPORT_V1",
        "checked_utc": datetime.now(timezone.utc).isoformat(),
        "status": "PASS_WORKSPACE_SECURE_AND_VERIFIED" if all_passed else "HOLD_WORKSPACE_SECURITY_GATE_FAILED",
        "gates": gates,
    }
    print(json.dumps(report, indent=2))
    return 0 if all_passed else 1


if __name__ == "__main__":
    sys.exit(main())
