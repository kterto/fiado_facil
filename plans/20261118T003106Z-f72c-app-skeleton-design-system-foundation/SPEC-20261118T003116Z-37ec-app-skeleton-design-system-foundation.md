---
id: SPEC-20261118T003116Z-37ec
title: App skeleton and design-system foundation (roadmap story 001.1.1)
status: READY_FOR_PLANNING
created_at: 2026-11-18T00:34:09Z
updated_at: 2026-11-18T00:34:09Z
cycle: 0
related_to: "—"
roadmap_story: 001.1.1
commit_trailer: "Roadmap-Story: 001.1.1"
---

## Summary

This story replaces the Flutter template counter app with the Fiado Fácil app shell. The shell is pt-BR only, portrait only, light theme only, and organized into presentation / domain / data folders. It sets up the design-system foundation that every later screen builds on: the design tokens from `docs/design/*.html` as a Flutter theme, Atkinson Hyperlegible bundled for offline use, a type scale with 18 sp body text, integer-centavos money and America/Recife date helpers, and the reusable widgets from the design's component list. The app launches to a placeholder pt-BR screen. Firebase, auth, navigation and real screens are not part of this story.

## Goals

- Opening the app shows a pt-BR placeholder screen titled "Fiado Fácil", rendered in Atkinson Hyperlegible from bundled assets. No network is needed.
- Every color, spacing, radius and size token in the design's `:root` block exists exactly once in Dart. The Material theme and every reusable widget read from that one source.
- Body text renders at 18 sp and nothing renders below 16 sp.
- Integer centavos format as `R$ 1.234,56` (negative: `-R$ 22,10`). Digit input converts to centavos. Instants format as `dd/mm/aaaa` and `dd/mm` in America/Recife (UTC−03:00). No `double` is involved at any step.
- Later stories reuse the widgets as they are: primary / secondary / text button (with an optional disabled-reason line), TopBar, OfflineBanner, TextField with FieldError, MoneyField, Snackbar helper (4 s), ConfirmDialog.
- `dart format --output=none --set-exit-if-changed lib test`, `flutter analyze` and `flutter test` pass.

## Non-goals

- Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`), emulators, `firestore.rules`, `integration_test/`: story 001.1.2.
- Login, session check, splash (S0) logic, navigation/routing between real screens, any real screen (A1, A3, A4, T1, T1.1, T2, T3, T3.1).
- Connectivity detection or sync-state tracking. OfflineBanner is a presentational widget only, and nothing in this story decides when to show it.
- Domain rules (saldo, limit check, overdue, statement text), entities, repositories. `lib/domain/` gets only the format helpers. `lib/data/` is created empty.
- Any `ChangeNotifier`/`Provider` wiring. `provider` is added as a dependency only.
- App icon, Android 12 system splash, release signing, Play Store metadata.
- Removing template platform folders (`ios/`, `web/`, `linux/`, `macos/`, `windows/`) or the `cupertino_icons` dependency.
- Dark theme, landscape, any locale other than `pt_BR` (PROJECT-CONTEXT Stack: light theme only; Android only).
- Out-of-scope items from PROJECT-CONTEXT (inventory, POS, Pix, iOS/web, Cloud Functions, …): none are touched.

## Users and use cases

- **Dono and Atendente** (ACTORS.md): they open the app on their own Android phone and see the Fiado Fácil placeholder in large, legible, high-contrast pt-BR type. In this story, success means the shell launches offline with the correct font, colors and sizes.
- **Developers / later pipeline runs** (indirect): they build each later screen from the tokens, type scale, helpers and widgets delivered here and do not redefine any of them.

## Functional requirements

### FR-1 App shell and structure

1. `lib/main.dart` contains no counter-template code. It locks orientation to `DeviceOrientation.portraitUp` via `SystemChrome.setPreferredOrientations` and then runs the app widget.
2. The root app widget is a `MaterialApp` (from `package:material_ui/material_ui.dart`, the package the project already uses). It is configured with `title: 'Fiado Fácil'`, `locale: Locale('pt', 'BR')`, `supportedLocales: [Locale('pt', 'BR')]`, the localization delegates needed for pt-BR Material/Widgets/Cupertino strings, `theme:` the app theme from FR-3, no `darkTheme`, `themeMode: ThemeMode.light`, and `debugShowCheckedModeBanner: false`.
3. The Android launcher label (`android:label` in `android/app/src/main/AndroidManifest.xml`) is `Fiado Fácil`. The main activity declares `android:screenOrientation="portrait"`.
4. `pubspec.yaml` adds `provider`, `intl` and `flutter_localizations` (`sdk: flutter`). Versions must resolve with `material_ui` 1.11.x, which itself requires `intl ^0.20.2` and `flutter_localizations`. The pubspec `description` becomes a short pt-BR or English product description in place of "A new Flutter project.".
5. The layered folders are (see Decisions):
   - `lib/main.dart`: bootstrap only.
   - `lib/app.dart`: the root `MaterialApp` widget.
   - `lib/ui/theme/`: tokens and `ThemeData`.
   - `lib/ui/widgets/`: reusable components.
   - `lib/ui/screens/`: screens. This story adds the placeholder home only.
   - `lib/domain/format/`: money and date helpers.
   - `lib/data/`: created empty, kept in git with a `.gitkeep`.
   - `test/` mirrors `lib/`.
6. The `## Layout` section of `.orchestrator/PROJECT-CONTEXT.md` is updated to list the chosen folders: replace the "planned layer split … (exact folder names set by first story)" line with the real folder list. The `## Conventions` money line gains the negative form `-R$ 22,10`. No other PROJECT-CONTEXT content is deleted or rewritten.

