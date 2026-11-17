# Intent

<!-- Written by context-builder on 2026-11-17. Linked from PROJECT-CONTEXT.md's `## Intent` heading,
     which holds the one-paragraph rule; this file holds the reasoning.
     Every claim ends with `source: <document path | interview>`.
     EP1 = docs/foundation/Projeto de software - pratica .pdf
     EP2 = docs/foundation/Mercadinho da familia pratica .pdf
     DESIGN = docs/design/*.html (v1.0, 17/11/2026)
     Precedence chosen by the user: EP2 is the base, EP1 fills gaps; interview overrides both. -->

## Problem

A family grocery in Zona Norte, Recife-PE (~12 years open, ~600 products, 4 staff) records credit sales (fiado) by hand in several notebooks at once, by different people, with no fixed format and no credit limit. source: EP1 p.3–4, p.6; EP2 p.5

Consequences: no single balance per customer; month-end closing takes the owner ~3 nights and "sempre dá diferença"; customers dispute amounts and there is no proof; ~30% of entries omit the items; logging takes 1–2 min and causes queues; the owner falls back on the overdraft (cheque especial) because receivables are unknown; an estimated 10–15% of credit sales are never collected. source: EP1 p.4, p.6; EP2 p.5, p.19, p.29

**Caveat:** both PDFs state the scenario is simulated — personas, quotes and numbers are plausible hypotheses, not measurements. The user confirmed the real shop's profile is "close enough", so the numbers are working estimates to re-measure. source: EP1 p.16; EP2 p.39, p.45; interview (turn 2)

A previous POS program was tried and abandoned: expensive and had no fiado. source: EP1 p.6

## Who has it

- The owner (dono) — closes the month, chases customers at night from home, carries the loss. source: EP1 p.7; EP2 p.5
- The counter staff (atendentes) — log sales under queue pressure; two of the four have low tech literacy (small text and complex menus are barriers). source: EP1 p.7; EP2 p.5
- ~80 credit customers (mostly elderly, low-income or informal workers) who settle on payday or benefit day and dispute amounts they cannot verify. source: EP1 p.4, p.7
- Each staff member and the owner use **their own Android phone**. source: interview (validation page, section 1 correction; turn 7)

## Vision

Every staff member, on their own phone, logs a fiado or a payment in a few seconds even without internet; every customer has one balance everyone trusts; the owner sees at any time how much is receivable and who is overdue, closes the month in minutes, and sends a customer an exact statement on WhatsApp in one tap. The paper notebook is retired. source: EP1 p.6, p.9; EP2 p.19–21; interview

## Success criteria

| Criterion | How it is measured | source |
|---|---|---|
| Register a fiado in ≤ 20 s with ≤ 4 taps | Timed usability test with the staff; taps counted are navigation only (customer → Fiado → Salvar fiado …), search and amount digits excluded. No in-app telemetry. | EP2 p.19; interview (turn 5, C7) |
| Month-end closing < 30 min (from ~3 nights) | Owner self-report after the pilot | EP1 p.13; interview (turn 5) |
| Loss rate below the measured baseline | (amount overdue > 30 days and unpaid) ÷ (credit sales in period), at 30, 60 and 90 days after go-live, computed from app data. Baseline first measured from the paper notebooks before the pilot. | EP1 p.13; interview (turn 5) |
| Paper notebook retired | ~2-week pilot in parallel with the notebook, then notebook abandoned and owner signs the acceptance term (termo de aceite) | EP1 p.7, p.12; EP2 p.9; interview (turn 5) |

## Decisions resolved by default

Locked by context-builder as stated defaults on 2026-11-17 and accepted in the user's confirmation; they are not user-stated requirements.

- Statement (extrato) content: current saldo + non-cancelled purchases and payments since the last time the balance was zero. source: interview (restatement, accepted)
- Ficha computes saldo from all of the customer's records; history is paginated 30 at a time and does not affect the saldo. source: interview (restatement, accepted); EP2 p.27
- Test tooling: `flutter_test` + `mocktail` (unit/widget), `integration_test` (e2e), Firebase Emulator Suite. source: interview (restatement, accepted); EP2 p.18, p.27

Earlier defaults **withdrawn** by the user's corrections (do not resurrect): same-day cancel window for atendentes; atendentes register customers without a limit; owner-only customer deactivation; logout blocked while writes are pending. source: interview (validation page, turn 7)

## Decisions made by the user

- Real product for a real shop (not only coursework). source: interview (turn 1)
- EP2 is the base spec; EP1 fills gaps. source: interview (turn 1)
- No hard deadline; the EP1 schedule (ending 2026-11-17) is historical. source: interview (turn 1)
- Firebase Spark plan only — strictly free, no Cloud Functions. source: interview (turn 3)
- Android only; every user's phone is Android. source: interview (turns 3, 8)
- One Firebase email/password account per person; no shop account, no PIN, no Google sign-in. source: interview (validation C1-B, C2-A)
- Owner creates users in the app (client-side account creation + `usuarios` doc gating access); deactivation via `ativo=false`. source: interview (turn 8)
- Owner-only: create/deactivate users, CSV export. Everything else is open to every active user. source: interview (validation C4-B + section 2 correction)
- Backup = owner CSV export via share sheet; ledger is append-only. source: interview (turn 4)
- LGPD: minimize (nome, telefone, endereço optional; no CPF/birth date/income), retain for history, no in-app consent flow. source: interview (turn 5); EP2 p.17, p.23
- RF09 (limit alert) and RF10 (dashboard) are in the MVP; dispute logging deferred. source: interview (turn 5)
- Logout on any phone, as in design 05: warns about unsent records, allows "Sair mesmo assim", wipes local data. source: interview (validation C3-B)
- Base text 18sp (design's 16/15 raised). source: interview (validation C5-A); EP2 p.30
- Statement opens the customer's WhatsApp chat via `wa.me` with pre-filled text; a person still taps send. source: interview (validation C6-B)

## Open product decisions

| Decision | Who decides | source |
|---|---|---|
| Can a deactivated customer be reactivated? | user (product owner) | interview (validation page, section 6) |
| Real loss-rate baseline, measured from the notebooks before the pilot | shop owner | interview (turn 5) |
| Design of the missing screens: user management (create/deactivate), owner/all dashboard, edit customer (limit, deactivate), CSV export, statement preview; and removal of Google button from design 02 | user (design) | DESIGN vs interview (validation page) |
| Firestore rules-test harness | first story that writes `firestore.rules` | context-builder (gap) |
