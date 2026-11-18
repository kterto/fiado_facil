---
id: FIX-20261118T015535Z-d340
title: Field accessible name (TalkBack) plus money-format and max-guard fixes
type: fix
status: DONE
created_at: 2026-11-18T01:56:56Z
updated_at: 2026-11-18T02:08:48Z
cycle: 0
related_to: SPEC-20261118T003116Z-37ec, CR-20261118T014808Z-817a, FEAT-20261118T003620Z-890e
---

**Related:** [SPEC-20261118T003116Z-37ec](./SPEC-20261118T003116Z-37ec-app-skeleton-design-system-foundation.md) · [CR-20261118T014808Z-817a](./CR-20261118T014808Z-817a-app-skeleton-design-system-foundation.md) · [FEAT-20261118T003620Z-890e](./FEAT-20261118T003620Z-890e-app-skeleton-design-system-foundation.md)

## Overview

This plan answers code review `CR-20261118T014808Z-817a` (REQUEST_CHANGES, cycle 1) on root plan `FEAT-20261118T003620Z-890e`. The one blocker, MF-1 / defect class DC-1, is that the shared `AppFieldLayout` draws the field label as a sibling `Text` that is not linked to the input. As a result TalkBack announces `AppTextField` by its placeholder and `MoneyField` with no name at all, which breaks invariant 14. One fix in `AppFieldLayout` covers both census sites.

The plan also includes two of the CR's Should Fix items as non-gating work:

- **SF-1.** `formatCentavosAmount` returns the wrong amount for negative input. The orchestrator's simplify pass introduced this regression when it removed the negative branch, so the plan includes it as the orchestrator asked.
- **SF-2.** The MoneyField max guard counts digits instead of comparing the value to `kMaxCentavos`.

**SF-3 is deferred by decision and is not planned here.** It is the stale "Greenfield — only the Flutter template exists …" sentence at `.orchestrator/PROJECT-CONTEXT.md:55`. The reason: root plan AC 7 requires `git diff .orchestrator/PROJECT-CONTEXT.md` to show exactly two hunks. Editing that line now would add a third hunk and make an already-met root criterion fail. The CR itself says the item is "not worth a cycle here".
Follow-up: roadmap story 001.1.2 (`roadmap/001-foundation/001.1-scaffold/001.1.2-firebase-emulators.md`), the next story that edits PROJECT-CONTEXT.

## Acceptance Criteria

1. With semantics enabled, `AppTextField(label: 'Nome', hintText: 'Ex.: Maria')` exposes a text-field semantics node (`SemanticsFlag.isTextField`). That node's `label` contains `Nome` and is not equal to `Ex.: Maria`. The placeholder is no longer the field's accessible name.
2. With semantics enabled, `AppTextField(label: 'Nome', labelSuffix: '(opcional)')` exposes a text-field semantics node whose `label` contains both `Nome` and `(opcional)`.
3. The visible label is announced once. In the semantics tree of a pumped `AppTextField(label: 'Nome')`, exactly one node has a `label` that contains `Nome`, and it is the text-field node. In a pumped `MoneyField(label: 'Valor')`, exactly one node has a `label` that contains `Valor`, and it is the text-field node.
4. With semantics enabled, `MoneyField(label: 'Valor', initialCentavos: 4790)` exposes a text-field semantics node whose `label` contains `Valor` and `R$`, and whose `value` is `47,90`.
5. When `errorText` is set on either `AppTextField` or `MoneyField`, the `FieldError` message is still its own live-region semantics node (`SemanticsFlag.isLiveRegion`, label contains the message). It is not merged into the text-field node.
6. Every pre-existing test in `test/ui/widgets/app_text_field_test.dart` and `test/ui/widgets/money_field_test.dart` passes with its assertions unchanged. The label style, the 8 gap between label and input, the borders, the formatters and the counter all stay as they are, so the visual layout does not regress.
7. Both census sites of DC-1 get their accessible name from `AppFieldLayout`: `AppTextField` (`lib/ui/widgets/app_text_field.dart:50`) and `MoneyField` (`lib/ui/widgets/money_field.dart:56`). No `TextField` in `lib/` is left without a linked label. A re-run of the CR's census command finds no new text input outside `AppFieldLayout`.

## Optional (non-gating)

8. `formatCentavosAmount` is correct for negative input: `-2210 → "-22,10"`, `-5 → "-0,05"`, `-123456 → "-1.234,56"`. All root AC 17 examples still hold (`123456 → "1.234,56"`, `0 → "0,00"`, and every `formatCentavos` example including `-2210 → "-R$ 22,10"`). Integer arithmetic only, with no `double`, `num` or `intl` (root AC 21).
9. The MoneyField input formatter returns `oldValue` whenever the parsed centavos value of the new digits is greater than `kMaxCentavos`, using a value comparison. The digit-length check stays and runs before the value is parsed, as the overflow guard. The existing boundary tests pass unchanged: `9999999` accepted and shown as `99.999,99`, one more digit ignored, and a 23-digit paste ignored.

