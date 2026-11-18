# Progress: FIX-20261118T015535Z-d340 — Field accessible name (TalkBack) plus money-format and max-guard fixes

**Plan**: [FIX-20261118T015535Z-d340-field-accessible-name-money-fixes.md](./FIX-20261118T015535Z-d340-field-accessible-name-money-fixes.md)
**Status**: QA_READY_TO_COMMIT
**Created**: 2026-11-18T01:56:56Z

---

## Log

### 2026-11-18T01:56:56Z | ARCHITECT

Created plan `FIX-20261118T015535Z-d340`. Type: fix. Tasks: 11 (5 gating, 6 optional).
Source CR: `CR-20261118T014808Z-817a` (REQUEST_CHANGES, cycle 1). MF-1 / DC-1 (2 sites, one repair in `AppFieldLayout`) gating; SF-1 and SF-2 planned as optional (non-gating); SF-3 deferred by decision to roadmap story 001.1.2 because root AC 7 limits the PROJECT-CONTEXT diff to two hunks.

### 2026-11-18T01:58:43Z | CODER

Session started. Plan status → IN_PROGRESS.

### 2026-11-18T02:00:46Z | CODER

Completed task: "Write failing semantics tests in `test/ui/widgets/app_text_field_test.dart` (new `group('semantics', …)`) covering AC 1, AC 2, AC 3 for `AppTextField`, and AC 5 with `errorText`. Run them and confirm that the AC 1–3 tests fail against the current code."
Plan tasks remaining: 19 unchecked

### 2026-11-18T02:00:46Z | CODER

Completed task: "Write failing semantics tests in `test/ui/widgets/money_field_test.dart` covering AC 4, AC 3 for `MoneyField`, and AC 5 with `errorText`. Confirm that the AC 4 test fails against the current code."
Plan tasks remaining: 18 unchecked

### 2026-11-18T02:02:36Z | CODER

Completed task: "Implement the label-to-input semantics link in `AppFieldLayout` (`lib/ui/widgets/app_text_field.dart`), with an optional semantic currency context that `MoneyField` fills from `kCurrencySymbol` (`lib/ui/widgets/money_field.dart`). Keep `FieldError` outside any merge."
Plan tasks remaining: 17 unchecked

### 2026-11-18T02:02:52Z | CODER — DC-1 census (AC 7)

Command: `grep -rnE "TextField\(|EditableText\(|TextFormField\(|labelText|Semantics\(" lib`

```
lib/ui/widgets/app_text_field.dart:10:  const AppTextField({
lib/ui/widgets/app_text_field.dart:50:      input: TextField(
lib/ui/widgets/app_text_field.dart:96:        MergeSemantics(
lib/ui/widgets/confirm_dialog.dart:76:      child: Semantics(
lib/ui/widgets/money_field.dart:56:      input: TextField(
lib/ui/widgets/top_bar.dart:49:                child: Semantics(
lib/ui/widgets/field_error.dart:16:    return Semantics(
lib/ui/widgets/offline_banner.dart:24:    return Semantics(
```

Text inputs: exactly 2 — `app_text_field.dart:50` and `money_field.dart:56`, both passed as `input:` to `AppFieldLayout`. New hit `app_text_field.dart:96` is the fix itself (`MergeSemantics`), not a text input. `confirm_dialog`, `top_bar`, `field_error`, `offline_banner` are non-input `Semantics(` as before. No `TextField` in `lib/` lacks a linked label.

Implementation note (MF-1): `AppFieldLayout` now wraps the label `Text.rich` + 8 gap + `input` in a `MergeSemantics`; `FieldError` stays outside it as its own `container`/`liveRegion` node (AC 5 tests). Probed merged text-field labels: `AppTextField(Nome, hint Ex.: Maria)` → `"Nome\nEx.: Maria"`; `(Limite, (opcional), maxLength 40)` → `"Limite (opcional)\n40 caracteres restantes"`; `MoneyField(Valor, 4790)` → label `"Valor\nR$"`, value `47,90`. The `R$` currency context comes from the existing `kCurrencySymbol` prefix `Text` merging into the node, so the optional semantic-suffix parameter the Technical Notes suggested was NOT added: it would announce `R$` twice. `lib/ui/widgets/money_field.dart` therefore needs no Phase 1 change; no public constructor changed.

