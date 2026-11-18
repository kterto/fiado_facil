---
id: CR-20261118T014808Z-817a
plan: FEAT-20261118T003620Z-890e
related_to: SPEC-20261118T003116Z-37ec, FEAT-20261118T003620Z-890e
title: Review of App skeleton and design-system foundation (roadmap story 001.1.1)
status: REQUEST_CHANGES
created_at: 2026-11-18T01:54:01Z
updated_at: 2026-11-18T01:54:01Z
reviewer: reviewer-agent
cycle: 1
root_plan: FEAT-20261118T003620Z-890e
must_fix_count: 1
should_fix_count: 3
requirements_unmet: 0
review_budget: 2
family_cr_count: 0
---

**Related:** [FEAT-20261118T003620Z-890e](./FEAT-20261118T003620Z-890e-app-skeleton-design-system-foundation.md) · [SPEC-20261118T003116Z-37ec](./SPEC-20261118T003116Z-37ec-app-skeleton-design-system-foundation.md) · [TEST-20261118T013640Z-10cb](./TEST-20261118T013640Z-10cb-app-skeleton-design-system-foundation.md)

## Summary

I reviewed the whole change set: 43 files against base `1118ab8`, with working-tree snapshot `0c2b93e`. The snapshot was unchanged when I rechecked it at the end. I excluded `.claude/agents/*.md` as pipeline tooling. The work is high quality. All 35 acceptance criteria and all 39 spec requirements are met. The whole-project gates pass: `dart format` exit 0, `flutter analyze` "No issues found!", and `flutter test` 214/214. The tokens are single-source, money code uses integers only, and the localization wiring avoids the `flutter_localizations` type trap.

One blocker remains, against invariant 14 (works with TalkBack). The shared field layout draws its label as a separate `Text` that is not linked to the input. So TalkBack announces the `AppTextField` by its placeholder and the `MoneyField` with no name at all. Every later form inherits this widget, so this is the cheapest point to fix it.

## Acceptance Criteria Check

| # | Criterion | Met? | Notes |
|---|-----------|------|-------|
| 1 | `main.dart` template removed; async main, ensureInitialized, await portraitUp, runApp | ✅ | `lib/main.dart` is 12 lines; `test/main_test.dart` asserts the orientation call happens before the app mounts |
| 2 | `FiadoFacilApp` `MaterialApp` properties | ✅ | `test/widget_test.dart:30-48` asserts each property |
| 3 | No `flutter_localizations` / `flutter/material.dart` imports; pt_BR + `Cancelar` | ✅ | grep over `lib` and `test` is empty; `widget_test.dart:50-58` |
| 4 | Manifest label + portrait, no other change | ✅ | diff is exactly those two attributes |
| 5 | pubspec deps, description, lock `direct main`, material_ui 1.11.x, no runtime font | ✅ | lock: provider/intl/flutter_localizations `direct main`, material_ui 1.11.1 |
| 6 | Folder tree, `lib/data/.gitkeep` only, mirrored tests, snake_case | ✅ | — |
| 7 | PROJECT-CONTEXT: two hunks only | ✅ | Diff shows exactly the Layout list and the negative money form (see SF-3) |
| 8 | 19 `AppColors` constants | ✅ | `app_tokens_test.dart` asserts each with `toARGB32()` |
| 9 | Spacing / radii / sizes | ✅ | — |
| 10 | `AppShadows.dialog` | ✅ | Lives in `app_colors.dart`, which AC 10 allows, so the RGB stays a private int |
| 11 | Single-source color literals; `1C1B1A` written once | ✅ | grep is empty; I read every file under `lib/ui/` and found no repeated token numbers |
| 12 | Fonts + OFL bundled, pubspec family, asset test | ✅ | `file` reports TrueType for both; OFL contains the license header |
| 13 | Six `AppTextStyles` | ✅ | — |
| 14 | Design-size mapping applied in widgets | ✅ | Covered by the field_error, snackbar, offline_banner, app_button, app_text_field and money_field tests |
| 15 | `buildAppTheme()` M3 + ColorScheme mapping | ✅ | 14 mappings asserted |
| 16 | TextTheme body 18/26, all 15 slots ≥ 16 in family | ✅ | — |
| 17 | `formatCentavos` / `formatCentavosAmount` examples | ✅ | Every stated example passes. Negative input to `formatCentavosAmount` is wrong (SF-1) but AC 17 does not define it |
| 18 | `parseDigitsToCentavos` | ✅ | Includes the Arabic-Indic digit and no-clamp cases |
| 19 | `kMaxCentavos` | ✅ | — |
| 20 | Recife date helpers | ✅ | Tester added a sweep that does not depend on the host time zone |
| 21 | No double/num/intl in money code | ✅ | grep is empty |
| 22 | Domain tests cover all examples | ✅ | — |
| 23 | `AppButton` variants, sizes, styles, icon, disabled reason | ✅ | — |
| 24 | `TopBar` | ✅ | — |
| 25 | `OfflineBanner` | ✅ | Live region asserted |
| 26 | `AppTextField` | ✅ | `<`/`>` stripped with and without caller formatters. Accessible name: see MF-1 |
| 27 | `FieldError` | ✅ | — |
| 28 | `MoneyField` | ✅ | Max guard counts digits instead of comparing values (SF-2) |
| 29 | `showAppSnackbar` | ✅ | — |
| 30 | `showConfirmDialog` | ✅ | The 20 dp gap above the actions is the design's 12 gap plus the 8 top margin |
| 31 | Rounded icons, no `semanticLabel`, no business logic | ✅ | Five `Icons.*_rounded` in `lib`, no `semanticLabel` |
| 32 | `HomeScreen` | ✅ | The explicit `backgroundColor: AppColors.bg` was dropped in the simplify pass. The background now comes from `theme.scaffoldBackgroundColor == AppColors.bg`, and the test asserts the rendered color. FR-6.1's intent ("Scaffold on `bg`") is met |
| 33 | `widget_test.dart` rewritten | ✅ | — |
| 34 | 200 % smoke test | ✅ | Text scale set with `textScaleFactorTestValue`; the test confirms the resolved scaler doubles 18 to 36 |
| 35 | Whole-project format / analyze / test | ✅ | Re-run by the reviewer: format exit 0, analyze clean, 214/214 pass |

