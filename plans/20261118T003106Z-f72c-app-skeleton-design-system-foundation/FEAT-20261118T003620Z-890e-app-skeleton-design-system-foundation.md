---
id: FEAT-20261118T003620Z-890e
title: App skeleton and design-system foundation (roadmap story 001.1.1)
type: feat
status: DONE
created_at: 2026-11-18T00:40:08Z
updated_at: 2026-11-18T01:25:27Z
cycle: 0
related_to: SPEC-20261118T003116Z-37ec
---

**Related:** [SPEC-20261118T003116Z-37ec](./SPEC-20261118T003116Z-37ec-app-skeleton-design-system-foundation.md)

## Overview

Replace the Flutter counter template with the Fiado Fácil app shell: a pt-BR-only, portrait-only, light-only `MaterialApp` (from `material_ui`) laid out as `lib/ui` (presentation) / `lib/domain` (domain) / `lib/data` (data, empty). The plan also builds the design-system foundation every later story reuses: the design `:root` tokens as single-source Dart constants, Atkinson Hyperlegible 400/700 bundled offline with a ≥ 16 sp type scale (body 18/26), integer-only money and America/Recife date helpers, the eight reusable widgets from the design's component list, and a placeholder home screen. Firebase, auth, navigation and real screens are out of scope (story 001.1.2 and later).

## Requirement Coverage

| Spec req # | Requirement (short) | Covered by AC # | Status |
| ---------- | ------------------- | --------------- | ------ |
| FR-1.1 | `main.dart` no counter; locks portraitUp, runs app | 1 | Met-by-plan |
| FR-1.2 | Root `MaterialApp` title, pt_BR locale, delegates, light theme | 2, 3 | Met-by-plan |
| FR-1.3 | Android label `Fiado Fácil`, activity portrait | 4 | Met-by-plan |
| FR-1.4 | pubspec adds provider, intl, flutter_localizations; description | 5 | Met-by-plan |
| FR-1.5 | Layered folders `ui/`, `domain/format/`, `data/`; test mirrors | 6 | Met-by-plan |
| FR-1.6 | PROJECT-CONTEXT Layout list and negative money form | 7 | Met-by-plan |
| FR-2.1 | Color constants equal design `:root` values | 8 | Met-by-plan |
| FR-2.2 | Spacing `space1..space8` = 4…40 | 9 | Met-by-plan |
| FR-2.3 | Radii sm 8, md 12, lg 16 | 9 | Met-by-plan |
| FR-2.4 | Sizes touch 48, button 56, field 56, amount 72, list 64, topbar 64 | 9 | Met-by-plan |
| FR-2.5 | Dialog shadow 0 4 16, textPrimary at 18 % | 10 | Met-by-plan |
| FR-2.6 | Each token defined exactly once; no repeated literals | 11 | Met-by-plan |
| FR-3.1 | Atkinson Hyperlegible 400/700 + OFL bundled, no runtime download | 12 | Met-by-plan |
| FR-3.2 | Type scale balance/amountInput/title/label/body/meta | 13 | Met-by-plan |
| FR-3.3 | Design 16 px → body 18, 15 px → meta 16, R$ → title | 14 | Met-by-plan |
| FR-3.4 | Material 3 ThemeData, font default, ColorScheme mapping | 15 | Met-by-plan |
| FR-3.5 | textTheme body 18/26; no entry below 16 | 16 | Met-by-plan |
| FR-4.1 | Money → `R$ 1.234,56`, negative `-R$ 22,10`, integer-only | 17, 21 | Met-by-plan |
| FR-4.2 | Digits → centavos fill-from-right; non-digit FormatException | 18 | Met-by-plan |
| FR-4.3 | Max amount constant 9999999 | 19 | Met-by-plan |
| FR-4.4 | Dates `dd/mm/aaaa`, `dd/mm` at fixed UTC−03:00 | 20 | Met-by-plan |
| FR-4.5 | Unit tests cover every example and acceptance case | 22 | Met-by-plan |
| FR-5.1 | Buttons primary/secondary/text, disabled reason, focus, ≥ 48 | 23, 31 | Met-by-plan |
| FR-5.2 | TopBar 64, title, optional back "Voltar", trailing, appBar | 24, 31 | Met-by-plan |
| FR-5.3 | OfflineBanner two modes verbatim copy, live region | 25, 31 | Met-by-plan |
| FR-5.4 | TextField + FieldError, borders, `<`/`>` rejected | 26, 27, 31 | Met-by-plan |
| FR-5.5 | MoneyField R$ prefix, right fill, `int?`, max ignored | 28, 31 | Met-by-plan |
| FR-5.6 | Snackbar helper hides current, floating, exactly 4 s | 29, 31 | Met-by-plan |
| FR-5.7 | ConfirmDialog LimitAlert layout, two tones, `Future<bool>` | 30, 31 | Met-by-plan |
| FR-6.1 | Scaffold on `bg` with TopBar "Fiado Fácil" | 32 | Met-by-plan |
| FR-6.2 | Centered verbatim S0 lines, body and meta | 32 | Met-by-plan |
| FR-6.3 | No interactive elements on placeholder | 32 | Met-by-plan |
| FR-7.1 | `widget_test.dart` rewritten with four assertions | 2, 3, 33 | Met-by-plan |
| FR-7.2 | Font assets load from bundle; `OFL.txt` exists | 12 | Met-by-plan |
| FR-7.3 | Token, theme/ColorScheme and typography tests | 8, 9, 10, 13, 15, 16 | Met-by-plan |
| FR-7.4 | Unit tests for FR-4 per FR-4.5 | 22 | Met-by-plan |
| FR-7.5 | Widget tests for each FR-5 widget | 23, 25, 26, 27, 28, 29, 30 | Met-by-plan |
| FR-7.6 | 200 % text-scale smoke test, no overflow | 34 | Met-by-plan |
| FR-7.7 | Format check, analyze zero issues, tests pass | 35 | Met-by-plan |

## Acceptance Criteria

**App shell (FR-1)**

