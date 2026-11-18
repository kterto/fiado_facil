---
id: CR-20261118T023725Z-ebb0
plan: FIX-20261118T015535Z-d340
related_to: SPEC-20261118T003116Z-37ec, FIX-20261118T015535Z-d340
title: Review of Field accessible name (TalkBack) plus money-format and max-guard fixes
status: APPROVED
created_at: 2026-11-18T02:44:05Z
updated_at: 2026-11-18T02:44:05Z
reviewer: reviewer-agent
cycle: 2
root_plan: FEAT-20261118T003620Z-890e
must_fix_count: 0
should_fix_count: 1
requirements_unmet: 0
review_budget: 2
family_cr_count: 0
---

**Related:** [FIX-20261118T015535Z-d340](./FIX-20261118T015535Z-d340-field-accessible-name-money-fixes.md) · [CR-20261118T014808Z-817a](./CR-20261118T014808Z-817a-app-skeleton-design-system-foundation.md) · [FEAT-20261118T003620Z-890e](./FEAT-20261118T003620Z-890e-app-skeleton-design-system-foundation.md) · [SPEC-20261118T003116Z-37ec](./SPEC-20261118T003116Z-37ec-app-skeleton-design-system-foundation.md) · [TEST-20261118T020911Z-1cc6](./TEST-20261118T020911Z-1cc6-field-accessible-name-money-fixes.md)

## Summary

I reviewed the whole change set against base `1118ab8`, using working-tree snapshot `e32a7e4`. Since cycle 1 (snapshot `0c2b93e`), only three source files changed: `app_text_field.dart`, `money_field.dart` and `money_format.dart`. Four test files changed with them. The cycle-1 blocker MF-1 / DC-1 is closed. `AppFieldLayout` now wraps the label and the input in one `MergeSemantics`, and keeps `FieldError` outside it. My own semantics probe shows that TalkBack now gets `Nome` and `Valor` + `R$` as the input's name. SF-1 and SF-2 are also fixed correctly.

The whole-project gates pass when I re-run them: `dart format` changed 0 files, `flutter analyze` reports "No issues found!", and `flutter test` passes 229 of 229. All 9 FIX criteria and all 39 root requirements are verified. **Verdict: APPROVED.**

## Acceptance Criteria Check

| # | Criterion | Met? | Notes |
|---|-----------|------|-------|
| 1 | `AppTextField(label: 'Nome', hintText: 'Ex.: Maria')`: the text-field node's label contains `Nome` and is not the placeholder | ✅ | `app_text_field_test.dart` group `semantics`. Probe: `label="Nome\nEx.: Maria\n60 caracteres restantes"` with `maxLength: 60`, `isTextField=true`. The hint is still read after the name while the field is empty; the form test asserts it disappears once text is entered |
| 2 | The label suffix is in the text-field node's label | ✅ | Asserted for `(opcional)` |
| 3 | The label is announced once, on the text-field node (both widgets) | ✅ | Asserted via the unmerged-node predicate in both widget tests and in `field_semantics_form_test.dart` |
| 4 | `MoneyField` node label contains `Valor` and `R$`; value `47,90` | ✅ | Probe: `label="Valor\nR$"`, `value="47,90"`. `R$` comes from the merged prefix `Text(kCurrencySymbol)`, so no second literal was added and no new `AppFieldLayout` parameter was needed |
| 5 | `FieldError` stays its own live-region node, not merged into the input | ✅ | `FieldError` is a sibling of the `MergeSemantics` (`app_text_field.dart:124-127`). Asserted for both widgets |
| 6 | Pre-existing widget tests unchanged and green; layout unchanged | ✅ | The diff to the two test files since `0c2b93e` only adds lines (+74/−0, +51/−0). The label, the 8 gap and the input keep their order and stretch alignment inside the nested `Column` |
| 7 | Both DC-1 sites get their name from `AppFieldLayout`; census finds no new input | ✅ | Census re-run: text inputs only at `app_text_field.dart:50` and `money_field.dart:56`, both passed as `input:` to `AppFieldLayout` |
| 8 | ⏭️ optional: `formatCentavosAmount` signed | ✅ (non-gating) | `money_format.dart:15-21` formats `abs()` and adds a `-` prefix. `-2210/-5/-123456` are pinned, and `formatCentavos(-2210)` is still `-R$ 22,10` |
| 9 | ⏭️ optional: value-compared max guard after the length guard | ✅ (non-gating) | `money_field.dart:102-108`: the length guard comes first (overflow guard), then `centavos > kMaxCentavos`. Verified by reading the code, as the plan specifies. The guard cannot be reached while `kMaxCentavos` is all nines, which the plan accepts |

## Requirement Coverage Check