### FR-2 Design tokens (single source of truth)

1. Colors are Dart constants equal to the design `:root` values: `bg #f7f5f1`, `surface #ffffff`, `textPrimary #1c1b1a`, `textSecondary #4f4b45`, `border #7a746b`, `divider #e3dfd8`, `primary #1e6b43`, `primaryPressed #17573a`, `onPrimary #ffffff`, `primaryContainer #e6f2ea`, `warningContainer #fff3d6`, `onWarning #6b4500`, `error #b3261e`, `errorContainer #fdecea`, `info #1e4e8c`, `infoContainer #e8f0fb`, `focus #1e6b43`, `disabledBg #d9d5ce`, `scrim #1c1b1a` at alpha `0x66` (40 %). The brief lists 16 colors; `onPrimary`, `focus` and `scrim` are also in the design's `:root`, and the widgets need them.
2. Spacing: `space1..space8` = 4, 8, 12, 16, 20, 24, 32, 40.
3. Radii: `sm 8`, `md 12`, `lg 16`.
4. Sizes: `touchMin 48`, `buttonHeight 56`, `fieldHeight 56`, `amountFieldHeight 72`, `listItemMin 64`, `topBarHeight 64`.
5. Dialog shadow: `0 4 16` (offset y 4, blur 16), color `textPrimary` at 18 % opacity.
6. Each token value is defined exactly once. Theme and widgets reference the constants and never repeat the literal hex or number.

### FR-3 Theme and typography

1. Atkinson Hyperlegible **Regular (400)** and **Bold (700)** TTFs are committed under `assets/fonts/` together with the font's `OFL.txt` licence. They are registered in `pubspec.yaml` as one family (e.g. `AtkinsonHyperlegible`) with weights 400 and 700. No runtime font download (`google_fonts` or similar) is used.
2. The type scale is one set of `TextStyle`s in the bundled family:

   | Style | Size / line height | Weight | Notes |
   |---|---|---|---|
   | balance | 32 / 40 | 700 | tabular figures |
   | amountInput | 28 / 36 | 700 | tabular figures |
   | title | 22 / 28 | 700 | |
   | label | 18 / 24 | 700 | |
   | body | 18 / 26 | 400 | base text |
   | meta | 16 / 22 | 400 | smallest size allowed |

   Line height is expressed as `height = lineHeight / fontSize`. "Tabular figures" means `FontFeature.tabularFigures()`. If the font has no `tnum` feature this has no effect, which is acceptable.
