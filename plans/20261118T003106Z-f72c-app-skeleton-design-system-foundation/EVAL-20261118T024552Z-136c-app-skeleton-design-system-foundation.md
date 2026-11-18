---
id: EVAL-20261118T024552Z-136c
status: ISSUES
created_at: 2026-11-18T02:50:56Z
updated_at: 2026-11-18T03:09:00Z
cycle: 1
plan: FEAT-20261118T003620Z-890e
---

# Evaluation — P0 (ASSUMED): App skeleton and design-system foundation (roadmap story 001.1.1)

**Profile**: `in-loop` (sections: evidence matrix, Final, ranked gaps, Engineering Gates; `R`, `S`, `D`, `E` and the cross-implementation roll-up are omitted — none of them moves `Final`).
**Source of truth**: `SPEC-20261118T003116Z-37ec` `## Functional requirements`, FR-1.1 … FR-7.7 (39 criteria, IDs used verbatim, not re-split).
**Coverage map**: `FEAT-20261118T003620Z-890e`; prior reviews `CR-20261118T014808Z-817a`, `CR-20261118T023725Z-ebb0` (APPROVED).
**AC baseline**: frozen in this report (section "Frozen checklist conventions" + the matrix). Not persisted to `<spec-folder>/evaluations/_ac-baseline.md` because the caller restricted this run to one report file and forbade an `evaluations/` folder; a future run should reuse the I/T check lists below verbatim.
**Judge model**: Claude Opus 5.5 (author model: Claude, same family — flagged per Core rule 4; borderline checks were resolved UNMET).
**Subject**: working tree vs base `1118ab85b6fb881f2529d35237ebc69d01245ac9`. HEAD `67f51b1` (tree `ff187c70`). Working-tree changes vs HEAD are only under `plans/` and `.claude/` (ignored), so the code under evaluation equals HEAD.

## Diff surface (scoped: `lib test pubspec.yaml android assets .orchestrator/PROJECT-CONTEXT.md`)

`.orchestrator/PROJECT-CONTEXT.md`, `android/app/src/main/AndroidManifest.xml`, `assets/fonts/{AtkinsonHyperlegible-Regular.ttf,AtkinsonHyperlegible-Bold.ttf,OFL.txt}`, `lib/{main,app}.dart`, `lib/data/.gitkeep`, `lib/domain/format/{date_format,money_format}.dart`, `lib/ui/screens/home_screen.dart`, `lib/ui/theme/{app_colors,app_dimens,app_text_styles,app_theme}.dart`, `lib/ui/widgets/{app_button,app_snackbar,app_text_field,confirm_dialog,field_error,money_field,offline_banner,top_bar}.dart`, `pubspec.yaml`, `test/domain/format/{date_format,money_format}_test.dart`, `test/helpers/test_app.dart`, `test/main_test.dart`, `test/widget_test.dart`, `test/ui/accessibility_smoke_test.dart`, `test/ui/screens/home_screen_test.dart`, `test/ui/theme/{app_text_styles,app_theme,app_tokens,font_assets}_test.dart`, `test/ui/widgets/{app_button,app_snackbar,app_text_field,confirm_dialog,field_error,field_semantics_form,money_field,offline_banner,top_bar}_test.dart` (44 files, +3616/−142). No untracked files outside the ignored folders. `pubspec.lock` (unchanged path, read for FR-1.4) is the only evidence outside the diff.

## Frozen checklist conventions