## Requirement Coverage Check

| Spec req # | Requirement | Claimed | Verified | Notes |
|-----------|-------------|---------|----------|-------|
| FR-1.1 | `main.dart` no counter; locks portraitUp, runs app | Met-by-plan | ✅ | `lib/main.dart` |
| FR-1.2 | Root `MaterialApp` title, pt_BR locale, delegates, light theme | Met-by-plan | ✅ | `lib/app.dart` |
| FR-1.3 | Android label `Fiado Fácil`, activity portrait | Met-by-plan | ✅ | `AndroidManifest.xml` |
| FR-1.4 | pubspec adds provider, intl, flutter_localizations; description | Met-by-plan | ✅ | `pubspec.yaml`, `pubspec.lock` |
| FR-1.5 | Layered folders `ui/`, `domain/format/`, `data/`; test mirrors | Met-by-plan | ✅ | — |
| FR-1.6 | PROJECT-CONTEXT Layout list and negative money form | Met-by-plan | ✅ | — |
| FR-2.1 | Color constants equal design `:root` values | Met-by-plan | ✅ | `app_colors.dart` |
| FR-2.2 | Spacing `space1..space8` = 4…40 | Met-by-plan | ✅ | `app_dimens.dart` |
| FR-2.3 | Radii sm 8, md 12, lg 16 | Met-by-plan | ✅ | — |
| FR-2.4 | Sizes touch 48, button 56, field 56, amount 72, list 64, topbar 64 | Met-by-plan | ✅ | — |
| FR-2.5 | Dialog shadow 0 4 16, textPrimary at 18 % | Met-by-plan | ✅ | — |
| FR-2.6 | Each token defined exactly once; no repeated literals | Met-by-plan | ✅ | — |
| FR-3.1 | Atkinson Hyperlegible 400/700 + OFL bundled, no runtime download | Met-by-plan | ✅ | — |
| FR-3.2 | Type scale balance/amountInput/title/label/body/meta | Met-by-plan | ✅ | — |
| FR-3.3 | Design 16 px → body 18, 15 px → meta 16, R$ → title | Met-by-plan | ✅ | — |
| FR-3.4 | Material 3 ThemeData, font default, ColorScheme mapping | Met-by-plan | ✅ | — |
| FR-3.5 | textTheme body 18/26; no entry below 16 | Met-by-plan | ✅ | — |
| FR-4.1 | Money → `R$ 1.234,56`, negative `-R$ 22,10`, integer-only | Met-by-plan | ✅ | `formatCentavos` is correct for negatives; see SF-1 for the prefix-less helper |
| FR-4.2 | Digits → centavos fill-from-right; non-digit FormatException | Met-by-plan | ✅ | — |
| FR-4.3 | Max amount constant 9999999 | Met-by-plan | ✅ | — |
| FR-4.4 | Dates `dd/mm/aaaa`, `dd/mm` at fixed UTC−03:00 | Met-by-plan | ✅ | — |
| FR-4.5 | Unit tests cover every example and acceptance case | Met-by-plan | ✅ | — |
| FR-5.1 | Buttons primary/secondary/text, disabled reason, focus, ≥ 48 | Met-by-plan | ✅ | — |
| FR-5.2 | TopBar 64, title, optional back "Voltar", trailing, appBar | Met-by-plan | ✅ | — |
| FR-5.3 | OfflineBanner two modes verbatim copy, live region | Met-by-plan | ✅ | — |
| FR-5.4 | TextField + FieldError, borders, `<`/`>` rejected | Met-by-plan | ✅ | All visual, border and filter requirements met; the accessible-name gap is filed under invariant 14 (MF-1) |
| FR-5.5 | MoneyField R$ prefix, right fill, `int?`, max ignored | Met-by-plan | ✅ | Same note as FR-5.4 |
| FR-5.6 | Snackbar helper hides current, floating, exactly 4 s | Met-by-plan | ✅ | — |
| FR-5.7 | ConfirmDialog LimitAlert layout, two tones, `Future<bool>` | Met-by-plan | ✅ | — |
| FR-6.1 | Scaffold on `bg` with TopBar "Fiado Fácil" | Met-by-plan | ✅ | Background comes from the theme (see AC 32 note) |
| FR-6.2 | Centered verbatim S0 lines, body and meta | Met-by-plan | ✅ | — |
| FR-6.3 | No interactive elements on placeholder | Met-by-plan | ✅ | — |
| FR-7.1 | `widget_test.dart` rewritten with four assertions | Met-by-plan | ✅ | — |
| FR-7.2 | Font assets load from bundle; `OFL.txt` exists | Met-by-plan | ✅ | — |
| FR-7.3 | Token, theme/ColorScheme and typography tests | Met-by-plan | ✅ | — |
| FR-7.4 | Unit tests for FR-4 per FR-4.5 | Met-by-plan | ✅ | — |
| FR-7.5 | Widget tests for each FR-5 widget | Met-by-plan | ✅ | — |
| FR-7.6 | 200 % text-scale smoke test, no overflow | Met-by-plan | ✅ | — |
| FR-7.7 | Format check, analyze zero issues, tests pass | Met-by-plan | ✅ | Re-run by the reviewer |