### 2026-11-18T02:02:52Z | CODER

Completed task: "Re-run the CR's census command (`grep -rnE "TextField\(|EditableText\(|TextFormField\(|labelText|Semantics\(" lib`). Confirm that both sites, and only those two, are text inputs and that both go through `AppFieldLayout` (AC 7). Append the census output to `.progress.md`."
Plan tasks remaining: 16 unchecked

### 2026-11-18T02:02:52Z | CODER

Completed task: "Run `flutter test test/ui/widgets/app_text_field_test.dart test/ui/widgets/money_field_test.dart` and confirm it is green, with every pre-existing test unchanged (AC 6)."
Plan tasks remaining: 15 unchecked

### 2026-11-18T02:05:48Z | CODER — GATE
Phase: 1  Files gated: 3  Base: 1118ab85b6fb881f2529d35237ebc69d01245ac9
format (dart-flutter): pass — exit 0, 4 files (0 changed)
  cmd: dart format --output=none --set-exit-if-changed lib/ui/widgets/app_text_field.dart lib/ui/widgets/money_field.dart test/ui/widgets/app_text_field_test.dart test/ui/widgets/money_field_test.dart  scope: changed-files
analyze (dart-flutter): pass — No issues found
  cmd: flutter analyze lib/ui/widgets test/ui/widgets  scope: changed-files
test (dart-flutter): pass — 34/34
  cmd: flutter test test/ui/widgets/app_text_field_test.dart test/ui/widgets/money_field_test.dart  scope: changed-files
G1 (dart-flutter): n/a — no .cleancode-gates.json (plan Gate coverage row)
G2 (dart-flutter): n/a — no .cleancode-gates.json (plan Gate coverage row)
G4 (dart-flutter): n/a — no .cleancode-gates.json (plan Gate coverage row)
G5 (dart-flutter): n/a — no .cleancode-gates.json (plan Gate coverage row)
G7 (dart-flutter): n/a — no .cleancode-gates.json (plan Gate coverage row)
Phase-1 intersection: lib/ui/widgets/app_text_field.dart, test/ui/widgets/app_text_field_test.dart, test/ui/widgets/money_field_test.dart (money_field.dart listed by the plan's format command but unchanged this phase; run as written).

### 2026-11-18T02:05:48Z | CODER

Completed task: "`dart format --output=none --set-exit-if-changed lib/ui/widgets/app_text_field.dart lib/ui/widgets/money_field.dart test/ui/widgets/app_text_field_test.dart test/ui/widgets/money_field_test.dart`"
Plan tasks remaining: 14 unchecked

### 2026-11-18T02:05:48Z | CODER

Completed task: "`flutter analyze lib/ui/widgets test/ui/widgets`"
Plan tasks remaining: 13 unchecked

### 2026-11-18T02:05:48Z | CODER

Completed task: "`flutter test test/ui/widgets/app_text_field_test.dart test/ui/widgets/money_field_test.dart`"
Plan tasks remaining: 12 unchecked

### 2026-11-18T02:06:14Z | CODER

Completed task: "(optional) Write failing tests in `test/domain/format/money_format_test.dart` under `group('formatCentavosAmount')` for `-2210 → "-22,10"`, `-5 → "-0,05"` and `-123456 → "-1.234,56"`. Confirm that they fail against the current code."
Plan tasks remaining: 11 unchecked

### 2026-11-18T02:06:40Z | CODER

Completed task: "(optional) Implement sign handling in `formatCentavosAmount` (`lib/domain/format/money_format.dart`), using integers only, so that every existing `formatCentavos` and `formatCentavosAmount` test stays green."
Plan tasks remaining: 10 unchecked

### 2026-11-18T02:06:40Z | CODER

Completed task: "(optional) Run `flutter test test/domain/format/money_format_test.dart test/ui/widgets/money_field_test.dart` and confirm it is green."
Plan tasks remaining: 9 unchecked

### 2026-11-18T02:07:17Z | CODER — GATE
Phase: 2  Files gated: 2  Base: 1118ab85b6fb881f2529d35237ebc69d01245ac9
format (dart-flutter): pass — exit 0, 2 files (0 changed)
  cmd: dart format --output=none --set-exit-if-changed lib/domain/format/money_format.dart test/domain/format/money_format_test.dart  scope: changed-files
analyze (dart-flutter): pass — No issues found
  cmd: flutter analyze lib/domain/format test/domain/format  scope: changed-files
test (dart-flutter): pass — 40/40
  cmd: flutter test test/domain/format/money_format_test.dart test/ui/widgets/money_field_test.dart  scope: changed-files
G1, G2, G4, G5, G7 (dart-flutter): n/a — no .cleancode-gates.json (plan Gate coverage rows)

### 2026-11-18T02:07:17Z | CODER

Completed task: "`dart format --output=none --set-exit-if-changed lib/domain/format/money_format.dart test/domain/format/money_format_test.dart`"
Plan tasks remaining: 8 unchecked

### 2026-11-18T02:07:17Z | CODER

Completed task: "`flutter analyze lib/domain/format test/domain/format`"
Plan tasks remaining: 7 unchecked

### 2026-11-18T02:07:17Z | CODER

Completed task: "`flutter test test/domain/format/money_format_test.dart test/ui/widgets/money_field_test.dart`"
Plan tasks remaining: 6 unchecked

### 2026-11-18T02:07:43Z | CODER

Completed task: "(optional) Run the existing max-boundary tests in `test/ui/widgets/money_field_test.dart` ("ignores a keystroke past 99.999,99" and "ignores a pasted digit string longer than the maximum") and confirm they are green before the change. They are the regression pin; see the testability note in Technical Notes."
Plan tasks remaining: 5 unchecked

### 2026-11-18T02:07:43Z | CODER

Completed task: "(optional) Add the value comparison `parseDigitsToCentavos(digits) > kMaxCentavos → oldValue` in `_CentavosInputFormatter.formatEditUpdate` (`lib/ui/widgets/money_field.dart`) after the existing length guard."
Plan tasks remaining: 4 unchecked

### 2026-11-18T02:08:04Z | CODER

Completed task: "(optional) Run `flutter test test/ui/widgets/money_field_test.dart` and confirm it is green with the boundary tests unchanged."
Plan tasks remaining: 3 unchecked

### 2026-11-18T02:08:41Z | CODER — GATE
Phase: 3  Files gated: 1  Base: 1118ab85b6fb881f2529d35237ebc69d01245ac9
format (dart-flutter): pass — exit 0, 1 file (0 changed)
  cmd: dart format --output=none --set-exit-if-changed lib/ui/widgets/money_field.dart  scope: changed-files
analyze (dart-flutter): pass — No issues found
  cmd: flutter analyze lib/ui/widgets/money_field.dart test/ui/widgets/money_field_test.dart  scope: changed-files
test (dart-flutter): pass — 15/15 (boundary tests unchanged and green before and after the change)
  cmd: flutter test test/ui/widgets/money_field_test.dart  scope: changed-files
G1, G2, G4, G5, G7 (dart-flutter): n/a — no .cleancode-gates.json (plan Gate coverage rows)
Note (SF-2): length guard kept first (prevents FormatException on a 23-digit paste); value guard `parseDigitsToCentavos(digits) > kMaxCentavos → oldValue` added after it. Not behaviorally distinguishable while kMaxCentavos is all nines (plan testability note); verify by reading `_CentavosInputFormatter.formatEditUpdate`.

### 2026-11-18T02:08:41Z | CODER

Completed task: "`dart format --output=none --set-exit-if-changed lib/ui/widgets/money_field.dart`"
Plan tasks remaining: 2 unchecked

### 2026-11-18T02:08:41Z | CODER

Completed task: "`flutter analyze lib/ui/widgets/money_field.dart test/ui/widgets/money_field_test.dart`"
Plan tasks remaining: 1 unchecked

### 2026-11-18T02:08:41Z | CODER

Completed task: "`flutter test test/ui/widgets/money_field_test.dart`"
Plan tasks remaining: 0 unchecked

### 2026-11-18T02:08:48Z | CODER

All tasks complete. Plan status → DONE.
Total tasks completed this session: 11 (plus 9 phase-verification items)

### 2026-11-18T02:31:09Z | TESTER

Test suite complete.
Report: plans/20261118T003106Z-f72c-app-skeleton-design-system-foundation/TEST-20261118T020911Z-1cc6-field-accessible-name-money-fixes.md
Status: BELOW_FLOOR
Coverage: 283/283 → 290/290 lines (branches UNMEASURED; changed files, vs configured G1: no `.cleancode-gates.json` — G1 MISSING_TOOL)
Coverage still below the configured G1 thresholds after best effort. See report. (Sole reason: no gate config exists; every changed Dart file is at 100% line coverage.)
Suite: executed `flutter test --coverage` at tree f3ee03a46ac43f8bc25369a27757149fffd94381 — 229/229 pass; ledger row appended (at 2026-11-18T02:27:58Z). Not inherited: only prior row for this artifact is at tree 59a584a5 (stale).
Retry note: the interrupted attempt added `test/ui/widgets/field_semantics_form_test.dart` (5 tests); audited, defect-probed, kept unchanged.

### 2026-11-18T02:44:05Z | REVIEWER

Code review complete.
CR: plans/20261118T003106Z-f72c-app-skeleton-design-system-foundation/CR-20261118T023725Z-ebb0-field-accessible-name-money-fixes.md
Status: APPROVED
Must Fix: 0 | Should Fix: 1
Ready for QA — invoke /qa with plan ID FIX-20261118T015535Z-d340.

### 2026-11-18T09:59:28Z | CODER — FIX (operator-directed, eval gaps FR-5.5/FR-5.7)

Source: EVAL-20261118T024552Z-136c `## Gaps (ranked)` items 1-2. No new plan artifact; TDD red -> green.

- FR-5.5 `lib/ui/widgets/money_field.dart`: `null` only when the field is empty. A zero result keeps `0,00` when the edit inserted a digit (typing `0`), and clears to empty when it only removed text (backspace from `0,00` / `0,01`). `initialCentavos: 0` renders `0,00`, `null` renders empty. Max/overflow guards unchanged.
  Red: `typing 0` and `initialCentavos 0` expected `0,00`, got `''`; `backspace from 0,00` failed at its precondition.
- FR-5.7 `lib/ui/widgets/confirm_dialog.dart`: `Dialog(semanticsRole: SemanticsRole.alertDialog)` (material_ui 1.11.1 `dialog.dart:98`; `SemanticsRole` from `package:flutter/semantics.dart`, which material_ui does not re-export).
  Red: `semantics expose the dialog as an alert dialog` found 0 alertDialog nodes.
- Tests: +5 in `test/ui/widgets/money_field_test.dart`, +1 in `test/ui/widgets/confirm_dialog_test.dart`. No existing test changed. The spec does not contradict any old assertion.
- SF-1 (`addTearDown(handle.dispose)`) tried and reverted. flutter_test checks for live SemanticsHandles in `_endOfTestVerifications`, before tear-downs run, so the tests fail. Kept the explicit `handle.dispose()`.

Gates (repo root):
- `dart format --output=none --set-exit-if-changed lib test`: exit 0, 37 files, 0 changed
- `flutter analyze`: exit 0, No issues found
- `flutter test`: exit 0, +235 All tests passed

### 2026-11-18T10:03:48Z | QA

Precondition check: Plan FIX-20261118T015535Z-d340 status=DONE, CR=CR-20261118T023725Z-ebb0 CR status=APPROVED. Proceeding.
Rigor: delivery (from orchestrator preamble). No `.cleancode-gates.json` at base 1118ab8, HEAD, working tree or origin/main: no barrier tiers declared, without-tiers path; numeric gates MISSING_TOOL.

### 2026-11-18T10:06:10Z | QA

Ran: flutter test --coverage
Tree: 0b81b0572f162123ab70528b714838ba2c1d64df
Result: PASS — Total: 235 | Passed: 235 | Failed: 0 | Skipped: 0
(No ledger row for this tree; executed and appended a qa row.)

### 2026-11-18T10:06:20Z | QA

Ran: dart format --output=none --set-exit-if-changed lib test integration_test
Result: PASS — 37 files, 0 changed (integration_test/ absent; exit 0)

### 2026-11-18T10:06:35Z | QA

Ran: flutter analyze
Result: PASS — No issues found

### 2026-11-18T10:06:50Z | QA

Ran: flutter build apk --debug
Result: PASS — Built build/app/outputs/flutter-apk/app-debug.apk (current code incl. 2a5cc4f, f91e4df)

### 2026-11-18T10:07:00Z | QA

Gate G1 (coverage)
Ran: flutter test --coverage → coverage/lcov.info
Result: MISSING_TOOL — no .cleancode-gates.json; informational: lines 300/300 on changed lib files, branches UNMEASURED

### 2026-11-18T10:07:00Z | QA

Gate G2/G4/G7 (complexity, naming, dependency structure)
Ran: —
Result: MISSING_TOOL — no .cleancode-gates.json, no tool wired

### 2026-11-18T10:07:00Z | QA

Gate G5 (no comments)
Ran: G5 awk audit over changed .dart files vs 1118ab8
Result: PASS — 0 violations (report-only at rigor delivery)

### 2026-11-18T10:07:00Z | QA

Gate G6 (mutation)
Ran: —
Result: UNMEASURED (rigor-delivery) — skipped by rigor; also no config/runner

### 2026-11-18T10:07:00Z | QA

Gate G8 (rework, family)
Ran: grep -rl SPEC-20261118T003116Z-37ec plans; CRs by `plan:` provenance
Result: UNMEASURED — 2 family CRs (< 3); raw (1 RC + 1 FIX)/2 = 1.00 not scored

### 2026-11-18T10:07:30Z | QA

QA suite complete.
Report: plans/20261118T003106Z-f72c-app-skeleton-design-system-foundation/QA-20261118T100301Z-be01-field-accessible-name-money-fixes.md
Status: READY_TO_COMMIT
Test failures: 0 | Lint errors: 0 | Type errors: 0
All checks pass. Safe to commit and open PR.

---

## Handoff

| From      | To        | Condition                  | Action                                                       |
| --------- | --------- | -------------------------- | ------------------------------------------------------------ |
| ARCHITECT | CODER     | Plan created               | `invoke /coder with plan ID FIX-20261118T015535Z-d340`       |
| CODER     | REVIEWER  | All tasks [x], status DONE | `invoke /reviewer with plan ID FIX-20261118T015535Z-d340`    |
| REVIEWER  | ARCHITECT | REQUEST_CHANGES            | `invoke /architect with CR-{NNN} file path`                  |
| REVIEWER  | QA        | APPROVED                   | `invoke /qa with plan ID FIX-20261118T015535Z-d340`          |
| QA        | ARCHITECT | BLOCKED                    | `invoke /architect with QA-{NNN} file path`                  |
