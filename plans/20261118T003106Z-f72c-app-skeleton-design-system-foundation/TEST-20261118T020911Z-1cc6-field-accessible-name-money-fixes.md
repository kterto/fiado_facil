---
id: TEST-20261118T020911Z-1cc6
plan: FIX-20261118T015535Z-d340
title: Test Report — Field accessible name (TalkBack) plus money-format and max-guard fixes
status: BELOW_FLOOR
created_at: 2026-11-18T02:31:09Z
updated_at: 2026-11-18T02:31:09Z
cycle: 0
related_to: SPEC-20261118T003116Z-37ec, FEAT-20261118T003620Z-890e, CR-20261118T014808Z-817a
---

**Related:** [FIX-20261118T015535Z-d340](./FIX-20261118T015535Z-d340-field-accessible-name-money-fixes.md)

## Summary

`rigor=delivery`. This is a retry. An earlier tester attempt with this same ID was interrupted before it wrote a report. Before the interruption it had done two things:

- It ran the whole suite at `tree=59a584a5…`: 224 of 224 passed. That ledger row is still in place, and it is true of that tree.
- It added one test file, `test/ui/widgets/field_semantics_form_test.dart`, with 5 tests.

To identify that file, I checked which files changed after the coder's `DONE` entry at 02:08:48Z. It is the only file under `test/` or `lib/` modified after that time (02:14:08Z). None of the coder's FIX entries in `.progress.md` names it, and neither does the earlier `TEST-20261118T013640Z-10cb`. I audited it the same way as the coder's tests, put it through a defect probe, and **kept it unchanged**.

At the current tree, `tree=f3ee03a46ac43f8bc25369a27757149fffd94381`, `flutter test --coverage` ran **229 tests, 229 passed**. The whole-project `dart format --set-exit-if-changed lib test` reported 0 changed, and `flutter analyze` reported no issues.

The status is **BELOW_FLOOR** for one reason only: **no gate config. `/Volumes/ssd/Developer/Flutter/fiado_facil/.cleancode-gates.json` was not found.** No G1 threshold exists, so no floor can be met. This is a gap for a human to close when bootstrapping the project, not a coverage shortfall. On the informational numbers, every changed Dart file with executable lines is at 100% line coverage (290 of 290 lines).

## Flows Triaged

Criticality = user impact × breakage likelihood × not covered by unit tests, each scored 1–3 (maximum 27).

| Flow | Criticality | Decision | Rationale |
|---|---|---|---|
| A TalkBack user moves through a form with several fields and hears each input by its own label: name, phone, then the optional money limit. This is the shape of the T1.1 new-customer form (critical flow 8) and the T2/T3.1 amount entry (critical flows 2 and 3). | 3×2×2 = **12** | **Selected and executed at widget level** | This is the gating purpose of the plan (invariant 14, MF-1/DC-1). The per-widget tests pump one field at a time, so they cannot see one field's label merging into another field's node. `field_semantics_form_test.dart` pumps `Nome` + `Telefone` + `MoneyField(Limite, (opcional))` in one form and asserts the following: each `isTextField` node carries only its own label; each label and `(opcional)` is announced exactly once, on its input; the money input's name includes `R$`; a semantics tap on the `Telefone` node focuses only the second input; typed text becomes the node's `value` while its name stays the label (hint gone, `47,90` / `4790` reported). **Observed: pass, 5 of 5.** |
| The same walk with real TalkBack on an Android device or emulator | 3×1×2 = 6 | **Excluded, not executed** | The project has no `integration_test/` harness yet; it arrives in story 001.1.2 with the Firebase emulator. TalkBack's spoken output cannot be automated even there. The widget semantics tree asserted above is what TalkBack reads. **Recommended human check** before the pilot: one manual TalkBack pass over a screen that uses these fields. |
| Amount entry at the maximum (`99.999,99`), including paste and overflow (critical flows 2 and 3) | 2×1×1 = 2 | Covered by existing tests (executed) | The boundary tests "ignores a keystroke past 99.999,99" and "ignores a pasted digit string longer than the maximum" are unchanged and pass. The SF-2 value guard is not reachable while `kMaxCentavos` is all nines (see Test-Quality Audit). |
| Showing a negative amount without the currency symbol (credit after overpayment, critical flow 3) | 2×2×1 = 4 | Covered by unit tests (executed) | `money_format_test.dart` covers `-2210`, `-5` and `-123456`, and `formatCentavos(-2210)` is still `-R$ 22,10`. No screen calls `formatCentavosAmount` with a negative value yet, so there is no flow to drive. |
| PROJECT-CONTEXT critical flows 1–10 end to end | n/a | **Excluded: not touched by this diff** | No auth, Firestore, ledger or screens exist yet. This plan changes only the shared field widgets and the money helper. |