1. `lib/main.dart` contains none of the template symbols (`MyApp`, `MyHomePage`, `_counter`, `_incrementCounter`, `FloatingActionButton`). Its `main` is `async`, calls `WidgetsFlutterBinding.ensureInitialized()`, awaits `SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp])`, then calls `runApp(const FiadoFacilApp())`. Nothing else lives in `main.dart`.
2. `lib/app.dart` defines `FiadoFacilApp`, whose `build` returns a `material_ui` `MaterialApp` with: `title: 'Fiado Fácil'`, `locale: Locale('pt', 'BR')`, `supportedLocales: [Locale('pt', 'BR')]` (exactly one entry), `localizationsDelegates: GlobalMaterialLocalizations.delegates` (the `material_ui` list — see Technical Notes), `theme:` the app theme from AC 15, `darkTheme == null`, `themeMode: ThemeMode.light`, `debugShowCheckedModeBanner: false`, `home: HomeScreen`. A widget test reads the pumped `MaterialApp` and asserts each of these property values.
3. Localization resolves to Portuguese through `material_ui`'s own localization types: no file under `lib/` imports `package:flutter_localizations/...` or `package:flutter/material.dart` (`grep -rnE "package:flutter_localizations|package:flutter/material.dart" lib` prints nothing), and a widget test inside the pumped `FiadoFacilApp` asserts `Localizations.localeOf(context) == const Locale('pt', 'BR')` and `MaterialLocalizations.of(context).cancelButtonLabel == 'Cancelar'`.
4. `android/app/src/main/AndroidManifest.xml` has `android:label="Fiado Fácil"` on `<application>` and `android:screenOrientation="portrait"` on the `.MainActivity` `<activity>`. No other manifest attribute changes.
5. `pubspec.yaml` declares under `dependencies`: `provider` (a `^6.1.x` constraint), `intl: ^0.20.2`, and `flutter_localizations: { sdk: flutter }`. `material_ui` and `cupertino_icons` stay. `description` is a short product description replacing "A new Flutter project.". `flutter pub get` exits 0, and `pubspec.lock` lists `provider`, `intl` and `flutter_localizations` as `direct main` with `material_ui` still at a `1.11.x` version. No `google_fonts` or other runtime-font dependency is added.
6. The tree contains `lib/main.dart`, `lib/app.dart`, `lib/ui/theme/`, `lib/ui/widgets/`, `lib/ui/screens/home_screen.dart`, `lib/domain/format/`, and `lib/data/.gitkeep` (the only file in `lib/data/`). Tests live in the mirrored folders `test/ui/theme/`, `test/ui/widgets/`, `test/ui/screens/`, `test/domain/format/` (plus `test/widget_test.dart` and an optional shared helper under `test/helpers/`). File names are `snake_case.dart`.
7. In `.orchestrator/PROJECT-CONTEXT.md`, the `## Layout` line "`lib/` — app; planned layer split presentation / domain / data (exact folder names set by first story)." is replaced by the real folder list of AC 6 (one bullet per folder with its role). The `## Conventions` money line reads with the negative form added, e.g. "Money shown `R$ 1.234,56` (negative `-R$ 22,10`); …". `git diff .orchestrator/PROJECT-CONTEXT.md` shows only these two hunks and deletes no other line.

**Design tokens (FR-2)**

8. `lib/ui/theme/app_colors.dart` defines `AppColors` with 19 `static const Color` constants equal to the design: `bg 0xFFF7F5F1`, `surface 0xFFFFFFFF`, `textPrimary 0xFF1C1B1A`, `textSecondary 0xFF4F4B45`, `border 0xFF7A746B`, `divider 0xFFE3DFD8`, `primary 0xFF1E6B43`, `primaryPressed 0xFF17573A`, `onPrimary 0xFFFFFFFF`, `primaryContainer 0xFFE6F2EA`, `warningContainer 0xFFFFF3D6`, `onWarning 0xFF6B4500`, `error 0xFFB3261E`, `errorContainer 0xFFFDECEA`, `info 0xFF1E4E8C`, `infoContainer 0xFFE8F0FB`, `focus 0xFF1E6B43`, `disabledBg 0xFFD9D5CE`, `scrim 0x661C1B1A`. A token test asserts each value with `toARGB32()`.
9. `lib/ui/theme/app_dimens.dart` defines `AppSpacing.space1..space8 = 4, 8, 12, 16, 20, 24, 32, 40`, `AppRadii.sm/md/lg = 8, 12, 16`, and `AppSizes.touchMin 48, buttonHeight 56, fieldHeight 56, amountFieldHeight 72, listItemMin 64, topBarHeight 64` (all `double`, which is fine — these are layout, not money). The token test asserts every value.
10. `AppShadows.dialog` (in `app_dimens.dart` or `app_colors.dart`) is one `BoxShadow` with `offset: Offset(0, 4)`, `blurRadius: 16`, `spreadRadius: 0`, and a color whose RGB equals `textPrimary`'s and whose alpha is `0x2E` (46/255 ≈ 18 %). The token test asserts offset, blur, RGB and alpha.
11. Single source: every color literal in `lib/` lives in `app_colors.dart` (`grep -rnE "Color\(0x|Color\.fromARGB|Color\.fromRGBO|#[0-9a-fA-F]{6}" lib --include='*.dart' | grep -v lib/ui/theme/app_colors.dart` prints nothing). Inside `app_colors.dart` the `1C1B1A` RGB is written once (as a private `const int`), and `textPrimary`, `scrim` and the dialog-shadow color are built from it by const bit-ORing an alpha byte. Theme and widget files reference `AppColors`/`AppSpacing`/`AppRadii`/`AppSizes`/`AppShadows`/`AppTextStyles` and never repeat a token's number for a token-defined dimension (reviewer-checked by reading `lib/ui/`).

**Theme and typography (FR-3)**