3. Mapping from design sizes to app sizes: every design element at 16 px (`type-body`, e.g. OfflineBanner text, FieldError text, Snackbar text) uses **body 18/26**. Every element at 15 px (`type-meta`, e.g. disabled-reason line, TopBar user name, field counter) uses **meta 16/22**. Every 18 px / 22 px / 28 px / 32 px element keeps its design style. The money prefix "R$" (design 22/28 bold, secondary color) uses `title` in `textSecondary`.
4. `ThemeData` uses Material 3 with the bundled font family as default. `scaffoldBackgroundColor` = `bg`. `ColorScheme` maps: primary→`primary`, onPrimary→`onPrimary`, primaryContainer→`primaryContainer`, onPrimaryContainer→`textPrimary`, surface→`surface`, onSurface→`textPrimary`, onSurfaceVariant→`textSecondary`, outline→`border`, outlineVariant→`divider`, error→`error`, onError→`onPrimary`, errorContainer→`errorContainer`, onErrorContainer→`error`, scrim→`scrim`. Tokens with no `ColorScheme` slot (warning, info, disabled, primaryPressed, focus) are read straight from the token constants, or through a `ThemeExtension` if the architect prefers. The source stays single either way.
5. The theme's `textTheme` uses body 18/26 as its default body style (`bodyLarge`/`bodyMedium`). No `textTheme` entry the app uses has a font size below 16.

### FR-4 Formatting helpers (`lib/domain/format/`), pure functions, no `double`

1. **Money → text.** `int centavos` → `R$ <reais>,<cc>`. Reais use `.` as the thousands separator, and there is always a two-digit centavos part with `,` as the decimal separator. Only integer arithmetic is used: no `NumberFormat` on a `double`, no division producing `double`.
   - `0 → "R$ 0,00"`, `5 → "R$ 0,05"`, `123456 → "R$ 1.234,56"`, `9999999 → "R$ 99.999,99"`, `100000000 → "R$ 1.000.000,00"`.
   - Negative values get a leading ASCII hyphen-minus before `R$`: `-2210 → "-R$ 22,10"`. This form is documented in PROJECT-CONTEXT Conventions (FR-1.6).
   - The space between `R$` and the digits is a regular space (U+0020). Tests assert exact strings.
2. **Digits → centavos.** A string of ASCII digits is read as centavos, filling from the right as in the design ("4790 vira 47,90"): `"" → 0`, `"5" → 5`, `"4790" → 4790`, `"0047" → 47`. Any non-digit character is a `FormatException`. The helper does not clamp. The maximum is enforced by MoneyField (FR-5.5).
3. **Max amount constant.** `9999999` centavos (R$ 99.999,99), the design's "máximo R$ 99.999,99" and the ACTORS.md lançamento limit, is exposed as a named constant.
4. **Dates.** Given any `DateTime` instant (UTC or local), the helpers convert it to America/Recife wall time as `instant.toUtc()` minus 3 hours (fixed UTC−03:00, no DST, no tz database) and format:
   - `dd/mm/aaaa` → e.g. `DateTime.utc(2026, 11, 18, 2, 0)` → `"17/11/2026"`, and `DateTime.utc(2026, 11, 18, 3, 0)` → `"18/11/2026"` (the day boundary falls at 03:00 UTC).
   - `dd/mm` → e.g. `DateTime.utc(2026, 1, 1, 2, 59)` → `"31/12"`.
   - Day and month are always zero-padded to two digits.
5. Unit tests cover every example above. They also include the acceptance cases `0`, `123456`, `9999999`, `-2210` and the Recife day-boundary cases.

### FR-5 Reusable widgets (`lib/ui/widgets/`)

All widgets take their colors, sizes and text styles from FR-2 and FR-3. Copy is supplied by the caller, except the OfflineBanner's fixed design copy. Decorative icons are excluded from semantics. Icons come from the bundled Material Icons font (`Icons.*`, rounded variants where they exist, matching the design's Material Symbols Rounded names) and must render offline.

1. **Buttons (`primary`, `secondary`, `text`)**
   - Primary/secondary: full width, `minHeight 56` (the button grows with text scale and never clips), radius `md 12`, horizontal padding 16, label style `label` 18/24 bold, optional leading icon 24 with gap 8.
   - Primary: `primary` bg, `onPrimary` fg, `primaryPressed` bg while pressed.
   - Secondary: `surface` bg, `primary` fg, 1 px `primary` border.
   - Text: no bg, `primary` fg, `minHeight 48`, intrinsic width, horizontal padding 8.
   - Disabled (any variant, `onPressed == null`): `disabledBg` bg, `textSecondary` fg, `disabledBg` border. If the caller passes `disabledReason`, that line renders below the button in `meta` 16/22 `textSecondary`, but only while the button is disabled.
   - Focus: 2 px `focus` outline.
   - Every variant's tappable area is ≥ 48×48 dp.
