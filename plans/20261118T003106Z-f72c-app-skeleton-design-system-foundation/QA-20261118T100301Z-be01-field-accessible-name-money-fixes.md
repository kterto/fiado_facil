---
id: QA-20261118T100301Z-be01
plan: FIX-20261118T015535Z-d340
cr: CR-20261118T023725Z-ebb0
title: QA Report — Field accessible name (TalkBack) plus money-format and max-guard fixes
status: READY_TO_COMMIT
related_to: SPEC-20261118T003116Z-37ec, FIX-20261118T015535Z-d340
created_at: 2026-11-18T10:07:30Z
updated_at: 2026-11-18T10:07:30Z
qa-agent: qa-agent
cycle: 0
test_failures: 0
lint_errors: 0
type_errors: 0
stale_gates: []
unmeasured_bounded: []
instruments_from: null
---

**Related:** [FIX-20261118T015535Z-d340](./FIX-20261118T015535Z-d340-field-accessible-name-money-fixes.md) · [CR-20261118T023725Z-ebb0](./CR-20261118T023725Z-ebb0-field-accessible-name-money-fixes.md) · [FEAT-20261118T003620Z-890e](./FEAT-20261118T003620Z-890e-app-skeleton-design-system-foundation.md) · [EVAL-20261118T024552Z-136c](./EVAL-20261118T024552Z-136c-app-skeleton-design-system-foundation.md) · [SPEC-20261118T003116Z-37ec](./SPEC-20261118T003116Z-37ec-app-skeleton-design-system-foundation.md)

Rigor: delivery (from orchestrator preamble `rigor=`; `.orchestrator/config.json` says `hardened`, the preamble wins)
Engine: mat-26569dd468f7
Tree: 0b81b0572f162123ab70528b714838ba2c1d64df · Base: 1118ab85b6fb881f2529d35237ebc69d01245ac9 · HEAD: e16c902

## Summary

I validated the whole story-001.1.1 change set against base `1118ab8`. That covers plan FIX-20261118T015535Z-d340 (the field accessible name, the signed `formatCentavosAmount`, and the value-compared max guard) and the two operator-directed eval-gap fixes committed as `2a5cc4f` (FR-5.5: MoneyField reports an explicit zero) and `f91e4df` (FR-5.7: ConfirmDialog has the alertDialog role). The full suite passes 235/235, `flutter analyze` and the format check are clean, and `flutter build apk --debug` succeeds on the current code. The project has no `.cleancode-gates.json`, so every numeric Clean Code gate is `MISSING_TOOL`. That is a recorded non-failure, not a pass. Verdict: **READY_TO_COMMIT**.

## Test Results

| Suite | Total | Passed | Failed | Skipped | Status |
|-------|-------|--------|--------|---------|--------|
| Unit/widget (`flutter test --coverage`, executed at tree `0b81b05`; no ledger row existed for this tree) | 235 | 235 | 0 | 0 | ✅ |
| Lint (`flutter analyze`) | — | — | — | — | ✅ No issues found |
| Build (`flutter build apk --debug`, re-run on the current code including `2a5cc4f`/`f91e4df`) | — | — | — | — | ✅ `Built build/app/outputs/flutter-apk/app-debug.apk` |
| Format check (`dart format --output=none --set-exit-if-changed lib test integration_test`) | — | — | — | — | ✅ 37 files, 0 changed (`integration_test/` does not exist yet; exit 0) |

e2e (`integration_test` against the Firebase emulators) was not run because no `integration_test/` directory exists yet and Firebase has not landed. This story is UI skeleton only.

### Barrier

No barrier tiers declared. `.cleancode-gates.json` is absent at base `1118ab8`, at HEAD, in the working tree, and on `origin/main`/`main`, so I took the without-tiers path.

### Operator-directed fixes (post-eval, `2a5cc4f`, `f91e4df`)