12. `assets/fonts/AtkinsonHyperlegible-Regular.ttf`, `assets/fonts/AtkinsonHyperlegible-Bold.ttf` and `assets/fonts/OFL.txt` are committed (`file` reports both TTFs as TrueType font data; `OFL.txt` contains "SIL OPEN FONT LICENSE"). `pubspec.yaml` `flutter.fonts` has one family `AtkinsonHyperlegible` with the Regular asset at weight 400 and the Bold asset at weight 700. A test (`test/ui/theme/font_assets_test.dart`) calls `rootBundle.load` on both TTF asset paths, asserts a non-empty `ByteData` for each, and asserts `File('assets/fonts/OFL.txt').existsSync()`.
13. `lib/ui/theme/app_text_styles.dart` defines `AppTextStyles.fontFamily = 'AtkinsonHyperlegible'` and six `TextStyle`s, all in that family: `balance` 32 / height 40/32 / w700 / `[FontFeature.tabularFigures()]`; `amountInput` 28 / 36/28 / w700 / tabular; `title` 22 / 28/22 / w700; `label` 18 / 24/18 / w700; `body` 18 / 26/18 / w400; `meta` 16 / 22/16 / w400. A typography test asserts each style's `fontFamily`, `fontSize`, `fontWeight`, `height` (to 1e-9) and, for balance/amountInput, the tabular feature, and asserts that no style's `fontSize` is below 16.
14. The design-size mapping is applied in the widgets, asserted by widget tests reading the rendered `Text`/`RichText` style (merged with `DefaultTextStyle`): OfflineBanner text, FieldError message and Snackbar message use `body` (18); the button disabled-reason line and the TextField character counter use `meta` (16, `textSecondary`); the MoneyField `R$` prefix uses `title` (22, w700) in `textSecondary`.
15. `lib/ui/theme/app_theme.dart` exposes `ThemeData buildAppTheme()` returning `useMaterial3: true`, brightness light, `fontFamily: AppTextStyles.fontFamily`, `scaffoldBackgroundColor: AppColors.bg`, and a `ColorScheme` with primary→`primary`, onPrimary→`onPrimary`, primaryContainer→`primaryContainer`, onPrimaryContainer→`textPrimary`, surface→`surface`, onSurface→`textPrimary`, onSurfaceVariant→`textSecondary`, outline→`border`, outlineVariant→`divider`, error→`error`, onError→`onPrimary`, errorContainer→`errorContainer`, onErrorContainer→`error`, scrim→`scrim` (required slots with no spec mapping — `secondary`/`onSecondary` — take `primary`/`onPrimary`). A theme test asserts all 14 spec mappings, the font family, `useMaterial3` and the scaffold background. Tokens without a `ColorScheme` slot are read from `AppColors` directly (no `ThemeExtension`).
16. `buildAppTheme().textTheme.bodyLarge` and `.bodyMedium` both equal `body` 18/26 (size, height, weight, family). All 15 `TextTheme` slots (`display*`, `headline*`, `title*`, `body*`, `label*`) have `fontSize >= 16` and `fontFamily == 'AtkinsonHyperlegible'` (suggested mapping: display/headline → `balance`/`amountInput`/`title`, title* → `title`/`label`, bodySmall → `meta`, label* → `label`/`meta`). A theme test iterates all 15 slots.

**Formatting helpers (FR-4)**

17. `lib/domain/format/money_format.dart` exposes `String formatCentavos(int centavos)` returning exactly: `0 → "R$ 0,00"`, `5 → "R$ 0,05"`, `123456 → "R$ 1.234,56"`, `9999999 → "R$ 99.999,99"`, `100000000 → "R$ 1.000.000,00"`, `-2210 → "-R$ 22,10"`. The separator after `R$` is U+0020; the negative sign is U+002D before `R$`. It also exposes the prefix-less form used by MoneyField, `String formatCentavosAmount(int centavos)` (`123456 → "1.234,56"`, `0 → "0,00"`), and `formatCentavos` is built on it.
18. `int parseDigitsToCentavos(String digits)` in the same file returns `"" → 0`, `"5" → 5`, `"4790" → 4790`, `"0047" → 47`, and throws `FormatException` for any non-ASCII-digit character (tests at least `"4a"`, `"-1"`, `" 1"`, `"1,0"`, `"١"` Arabic-Indic digit). It never clamps (`"100000000" → 100000000`).
19. `const int kMaxCentavos = 9999999;` is exported from `lib/domain/format/money_format.dart`, and a test asserts its value and that `formatCentavos(kMaxCentavos) == "R$ 99.999,99"`.
20. `lib/domain/format/date_format.dart` exposes `String formatDateRecife(DateTime instant)` (`dd/mm/aaaa`) and `String formatDayMonthRecife(DateTime instant)` (`dd/mm`), both computing wall time as `instant.toUtc().subtract(const Duration(hours: 3))` with no timezone package: `DateTime.utc(2026, 11, 18, 2, 0) → "17/11/2026"`, `DateTime.utc(2026, 11, 18, 3, 0) → "18/11/2026"`, `DateTime.utc(2026, 1, 1, 2, 59)` (dd/mm) `→ "31/12"`, and a local (non-UTC) `DateTime` gives the same result as its UTC equivalent. Day and month are zero-padded (e.g. `DateTime.utc(2026, 3, 5, 12) → "05/03/2026"`).
21. No `double` arithmetic in money code: `grep -rnE "\bdouble\b|\bnum\b|toDouble|NumberFormat|package:intl" lib/domain/format lib/ui/widgets/money_field.dart` prints nothing; integer division uses `~/` and `%` only.
22. `test/domain/format/money_format_test.dart` and `test/domain/format/date_format_test.dart` cover every example in AC 17–20, including the acceptance cases `0`, `123456`, `9999999`, `-2210` and both Recife day-boundary cases; tests assert exact strings.

**Reusable widgets (FR-5)** — every widget below lives in `lib/ui/widgets/`, takes all colors/sizes/styles from the AC 8–13 constants, takes copy from the caller (except OfflineBanner's fixed copy and TopBar's "Voltar"), and has a widget test in `test/ui/widgets/`.