## Out of Scope

- **SF-3 (stale "Greenfield" sentence in `.orchestrator/PROJECT-CONTEXT.md:55`).** Deferred by decision to roadmap story 001.1.2, because root AC 7 restricts the PROJECT-CONTEXT diff to two hunks. Do not touch `.orchestrator/PROJECT-CONTEXT.md` in this plan.
- What `MoneyField` should do with a negative `initialCentavos`. No caller passes one, and the spec does not define it. SF-1 fixes only the shared formatting helper.
- Any change to `AppTextField`'s or `MoneyField`'s public constructor parameters.
- A `semanticLabel` on any `Icon`. Root AC 31 still applies: decorative icons stay excluded from semantics.
- `int` minimum-value overflow in `abs()`. It is not a reachable money value.

## Technical Notes

- **Defect class DC-1 census (from the CR, re-verified at planning time).** I ran `grep -rnE "TextField\(|EditableText\(|TextFormField\(|labelText|Semantics\(" lib`. It found exactly two text inputs: `lib/ui/widgets/app_text_field.dart:50` and `lib/ui/widgets/money_field.dart:56`. Both are passed as `input` to `AppFieldLayout` (`app_text_field.dart:74-121`). The other `Semantics(` hits (`confirm_dialog.dart`, `top_bar.dart`, `field_error.dart`, `offline_banner.dart`) are not text inputs. **Sites: 2.** The single repair goes in `AppFieldLayout`, and the AC 1–4 tests cover both sites.
- **MF-1 approach (the coder chooses, within these constraints).** Link the visible label (plus `labelSuffix`) to the input's semantics node, and keep the label `Text` from being announced as a separate node. The CR offers two shapes:
  - `ExcludeSemantics` around the label `Text.rich`, plus a `Semantics(label: …)` around `input`.
  - A `MergeSemantics` around the label and the input only.

  **Do not wrap the `FieldError` in the merge.** It must stay its own `container: true, liveRegion: true` node (AC 5). Before relying on a plain `Semantics(label:)` wrapper, confirm with the AC 1 test that its label actually lands on the `isTextField` node and not on a sibling or parent node. That is the failure mode the tests exist to catch.
- **MoneyField currency context (AC 4).** The `R$` prefix is rendered as an `InputDecoration.prefixIcon` `Text`, which today contributes nothing to the node (the CR probe found `label=""`). The simplest way to add currency context is to have `AppFieldLayout` accept an optional semantic suffix, or a full semantic-label override, that `MoneyField` fills with `kCurrencySymbol`. `AppFieldLayout` is the shared internal layout, not a public widget contract, so adding an optional parameter there is in scope. Do not hard-code `'R$'` a second time: use `kCurrencySymbol`.
- **Semantics test mechanics.** Use `final handle = tester.ensureSemantics();` … `handle.dispose();`. Find the text-field node with `tester.getSemantics(find.byType(EditableText))`. Assert its `label` and `value`, and check flags with `hasFlag(SemanticsFlag.isTextField)`, or use `matchesSemantics(...)` / `containsSemantics(...)` with `isTextField: true`. For AC 3, use `find.bySemanticsLabel(RegExp('Nome'))` and expect `findsOneWidget`. For AC 5, use `tester.getSemantics(find.byType(FieldError))` and check `isLiveRegion`. Get `SemanticsFlag` from `dart:ui`, or through `material_ui`/`flutter_test` re-exports. Do not import `package:flutter/material.dart` (root AC 3).
- **SF-1 (AC 8).** The root cause is that Dart's `%` is non-negative and `~/` truncates toward zero. The census of that idiom applied to a possibly-negative int in `lib/` found **1 site**: `lib/domain/format/money_format.dart:16-17`, found with `grep -rnE "~/|% ?100|\.abs\(\)" lib`. Fix it by formatting `centavos.abs()` and prefixing `-` when `centavos < 0`. `formatCentavos` can keep passing `abs()`. Its output must stay byte-identical for every root AC 17 example, so the hyphen-minus still comes before `R$` and is not doubled.
- **SF-2 (AC 9).** In `_CentavosInputFormatter.formatEditUpdate` (`money_field.dart:101-104`), keep `digits.length > _maxDigits → oldValue` first. Without it, `int.parse` of a 23-digit paste throws a `FormatException`. Then add `parseDigitsToCentavos(digits) > kMaxCentavos → oldValue`. **Testability note:** `kMaxCentavos` is currently `9999999`, all nines, so no behavioral test can tell the length guard from the value guard. Do not widen the formatter's or the widget's API to inject a different maximum just to test this. The existing boundary tests are the regression pin, and the reviewer verifies the value comparison by reading the code.
- Invariant 1: money stays an integer in centavos everywhere. Invariant 14: the app works with TalkBack, and this plan's gating purpose is that invariant.
- UI copy is unchanged. No new user-visible string is added. The semantic label is built from the caller's existing `label` and `labelSuffix` plus `kCurrencySymbol`.