These rows are the root plan's map (`FEAT-20261118T003620Z-890e`). In cycle 1 all 39 were verified on snapshot `0c2b93e`. Since then only three source files changed (`app_text_field.dart`, `money_field.dart`, `money_format.dart`). The rows they back (FR-4.1, FR-5.4, FR-5.5, FR-7.4, FR-7.5) were re-checked against the new code. The other rows rest on files that are byte-identical to `0c2b93e`, and on the whole suite, which still passes.

| Spec req # | Requirement | Claimed | Verified | Notes |
|-----------|-------------|---------|----------|-------|
| FR-1.1 | `main.dart` no counter; locks portraitUp, runs app | Met-by-plan | ✅ | Unchanged since cycle 1 |
| FR-1.2 | Root `MaterialApp` title, pt_BR locale, delegates, light theme | Met-by-plan | ✅ | Unchanged |
| FR-1.3 | Android label `Fiado Fácil`, activity portrait | Met-by-plan | ✅ | Unchanged |
| FR-1.4 | pubspec adds provider, intl, flutter_localizations; description | Met-by-plan | ✅ | Unchanged |
| FR-1.5 | Layered folders `ui/`, `domain/format/`, `data/`; test mirrors | Met-by-plan | ✅ | The new `field_semantics_form_test.dart` sits under `test/ui/widgets/` |
| FR-1.6 | PROJECT-CONTEXT Layout list and negative money form | Met-by-plan | ✅ | Still exactly 2 hunks vs base (`git diff --unified=0` count) |
| FR-2.1 | Color constants equal design `:root` values | Met-by-plan | ✅ | Unchanged |
| FR-2.2 | Spacing `space1..space8` = 4…40 | Met-by-plan | ✅ | Unchanged |
| FR-2.3 | Radii sm 8, md 12, lg 16 | Met-by-plan | ✅ | Unchanged |
| FR-2.4 | Sizes touch 48, button 56, field 56, amount 72, list 64, topbar 64 | Met-by-plan | ✅ | Unchanged |
| FR-2.5 | Dialog shadow 0 4 16, textPrimary at 18 % | Met-by-plan | ✅ | Unchanged |
| FR-2.6 | Each token defined exactly once; no repeated literals | Met-by-plan | ✅ | The FIX added no literals |
| FR-3.1 | Atkinson Hyperlegible 400/700 + OFL bundled, no runtime download | Met-by-plan | ✅ | Unchanged |
| FR-3.2 | Type scale balance/amountInput/title/label/body/meta | Met-by-plan | ✅ | Unchanged |
| FR-3.3 | Design 16 px → body 18, 15 px → meta 16, R$ → title | Met-by-plan | ✅ | Unchanged |
| FR-3.4 | Material 3 ThemeData, font default, ColorScheme mapping | Met-by-plan | ✅ | Unchanged |
| FR-3.5 | textTheme body 18/26; no entry below 16 | Met-by-plan | ✅ | Unchanged |
| FR-4.1 | Money → `R$ 1.234,56`, negative `-R$ 22,10`, integer-only | Met-by-plan | ✅ | Re-checked: every root AC 17 example passes, and the AC 21 grep is empty. The prefix-less helper is now also correct for negatives |
| FR-4.2 | Digits → centavos fill-from-right; non-digit FormatException | Met-by-plan | ✅ | Unchanged |
| FR-4.3 | Max amount constant 9999999 | Met-by-plan | ✅ | Unchanged |
| FR-4.4 | Dates `dd/mm/aaaa`, `dd/mm` at fixed UTC−03:00 | Met-by-plan | ✅ | Unchanged |
| FR-4.5 | Unit tests cover every example and acceptance case | Met-by-plan | ✅ | Negative examples added |
| FR-5.1 | Buttons primary/secondary/text, disabled reason, focus, ≥ 48 | Met-by-plan | ✅ | Unchanged |
| FR-5.2 | TopBar 64, title, optional back "Voltar", trailing, appBar | Met-by-plan | ✅ | Unchanged |
| FR-5.3 | OfflineBanner two modes verbatim copy, live region | Met-by-plan | ✅ | Unchanged |
| FR-5.4 | TextField + FieldError, borders, `<`/`>` rejected | Met-by-plan | ✅ | Re-checked. It is now also a labelled field for TalkBack, which closes cycle-1 MF-1 |
| FR-5.5 | MoneyField R$ prefix, right fill, `int?`, max ignored | Met-by-plan | ✅ | Re-checked. The name now includes the label and `R$`; the max boundary tests are unchanged and green |
| FR-5.6 | Snackbar helper hides current, floating, exactly 4 s | Met-by-plan | ✅ | Unchanged |
| FR-5.7 | ConfirmDialog LimitAlert layout, two tones, `Future<bool>` | Met-by-plan | ✅ | Unchanged |
| FR-6.1 | Scaffold on `bg` with TopBar "Fiado Fácil" | Met-by-plan | ✅ | Unchanged |
| FR-6.2 | Centered verbatim S0 lines, body and meta | Met-by-plan | ✅ | Unchanged |
| FR-6.3 | No interactive elements on placeholder | Met-by-plan | ✅ | Unchanged |
| FR-7.1 | `widget_test.dart` rewritten with four assertions | Met-by-plan | ✅ | Unchanged |
| FR-7.2 | Font assets load from bundle; `OFL.txt` exists | Met-by-plan | ✅ | Unchanged |
| FR-7.3 | Token, theme/ColorScheme and typography tests | Met-by-plan | ✅ | Unchanged |
| FR-7.4 | Unit tests for FR-4 per FR-4.5 | Met-by-plan | ✅ | +3 negative cases |
| FR-7.5 | Widget tests for each FR-5 widget | Met-by-plan | ✅ | +7 semantics tests in the widget files, +5 in the form test |
| FR-7.6 | 200 % text-scale smoke test, no overflow | Met-by-plan | ✅ | Unchanged; passes |
| FR-7.7 | Format check, analyze zero issues, tests pass | Met-by-plan | ✅ | Re-run by the reviewer: format 0 changed, analyze clean, 229/229 |