2. **TopBar**
   - `minHeight 64`, `bg` background.
   - Title in `title` 22/28 bold.
   - Optional back action: arrow-back icon with the text "Voltar", as a text button. When present the left padding is 4, otherwise 16. The right padding is 8.
   - Optional trailing area for actions (e.g. user name in `meta` + a text button).
   - Implemented as a `PreferredSizeWidget` usable as `Scaffold.appBar`.
3. **OfflineBanner**
   - Two modes with verbatim design copy:
     - `offline`: icon `cloud_off`, text "Sem internet. Pode continuar usando: os dados serão enviados depois."
     - `sending`: icon `cloud_upload`, text "Enviando dados..."
   - `infoContainer` bg, icon in `info`, text `body` 18/26 `textPrimary`, `minHeight 48`, padding 8 vertical / 16 horizontal, gap 12.
   - Exposed to TalkBack as a live region (design `role="status"`).
   - No visibility logic: the parent decides when to show it.
4. **TextField + FieldError**
   - A labelled field: permanent label above the input in `label` 18/24 bold. The optional suffix (e.g. "(opcional)") is in regular weight `textSecondary`. Gap 8.
   - Input box: `minHeight 56`, `surface` bg, radius `sm 8`, horizontal padding 12, text `body` 18/26.
   - Border: 1 px `border` idle, 2 px `primary` focused, 2 px `error` when an error message is present.
   - Optional leading icon in `border` color, optional placeholder in `textSecondary`, optional character counter `n/max` right-aligned in `meta`.
   - Caller-chosen `keyboardType`, `textCapitalization`, `inputFormatters`.
   - The text-field widget rejects the characters `<` and `>` at input (PROJECT-CONTEXT invariant 11) through a built-in input formatter, so every text field inherits the rule.
   - **FieldError** renders below the field: `error` icon (20) + message in `body` 18/26 `error` color, gap 8. TalkBack announces it (design `role="alert"`). It is never shown by color alone: the icon and text are always present.
5. **MoneyField**
   - A labelled field like 4 but with `minHeight 72`, `R$` prefix (`title` style, `textSecondary`), and the value right-aligned in `amountInput` 28/36 bold with tabular figures.
   - Numeric keyboard (`TextInputType.number`). Input accepts digits only and fills from the right using FR-4.2. The display shows the formatted value without the `R$` (e.g. `1.234,56`).
   - Exposes `int? centavos`: `null` when nothing has been typed (placeholder `0,00` in `textSecondary`), otherwise the integer value. Deleting all digits returns to `null`.
   - A keystroke that would push the value above the FR-4.3 max (9.999.999) is ignored, and the previous value stays.
   - Supports FieldError like 4.
6. **Snackbar helper**
   - A function (e.g. `showAppSnackbar(context, message)`) that hides any current snackbar and then shows a floating snackbar for exactly **4 s**.
   - Style: `primaryContainer` bg, radius `md 12`, padding 12 vertical / 16 horizontal, leading `check_circle` icon in `primary`, message in `body` 18/26 `textPrimary`, dialog shadow.
7. **ConfirmDialog**
   - The design's LimitAlert layout: radius `lg 16`, 2 px border, padding 24 top / 20 sides / 20 bottom, gap 12, dialog shadow.
   - Head row: icon 32 + title in `title` 22/28 bold, gap 8.
   - Body: `body` 18/26 `textPrimary`.
   - Actions stacked vertically with gap 8 (top margin 8): primary button (confirm) above secondary button (dismiss), both full width, 56 high.
   - Background scrim is `scrim` (40 %).
   - Tone `neutral` (default, design `.ff-dialog`): `surface` bg, `border` border, icon in `primary`, title in `textPrimary`.
   - Tone `warning` (design LimitAlert, needed by T2 later): `warningContainer` bg, `onWarning` border, icon and title in `onWarning`.
   - A show helper returns `Future<bool>`: `true` when confirm is tapped, `false` on dismiss, scrim tap or system back.
   - Exposed to TalkBack as an alert dialog with the title as its label.

### FR-6 Placeholder home screen