## E2E Tests Added

None. There is no e2e harness yet (`integration_test/` comes in story 001.1.2). The selected flow is exercised at the widget level by the file the interrupted attempt added and this run kept:

- `test/ui/widgets/field_semantics_form_test.dart` (new, 5 tests, kept unchanged).

**Defect probe** (a temporary test file, run and then deleted; it reproduces each wiring with raw widgets and applies the same assertions):

| Wiring | Expected | Result |
|---|---|---|
| Label `Text` and input as siblings with no merge (the pre-fix shape) | caught | caught: the AC 1/3 assertions fail |
| `MergeSemantics` that also swallows the `FieldError` | caught | caught: the AC 5 assertions fail |
| One merge across two fields (`Nome` + `Telefone` on one node) | caught | caught: the form file's "own label only" check fails. **Only the new file can see this.** |
| `ExcludeSemantics(label)` + `Semantics(container: true, label:)` around the input (a valid alternative fix) | not caught | passes, so the tests are not tied to `MergeSemantics` |

## Coverage

**G1 gate: `MISSING_TOOL`, because there is no gate config. `/Volumes/ssd/Developer/Flutter/fiado_facil/.cleancode-gates.json` was not found.** No thresholds, roots, `exclude` or `exempt` are configured, so every changed file is ungated: it sits outside all configured roots because none exist. The numbers below are for information only.

- **Instrument:** `flutter test --coverage` → `coverage/lcov.info`.
- **Branches:** `UNMEASURED` on dart-flutter. The instrument writes zero `BRF`/`BRDA` records.

Scope: base `1118ab85b6fb881f2529d35237ebc69d01245ac9` compared to the working tree, plus untracked files, excluding `plans/` and `.orchestrator/`. Dart source with executable lines only. "Before" is the last measurement at the root plan's tester exit (`TEST-20261118T013640Z-10cb`). "After" is this run at `f3ee03a4`.

| File | Before (lines) | After (lines) |
|---|---|---|
| `lib/ui/widgets/app_text_field.dart` (FIX: `MergeSemantics` in `AppFieldLayout`) | 50/50 | 53/53 |
| `lib/ui/widgets/money_field.dart` (FIX: value guard) | 39/39 | 41/41 |
| `lib/domain/format/money_format.dart` (FIX: signed `formatCentavosAmount`) | 21/21 | 23/23 |
| `lib/main.dart`, `lib/app.dart`, `date_format.dart`, `home_screen.dart`, `app_theme.dart`, `app_button.dart`, `app_snackbar.dart`, `confirm_dialog.dart`, `field_error.dart`, `offline_banner.dart`, `top_bar.dart` (not touched by this FIX) | 173/173 | 173/173 |
| `app_colors.dart`, `app_dimens.dart`, `app_text_styles.dart` | const-only, no records | same |
| **Total** | **283/283 over 14 files** | **290/290 over 14 files** |

**Caveat on the 100% for `money_field.dart`.** The VM emits no `DA` record for either `return oldValue;` line (103 and 107). Line 103 (the length guard) is demonstrably exercised by the 23-digit paste test, so the missing records are an instrument artifact, not a gap. The same artifact means line 107, the SF-2 value guard, is not represented at all. That guard cannot be reached while `kMaxCentavos == 9999999`, so "41/41" says nothing about it. See the audit below.

Other changed paths are ungated and not Dart source: `lib/data/.gitkeep`, `android/app/src/main/AndroidManifest.xml`, `pubspec.yaml`, `pubspec.lock`, `assets/fonts/*`, and `.claude/agents/*.md`. Per the orchestrator, `.claude/agents/*.md` is orchestrator tooling, not part of this change.

**Process check:** the coder's phase gates recorded G1 as n/a (no config). This run found no coverage work to do, which is consistent with honest phase gates. No phase gate looks skipped.