## Tasks

> Tasks are ordered TDD-first: write/update tests before implementation.
> The coder will check off [ ] → [x] as each task is verified.
> Each phase ends with a `### Phase N verification` checklist the coder MUST run and RECORD the verdict of before checking the last task in the phase — exit 0, or a carried `CODER — GATE` entry naming the fix it rejected and why. A gate it cannot clear never blocks the phase. The exact commands per phase come from `## Verification (per phase)` below.

### Phase 1 — MF-1 / DC-1: accessible name for every field (gating; AC 1–7)

- [x] Write failing semantics tests in `test/ui/widgets/app_text_field_test.dart` (new `group('semantics', …)`) covering AC 1, AC 2, AC 3 for `AppTextField`, and AC 5 with `errorText`. Run them and confirm that the AC 1–3 tests fail against the current code.
- [x] Write failing semantics tests in `test/ui/widgets/money_field_test.dart` covering AC 4, AC 3 for `MoneyField`, and AC 5 with `errorText`. Confirm that the AC 4 test fails against the current code.
- [x] Implement the label-to-input semantics link in `AppFieldLayout` (`lib/ui/widgets/app_text_field.dart`), with an optional semantic currency context that `MoneyField` fills from `kCurrencySymbol` (`lib/ui/widgets/money_field.dart`). Keep `FieldError` outside any merge.
- [x] Re-run the CR's census command (`grep -rnE "TextField\(|EditableText\(|TextFormField\(|labelText|Semantics\(" lib`). Confirm that both sites, and only those two, are text inputs and that both go through `AppFieldLayout` (AC 7). Append the census output to `.progress.md`.
- [x] Run `flutter test test/ui/widgets/app_text_field_test.dart test/ui/widgets/money_field_test.dart` and confirm it is green, with every pre-existing test unchanged (AC 6).

#### Phase 1 verification

- [x] `dart format --output=none --set-exit-if-changed lib/ui/widgets/app_text_field.dart lib/ui/widgets/money_field.dart test/ui/widgets/app_text_field_test.dart test/ui/widgets/money_field_test.dart`
- [x] `flutter analyze lib/ui/widgets test/ui/widgets`
- [x] `flutter test test/ui/widgets/app_text_field_test.dart test/ui/widgets/money_field_test.dart`

### Phase 2 — SF-1: signed `formatCentavosAmount` (optional; AC 8)

- [x] (optional) Write failing tests in `test/domain/format/money_format_test.dart` under `group('formatCentavosAmount')` for `-2210 → "-22,10"`, `-5 → "-0,05"` and `-123456 → "-1.234,56"`. Confirm that they fail against the current code.
- [x] (optional) Implement sign handling in `formatCentavosAmount` (`lib/domain/format/money_format.dart`), using integers only, so that every existing `formatCentavos` and `formatCentavosAmount` test stays green.
- [x] (optional) Run `flutter test test/domain/format/money_format_test.dart test/ui/widgets/money_field_test.dart` and confirm it is green.

#### Phase 2 verification

- [x] `dart format --output=none --set-exit-if-changed lib/domain/format/money_format.dart test/domain/format/money_format_test.dart`
- [x] `flutter analyze lib/domain/format test/domain/format`
- [x] `flutter test test/domain/format/money_format_test.dart test/ui/widgets/money_field_test.dart`

### Phase 3 — SF-2: value-compared max guard (optional; AC 9)

- [x] (optional) Run the existing max-boundary tests in `test/ui/widgets/money_field_test.dart` ("ignores a keystroke past 99.999,99" and "ignores a pasted digit string longer than the maximum") and confirm they are green before the change. They are the regression pin; see the testability note in Technical Notes.
- [x] (optional) Add the value comparison `parseDigitsToCentavos(digits) > kMaxCentavos → oldValue` in `_CentavosInputFormatter.formatEditUpdate` (`lib/ui/widgets/money_field.dart`) after the existing length guard.
- [x] (optional) Run `flutter test test/ui/widgets/money_field_test.dart` and confirm it is green with the boundary tests unchanged.

#### Phase 3 verification

- [x] `dart format --output=none --set-exit-if-changed lib/ui/widgets/money_field.dart`
- [x] `flutter analyze lib/ui/widgets/money_field.dart test/ui/widgets/money_field_test.dart`
- [x] `flutter test test/ui/widgets/money_field_test.dart`

