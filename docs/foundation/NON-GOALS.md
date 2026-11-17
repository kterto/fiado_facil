# Non-goals

<!-- Written by context-builder on 2026-11-17. Linked from PROJECT-CONTEXT.md's `## Non-goals` heading.
     Every claim ends with `source: <document path | interview>`.
     EP1 = docs/foundation/Projeto de software - pratica .pdf
     EP2 = docs/foundation/Mercadinho da familia pratica .pdf -->

## Non-goals

| Not doing | Why it is out | source |
|---|---|---|
| Inventory, product catalog (~600 items), barcode, stock deduction | The problem is the credit ledger, not stock; description stays free text | EP1 p.11; EP2 p.6, p.17 |
| POS, cash sales, NFC-e / fiscal receipts | A POS was already tried and abandoned (cost, no fiado) | EP1 p.6, p.11; EP2 p.10 |
| Pix, bank, card-machine integration | Payments are recorded manually; integration costs and adds scope | EP1 p.11; EP2 p.10 |
| Automated collection, WhatsApp Business API, scheduled messages | Requires LGPD consent and paid API; statement is sent by a person | EP1 p.11; EP2 p.19 |
| Customer app/portal, credit scoring | Customers are indirect beneficiaries; outside the problem | EP1 p.11 |
| iOS, web, desktop | Every user has an Android phone; web needs constant connection; no computer in the shop | EP1 p.9; EP2 p.27; interview (turn 8) |
| Google sign-in | Not needed with per-person email/password accounts | interview (validation C2-A) |
| Shared shop account / per-operator PIN | Each person has their own phone and account | interview (validation C1-B, section 1) |
| Cloud Functions, Blaze plan, managed Firestore backups | Cost must be zero (Spark only) | EP1 p.6; interview (turn 3) |
| Editing or deleting ledger entries | Trust and dispute evidence: only cancel, audited | EP2 p.20–21 |
| Collecting CPF, birth date, income | LGPD data minimization | EP2 p.17, p.23; interview (turn 5) |
| In-app consent flow | User decided minimize + retain without consent screen | interview (turn 5) |

## Deferred

| Deferred | Condition that brings it back | source |
|---|---|---|
| Customer dispute (contestação) records | Pilot shows cancel + audit trail is not enough to settle disputes | EP1 p.13; interview (turn 5) |
| iOS | A user of the app gets an iPhone | interview (turn 8) |
| Monthly closing snapshot / stored balances | Saldo computation over all records breaches the ≤ 2 s ficha target on real data | EP2 p.27 |

## One-way doors

- **Firestore region `southamerica-east1`** — cannot be changed after project creation; moving means a new project and data migration. source: EP2 p.13
- **Account model: one Firebase Auth account per person + `usuarios` doc gating, client-side user creation on Spark** — `registrado_por` history is tied to Auth UIDs; switching to shared/PIN accounts later breaks attribution. Auth sign-up stays open, so rules must always gate on `usuarios.ativo`. source: interview (turn 8, validation C1-B)
- **Integer centavos + Portuguese snake_case field names in Firestore** — schema changes require migrating every document on every device cache. source: EP2 p.13, p.15
- **Append-only ledger with derived saldo** — once real entries exist, introducing edits or stored balances changes the audit guarantees customers were promised. source: EP2 p.15, p.20–21
