---
id: TEST-20261118T013640Z-10cb
plan: FEAT-20261118T003620Z-890e
title: Test Report — App skeleton and design-system foundation (roadmap story 001.1.1)
status: BELOW_FLOOR
created_at: 2026-11-18T01:46:53Z
updated_at: 2026-11-18T01:46:53Z
cycle: 0
related_to: SPEC-20261118T003116Z-37ec
---

**Related:** [FEAT-20261118T003620Z-890e](./FEAT-20261118T003620Z-890e-app-skeleton-design-system-foundation.md)

## Summary

`rigor=delivery`. The whole suite was green before the tester touched anything: `flutter test --coverage` ran 212 tests with 0 failures at `tree=5ff4ce5428c6909df4d2b9efc47225ff19c76825`. The ledger had no row to inherit, so the suite was executed and a row was appended. After the tester's two additions the suite runs 214 tests, all passing.

The status is **BELOW_FLOOR** for one reason only: **no gate config. `/Volumes/ssd/Developer/Flutter/fiado_facil/.cleancode-gates.json` was not found.** No G1 threshold exists to measure against, so no floor can be met. This is a bootstrap gap for a human to close. It is not a coverage shortfall. On the informational numbers, every changed Dart file with executable lines is at 100% line coverage.

Two test gaps were found and closed:
1. **`lib/main.dart` was not loaded by any test.** It did not appear in `lcov.info` at all. AC 1 (portrait lock, then `runApp`) had no executable check. Added `test/main_test.dart`.
2. **The date helpers' "local equals UTC" tests passed even with the defect they were meant to catch.** A probe confirmed that removing `toUtc()` still passes them on this host (UTC−03:00), and on any UTC host. Added a 48-hour sweep that does catch it.

## Flows Triaged

Criticality = user impact × breakage likelihood × not-covered-by-unit, each scored 1–3 (max 27).

| Flow | Criticality | Decision | Rationale |
|---|---|---|---|
| App launch: `main()` → portrait lock → `FiadoFacilApp` → pt-BR `HomeScreen` | 3×2×3 = **18** | **Selected, executed (widget level)** | The only user-facing flow in this story. If launch fails, nothing else works. No test ever called `main()` (`lib/main.dart` was missing from `lcov.info`). New test `test/main_test.dart` calls the real `main()` and checks three things: exactly one `SystemChrome.setPreferredOrientations([portraitUp])`, the app is not yet mounted when that call happens, and `FiadoFacilApp` and the S0 copy appear afterwards. **Observed: pass.** |
| App launch on a real Android device or emulator (manifest label and `screenOrientation`, bundled fonts on device) | 3×1×2 = 6 | **Excluded: not executed** | The project has no `integration_test/` harness yet; story 001.1.2 brings it, along with the Firebase emulator. Adding the `integration_test` dev dependency would mean editing `pubspec.yaml`, which is not a test file. AC 4 is checked statically. The widget suite already loads the bundled fonts (`font_assets_test.dart`). The cheapest real observation is `flutter build apk --debug`, which is QA's to run. |
| 200% text scale on a 360×800 phone (Invariant 14) | 2×2×1 = 4 | Covered by existing test (executed) | `test/ui/accessibility_smoke_test.dart` already does this. It passed in both suite runs. |
| PROJECT-CONTEXT critical flows 1–10 (login, fiado, payment, cancel, statement, offline, users, new customer, dashboard, CSV) | n/a | **Excluded: not touched by this diff** | No auth, Firestore, ledger or navigation exists yet. The widgets those flows will use (`MoneyField` for 2/3, `ConfirmDialog` for the over-limit alert in 2 and the cancel in 4, `OfflineBanner` for 6, `AppTextField` for 8) are covered by widget tests. Their e2e flows belong to the stories that build the screens. |

## E2E Tests Added

None. There is no e2e framework set up yet (`integration_test/` comes in story 001.1.2), and this story has no critical user flow beyond app launch. The launch flow was exercised at widget level instead:

- `test/main_test.dart` (new). It runs the real `entry_point.main()` with a mock `SystemChannels.platform` handler. **Defect check:** a probe with `runApp` placed *before* `setPreferredOrientations` makes the "not yet mounted" assertion fail. Dropping the orientation call fails `hasLength(1)`. The probe file was deleted.

## Coverage

**G1 gate: no gate config. `/Volumes/ssd/Developer/Flutter/fiado_facil/.cleancode-gates.json` was not found.** No thresholds, roots, `exclude` or `exempt` are configured. Every changed file is therefore *ungated (outside all configured roots)*, because no roots exist. The numbers below are for information only. Instrument: `flutter test --coverage` → `coverage/lcov.info`. Branch coverage is **UNMEASURED** (dart-flutter emits no `BRF`/`BRH` records).

Changed-file scope (base `1118ab85b6fb881f2529d35237ebc69d01245ac9` against the working tree, plus untracked files, excluding `plans/` and `.orchestrator/`), Dart source only:

| File | Before (lines) | After (lines) |
|---|---|---|
| `lib/main.dart` | **not loaded by any test (absent from lcov)** | 4/4 (100%) |
| `lib/app.dart` | 5/5 | 5/5 |
| `lib/domain/format/money_format.dart` | 21/21 | 21/21 |
| `lib/domain/format/date_format.dart` | 8/8 | 8/8 |
| `lib/ui/screens/home_screen.dart` | 11/11 | 11/11 |
| `lib/ui/theme/app_theme.dart` | 2/2 | 2/2 |
| `lib/ui/widgets/app_button.dart` | 52/52 | 52/52 |
| `lib/ui/widgets/app_snackbar.dart` | 16/16 | 16/16 |
| `lib/ui/widgets/app_text_field.dart` | 50/50 | 50/50 |
| `lib/ui/widgets/confirm_dialog.dart` | 35/35 | 35/35 |
| `lib/ui/widgets/field_error.dart` | 9/9 | 9/9 |
| `lib/ui/widgets/money_field.dart` | 39/39 | 39/39 |
| `lib/ui/widgets/offline_banner.dart` | 13/13 | 13/13 |
| `lib/ui/widgets/top_bar.dart` | 18/18 | 18/18 |
| `lib/ui/theme/app_colors.dart`, `app_dimens.dart`, `app_text_styles.dart` | no executable lines (const-only; the VM emits no records) | same. Values are asserted by `app_tokens_test.dart` and `app_text_styles_test.dart` |
| **Total** | **279/279 over 13 files, 1 changed file never loaded** | **283/283 over 14 files** |

Other changed paths, all ungated and not Dart source: `lib/data/.gitkeep`, `android/app/src/main/AndroidManifest.xml`, `pubspec.yaml`, `pubspec.lock`, `assets/fonts/*` (3 files), and `.claude/agents/*.md` (6 files). **The `.claude/agents/*.md` files are not part of this plan's tasks.** They look like orchestrator-setup leftovers that fall in the diff scope. The reviewer should confirm they belong in this change set.

**Phase-gate note:** the coder's phase gates could not measure G1 either (the plan's Gate coverage table marks G1 n/a). So the `main.dart` gap above is not evidence of a skipped gate. It is a gap that was unmeasurable without a config.

Suite ledger: executed `flutter test --coverage` at `tree=5ff4ce54…`, result `pass`, 212/212. Row appended to `.orchestrator/verification-ledger.json` (`at` 2026-11-18T01:41:28Z). The tester's re-run after adding tests (214/214 passing) ran on a changed tree that has no minted hash, so it is not recorded as a ledger row.

## Test-Quality Audit

No empty asserts and no tautologies. The 17 coder test files assert concrete token values, resolved `ButtonStyle` states, rendered geometry, exact strings and dialog return values. Notes:

- **Weak, now fixed: `test/domain/format/date_format_test.dart` "a local DateTime gives the same result as its UTC equivalent" (both groups).** The chosen instants (`02:30Z`, `02:59Z`) give the same date with or without `toUtc()` on a UTC−03:00 host (this machine) and on a UTC host (typical CI). A probe implementing the defect (`instant.subtract(3h)` without `toUtc()`) passed the original cases (`OLD_CAUGHT=false`) and was caught by a half-hourly sweep over 48 h (`SWEEP_CAUGHT=true`). Added the group `host time zone independence` to the same file. The original tests stay as they were.
- Minor: `confirm_dialog_test.dart` checks the 24 dp top padding as `>= 24` (a lower bound only). The other three paddings are exact. Acceptable.
- Minor: `app_snackbar_test.dart` "disappears after 4 seconds" does not check that the snackbar is still visible just before 4 s. The duration itself is asserted exactly (`Duration(seconds: 4)`), so the contract is pinned.
- Minor: `accessibility_smoke_test.dart` checks growth only for primary and secondary (as AC 34 specifies). The text variant is only checked for "no exception".
- `font_assets_test.dart` checks `OFL.txt` by `existsSync()` only. The "SIL OPEN FONT LICENSE" content is a static AC 12 check. Acceptable.

Documentation check: `.orchestrator/PROJECT-CONTEXT.md` states no coverage, complexity or mutation numbers, so there is no documentation defect there. The plan's Gate coverage row calls G1 "advisory — not measured at phase exit". With no config that is the right outcome. Once a `.cleancode-gates.json` lands, G1 is the same gate QA blocks on at `delivery`, not an advisory one.

## Verdict

**BELOW_FLOOR.** Reason: no gate config. `/Volumes/ssd/Developer/Flutter/fiado_facil/.cleancode-gates.json` was not found. Every executed check is green: the 214-test suite, the launch flow observed through the real `main()`, and the 200% smoke test. Every changed Dart file with executable lines is at 100% line coverage. Branches are UNMEASURED on dart-flutter. To close the gap, a human bootstraps `.cleancode-gates.json` (for example with `clean-code-gates --scaffold`, or `/orchestrator --setup`). This is not a code fix. Rigor finding: none. `delivery` fits a foundation story.

Tester-added or modified test files (test files only, no production source touched):
- `test/main_test.dart` (new)
- `test/domain/format/date_format_test.dart` (one group appended)