**Suite ledger.** No `suites[]` row matched `flutter test --coverage` at `tree=f3ee03a4…`, so the suite was executed rather than inherited. The row at `59a584a5` (224 of 224, `at` 2026-11-18T02:12:48Z, this artifact) belongs to an earlier tree and was not inherited. I appended a new row: `flutter test --coverage`, `tree=f3ee03a46ac43f8bc25369a27757149fffd94381`, `pass`, 229 of 229, `at` 2026-11-18T02:27:58Z.

I recomputed the Step 0a hash before running, and it differs from `f3ee03a4…` only under `plans/` and `.orchestrator/`. The exclusion pathspecs did not take effect in this shell, which explains the difference. So the source and test content that was run is exactly the preamble's tree.

## Test-Quality Audit

No empty asserts and no tautologies in the FIX's tests or in the kept file. Each semantics test asserts the `isTextField` flag together with the label content, which is the failure mode the plan warned about.

- **Kept unchanged: `field_semantics_form_test.dart` (interrupted attempt, 5 tests).** It is the only test that can detect label bleed across neighbouring fields; the probe confirmed this. It also adds two behaviours no per-widget test covers: semantics-tap focuses the right input, and the name stays the label after typing (the hint is no longer in the label). Its helper `_announcedNodesLabelled` duplicates the private helper in `app_text_field_test.dart`, which is a minor duplication across test files. Analyzer and formatter are clean.
- **Weak by construction, accepted by the plan: SF-2 value guard (`money_field.dart:105-108`).** With `kMaxCentavos = 9999999` and leading zeros stripped, any input that passes the length guard is at most 9999999, so `centavos > kMaxCentavos` is never true. That makes the guard dead code today. No test can detect its removal, and line coverage does not record it either. The plan's testability note accepts this and assigns verification to the reviewer reading the code. It becomes live, and testable, only if `kMaxCentavos` stops being all nines.
- **Minor: the AC 1 tests in `app_text_field_test.dart` assert `label isNot('Ex.: Maria')`,** which is an equality check. The merged label is `"Nome\nEx.: Maria"`: Flutter folds an empty field's hint into the node label. That meets AC 1 as written. The stronger check, "the hint is not in the name once text is entered", is made by the kept form test.
- **Minor: every semantics test calls `handle.dispose()` at the end of the body rather than through `addTearDown`.** When an assertion fails, a second "SemanticsHandle was active" error is added to the output. This is cosmetic and does not cause false passes.
- **AC 6 holds:** the pre-existing layout, style, border, formatter and counter tests in both widget files are unchanged and pass.
- **AC 8 is pinned well:** `-5 → "-0,05"` exercises the sign on a zero-reais value, and `formatCentavos(-2210)` is still asserted byte-for-byte as `-R$ 22,10` (no doubled sign), with a U+002D check.

**Documentation check.** `.orchestrator/PROJECT-CONTEXT.md` states no coverage, complexity or mutation numbers, so it has no documentation defect of that kind. The FIX plan's Gate coverage row calls G1 "advisory — not measured at phase exit". With no config, n/a is the right outcome. Once a `.cleancode-gates.json` exists, G1 is not advisory: it is the same gate QA blocks on.

**Rigor note.** `.orchestrator/config.json` sets `"rigor": "hardened"`, while this spawn's preamble says `rigor=delivery`. I tested at `delivery`, as given. Even at `hardened`, the outcome here would be the same plus one carried finding: the real-device TalkBack walk was not observed.

## Verdict

**BELOW_FLOOR.** Reason: no gate config. `/Volumes/ssd/Developer/Flutter/fiado_facil/.cleancode-gates.json` was not found, so G1 is `MISSING_TOOL` and branches are `UNMEASURED` on dart-flutter.

Every check that was executed is green:

- the whole suite, 229 of 229 at `f3ee03a4`;
- the selected TalkBack-naming flow, observed at form level;
- whole-project format and analyze.

Every changed Dart file with executable lines is at 100% line coverage, with the caveat about the unreachable SF-2 guard above. Closing the gap means a human bootstraps `.cleancode-gates.json`, for example with `clean-code-gates --scaffold` or `/orchestrator --setup`. No code change is needed.

Test files added or modified in this tester ID (test files only; no production source was touched):

- `test/ui/widgets/field_semantics_form_test.dart` (new; written by the interrupted attempt; audited and kept unchanged by this run).
- No other test file was changed. The defect probe was a temporary file and has been deleted.