## Must Fix (Blockers)

None — no blockers found.

## Should Fix (Warnings)

### SF-1 — Semantics test hygiene: duplicated node helper, handle disposed in the test body

**File**: `test/ui/widgets/app_text_field_test.dart:24-31`, `test/ui/widgets/money_field_test.dart:180-186`, `test/ui/widgets/field_semantics_form_test.dart:35-42`
**Problem**: The "unmerged nodes whose label contains X" query is written three times: as a private helper in two files and inline in `money_field_test.dart`. Every semantics test (12 of them) also calls `handle.dispose()` as its last statement. When an assertion fails, the dispose never runs, and a second "SemanticsHandle was active" error buries the real failure. This does not cause false passes; the tester's report flagged it too.
**Fix**: Move `announcedNodesLabelled(String)` into `test/helpers/` and use it from all three files. Register disposal with `addTearDown(tester.ensureSemantics().dispose)` (or `addTearDown(handle.dispose)`) instead of calling it at the end of the body.

## Read scope

`delta=` named 6 code and test files: `lib/domain/format/money_format.dart`, `lib/ui/widgets/app_text_field.dart`, `lib/ui/widgets/money_field.dart`, `test/domain/format/{date,money}_format_test.dart`, `test/main_test.dart` and `test/ui/widgets/{app_text_field,field_semantics_form,money_field}_test.dart`. The rest of the list is plan artifacts and `.orchestrator/PROJECT-CONTEXT.md`, which I ignored for the code review as instructed. A tree diff `0c2b93e → e32a7e4` (cycle-1 snapshot → this snapshot) narrows what actually changed in `lib/` and `test/` to 7 files. `date_format_test.dart` and `main_test.dart` are on the delta list but are byte-identical to cycle 1.

- **Opened in full:** all 3 changed `lib/` files and `test/ui/widgets/field_semantics_form_test.dart` (new). I read the full cycle-2 diffs of `app_text_field_test.dart`, `money_field_test.dart` and `money_format_test.dart`; every hunk is an addition. I also read `test/helpers/test_app.dart`.
- **Closure:** `kCurrencySymbol` / `kMaxCentavos` / `formatCentavosAmount` (3 lib hits, all in the files above). For the DC-1 census I re-ran `grep -rnE "TextField\(|EditableText\(|TextFormField\(|labelText|Semantics\(" lib`: 8 hits, 2 text inputs.
- **Not re-opened this cycle:** the other ~38 union files (theme, other widgets, screens, app/main, pubspec, manifest, fonts, the other tests). They are byte-identical to cycle 1's snapshot `0c2b93e`, where they were reviewed. Their behaviour is covered by the 229/229 whole-suite re-run.
- **Probe:** a scratch test outside the repo, deleted after use. It dumped the merged `EditableText` semantics for `AppTextField` (with `maxLength`, with a leading icon) and for `MoneyField`.
- **Out of scope, ignored:** `.claude/agents/*.md` and `.github/workflows/ci.yml` (operator-added CI).
- **Snapshot recheck:** the end-of-review tree was `75a6cd3`, not `e32a7e4`. `git diff --stat` between them shows only 3 files under `plans/` (FIX plan, its progress log, the TEST report). These came from the operator committing plan artifacts into `HEAD` while I worked. No code, test or config file differs, so this verdict describes the current change set.

## Verdict

**Status**: APPROVED

Cycle-1 MF-1 (no accessible name on either field, invariant 14) is fixed at its single root in `AppFieldLayout`. The fix is pinned per widget and at form level. All FIX criteria and all 39 root requirements are verified, and the whole-project gates are green.

Invoke `/qa` with plan ID `FIX-20261118T015535Z-d340` to run the QA suite.