1. A `Scaffold` on `bg` with the TopBar titled "Fiado Fácil".
2. The body is centered and shows the two lines copied verbatim from design S0 state B: "A caderneta do fiado" (`body`) and "Mercadinho da Família" (`meta`, `textSecondary`). No other copy is invented.
3. No interactive elements. This screen is replaced when auth/navigation stories land.

### FR-7 Tests

1. `test/widget_test.dart` is rewritten. It pumps the root app and asserts:
   - "Fiado Fácil" and "A caderneta do fiado" are found;
   - the counter template is absent ("0", the `+` FAB);
   - `MaterialApp.locale` is `pt_BR`;
   - the resolved default text style's `fontFamily` is the bundled family at size 18.
2. A test asserts that the font assets declared in `pubspec.yaml` load from the asset bundle (e.g. `rootBundle.load` of each TTF succeeds) and that `OFL.txt` exists in the repo.
3. A token test asserts every FR-2 constant equals its design value, and the `ThemeData`/`ColorScheme` mapping of FR-3.4. A typography test asserts every FR-3.2 style's size, weight and height, and that none is below 16.
4. Unit tests for FR-4 as listed in FR-4.5.
5. Widget tests render each FR-5 widget and assert:
   - each button variant's tappable size is ≥ 48 dp, and primary/secondary height is exactly 56 at text scale 1.0;
   - the disabled-reason line shows only when the button is disabled;
   - OfflineBanner shows the exact copy for each mode;
   - TextField strips `<`/`>`, and FieldError shows its icon and message;
   - MoneyField fills from the right, returns `null` when empty, ignores a keystroke above the max, and shows the `R$` prefix;
   - the snackbar duration is 4 s;
   - ConfirmDialog returns `true`/`false` for confirm/dismiss, and the two tones use their token backgrounds.
6. An accessibility smoke test pumps the placeholder screen and one of each button variant at `TextScaler.linear(2.0)`. It asserts no overflow/layout exception (invariant 14: works at 200 % zoom).
7. Gate: `dart format --output=none --set-exit-if-changed lib test`, `flutter analyze` (zero issues) and `flutter test` all pass.

## Non-functional requirements

- **Performance**: no runtime font or network fetch. The app starts from bundled assets only. No other budget for this story (invariant 15 applies to the ficha/save flows later).
- **Security / auth**: no auth in this story. The text-field widget enforces the `<`/`>` rejection (invariant 11) at input.
- **Localization**: pt-BR only (`pt_BR`). Money is `R$ 1.234,56`, negative `-R$ 22,10`. Dates are `dd/mm/aaaa` / `dd/mm` in America/Recife, fixed UTC−03:00. All visible copy is pt-BR and taken from `docs/design/*.html` where it exists.
- **Accessibility**: invariant 14 applies.
  - Base text 18 sp, nothing below 16 sp, saldo style 32 sp.
  - Touch targets ≥ 48 dp; primary/secondary buttons and fields 56 dp; amount field 72 dp.
  - Design colors keep contrast ≥ 4.5:1.
  - Layouts use min-heights so they grow at 200 % text scale.
  - Decorative icons are excluded from semantics. Errors and banners are announced and never conveyed by color alone.
- **Geospatial / geofence**: —
- **Trust / moderation**: —
- **Privacy / compliance**: no user data is introduced. The OFL licence text of the bundled font ships in the repo (`assets/fonts/OFL.txt`).
- **Monetization tier**: — (Spark-only project; no paid dependencies).

## Project-context fit

- **Layers touched**: presentation (`lib/ui/`: theme, widgets, placeholder screen), domain (`lib/domain/format/`), data (empty folder), app root, Android manifest, `pubspec.yaml`, `assets/fonts/`, PROJECT-CONTEXT Layout/Conventions.
- **Dependencies**: none. This is the first story (`depends_on: []`). Story 001.1.2 (Firebase wiring) depends on it.
- **Invariants that shape it**:
  - 1 (money is integer centavos; the formatter and MoneyField never use `double`);
  - 11 (`<`/`>` rejected at text input);
  - 12 (offline: bundled font and icons, OfflineBanner copy ready);
  - 14 (accessibility sizes, 18 sp base);
  - 10 (no local store is introduced).
  - Conventions: pt-BR copy verbatim from design, Recife time zone, `snake_case.dart`, `flutter_lints`, no business logic in widgets.