- One I-check per observable clause; enumerated values (19 colors, 8 spacings, 14 `ColorScheme` slots, 6 type styles + 2 tabular flags) get one check each (Conjunction rule).
- T-level policy: pure helpers and widgets → unit/widget test required (widget tests are this stack's highest in-repo level; no e2e is required by the spec for this story — e2e lands with 001.1.2).
- **Static artifacts** (FR-1.3 manifest, FR-1.5 folder layout, FR-1.6 PROJECT-CONTEXT prose, FR-2.6 single-source rule) have no runtime test level under the fixed policy and the spec's FR-7 does not request one: T = n/a and `AC_score = I`. Recorded as an assumption; it moves no number here because all four are I = 1.00.
- FR-7.x criteria *are* tests: the I-checks ask "does a test exist that asserts the clause", the T-check asks "did that suite execute green on this tree" (gate evidence).

## Per-criterion evidence matrix

`I` / `T` are MET/total of binary checks. Paths are repo-relative.

| FR | I-checks (atomic) | I | Implementation evidence | T-checks | T | Test evidence | AC |
|---|---|---|---|---|---|---|---|
| FR-1.1 | no counter code; `setPreferredOrientations([portraitUp])` awaited before `runApp` | 2/2 | `lib/main.dart:6-12` | portrait call before mount; counter absent | 2/2 | `test/main_test.dart:32-41`; `test/widget_test.dart:17-19` | 1.00 |
| FR-1.2 | material_ui `MaterialApp`; title; locale; supportedLocales; delegates cover Material+Widgets+Cupertino; theme; no darkTheme + `ThemeMode.light`; banner off | 8/8 | `lib/app.dart:1,14-22`; delegates list = Cupertino+Material+Widgets at `material_ui-1.11.1/lib/src/global_material_localizations.dart:674-678` | config asserted; pt strings resolve | 2/2 | `test/widget_test.dart:35-47`, `:50-58` ("Cancelar") | 1.00 |
| FR-1.3 | label `Fiado Fácil`; `screenOrientation="portrait"` | 2/2 | `android/app/src/main/AndroidManifest.xml:3,10` | n/a (static) | — | — | 1.00 |
| FR-1.4 | `provider`; `intl`; `flutter_localizations` sdk; resolves with material_ui 1.11.x; description replaced | 5/5 | `pubspec.yaml:2,33-37`; `pubspec.lock:155-162` (material_ui 1.11.1) | deps resolve and suite runs on them | 1/1 | CI run 44224719545 "Install dependencies" + "Test with coverage" success on HEAD `67f51b1` | 1.00 |
| FR-1.5 | main bootstrap only; `app.dart`; `ui/theme`; `ui/widgets`; `ui/screens` (home only); `domain/format`; `data/.gitkeep`; `test/` mirrors `lib/` | 8/8 | `lib/main.dart:1-12`; `lib/app.dart`; `lib/ui/{theme,widgets,screens}/`; `lib/domain/format/`; `lib/data/.gitkeep`; `test/{domain/format,ui/theme,ui/widgets,ui/screens}/` | n/a (static) | — | — | 1.00 |
| FR-1.6 | Layout placeholder line replaced by real folders; money line gains `-R$ 22,10`; nothing else rewritten | 3/3 | `.orchestrator/PROJECT-CONTEXT.md:60-66,78`; diff is exactly 2 hunks (+8/−2) | n/a (static) | — | — | 1.00 |
| FR-2.1 | 19 color constants equal design `:root` (scrim `0x661C1B1A`) | 19/19 | `lib/ui/theme/app_colors.dart:4-25` | each of 19 asserted by ARGB | 19/19 | `test/ui/theme/app_tokens_test.dart:8-38` | 1.00 |
| FR-2.2 | space1..space8 = 4…40 | 8/8 | `lib/ui/theme/app_dimens.dart:1-10` | list asserted | 8/8 | `test/ui/theme/app_tokens_test.dart:42-56` | 1.00 |
| FR-2.3 | radii 8/12/16 | 3/3 | `lib/ui/theme/app_dimens.dart:12-16` | asserted | 3/3 | `test/ui/theme/app_tokens_test.dart:60-64` | 1.00 |
| FR-2.4 | 6 size tokens | 6/6 | `lib/ui/theme/app_dimens.dart:18-25` | asserted | 6/6 | `test/ui/theme/app_tokens_test.dart:68-75` | 1.00 |
| FR-2.5 | offset y 4; blur 16; textPrimary RGB at 18 % (0x2E) | 3/3 | `lib/ui/theme/app_colors.dart:28-36` | asserted | 3/3 | `test/ui/theme/app_tokens_test.dart:81-93` | 1.00 |
| FR-2.6 | no hex literal outside `app_colors.dart`; theme/widgets reference token constants | 2/2 | search: `grep -rn "Color(0x\|0xFF\|0x66" lib` → only `app_colors.dart`; numeric scan of `lib/ui/widgets` finds only icon sizes (24/20/32, not FR-2 tokens) | n/a (static) | — | — | 1.00 |
| FR-3.1 | Regular+Bold TTF committed; `OFL.txt`; one family 400/700 in pubspec; no runtime font download | 4/4 | `assets/fonts/*` (OFL header "Braille Institute"); `pubspec.yaml:65-71`; `grep google_fonts\|http lib pubspec.yaml` → only comments | each TTF loads from bundle; OFL exists; family resolves at render | 3/3 | `test/ui/theme/font_assets_test.dart:14-24`; `test/widget_test.dart:22-28` | 1.00 |
| FR-3.2 | balance, amountInput, title, label, body, meta size/lh/weight; tabular on balance + amountInput | 8/8 | `lib/ui/theme/app_text_styles.dart:4-52` | each style + tabular flag asserted | 8/8 | `test/ui/theme/app_text_styles_test.dart:18-86` | 1.00 |
| FR-3.3 | banner text body; FieldError body; snackbar body; disabled-reason meta; counter meta; `R$` prefix title textSecondary | 6/6 | `offline_banner.dart:41`; `field_error.dart:31`; `app_snackbar.dart:50`; `app_button.dart:61`; `app_text_field.dart:168`; `money_field.dart:69-72` | each asserted on rendered style | 6/6 | `offline_banner_test.dart:54-58`; `field_error_test.dart:21-25`; `app_snackbar_test.dart:65-67`; `app_button_test.dart:279-282`; `app_text_field_test.dart:172-189`; `money_field_test.dart:49-58` | 1.00 |
| FR-3.4 | M3; default family; scaffold bg; 14 `ColorScheme` slots; slotless tokens read from constants | 18/18 | `lib/ui/theme/app_theme.dart:6-35`; slotless use e.g. `app_button.dart:121,125,136`, `confirm_dialog.dart:63-68`, `offline_banner.dart:33,36` | each asserted | 18/18 | `test/ui/theme/app_theme_test.dart:11-56`; slotless: `app_button_test.dart:104-107,193-208`, `confirm_dialog_test.dart:235-251`, `offline_banner_test.dart:52-53` | 1.00 |
| FR-3.5 | bodyLarge/bodyMedium = body 18/26; no entry < 16 | 2/2 | `lib/ui/theme/app_theme.dart:37-53` | asserted (15 slots) | 2/2 | `test/ui/theme/app_theme_test.dart:61-100` | 1.00 |
| FR-4.1 | `R$ x.xxx,cc` grouping; integer-only math; 5 examples exact; `-R$` negative; U+0020 space | 5/5 | `lib/domain/format/money_format.dart:9-21,30-40` (`~/`, `%`, no `double`/`NumberFormat`) | examples; negative; space code unit; hyphen-minus code unit | 4/4 | `test/domain/format/money_format_test.dart:6-27` | 1.00 |
| FR-4.2 | `""→0`; `"5"→5`; `"4790"→4790`; `"0047"→47`; non-digit → `FormatException`; no clamping | 6/6 | `lib/domain/format/money_format.dart:23-28` | each asserted (incl. 100000000 unclamped, 5 invalid inputs) | 6/6 | `test/domain/format/money_format_test.dart:52-73` | 1.00 |
| FR-4.3 | named max constant 9999999 | 1/1 | `lib/domain/format/money_format.dart:1` | asserted | 1/1 | `test/domain/format/money_format_test.dart:76-83` | 1.00 |
| FR-4.4 | fixed `toUtc() − 3 h`; `dd/mm/aaaa`; `dd/mm`; zero-pad | 4/4 | `lib/domain/format/date_format.dart:1-15` | day boundary 02:00/03:00; `31/12`; zero-pad; local == UTC | 4/4 | `test/domain/format/date_format_test.dart:6-64` | 1.00 |
| FR-4.5 | tests for every money, digits, date example; acceptance 0/123456/9999999/-2210; Recife boundary | 5/5 | `money_format_test.dart:6-13,52-58`; `date_format_test.dart:6-12,28-30` | suite green | 1/1 | ledger `flutter test --coverage` 229/229; CI run 44224719545 | 1.00 |
| FR-5.1 | full width; minHeight 56 grows; radius md; h-pad 16; label style; icon 24 + gap 8; primary + pressed; secondary + 1 px border; text variant (no bg, 48, intrinsic, pad 8); disabled colors; disabled-reason only while disabled; 2 px focus; tap ≥ 48×48 | 13/13 | `lib/ui/widgets/app_button.dart:42-182` | each clause asserted | 13/13 | `test/ui/widgets/app_button_test.dart:32-90,94-174,188-221,235-255,260-297`; growth `accessibility_smoke_test.dart:64-68` | 1.00 |
| FR-5.2 | minHeight 64 on bg; title style; back = arrow + "Voltar" text button; left 4/16, right 8; trailing actions; `PreferredSizeWidget` | 6/6 | `lib/ui/widgets/top_bar.dart:8-70` | each asserted | 6/6 | `test/ui/widgets/top_bar_test.dart:14-90` | 1.00 |
| FR-5.3 | offline icon+copy; sending icon+copy; infoContainer/info/body styling; minHeight 48, pad 8/16, gap 12; live region; no visibility logic | 6/6 | `lib/ui/widgets/offline_banner.dart:7-50` (only a `mode` param) | modes ×2; styling; geometry; live region | 5/5 | `test/ui/widgets/offline_banner_test.dart:28-100` | 1.00 |
| FR-5.4 | label 18/24 bold + gap 8; suffix regular textSecondary; box 56/surface/r8/pad 12; body input; borders idle/focus/error; leading icon border color; placeholder textSecondary; counter `n/max` meta right; keyboardType/capitalization/formatters pass-through; built-in `<`/`>` deny; FieldError icon 20 + body error, gap 8; announced (live region); never color alone | 13/13 | `lib/ui/widgets/app_text_field.dart:9-181`; `lib/ui/widgets/field_error.dart:7-38` | each asserted | 13/13 | `test/ui/widgets/app_text_field_test.dart:35-257,261-283`; `test/ui/widgets/field_error_test.dart:12-47` | 1.00 |
| FR-5.5 | minHeight 72; `R$` prefix; right-aligned amountInput tabular; number keyboard; digits fill from right via FR-4.2; display without `R$`; `null` when empty + `0,00` hint; delete-all → `null`; **otherwise the integer value (a typed `0` reports `0`)**; above-max keystroke ignored; FieldError | 10/11 | `lib/ui/widgets/money_field.dart:30-114`. **UNMET**: `formatEditUpdate` strips leading zeros (`:101`), so typing `0` yields empty text and `centavosOf` maps 0 → `null` (`:91-94`); `initialCentavos: 0` also renders empty (`:88-89`). Searched `money_field.dart` + `money_field_test.dart` for a zero path: none. | same 11 clauses | 10/11 | `test/ui/widgets/money_field_test.dart:40-160`; zero case: searched, no test | 0.91 |
| FR-5.6 | hide current then show; floating; exactly 4 s; primaryContainer + radius md; pad 12/16; `check_circle` primary; body textPrimary; dialog shadow | 8/8 | `lib/ui/widgets/app_snackbar.dart:7-59` | each asserted (incl. replace + auto-dismiss) | 8/8 | `test/ui/widgets/app_snackbar_test.dart:25-105` | 1.00 |
| FR-5.7 | radius 16 / 2 px border / shadow; pad 24/20/20 + gap 12; head icon 32 + title gap 8; body style; actions stacked, gap 8, full width 56; scrim; neutral tone; warning tone; confirm → `true`; dismiss/scrim/back → `false`; label = title (route-naming); **alert-dialog role** | 11/12 | `lib/ui/widgets/confirm_dialog.dart:10-136`. **UNMET**: `Dialog(...)` at `:71` leaves `semanticsRole` at its default `SemanticsRole.dialog` (`material_ui-1.11.1/lib/src/dialog.dart:98,322`); material_ui's own `AlertDialog` passes `SemanticsRole.alertDialog` (`dialog.dart:1006`). Searched `lib/` + `test/` for `alertDialog\|SemanticsRole`: no hits. | same 12 clauses | 11/12 | `test/ui/widgets/confirm_dialog_test.dart:63-284`; role: searched, not asserted | 0.92 |
| FR-6.1 | Scaffold on bg; TopBar "Fiado Fácil" | 2/2 | `lib/ui/screens/home_screen.dart:13-14` | asserted | 2/2 | `test/ui/screens/home_screen_test.dart:19-38` | 1.00 |
| FR-6.2 | centered; two verbatim S0 lines; body / meta textSecondary; no other copy | 4/4 | `lib/ui/screens/home_screen.dart:15-36` | asserted (exact text list) | 4/4 | `test/ui/screens/home_screen_test.dart:40-70` | 1.00 |
| FR-6.3 | no interactive elements | 1/1 | `lib/ui/screens/home_screen.dart:13-40` | asserted | 1/1 | `test/ui/screens/home_screen_test.dart:72-95` | 1.00 |
| FR-7.1 | rewritten test asserts both texts; counter absent; locale pt_BR; default text family at 18 | 4/4 | `test/widget_test.dart:15-19,37,22-28`; theme default `test/ui/theme/app_theme_test.dart:61-71` | suite green | 1/1 | ledger 229/229; CI 44224719545 | 1.00 |
| FR-7.2 | `rootBundle.load` each TTF; `OFL.txt` exists | 2/2 | `test/ui/theme/font_assets_test.dart:14-24` | suite green | 1/1 | same | 1.00 |
| FR-7.3 | every FR-2 constant; theme/ColorScheme mapping; typography size/weight/height; none < 16 | 4/4 | `app_tokens_test.dart:7-93`; `app_theme_test.dart:29-56`; `app_text_styles_test.dart:63-86` | suite green | 1/1 | same | 1.00 |
| FR-7.4 | FR-4 unit tests per FR-4.5 | 1/1 | `test/domain/format/*_test.dart` | suite green | 1/1 | same | 1.00 |
| FR-7.5 | tappable ≥ 48 + 56 exact; disabled-reason only disabled; banner copy; `<`/`>` strip + FieldError; MoneyField fill/null/max/prefix; snackbar 4 s; dialog true/false + tone bgs | 7/7 | `app_button_test.dart:32-90,257-297`; `offline_banner_test.dart:32-37`; `app_text_field_test.dart:221-277`; `money_field_test.dart:49-135`; `app_snackbar_test.dart:25-37`; `confirm_dialog_test.dart:63-101,216-251` | suite green | 1/1 | same | 1.00 |
| FR-7.6 | placeholder at 2.0 text scale; one of each button variant at 2.0; no overflow/exception asserted | 3/3 | `test/ui/accessibility_smoke_test.dart:10-70` (`textScaleFactorTestValue = 2`, asserts `textScalerOf(...).scale(18) == 36` and `takeException()` null) | suite green | 1/1 | same | 1.00 |
| FR-7.7 | format check; analyze zero issues; `flutter test` pass | 3/3 | CI run 44224719545 on `67f51b1` (= evaluated code): "Check formatting", "Analyze", "Test with coverage" all success | gates executed green | 1/1 | see Engineering Gates | 1.00 |

Totals: I-checks **226/228**, T-checks **177/179** (four static FRs carry no T-checks).

## Roll-up (script output, pasted verbatim)

Script: `scratchpad/rollup.py` (per-FR `(I_met, I_total, T_met, T_total)`; `Σw` derived from the priority table; static FRs use `AC = I`).

```
FR-1.1 … FR-5.4: AC=1.00 (each)
FR-5.5: I=10/11=0.91 T=10/11=0.91 AC=0.91
FR-5.6: AC=1.00
FR-5.7: I=11/12=0.92 T=11/12=0.92 AC=0.92
FR-6.1 … FR-7.7: AC=1.00 (each)
I-checks 226/228  T-checks 177/179
Story_score=0.9955 sum_w=3 Final=1.00
Band: Spec-complete
```

| Story | Priority | Weight | Story_score |
|---|---|---|---|
| 001.1.1 App skeleton and design-system foundation | P0 (ASSUMED — roadmap says `release: mvp`, no P-label) | 3 | 0.9955 |

**Final = 1.00 → Spec-complete.** Adjusted Final: not applicable (no confirmed-red gate). Because the rounded Final hides two real misses, `status: ISSUES` follows from the non-empty gap list, not from the band.

## Engineering Gates `G`

| Gate | Pinned command | Verdict | Evidence |
|---|---|---|---|
| lint | `flutter analyze` | ✓ | CI run 44224719545, step "Analyze" success, `headSha 67f51b1` = HEAD; working-tree code identical to HEAD (`git diff --stat HEAD -- lib test pubspec.yaml android assets` empty). Also clean in two independent role runs (CR-ebb0). |
| format | `dart format --output=none --set-exit-if-changed lib test` | ✓ | CI run 44224719545, step "Check formatting" success on `67f51b1`. |
| unit (whole suite) | `flutter test --coverage` | ✓ | Ledger `.orchestrator/verification-ledger.json`: 229/229 pass at tree `f3ee03a4`; `git diff --stat f3ee03a4 ff187c70 -- lib test pubspec.yaml android assets analysis_options.yaml` is empty (tree moved only in `plans/`, `.claude/`, `.github/`, PROJECT-CONTEXT). Independently: CI step "Test with coverage" success on HEAD `67f51b1` (tree `ff187c70`) — byte-identical command on the identical tree. |
| build | `flutter build apk --debug` (PROJECT-CONTEXT command table, "Build (debug)") | not-run (toolchain could not start; not a confirmed red) | Executed by the evaluator: exit 1 after 19 min with `Execution failed for task ':app:processDebugResources' … Failed to transform core-1.13.1.aar (androidx.core:core:1.13.1) … AAPT2 aapt2-9.3.1-15703166-osx Daemon #0: Daemon startup failed`. The failure is the AAPT2 daemon failing to start while transforming a third-party AAR, before any app resource is compiled. That points to the evaluator's sandboxed environment, not to the subject (the only Android change is `android:label` + `android:screenOrientation` in the manifest). The evaluator did not bypass its sandbox to retry. **Action for the orchestrator/user:** run `flutter build apk --debug` once outside the sandbox. If it fails there, it becomes a confirmed ✗ and `Adjusted Final = Final × 0.5`. |
| e2e | `flutter test integration_test` (PROJECT-CONTEXT test strategy) | not-run | Probe: `ls integration_test` → `ls: integration_test: No such file or directory`; `grep -n "integration_test" pubspec.yaml pubspec.lock` → 0 matches. The spec defers `integration_test/` to story 001.1.2 (Non-goals). Blind spot, no credit change. |
| mutation | none configured | not-run | Probe: no `mutation_test*` config in the repo (`ls mutation_test*` → no matches; `grep mutation pubspec.yaml pubspec.lock` → 0 matches). `dart pub global list` shows `mutation_test 1.8.0` activated globally, so the tool exists on this machine but the project has no rules/config for it. Not one of the skill's pinned gates; blind spot only. |

Confirmed-red gates: none. Blind spots: build (environment), e2e, mutation.

## Gaps (ranked) and fixes to reach 1.00

1. **FR-5.5 — MoneyField cannot report an explicit `0`** (I-check 9 + matching T-check, UNMET). Typing `0` (or `initialCentavos: 0`) collapses to empty text and reports `null` (`lib/ui/widgets/money_field.dart:88-94,101`). The spec's own rationale for `null` (SPEC line 249: T1.1 needs "vazio = sem limite" to differ from an explicit 0) needs `0` to be enterable. Fix: track "has the user typed a digit" separately from the value — keep `0,00` as real text after a typed `0` (do not strip the last zero when the digit string is non-empty), render `initialCentavos: 0` as `0,00`, and report `0` in that case; keep `null` only for an empty field. Add widget tests: typing `0` shows `0,00` and reports `0`; `initialCentavos: 0` shows `0,00`; clearing still reports `null`.
2. **FR-5.7 — ConfirmDialog is not exposed with the alert-dialog role** (I-check 12 + matching T-check, UNMET). `Dialog` at `lib/ui/widgets/confirm_dialog.dart:71` keeps the default `SemanticsRole.dialog`. Fix: pass `semanticsRole: SemanticsRole.alertDialog` to that `Dialog` (the material_ui `Dialog` constructor takes it, `dialog.dart:98`), and extend `test/ui/widgets/confirm_dialog_test.dart:254-284` to assert the node's `SemanticsData.role == SemanticsRole.alertDialog` next to the existing label/route-naming checks.

## Assumptions and notes

- Priority P0 is ASSUMED (`roadmap/001-foundation/001.1-scaffold/001.1.1-app-skeleton.md`: `release: mvp`, no P-label). Single story, so the weight does not move `Final`.
- k = 3: pass 1 scored all 407 checks; passes 2 and 3 re-derived every check that was not a direct value equality (FR-5.5 zero path, FR-5.7 role, FR-7.1 "resolved default text style", FR-7.6 `TextScaler.linear(2.0)` vs `textScaleFactorTestValue = 2`, FR-5.5 T7 initial-empty state, FR-2.6 icon-size literals). No verdict changed across passes. FR-5.5 I9 and FR-5.7 I12 are the borderline ones; both resolve UNMET (same-family judge, Core rule 4).
- FR-7.6 uses `platformDispatcher.textScaleFactorTestValue = 2` rather than a literal `TextScaler.linear(2.0)`; the test asserts the resulting scaler maps 18 → 36, which is the same linear 2.0 scaler. Scored MET.
- FR-2.6: widgets hold three non-token numeric constants (icon sizes 24, 20, 32 and a 2 px border width). FR-2 defines no icon-size token, so these are not repeated token literals. Scored MET.
- Notes that do not move the score: `formatCentavosAmount` negative handling was fixed after CR-817a and is now tested (`money_format_test.dart:39-48`); `ColorScheme.secondary` is set to `primary` (an extra slot, harmless).