23. `app_button.dart` — `AppButton` with three variants (e.g. named constructors `AppButton.primary/.secondary/.text`) taking `label`, `onPressed` (null = disabled), optional `icon` and optional `disabledReason`. Widget tests assert at text scale 1.0:
    - primary and secondary render exactly 56 dp high and as wide as their parent; the text variant is ≥ 48 dp high and narrower than its parent (intrinsic width); every variant's tappable area is ≥ 48×48 dp;
    - the button's `ButtonStyle` resolves: primary bg `primary` (idle) and `primaryPressed` (`WidgetState.pressed`), fg `onPrimary`; secondary bg `surface`, fg `primary`, side 1 px `primary`; text bg transparent, fg `primary`, horizontal padding 8; primary/secondary horizontal padding 16 and radius `md` 12; any variant under `WidgetState.disabled` bg `disabledBg`, fg `textSecondary`, side `disabledBg`; any variant under `WidgetState.focused` side 2 px `focus`;
    - the label uses `label` 18/24 w700; a leading icon renders at size 24 with an 8 dp gap;
    - the `disabledReason` text renders below the button in `meta` `textSecondary` when `onPressed == null`, and is absent from the tree when `onPressed != null` even if `disabledReason` is passed.
24. `top_bar.dart` — `TopBar implements PreferredSizeWidget` with `preferredSize.height == 64`, background `bg`, title in `title` 22/28 w700. With `onBack` set it shows a text button with `Icons.arrow_back_rounded` and the text "Voltar" that calls `onBack` when tapped, and the bar's left padding is 4; without `onBack` there is no back button and the left padding is 16; right padding is 8. An optional `actions` list renders in the trailing area. A test places it as `Scaffold.appBar` and asserts each of these.
25. `offline_banner.dart` — `OfflineBanner(mode: OfflineBannerMode.offline | .sending)` renders, verbatim, `offline`: `Icons.cloud_off_rounded` + "Sem internet. Pode continuar usando: os dados serão enviados depois."; `sending`: `Icons.cloud_upload_rounded` + "Enviando dados...". Background `infoContainer`, icon color `info`, text `body` `textPrimary`, min height 48, padding 8 vertical / 16 horizontal, icon–text gap 12. Its semantics node is a live region (`isLiveRegion`) carrying the text. It has no visibility input and renders whenever built.
26. `app_text_field.dart` — `AppTextField` with `label`, optional `labelSuffix` (e.g. "(opcional)"), optional `controller`, `hintText`, `leadingIcon`, `maxLength` (shows an `n/max` counter right-aligned in `meta` `textSecondary`), `errorText`, `keyboardType`, `textCapitalization`, `inputFormatters`, `onChanged`. Widget tests assert: label above the input in `label` 18/24 w700, suffix in regular weight `textSecondary`, label–input gap 8; input min height 56, fill `surface`, radius `sm` 8, horizontal content padding 12, text `body`; border 1 px `border` when idle, 2 px `primary` when focused, 2 px `error` (idle and focused) when `errorText != null`; leading icon in `border` color; hint in `textSecondary`; caller's `keyboardType`/`textCapitalization` reach the inner field. Entering `"a<b>c"` yields controller text `"abc"`, both with and without caller-supplied `inputFormatters` (the deny formatter is always applied first).
27. `field_error.dart` — `FieldError(message)` renders `Icons.error_rounded` at size 20 in `error` plus the message in `body` `error`, gap 8. Its semantics node is a live region carrying the message. `AppTextField` (and `MoneyField`) render a `FieldError` below the input exactly when `errorText != null`; a test asserts both icon and text are present whenever it is shown.
28. `money_field.dart` — `MoneyField` with `label`, optional `labelSuffix`, `initialCentavos` (`int?`), `onChanged: ValueChanged<int?>`, `errorText`. Widget tests assert: input min height 72; a `R$` prefix in `title` `textSecondary`; the value text right-aligned in `amountInput` (28/36 w700, tabular figures); `keyboardType == TextInputType.number`; typing `4790` shows `47,90` and reports `4790`; typing `0047` shows `0,47` and reports `47`; a non-digit typed is dropped; clearing all digits reports `null` and shows the hint `0,00` in `textSecondary`; with `99.999,99` showing, one more digit is ignored (text stays `99.999,99`, no new `onChanged` value); `errorText` shows a `FieldError`. Conversion goes through `parseDigitsToCentavos` / `formatCentavosAmount` / `kMaxCentavos` (no duplicated money logic in the widget).
29. `app_snackbar.dart` — `void showAppSnackbar(BuildContext context, String message)` calls `ScaffoldMessenger.of(context).hideCurrentSnackBar()` then shows a `SnackBar` with `behavior: SnackBarBehavior.floating` and `duration: const Duration(seconds: 4)`. Its visible content is a box with `primaryContainer` background, radius `md` 12, padding 12 vertical / 16 horizontal, `AppShadows.dialog`, a leading `Icons.check_circle_rounded` in `primary`, and the message in `body` `textPrimary`, gap 12. Tests assert the duration and behavior, the content styling, and that calling it twice in a row leaves only the second message on screen.
30. `confirm_dialog.dart` — `Future<bool> showConfirmDialog(BuildContext context, {required String title, required String message, required String confirmLabel, required String dismissLabel, IconData? icon, ConfirmDialogTone tone = ConfirmDialogTone.neutral})`. Tests assert: returns `true` on the confirm button, `false` on the dismiss button, `false` on a barrier tap, and `false` on system back; barrier color `scrim`; dialog box radius `lg` 16, 2 px border, padding 24 top / 20 sides / 20 bottom, internal gap 12, `AppShadows.dialog`; head row = icon size 32 + title in `title` 22/28 w700, gap 8; body in `body` `textPrimary`; actions stacked vertically (confirm is a primary `AppButton` above a secondary `AppButton` dismiss), both full width and 56 high, gap 8, 8 above the actions; tone `neutral` → bg `surface`, border `border`, icon `primary`, title `textPrimary`; tone `warning` → bg `warningContainer`, border/icon/title `onWarning`. The dialog's semantics node has the `scopesRoute` and `namesRoute` flags and the title as its label.
31. Decorative icons in every widget are created without a `semanticLabel` (excluded from semantics), and every icon is an `Icons.*_rounded` constant from `material_ui` rendered from the bundled Material Icons font (`uses-material-design: true` stays). No widget file contains business rules (saldo, limit, overdue) or connectivity logic.

**Placeholder home screen (FR-6)**

32. `lib/ui/screens/home_screen.dart` — `HomeScreen` is a `Scaffold` with `backgroundColor: AppColors.bg` and `appBar: TopBar(title: 'Fiado Fácil')` (no back, no actions). Its body is centered and contains exactly two `Text` widgets: "A caderneta do fiado" in `body` and "Mercadinho da Família" in `meta` `textSecondary`. A screen test asserts that copy and styling, that no other `Text` appears in the body, and that the screen contains no `AppButton`, `ButtonStyleButton`, `InkWell`, `GestureDetector` or `EditableText`.