## Verification (per phase)

> Emit this section in EVERY FEAT plan. Before checking off the LAST task in
> any phase, the coder runs the gate commands from the Commands section of
> PROJECT-CONTEXT.md that apply to the phase's touched paths and records the
> verdict of each. A failure it cannot clear inside its authorized tasks is
> RECORDED as a `CODER — GATE` entry in `.progress.md` and the phase proceeds —
> never a `BLOCKED` stop, and never a silent rewrite.

Use the Commands section of `PROJECT-CONTEXT.md` to work out the per-phase gate commands. Its phase gate is format check + `flutter analyze` + `flutter test`, scoped to the touched paths. Run only the commands whose path condition matches the phase's diff. A phase may exit only when every applicable command has been run and its verdict recorded: either exit 0, or a carried `GATE` entry that names the rejected fix and why it was rejected. Do not silently rewrite source to make a gate pass without a matching plan task.

| Command | Scope | Phases | Path condition |
| ------- | ----- | ------ | -------------- |
| `dart format --output=none --set-exit-if-changed <changed-dart-paths>` | changed-files | 1, 2, 3 | The phase changed `.dart` files under `lib/` or `test/`. Fill `<changed-dart-paths>` with exactly those files. Use the non-mutating check form, never the write form. |
| `flutter analyze <changed-lib-and-test-paths>` | changed-files | 1, 2, 3 | The phase changed `.dart` files. Fill the placeholder with the phase's `lib/…` and `test/…` paths. |
| `flutter test <changed-test-paths>` | changed-files | 1, 2, 3 | Fill the placeholder with the phase's test files, plus `test/ui/widgets/money_field_test.dart` in Phase 2 because `MoneyField` consumes `formatCentavosAmount`. Never run bare `flutter test`. |

The whole-project `dart format … lib test`, `flutter analyze` and `flutter test` (root AC 35) are the run's barrier (tester/QA), not a phase row.

### Gate coverage

| Gate | Phases | Carried by | Assertion |
| ---- | ------ | ---------- | --------- |
| G1 | n/a: the project has no `.cleancode-gates.json`, so no coverage floor or roots are configured | n/a | advisory — not measured at phase exit |
| G2 | n/a: no `.cleancode-gates.json` (no complexity roots configured) | n/a | not asserted |
| G4 | n/a: no `.cleancode-gates.json` (no naming roots configured) | n/a | not asserted |
| G5 | n/a: no `.cleancode-gates.json` (no no-comments roots configured) | n/a | not asserted |
| G6 | — | — | QA-only — never run at phase exit |
| G7 | n/a: no `.cleancode-gates.json` (no dependency-structure roots configured) | n/a | not asserted |

## Dependencies

- `FEAT-20261118T003620Z-890e` (DONE). This plan amends its field widgets and money helper.

## Progress Log

<!-- Agents append below. Never rewrite entries. Newest on top. -->

### 2026-11-18T10:07:30Z | QA

QA-20261118T100301Z-be01 created. Status: READY_TO_COMMIT. Family: 2 reviews, rework UNMEASURED. Failures: 0. Lint/type errors: 0.

### 2026-11-18T02:44:05Z | REVIEWER

CR-20261118T023725Z-ebb0 created. Status: APPROVED. Must Fix: 0. Should Fix: 1.

### 2026-11-18T02:31:09Z | TESTER

TEST-20261118T020911Z-1cc6 created. Status: BELOW_FLOOR (no gate config — `.cleancode-gates.json` not found; G1 MISSING_TOOL). Coverage: 283/283 → 290/290 lines (stmts/lines 100% on every changed Dart file; branches UNMEASURED on dart-flutter; changed files, vs configured G1: none configured). Suite 229/229 at tree f3ee03a4. Kept `test/ui/widgets/field_semantics_form_test.dart` (added by the interrupted attempt) unchanged after audit + defect probe.

### 2026-11-18T02:08:48Z | CODER

All 11 tasks complete (plus 9 phase-verification items). Plan status → DONE. Ready for reviewer.

### 2026-11-18T01:58:43Z | CODER

Session started. Plan status → IN_PROGRESS. Beginning from first unchecked task.

### 2026-11-18T01:56:56Z | ARCHITECT

Plan `FIX-20261118T015535Z-d340` created. Type: fix. Tasks: 11 (5 gating in Phase 1, 6 optional in Phases 2–3; phase-verification checklists not counted).
Source CR: `CR-20261118T014808Z-817a`. Coverage: MF-1/DC-1 (2 sites) gating; SF-1 and SF-2 optional; SF-3 deferred by decision to story 001.1.2 (root AC 7).
Status: PLANNED. Ready for coder.