## Must Fix (Blockers)

### MF-1 — Field label is not the input's accessible name (invariant 14, TalkBack)

**File**: `lib/ui/widgets/app_text_field.dart:74-121` (`AppFieldLayout`, shared by `AppTextField` and `MoneyField`)
**Problem**: `AppFieldLayout` draws the label ("Nome", "Valor (opcional)") as a sibling `Text.rich`. It sits above a `TextField` whose `InputDecoration` has no `labelText`, and no semantics wrapper links the two. I probed it with `tester.getSemantics` on the inner `EditableText`, using a scratch test outside the repo:

- `AppTextField(label: 'Nome', hintText: 'Ex.: Maria')` → node `label="Ex.: Maria"`. TalkBack reads the placeholder instead of "Nome".
- `MoneyField(label: 'Valor', initialCentavos: 4790)` → node `label=""`, `value="47,90"`. TalkBack announces "47,90, edit box" with no field name and no currency.

PROJECT-CONTEXT invariant 14 requires the app to work with TalkBack, and the spec's NFR applies it to this story. FR-5.4 also describes the widget as "a labelled field". A form control without an accessible name fails that requirement (WCAG 4.1.2). This is the shared layout behind every field in critical flows 2, 3 and 8 (fiado amount, payment amount, new customer). If it ships unfixed, every later screen inherits the defect.

**Fix**: Make the visible label (plus its suffix) the field's semantic label, and keep the label `Text` from being announced a second time. For example, wrap the label in `ExcludeSemantics` and the `input` in `Semantics(label: suffix == null ? label : '$label $suffix', child: input)`, or wrap the label and input in a `MergeSemantics`. For `MoneyField`, the amount should be announced with its currency context (for example the label plus the `R$` prefix). Add a widget test in `test/ui/widgets/app_text_field_test.dart` and one in `money_field_test.dart` that call `tester.ensureSemantics()` and assert that the field's semantics node has a `label` containing the field's label text. They should also assert that the hint/placeholder is not the label.

## Defect class

### DC-1 — Text input with no accessible name

