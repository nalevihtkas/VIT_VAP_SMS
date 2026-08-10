# Automated Verification Workflow

After synthesis, each category contains `scripts/verify_results.tcl`. Run it with ordinary Tcl:

```bash
tclsh scripts/verify_results.tcl
```

It prints and saves:

```text
verification/verification_report.txt
```

Statuses mean:

- **PASS** — the requested evidence is actually present (or an intended redundant structure is demonstrably absent).
- **INFO** — useful evidence exists, but the result is not sufficient by itself to prove the optimization.
- **NOT PROVEN** — the demo RTL/library cannot establish physical insertion or automatic optimization; inspect the stated limitation.
- **FAIL** — an expected output/input file or mandatory setup element is missing.

The verifier intentionally does not label a feature PASS solely because a synthesis command was accepted. For retiming, ICG, MBFF, level shifting, isolation, retention, and power switches, structural/report evidence is required.
