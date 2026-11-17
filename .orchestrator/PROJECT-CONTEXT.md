# Project context — Fiado Fácil

## Project

**Fiado Fácil** (`fiado_facil`) — Android app that replaces the paper fiado notebooks (cadernetas) of a small family grocery ("Mercadinho da Família", Recife-PE) with a shared, offline-first ledger: customers, credit purchases, payments, derived balance, credit-limit alert, WhatsApp statement, owner dashboard. Real product for a real shop; no hard deadline.

<!-- BEGIN context-builder-managed (rewritten on refresh) -->
## Intent

Owner and staff today log credit sales by hand in several notebooks: no single balance, no limit, ~3 nights to close the month, disputes with no proof, estimated 10–15% never collected (hypothesis — source docs are a simulated scenario; real baseline must be measured from the notebooks before the pilot). The app gives every staff member, on their own phone, one shared ledger that works without internet. Full reasoning, success measures, defaults and open decisions: `docs/foundation/INTENT.md`.

## Users

Two roles, one Firebase email/password account each, own Android phone each. **Owner** (dono) = everything + create/deactivate users + CSV export. **Atendente** = everything else (customers, limits, fiado, payments, cancel any entry, deactivate customers, dashboard, statement). Credit customers (~80) never use the app; they receive statements by WhatsApp. Actor table, entity lifecycle, data stores: `docs/foundation/ACTORS.md`.

## Success criteria

Fiado entry ≤ 20 s and ≤ 4 navigation taps (search and amount typing not counted), timed usability test with staff · month-end closing < 30 min · loss rate below measured baseline at 30/60/90 days · paper notebook retired after ~2-week parallel pilot + owner signs acceptance term. Details: `docs/foundation/INTENT.md`.

## Non-goals

No inventory/catalog, POS/fiscal, Pix/bank/card integration, automated collection or WhatsApp Business API, customer app, credit scoring, iOS/web, Google sign-in, Cloud Functions or paid Firebase. Reasons, deferred items, one-way doors: `docs/foundation/NON-GOALS.md`.
<!-- END context-builder-managed -->

## Stack

- Flutter 3.50 (stable) · Dart SDK `^3.14.0` · package manager `flutter pub`.
- UI: `material_ui` (decoupled Material package already in `pubspec.yaml`), design system from `docs/design/` (Atkinson Hyperlegible, bundled — must work offline; light theme only).
- State: Provider / ChangeNotifier. Layered monolith: presentation → domain → data (repository interfaces).
- Backend: Firebase **Spark plan only** — Firebase Auth (email/password) + Cloud Firestore (`southamerica-east1`, offline persistence on). **No Cloud Functions.**
- Packages planned: `firebase_core`, `firebase_auth`, `cloud_firestore`, `provider`, `intl` (pt_BR), `url_launcher` (wa.me statement), `share_plus` (CSV export), `mocktail` (dev).
- Target: Android 8.0+ (API 26), ≥ 2 GB RAM, signed APK (Play Store optional).

## Commands

| Purpose | Whole project | Scoped |
|---|---|---|
| Install deps | `flutter pub get` | — |
| Lint | `flutter analyze` | `flutter analyze lib/<path> test/<path>` |
| Format (check) | `dart format --output=none --set-exit-if-changed lib test integration_test` | `dart format --output=none --set-exit-if-changed <paths>` |
| Format (write) | `dart format lib test integration_test` | `dart format <paths>` |
| Unit/widget tests | `flutter test` | `flutter test test/<path>` |
| Build (debug) | `flutter build apk --debug` | — |
| Build (release) | `flutter build apk --release` | — |
| Firebase emulators | `firebase emulators:start --only auth,firestore` | — |

Phase gate: format check + `flutter analyze` + `flutter test`, scoped to touched paths.

## Test tooling

- Unit/widget: `flutter_test` + `mocktail`. Domain rules (saldo, limit, overdue, statement period) must have unit tests.
- e2e: `integration_test` against the Firebase Emulator Suite on an Android emulator/device: `firebase emulators:exec --only auth,firestore "flutter test integration_test"`.
- Coverage: `flutter test --coverage` → `coverage/lcov.info`.
- Firestore security rules must be tested against the emulator; rules-test harness not yet chosen (decide in the first story that writes `firestore.rules`).

## Layout

Greenfield — only the Flutter template exists (`lib/main.dart`, `test/widget_test.dart`).

- `lib/` — app; planned layer split presentation / domain / data (exact folder names set by first story).
- `test/` — unit/widget tests mirroring `lib/`.
- `integration_test/` — e2e flows (to be created).
- `firestore.rules`, `firestore.indexes.json`, `firebase.json` — repo root (to be created).
- `android/` — Android host (only shipped platform; `ios/ web/ linux/ macos/ windows/` are template leftovers, not targets).
- `docs/foundation/` — source PDFs + context docs. `docs/design/` — screen designs v1.0 (`00-indice` … `09-registrar-pagamento`).