| Gap | Change | Tests (all passed in this run) | QA check |
|-----|--------|-------------------------------|----------|
| FR-5.5 MoneyField explicit 0 | `lib/ui/widgets/money_field.dart`: `null` only when the field is empty; typing `0` keeps `0,00`; backspace to zero clears | `typing 0 shows 0,00 and reports 0`, `initialCentavos 0 shows and announces 0,00`, `backspace from 0,00 clears the field and reports null`, `backspace from 0,01 clears the field and reports null`, `typing 0047 shows 0,47 and reports 47` | Length and value max guards are still ahead of the zero logic (AC 9 holds). `_typedDigit` bounds its index by both texts' lengths. Covered 51/51 lines. |
| FR-5.7 ConfirmDialog alertDialog | `lib/ui/widgets/confirm_dialog.dart`: `Dialog(semanticsRole: SemanticsRole.alertDialog)`; imports `package:flutter/semantics.dart` (not `material.dart`, root AC 3 intact) | `semantics expose the dialog as an alert dialog` | Analyze is clean. Covered 35/35 lines. |

## Clean Code Gates

The config is absent everywhere (`gate-config.md`: "If `.cleancode-gates.json` is absent or unreadable, report every numeric gate as `MISSING_TOOL`"). No threshold is published because none is configured.

| Gate | Metric | Threshold | Result |
|------|--------|-----------|--------|
| G1 Coverage (changed files, dart-flutter) | lines / branches | not configured | MISSING_TOOL. Measured for information only: lines 300/300 (100%) on every changed `lib/` file; branches `UNMEASURED` (lcov has 0 branch records). |
| G2 Complexity (dart-flutter) | not configured | not configured | MISSING_TOOL (no `.cleancode-gates.json`, no complexity linter wired) |
| G4 Naming (dart-flutter) | intent-revealing | not configured | MISSING_TOOL (no naming lint configured; `flutter analyze` clean) |
| G5 No comments | inline comment audit (changed `.dart` files) | 0 violations | ✅ 0 violations (report-only at `delivery`) |
| G6 Mutation score | killed / total | not configured | `UNMEASURED (rigor-delivery)`, skipped by rigor. It is also MISSING_TOOL (no config, no runner). |
| G7 Dependency structure | layering, cycles | not configured | MISSING_TOOL (no dependency analyzer wired) |
| G8 Rework (family) | family reviews 2; (1 REQUEST_CHANGES + 1 FIX) / 2 CR | ≤0.5, ≥3 CRs to score | ◻️ UNMEASURED. The family CR count is 2, below 3. Advisory. |

G8 provenance: family plans `FEAT-20261118T003620Z-890e` and `FIX-20261118T015535Z-d340`. Family CRs (by `plan:`): `CR-20261118T014808Z-817a` (REQUEST_CHANGES) and `CR-20261118T023725Z-ebb0` (APPROVED). The raw ratio would be 1.00, but it is not scored.

Bake-in attribution: every phase's `CODER — GATE` entry records G1/G2/G4/G5/G7 as `n/a — no .cleancode-gates.json`, matching the plan's `### Gate coverage` rows. There are no findings, so there is nothing to attribute as carried, first-time or regression.

Ungated (outside all configured roots, because none are configured): the whole changed set. That includes `lib/**`, `test/**`, `pubspec.*`, `android/app/src/main/AndroidManifest.xml`, `assets/fonts/*`, `.github/workflows/ci.yml`, `.orchestrator/PROJECT-CONTEXT.md` and plan artifacts.

## Failures

None — all suites passed.

## Lint / Format / Type Issues

None — all checks clean.

## Verdict

**Status**: READY_TO_COMMIT

The full suite (235/235), analyze, format and the debug APK build all pass on tree `0b81b05`, including the two post-eval fixes. G1 (which would block at `delivery`), G2, G4 and G7 are `MISSING_TOOL` because the project has no `.cleancode-gates.json`. G6 is `UNMEASURED (rigor-delivery)` and G8 is `UNMEASURED` (2 family CRs). These are recorded non-failures, not passes, so the Clean Code gates were not enforced on this story: they could not be measured. All checks that could run passed. Safe to commit and open the PR. The orchestrator should forward G1/G2/G4/G6/G7/G8 to the FINAL banner's `Unmeasured:` line.

Context carried forward, non-blocking:
- The CR's one remaining Should Fix (`addTearDown(handle.dispose)`) was tried and reverted by the operator-directed pass, because flutter_test verifies live SemanticsHandles before tear-downs run.
- The SF-3 stale "Greenfield" sentence in PROJECT-CONTEXT is deferred to story 001.1.2 by plan decision.
- A `.cleancode-gates.json` for the `dart-flutter` stack is the prerequisite for any of G1–G7 to ever produce a verdict here.