**Sites**: 2 found. `lib/ui/widgets/app_text_field.dart:50` (`TextField` in `AppTextField`) and `lib/ui/widgets/money_field.dart:56` (`TextField` in `MoneyField`). Both get their label only through `AppFieldLayout` (`app_text_field.dart:96`).
**Filed above as**: MF-1. One fix in `AppFieldLayout` covers both sites.
**Search used**: `grep -rnE "TextField\(|EditableText\(|labelText|Semantics\(" lib`
**Not an instance**: none. There are no other text inputs in `lib/`. Scope: change set only; the rest of the repo is the Flutter template.

## Should Fix (Warnings)

### SF-1 — `formatCentavosAmount` returns wrong money for negative input

**File**: `lib/domain/format/money_format.dart:15-19`
**Problem**: Dart's `%` is always non-negative and `~/` truncates toward zero, so the public helper silently returns the wrong amount for negatives. Measured with a scratch script: `formatCentavosAmount(-2210)` → `"-22,90"`, `(-5)` → `"0,95"`, `(-123456)` → `"-1.234,44"`. `formatCentavos` is correct because it passes `centavos.abs()`. The simplify pass removed the old negative branch as "dead", but the function is public domain API. Saldo can be negative (invariant 4), so a later screen that formats a credit balance with the prefix-less helper would show a wrong amount with no error. The same path can be reached through `MoneyField(initialCentavos: <negative>)` via `textFor` (`money_field.dart:88-89`). No current caller passes a negative value, so this is not blocking.
**Fix**: Either handle the sign (`'${c < 0 ? '-' : ''}${…abs()…}'`) or reject negatives explicitly (`if (centavos < 0) throw ArgumentError.value(...)`). Add a test that pins whichever contract you choose.

### SF-2 — MoneyField max guard counts digits instead of comparing to `kMaxCentavos`

**File**: `lib/ui/widgets/money_field.dart:84, 101-104`
**Problem**: The formatter rejects input when `digits.length > kMaxCentavos.toString().length`. That equals "value > `kMaxCentavos`" only because the constant is currently all nines. If the maximum ever changes to a value that is not all nines (for example 5000000), the field would accept 5000001–9999999. The plan's Technical Notes specified a value comparison.
**Fix**: Keep the length check as the overflow guard, and also return `oldValue` when `parseDigitsToCentavos(digits) > kMaxCentavos`.

### SF-3 — PROJECT-CONTEXT Layout intro is now stale

**File**: `.orchestrator/PROJECT-CONTEXT.md:55` ("Greenfield — only the Flutter template exists (`lib/main.dart`, `test/widget_test.dart`).")
**Problem**: The folder list below this sentence now describes the real tree, so the sentence contradicts it. AC 7 prohibited touching any other line, so the coder was right to leave it.
**Fix**: Update it in the next story that edits PROJECT-CONTEXT (001.1.2). It is not worth a cycle here.

## Read scope

There was no `delta=` line; this is the first review cycle, so the subject is the whole union.

- **Union:** 43 changed files plus `.orchestrator/PROJECT-CONTEXT.md`. The `.claude/` directory was excluded as tooling, as the orchestrator instructed.
- **Read in full (28):** all 18 `lib/` entries (including `.gitkeep`); the `AndroidManifest.xml`, `pubspec.yaml` and `PROJECT-CONTEXT.md` diffs; and 7 test files: `helpers/test_app.dart`, `widget_test.dart`, `main_test.dart`, `ui/screens/home_screen_test.dart`, `ui/accessibility_smoke_test.dart`, `ui/widgets/money_field_test.dart`, `ui/widgets/confirm_dialog_test.dart`.
- **Checked by command, not read line by line:** `pubspec.lock` (grep of the four dependency entries) and `assets/fonts/*` (`file` and grep).
- **Not opened in full (12 test files):** `app_button`, `app_text_field`, `top_bar`, `offline_banner`, `app_snackbar` and `field_error` tests, the four `ui/theme` tests, and the two `domain/format` tests. I checked them by listing every test and group name against the AC each must prove, and they all pass in the full run. I did not audit their assertion bodies line by line.

## Verdict

**Status**: REQUEST_CHANGES

Every acceptance criterion and every requirement is met, but the shared field layout breaches invariant 14 (TalkBack): it leaves both text inputs without an accessible name.

Invoke `/architect` with this CR file path (`plans/20261118T003106Z-f72c-app-skeleton-design-system-foundation/CR-20261118T014808Z-817a-app-skeleton-design-system-foundation.md`) to generate a FIX plan. Every Must Fix item will become a TDD task pair.