- **Conflicts**: none.
  - The brief's "nothing below 16" overrides the design's 15 px meta and the 16 px "body" (the product owner's decision recorded in INTENT.md: "Base text 18sp (design's 16/15 raised)").
  - The brief overrides the design's Material Symbols web font: icons come from Flutter's bundled Material Icons so they work offline.
- **Technical note for the architect**: `material_ui` 1.11.1 re-exports `package:flutter/widgets.dart` and ships its own `GlobalMaterialLocalizations` (with `delegates`, including `pt`). `flutter_localizations` also defines Material localizations against `package:flutter/material.dart`. Check for a name clash or duplicate-delegate issue when wiring `localizationsDelegates`, and import with `show`/`hide` as needed. Prefer `material_ui`'s `GlobalMaterialLocalizations.delegates` if it already covers Widgets/Cupertino.
- **Open product decisions it depends on**: none. The open decisions in INTENT.md (customer reactivation, missing screens' design, rules-test harness) do not touch this story.

## Affected surface

- **Backend**: —
- **Frontend / mobile**:
  - `lib/main.dart` (rewritten), `lib/app.dart` (new);
  - `lib/ui/theme/*` (tokens, typography, theme);
  - `lib/ui/widgets/*` (buttons, top bar, offline banner, text field + field error, money field, snackbar helper, confirm dialog);
  - `lib/ui/screens/home_screen.dart` (placeholder);
  - `lib/domain/format/*` (money, digits→centavos, dates);
  - `lib/data/.gitkeep`;
  - `assets/fonts/AtkinsonHyperlegible-Regular.ttf`, `AtkinsonHyperlegible-Bold.ttf`, `OFL.txt`;
  - `pubspec.yaml` (deps, fonts, description);
  - `android/app/src/main/AndroidManifest.xml` (label, portrait);
  - `test/widget_test.dart` (rewritten) plus new tests mirroring `lib/`;
  - `.orchestrator/PROJECT-CONTEXT.md` (Layout section; Conventions money line).
- **Admin**: —
- **Shared**: —

## Open questions

- None.

## Decisions resolved by Brainstormer default

Mode was `autonomous`. Each item below is a default the architect can audit. None is a reserved decision: the font, its licence, the locale, the title, the light-only theme and the folder-naming choice were all explicitly set or delegated by the confirmed story brief.

- Folder names ("pick concise folder names", delegated by the brief) → `lib/ui/{theme,widgets,screens}`, `lib/domain/format`, `lib/data` (`.gitkeep`), `lib/app.dart` → short, maps 1:1 to presentation/domain/data, and an empty `data/` still makes the layer visible in git.
- Where the format helpers live → `lib/domain/format/` → the statement (extrato) text, a domain concern, will need the same money/date formatting. Putting the helpers in `ui/` would make domain depend on presentation.
- Negative money form → `-R$ 22,10` (ASCII hyphen-minus, sign before `R$`) → it is the form the acceptance criteria name. The design's labels ("Crédito de R$ 22,10", "− R$ 100,00" in history) are per-screen presentation built on the absolute value later.
- Money formatting implementation → pure integer arithmetic, no `NumberFormat`/`double` → invariant 1. It also avoids the intl locale-data dependency.
- Digits→centavos on non-digit input → throw `FormatException`; no clamping in the helper → the helper's contract is "digits only". MoneyField already filters input, so a non-digit there is a programming error that should surface.
- MoneyField max handling → ignore the keystroke that would exceed R$ 99.999,99 → the design says "máximo R$ 99.999,99" with right-to-left fill, and ignoring the extra digit is the least surprising cash-register behavior. No error copy exists in the design for it.
- MoneyField empty value → `null` (placeholder `0,00`) → T1.1 needs "vazio = sem limite" to differ from an explicit 0, and T2/T3.1 treat null and 0 the same.
- MoneyField input method → system numeric keyboard (`TextInputType.number`) → design 06/08 say "teclado numérico". The keypad drawn in T2/T3.1 depicts the phone's numeric keyboard, not a custom widget.
- Design 16 px and 15 px text → map to body 18/26 and meta 16/22 respectively → this is the mechanical reading of the brief ("body text is 18 (design's 16 raised) and nothing renders below 16"). It applies to banner, error, snackbar, disabled-reason, counter and user-name text.
- Date conversion → fixed offset (`toUtc()` − 3 h) with no timezone package → the brief states "fixed UTC−03:00, no DST". Recife has observed no DST since 2019, and a tz database adds weight for no gain.
- Font source and files → original **Atkinson Hyperlegible** (not "Atkinson Hyperlegible Next") Regular + Bold TTF from the Google Fonts `ofl/atkinsonhyperlegible` set, with its `OFL.txt` → the design's `--font-sans` names "Atkinson Hyperlegible", and the brief asks for 400/700 + OFL. Italic is not bundled because the design uses none.
- Icons → Flutter's bundled `Icons.*` (rounded variants) instead of the Material Symbols web font → it must work offline and needs no new dependency. The design's symbol names have direct `Icons` equivalents (`cloud_off`, `cloud_upload`, `error`, `check_circle`, `arrow_back`, `warning`, `block`).
- ConfirmDialog tones → `neutral` (default, surface) plus `warning` (LimitAlert colors) in one widget → the brief asks for the LimitAlert layout on surface. Exposing the warning tone costs one parameter and saves T2 from re-implementing the same layout. Its copy and trigger stay out of scope.
- ConfirmDialog result → `Future<bool>`, with scrim tap / back = `false` → this is the safest reading of the design's "Manter compra" / "Voltar" dismiss semantics.
- Snackbar stacking → hide the current snackbar before showing a new one → consecutive confirmations (save, then cancel) should not queue behind each other for 8+ s.
- OfflineBanner modes → `offline` and `sending` with verbatim copy, no visibility logic → design 05 shows both states. Connectivity/sync detection belongs to the Firebase/offline stories.
- `<`/`>` rejection → built into the text-field widget's input formatter → invariant 11 applies to every text field, so the shared widget is the one place to enforce it on the client.
- Provider → dependency added, no `MultiProvider` wiring yet → there is no `ChangeNotifier` to provide. `MultiProvider` with an empty list is invalid, and wiring belongs with the first stateful feature.
- Placeholder copy → "Fiado Fácil" (TopBar), "A caderneta do fiado", "Mercadinho da Família", verbatim from design S0 state B → this follows the convention that UI copy comes verbatim from the design, and no copy is invented.
- Orientation → `portraitUp` only, via `SystemChrome` plus manifest `screenOrientation="portrait"` → the brief says portrait. The design canvas is 360×800 portrait.
- Android launcher label → `Fiado Fácil` → the brief sets the app title. The template label `fiado_facil` is user-visible on the home screen.
- 200 % text-scale smoke test → included → invariant 14 requires it, and it is cheap to check here, where the min-height-not-fixed-height rule for all components is set.
- `cupertino_icons` and template platform folders → left untouched → cleanup is not in the brief and is unrelated to the shell.

## References

- Story brief (source of truth): `roadmap/001-foundation/001.1-scaffold/001.1.1-app-skeleton.md`
- Next story: `roadmap/001-foundation/001.1-scaffold/001.1.2-firebase-emulators.md`
- `.orchestrator/PROJECT-CONTEXT.md`: Stack, Layout, Conventions, Invariants 1, 10, 11, 12, 14
- `docs/foundation/INTENT.md`: "Base text 18sp (design's 16/15 raised)" decision
- `docs/foundation/ACTORS.md`: lançamento `valor_centavos ≤ 9.999.999`
- Design tokens and components: `docs/design/00-indice.html` (`:root` block, `.ff-*` component CSS; identical across all `docs/design/*.html`)
- Component behavior and copy: `docs/design/01-splash.html` (S0 copy), `05-lista-clientes.html` (TopBar, OfflineBanner modes), `06-novo-cliente.html` (fields, limit MoneyField), `07-ficha-cliente.html` (ConfirmDialog `.ff-dialog`, Snackbar 4 s), `08-novo-fiado.html` (MoneyField right-to-left fill, max, LimitAlert)
- `material_ui` 1.11.1 localizations: `<pub-cache>/hosted/pub.dev/material_ui-1.11.1/lib/src/global_material_localizations.dart`
- Prior-art skim: no SPEC/FEAT/PACT artifacts exist under `plans/` (first run in this project)