**Tests and gates (FR-7)**

33. `test/widget_test.dart` is rewritten: it pumps `const FiadoFacilApp()` and asserts "Fiado Fácil" and "A caderneta do fiado" are found; `find.text('0')`, `find.byIcon(Icons.add)` and `find.byType(FloatingActionButton)` find nothing; the `MaterialApp`'s `locale` is `Locale('pt', 'BR')`; and the `DefaultTextStyle` resolved at "A caderneta do fiado" (or that `Text`'s merged style) has `fontFamily == 'AtkinsonHyperlegible'` and `fontSize == 18`.
34. `test/ui/accessibility_smoke_test.dart` pumps, at `MediaQuery` `textScaler: TextScaler.linear(2.0)` on a 360×800 logical surface: (a) `FiadoFacilApp` / `HomeScreen`; (b) a column with one enabled `AppButton` of each variant plus one disabled primary with a `disabledReason`. For each it asserts `tester.takeException()` is `null` (no overflow / layout exception), and that primary/secondary buttons are taller than 56 (they grew instead of clipping).
35. At the end of the run, from the repo root: `dart format --output=none --set-exit-if-changed lib test` exits 0, `flutter analyze` reports "No issues found!", and `flutter test` passes every test. (These whole-project runs are the run's barrier — tester/QA — not a phase gate; phases run the scoped forms in `## Verification (per phase)`.)

## Out of Scope

- Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`), emulators, `firestore.rules`, `integration_test/` — story 001.1.2.
- Login, session check, S0 splash logic, routing/navigation between real screens, any real screen (A1, A3, A4, T1, T1.1, T2, T3, T3.1).
- Connectivity detection or sync-state tracking; OfflineBanner visibility decisions.
- Domain rules (saldo, limit check, overdue, statement text), entities, repositories; anything in `lib/data/` beyond `.gitkeep`.
- `ChangeNotifier`/`Provider`/`MultiProvider` wiring (`provider` is a dependency only).
- App icon, Android 12 splash, release signing, Play Store metadata.
- Removing `ios/ web/ linux/ macos/ windows/` or `cupertino_icons`.
- Dark theme, landscape, any locale other than `pt_BR`.
- Every PROJECT-CONTEXT out-of-scope item (inventory, POS, Pix, iOS/web, Cloud Functions, …).

## Technical Notes

- **Localization wiring (brainstormer risk — verified against the installed package).** `material_ui` 1.11.1 (`/Volumes/ssd/Developer/.pub-cache/hosted/pub.dev/material_ui-1.11.1`) is a decoupled copy of Material: it declares its **own** `abstract class MaterialLocalizations` (`lib/src/material_localizations.dart`) and its own `GlobalMaterialLocalizations` (`lib/src/global_material_localizations.dart`, exported from `package:material_ui/material_ui.dart`), with a generated `MaterialLocalizationPt` (`cancelButtonLabel 'Cancelar'`, `backButtonTooltip 'Voltar'`). Its `GlobalMaterialLocalizations.delegates` already contains all three delegates the spec asks for: `GlobalCupertinoLocalizations.delegate` (from `cupertino_ui`), its own Material delegate, and `GlobalWidgetsLocalizations.delegate` (from `flutter_localizations`). Therefore:
  - Use `localizationsDelegates: GlobalMaterialLocalizations.delegates` with the `material_ui` import only.
  - Do **not** import `package:flutter_localizations/flutter_localizations.dart` anywhere in `lib/` or `test/`: it also exports a `GlobalMaterialLocalizations` (ambiguous-import compile error), and its Material delegate provides `package:flutter/material.dart`'s `MaterialLocalizations` type, which `material_ui` widgets cannot look up — `Localizations.of<material_ui.MaterialLocalizations>` would fall back to the default English set or throw "No MaterialLocalizations found". AC 3's `cancelButtonLabel == 'Cancelar'` check is the test that catches a wrong delegate.
  - `flutter_localizations` is still added to `pubspec.yaml` as a direct `sdk: flutter` dependency (FR-1.4 / brief), even though it is already transitive through `material_ui`; it is not imported.
  - Never import `package:flutter/material.dart` in app or test code — mixing it with `material_ui` gives two `MaterialApp`/`ThemeData` types. `flutter_test` + `material_ui` together is fine (the template test already does it). `package:flutter/services.dart` may be imported where `SystemChrome`, `DeviceOrientation`, `TextInputFormatter`, `FilteringTextInputFormatter` are needed.
- **Dependency versions.** `material_ui 1.11.1` requires `intl ^0.20.2` (lock already resolves `intl 0.20.3`) and `flutter >= 3.47` (local Flutter 3.50.0 stable). `provider ^6.1.5` is in the local pub cache. Keep `material_ui: ^1.1.0` as is.
- **Fonts.** Download the original Atkinson Hyperlegible (not "Next") from the Google Fonts repo — the URLs return 200 as of planning:
  `https://raw.githubusercontent.com/google/fonts/main/ofl/atkinsonhyperlegible/AtkinsonHyperlegible-Regular.ttf`, `…/AtkinsonHyperlegible-Bold.ttf`, `…/OFL.txt` (use `curl -fL -o`). If the network is unavailable, stop and record it as BLOCKED rather than substituting another font. `flutter test` bundles declared assets, so `rootBundle.load('assets/fonts/…ttf')` works in a widget test; widget tests still render glyphs with the test font, so typography assertions read `TextStyle` properties, never pixel metrics.
- **Single-source colors.** `Color.withValues`/`withAlpha` are not `const`, so build alpha variants with const integer arithmetic: `static const int _textPrimaryRgb = 0x1C1B1A; static const Color textPrimary = Color(0xFF000000 | _textPrimaryRgb); static const Color scrim = Color(0x66000000 | _textPrimaryRgb);` and the shadow color `Color(0x2E000000 | _textPrimaryRgb)`. `focus` and `primary` share a hex value in the design but are distinct tokens; both are design `:root` entries, so both constants exist.
- **Buttons.** Recommended: build `AppButton` on `material_ui`'s `FilledButton` (primary), `OutlinedButton` (secondary) and `TextButton` (text) with a token-built `ButtonStyle` using `WidgetStateProperty` for pressed/disabled/focused, `minimumSize: Size(double.infinity or 0, 56/48)` (min, never fixed, so it grows at 200 %), `tapTargetSize: MaterialTapTargetSize.padded`, `shape: RoundedRectangleBorder(AppRadii.md)`. This gives AC 23's style assertions a single object to read and keeps keyboard focus/semantics native. The design's 2 px focus outline sits 2 px outside the button; a `side` of 2 px `focus` is an accepted approximation (Material's focus overlay adds a second cue). Disabled reason: `Column` with the button and, when disabled and non-null, the reason `Text` with a `space2` gap.
- **TopBar at 200 %.** `Scaffold.appBar` gives the bar a tight `preferredSize` height, so the title should be single-line with `TextOverflow.ellipsis`; AC 34 verifies "Fiado Fácil" fits at 2.0.
- **Text field borders.** Show the error through `FieldError` below the field, not `InputDecoration.errorText` (whose style is Material's); switch `enabledBorder`/`focusedBorder` to the 2 px `error` side when `errorText != null`. Use `isDense`/`contentPadding` + `constraints: BoxConstraints(minHeight: 56)` so the box grows with text scale.
- **MoneyField.** Implement fill-from-right as a `TextInputFormatter` that strips non-digits from the new value, drops leading zeros, rejects (returns `oldValue`) when `parseDigitsToCentavos(digits) > kMaxCentavos`, and otherwise returns `formatCentavosAmount(value)` with the caret collapsed at the end; empty digits → empty text (hint `0,00` shows) and `onChanged(null)`. `tester.enterText` runs input formatters, so AC 28 is testable with it.
- **ConfirmDialog.** Use `showDialog<bool>(barrierColor: AppColors.scrim, barrierDismissible: true, …)` and return `result ?? false`. Build the box with `material_ui` `Dialog` (transparent background, zero elevation) wrapping a `DecoratedBox` (tone bg, 2 px tone border, `AppRadii.lg`, `AppShadows.dialog`), and a `Semantics(scopesRoute: true, namesRoute: true, explicitChildNodes: true, label: title)` wrapper. System back in a test: `await tester.binding.handlePopRoute()`.
- **Snackbar.** `material_ui` `SnackBar` cannot take a `BoxShadow`, so give it `backgroundColor: Colors.transparent`, `elevation: 0`, `padding: EdgeInsets.zero` and put the token-styled `DecoratedBox` in `content`.
- **Widget test harness.** A small `test/helpers/test_app.dart` (`Widget wrapInApp(Widget child)` returning a `MaterialApp(theme: buildAppTheme(), locale/delegates as AC 2, home: Scaffold(body: child))`) keeps widget tests consistent. It is test-only code.
- **Invariants applied:** 1 (integer centavos, AC 17–21, 28), 10 (no store introduced), 11 (`<`/`>` rejected, AC 26), 12 (offline font/icons, AC 12, 31), 14 (18 sp base, ≥ 16, 48/56/72 dp, 200 %, live regions, never color alone: AC 13–16, 23, 25, 27, 34). Conventions: pt-BR copy verbatim from `docs/design/*.html`; `snake_case.dart`; `flutter_lints`; no business logic in widgets.
- **No open product decision** in PROJECT-CONTEXT/INTENT touches this story. Design source of truth for tokens/components: `docs/design/00-indice.html` (`:root` block lines 1–40 of its `<style>`, `.ff-*` component rules).
- **Gate config:** the project has no `.cleancode-gates.json`, so no clean-code gate (G1–G7) has configured roots; phases carry the PROJECT-CONTEXT phase gate (format check + analyze + test, scoped).

## Tasks

> Tasks are ordered TDD-first: write/update tests before implementation.
> The coder will check off [ ] → [x] as each task is verified.
> Each phase ends with a `### Phase N verification` checklist the coder MUST run and RECORD the verdict of before checking the last task in the phase — exit 0, or a carried `CODER — GATE` entry naming the fix it rejected and why. A gate it cannot clear never blocks the phase. The exact commands per phase come from `## Verification (per phase)` below.

### Phase 1 — Dependencies, fonts, manifest, folders (AC 4, 5, 6 partial, 12)

- [x] Write failing test `test/ui/theme/font_assets_test.dart`: `rootBundle.load` of both TTF asset paths returns non-empty data; `File('assets/fonts/OFL.txt').existsSync()` (AC 12)
- [x] Download `AtkinsonHyperlegible-Regular.ttf`, `AtkinsonHyperlegible-Bold.ttf` and `OFL.txt` into `assets/fonts/` from the Google Fonts URLs in Technical Notes; confirm with `file` that both are TrueType and `OFL.txt` contains "SIL OPEN FONT LICENSE"
- [x] Edit `pubspec.yaml`: add `provider`, `intl: ^0.20.2`, `flutter_localizations: { sdk: flutter }`; replace `description`; add `flutter.fonts` family `AtkinsonHyperlegible` (400 Regular, 700 Bold); keep `uses-material-design: true`; run `flutter pub get` and confirm the lock shows the three as `direct main` and `material_ui` 1.11.x (AC 5, 12)
- [x] Edit `android/app/src/main/AndroidManifest.xml`: `android:label="Fiado Fácil"`, `android:screenOrientation="portrait"` on `.MainActivity` (AC 4)
- [x] Create `lib/data/.gitkeep` (AC 6)
- [x] Run the font asset test and confirm green

### Phase 1 verification

- [x] `dart format --output=none --set-exit-if-changed test/ui/theme/font_assets_test.dart` — record verdict
- [x] `flutter analyze test/ui/theme/font_assets_test.dart` — record verdict
- [x] `flutter test test/ui/theme/font_assets_test.dart` — record verdict

### Phase 2 — Domain formatting helpers (AC 17–22)

- [x] Write failing tests `test/domain/format/money_format_test.dart`: every `formatCentavos`, `formatCentavosAmount`, `parseDigitsToCentavos` (incl. each `FormatException` case and no-clamp case) and `kMaxCentavos` example from AC 17–19
- [x] Implement `lib/domain/format/money_format.dart` with integer-only arithmetic (`~/`, `%`, string grouping) to pass
- [x] Write failing tests `test/domain/format/date_format_test.dart`: both Recife day-boundary cases, the `dd/mm` case, zero-padding, local-vs-UTC equivalence (AC 20)
- [x] Implement `lib/domain/format/date_format.dart` (fixed `toUtc() − 3 h`, manual zero-pad, no `intl`/tz) to pass
- [x] Confirm `grep -rnE "\bdouble\b|\bnum\b|toDouble|NumberFormat|package:intl" lib/domain/format` prints nothing (AC 21)
- [x] Run `test/domain/format` and confirm green

### Phase 2 verification

- [x] `dart format --output=none --set-exit-if-changed lib/domain/format test/domain/format` — record verdict
- [x] `flutter analyze lib/domain/format test/domain/format` — record verdict
- [x] `flutter test test/domain/format` — record verdict

### Phase 3 — Tokens, typography, theme (AC 8–11, 13, 15, 16)

- [x] Write failing token test `test/ui/theme/app_tokens_test.dart`: all 19 colors, spacing, radii, sizes, dialog shadow (AC 8–10)
- [x] Implement `lib/ui/theme/app_colors.dart` (single private RGB int for `1C1B1A`, const-ORed alpha variants) and `lib/ui/theme/app_dimens.dart` (`AppSpacing`, `AppRadii`, `AppSizes`, `AppShadows`) to pass
- [x] Write failing typography test `test/ui/theme/app_text_styles_test.dart`: six styles' family/size/weight/height/tabular, none < 16 (AC 13)
- [x] Implement `lib/ui/theme/app_text_styles.dart` to pass
- [x] Write failing theme test `test/ui/theme/app_theme_test.dart`: Material 3, font family, scaffold bg, 14 ColorScheme mappings, bodyLarge/bodyMedium = body, all 15 TextTheme slots ≥ 16 in the bundled family (AC 15, 16)
- [x] Implement `lib/ui/theme/app_theme.dart` (`buildAppTheme()`) to pass
- [x] Run `test/ui/theme` and confirm green

### Phase 3 verification

- [x] `dart format --output=none --set-exit-if-changed lib/ui/theme test/ui/theme` — record verdict
- [x] `flutter analyze lib/ui/theme test/ui/theme` — record verdict
- [x] `flutter test test/ui/theme` — record verdict

### Phase 4 — Widgets I: buttons, TopBar, OfflineBanner (AC 14 partial, 23–25, 31)

- [x] Create test helper `test/helpers/test_app.dart` (`wrapInApp`) per Technical Notes
- [x] Write failing widget tests `test/ui/widgets/app_button_test.dart`: sizes (56 exact / ≥ 48 / full vs intrinsic width), resolved style per variant and state (idle, pressed, disabled, focused), label style, icon size/gap, disabled-reason visibility and `meta` style (AC 23, 14)
- [x] Implement `lib/ui/widgets/app_button.dart` to pass
- [x] Write failing widget tests `test/ui/widgets/top_bar_test.dart`: preferredSize 64, bg, title style, back button icon/"Voltar"/callback, paddings 4/16/8, actions (AC 24)
- [x] Implement `lib/ui/widgets/top_bar.dart` to pass
- [x] Write failing widget tests `test/ui/widgets/offline_banner_test.dart`: verbatim copy and icon per mode, colors, min height, padding, gap, `body` text, live-region semantics (AC 25, 14)
- [x] Implement `lib/ui/widgets/offline_banner.dart` to pass
- [x] Run `test/ui/widgets` and confirm green

### Phase 4 verification

- [x] `dart format --output=none --set-exit-if-changed lib/ui/widgets test/ui/widgets test/helpers` — record verdict
- [x] `flutter analyze lib/ui/widgets test/ui/widgets test/helpers` — record verdict
- [x] `flutter test test/ui/widgets` — record verdict

### Phase 5 — Widgets II: TextField/FieldError, MoneyField, Snackbar, ConfirmDialog (AC 14 partial, 26–31)

- [x] Write failing widget tests `test/ui/widgets/field_error_test.dart` and `test/ui/widgets/app_text_field_test.dart`: FieldError icon/text/semantics; field label/suffix/gap, box geometry, three border states, leading icon, hint, counter in `meta`, pass-through params, `<`/`>` stripping with and without caller formatters (AC 26, 27, 14)
- [x] Implement `lib/ui/widgets/field_error.dart` and `lib/ui/widgets/app_text_field.dart` to pass
- [x] Write failing widget tests `test/ui/widgets/money_field_test.dart`: min height 72, `R$` prefix style, value style/alignment, numeric keyboard, `4790`/`0047` fill, non-digit dropped, clear → `null` + hint, max keystroke ignored, FieldError (AC 28, 14)
- [x] Implement `lib/ui/widgets/money_field.dart` (formatter built on the Phase 2 helpers) to pass; confirm the AC 21 grep is still empty for `money_field.dart`
- [x] Write failing widget tests `test/ui/widgets/app_snackbar_test.dart`: floating, 4 s, content styling, second call replaces first (AC 29, 14)
- [x] Implement `lib/ui/widgets/app_snackbar.dart` to pass
- [x] Write failing widget tests `test/ui/widgets/confirm_dialog_test.dart`: `true`/`false` for confirm/dismiss/barrier/back, scrim, box geometry, head row, actions order/size, both tones' colors, semantics flags and label (AC 30)
- [x] Implement `lib/ui/widgets/confirm_dialog.dart` to pass
- [x] Confirm every `Icon` in `lib/ui/widgets` uses an `Icons.*_rounded` constant with no `semanticLabel` (AC 31)
- [x] Run `test/ui/widgets` and confirm green

### Phase 5 verification

- [x] `dart format --output=none --set-exit-if-changed lib/ui/widgets test/ui/widgets` — record verdict
- [x] `flutter analyze lib/ui/widgets test/ui/widgets` — record verdict
- [x] `flutter test test/ui/widgets` — record verdict

### Phase 6 — App shell, placeholder screen, smoke tests, PROJECT-CONTEXT (AC 1–3, 6, 7, 11, 32–34)

- [x] Write failing screen test `test/ui/screens/home_screen_test.dart`: Scaffold bg, TopBar title, the two verbatim lines and their styles, no other body text, no interactive widgets (AC 32)
- [x] Implement `lib/ui/screens/home_screen.dart` to pass
- [x] Rewrite `test/widget_test.dart` per AC 33, plus the AC 2 property assertions and the AC 3 locale / `cancelButtonLabel == 'Cancelar'` assertions (failing until the shell exists)
- [x] Implement `lib/app.dart` (`FiadoFacilApp`, `material_ui` `GlobalMaterialLocalizations.delegates`) and rewrite `lib/main.dart` (orientation lock + `runApp`, template removed) to pass (AC 1–3)
- [x] Write `test/ui/accessibility_smoke_test.dart` at `TextScaler.linear(2.0)` on a 360×800 surface (AC 34); fix any overflow it surfaces in the Phase 4–6 widgets
- [x] Update `.orchestrator/PROJECT-CONTEXT.md`: replace the `## Layout` planned-split line with the real folder list; add `-R$ 22,10` to the `## Conventions` money line; confirm `git diff` shows only those two hunks (AC 7)
- [x] Run the AC 3 and AC 11 greps (`package:flutter_localizations|package:flutter/material.dart` in `lib`; color literals outside `app_colors.dart`) and confirm both print nothing
- [x] Run this phase's tests and confirm green

### Phase 6 verification

- [x] `dart format --output=none --set-exit-if-changed lib/main.dart lib/app.dart lib/ui/screens test/widget_test.dart test/ui/screens test/ui/accessibility_smoke_test.dart` — record verdict
- [x] `flutter analyze lib/main.dart lib/app.dart lib/ui/screens test/widget_test.dart test/ui/screens test/ui/accessibility_smoke_test.dart` — record verdict
- [x] `flutter test test/widget_test.dart test/ui/screens test/ui/accessibility_smoke_test.dart` — record verdict

## Verification (per phase)

> Emit this section in EVERY FEAT plan. Before checking off the LAST task in
> any phase, the coder runs the gate commands from the Commands section of
> PROJECT-CONTEXT.md that apply to the phase's touched paths and records the
> verdict of each. A failure it cannot clear inside its authorized tasks is
> RECORDED as a `CODER — GATE` entry in `.progress.md` and the phase proceeds —
> never a `BLOCKED` stop, and never a silent rewrite.

Apply the Commands section of `PROJECT-CONTEXT.md` to determine the per-phase gate commands (its stated phase gate: format check + `flutter analyze` + `flutter test`, scoped to touched paths). Run only those whose path condition matches the phase's diff. Phase exit criterion: EVERY applicable command was run and its verdict recorded — exit 0, or a carried `GATE` entry naming the fix that was rejected and why. No silent rewrites of source to make a gate pass without a corresponding plan task.

| Command | Scope | Phases | Path condition |
| ------- | ----- | ------ | -------------- |
| `dart format --output=none --set-exit-if-changed <changed-dart-paths>` | changed-files | 1, 2, 3, 4, 5, 6 | phase added/changed `.dart` files under `lib/` or `test/`; fill `<changed-dart-paths>` with exactly those files/folders (non-mutating check form — never the write form) |
| `flutter analyze <changed-lib-and-test-paths>` | changed-files | 1, 2, 3, 4, 5, 6 | phase changed `.dart` files or `pubspec.yaml`; fill with the phase's `lib/…` and `test/…` paths (Phase 1: the font asset test, which also exercises the new pubspec) |
| `flutter test <changed-test-paths>` | changed-files | 1, 2, 3, 4, 5, 6 | phase added/changed test files; fill with those test files/folders only — never bare `flutter test` |

The whole-project `dart format … lib test`, `flutter analyze` and `flutter test` of AC 35 are the run's barrier (tester/QA), not a phase row. `.orchestrator/PROJECT-CONTEXT.md`, `AndroidManifest.xml`, `pubspec.yaml` and `assets/fonts/*` have no formatter/analyzer row of their own; they are checked by the AC 4/5/7/12 assertions and greps.

### Gate coverage

| Gate | Phases | Carried by | Assertion |
| ---- | ------ | ---------- | --------- |
| G1 | n/a — no `.cleancode-gates.json` in the project, so no coverage floor or roots are configured | n/a | advisory — not measured at phase exit |
| G2 | n/a — no `.cleancode-gates.json` (no complexity roots configured) | n/a | not asserted |
| G4 | n/a — no `.cleancode-gates.json` (no naming roots configured) | n/a | not asserted |
| G5 | n/a — no `.cleancode-gates.json` (no no-comments roots configured) | n/a | not asserted |
| G6 | — | — | QA-only — never run at phase exit |
| G7 | n/a — no `.cleancode-gates.json` (no dependency-structure roots configured) | n/a | not asserted |

## Dependencies

- None. This is the first story (`depends_on: []`); story 001.1.2 (Firebase wiring) depends on it.

## Progress Log

<!-- Agents append below. Never rewrite entries. Newest on top. -->

### 2026-11-18T01:54:01Z | REVIEWER

CR-20261118T014808Z-817a created. Status: REQUEST_CHANGES. Must Fix: 1. Should Fix: 3.

### 2026-11-18T01:46:53Z | TESTER

TEST-20261118T013640Z-10cb created. Status: BELOW_FLOOR. Coverage: 279/279 lines (13 files; lib/main.dart never loaded) → 283/283 lines (14 files), branches UNMEASURED (stmts/branches, changed files, vs configured G1: none — no gate config, .cleancode-gates.json not found).

### 2026-11-18T01:25:27Z | CODER

All 63 tasks complete. Plan status → DONE. Ready for reviewer.

### 2026-11-18T00:46:32Z | CODER

Session started. Plan status → IN_PROGRESS. Beginning from first unchecked task.

### 2026-11-18T00:40:08Z | ARCHITECT

Plan `FEAT-20261118T003620Z-890e` created. Type: feat. Tasks: 63 (45 work tasks + 18 phase-verification checks across 6 phases).
Status: PLANNED. Ready for coder.