## Conventions

- Dart: `flutter_lints`; files `snake_case.dart`; no business logic in widgets — domain layer owns rules.
- Firestore: collections `usuarios`, `clientes`, `lancamentos`, `pagamentos`; field names Portuguese `snake_case` (`valor_centavos`, `registrado_por`, `acima_do_limite`, `cancelado_por`, `nome_busca`, `limite_credito_centavos`).
- UI copy is **pt-BR**, taken verbatim from `docs/design/*.html` "Textos da tela" tables; screen IDs from the design (`S0`, `A1`, `A3`, `A4`, `T1`, `T1.1`, `T2`, `T3`, `T3.1`).
- Money shown `R$ 1.234,56`; dates `dd/mm/aaaa`; time zone `America/Recife`.

## Invariants

1. Money is an **integer in centavos** everywhere (storage, domain, transport). No `double` for money.
2. **Saldo is never stored.** saldo = Σ non-cancelled `lancamentos` − Σ non-cancelled `pagamentos` for the customer, over all records (history pagination of 30 must not affect it). > 0 "Deve", < 0 "Crédito", = 0 "Sem débito".
3. **Append-only ledger.** Lançamentos and pagamentos are never edited, deleted or reactivated; the only allowed update is cancel (`cancelado=true`, `cancelado_por`), with confirmation. Any active user may cancel any entry.
4. Overpayment is allowed after a warning and leaves credit (negative saldo).
5. Credit limit **warns, never blocks**; a confirmed over-limit purchase is saved with `acima_do_limite=true`. Empty limit = no limit.
6. **Overdue** (em atraso) = saldo > 0 and no non-cancelled payment in the last 30 days. Computed, never stored.
7. A customer with saldo > 0 can be deactivated, never deleted.
8. `registrado_por` / `cancelado_por` = `request.auth.uid`, enforced by Firestore rules.
9. Access requires a `usuarios/{uid}` doc with `ativo=true`; rules deny by default. Only `papel=dono` may create/modify `usuarios` docs and export CSV. Auth sign-up is technically open (client-side account creation on Spark) — an account without an active `usuarios` doc must see nothing.
10. Cloud Firestore is the **only** data store; its offline cache is the only local store. No SQLite, files or second backend.
11. Text fields reject `<` and `>` (client and rules). Personal data limited to nome, telefone, endereço (optional) — never CPF, birth date, income (LGPD minimization).
12. Must work offline for search, customer registration, fiado, payment, cancel and ficha; writes show "Ainda não enviado" until synced. Double taps never create duplicate entries.
13. Spark plan only: no Cloud Functions, no paid features.
14. Accessibility: base text 18sp, saldo 32sp, touch targets ≥ 48dp, primary buttons/fields 56dp, contrast ≥ 4.5:1, works at 200% zoom and with TalkBack, never color alone.
15. Performance: ficha loads ≤ 2 s, save confirms ≤ 1 s on a 2 GB-RAM Android 10 over slow 4G (1.5 Mbps / 300 ms).

## Critical flows

1. Login (email/password), password recovery by email, logout with unsent-records warning (A1, A3, A4, T1).
2. Register fiado: search customer → Fiado → amount (+ optional description) → Salvar fiado, incl. over-limit alert (T1 → T3 → T2).
3. Register payment, partial / total ("Pagou tudo") / overpayment → crédito (T3.1).
4. Cancel a compra or pagamento from history; saldo updates, entry stays struck-through (T3).
5. Send statement: opens WhatsApp chat with the customer via `wa.me/55…` with pre-filled text (T3).
6. Offline: register customer, fiado and payment with no connection; sync on reconnect.
7. Owner creates a user (nome, e-mail, senha inicial) and deactivates a user; deactivated user loses access.
8. New customer with validation (nome, telefone 10–11 dígitos, optional limit) (T1.1).
9. Dashboard: total a receber + overdue list.
10. Owner exports CSV backup via share sheet.

## Out of scope

- Inventory, product catalog, barcode, stock — purchase description stays free text.
- POS, cash sales, NFC-e / fiscal receipts.
- Pix, bank, card-machine integration — payments recorded manually.
- Automated collection, WhatsApp Business API, scheduled messages (statement is sent manually by a person).
- Customer-facing app or portal; credit scoring.
- iOS, web, desktop.
- Google sign-in; shop/shared accounts; PIN operators.
- Cloud Functions, Blaze plan, managed Firestore backups.
- Customer dispute (contestação) records — deferred until pilot shows cancel + audit is not enough.
- Editing or deleting ledger entries.
