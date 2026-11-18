# Actors and domain

<!-- Written by context-builder on 2026-11-17. Linked from PROJECT-CONTEXT.md's `## Users` heading.
     Every claim ends with `source: <document path | interview>`.
     EP1 = docs/foundation/Projeto de software - pratica .pdf
     EP2 = docs/foundation/Mercadinho da familia pratica .pdf
     DESIGN = docs/design/*.html -->

## Actors

| Actor | May do | May never do | source |
|---|---|---|---|
| Dono (owner) — persona José Carlos, 58 | Everything an atendente may do; create users in-app (nome, e-mail, senha inicial); deactivate users (`ativo=false`); export CSV backup | Delete or edit ledger entries; collect CPF, birth date or income | interview (turn 8, validation C4 + section 2); EP2 p.15, p.23 |
| Atendente — personas Márcia 54, Lucas 24, caixa 30 | Log in on own phone; register/edit/deactivate customers; set or change credit limits; record fiado and payments; cancel any entry (audited); view ficha, history, dashboard; send statement | Create or deactivate users; export CSV; delete or edit ledger entries; access without an active `usuarios` doc | interview (validation C1-B, C4-B, section 2); EP2 p.20–21 |
| Account without active `usuarios` doc (self-signed-up or deactivated) | Nothing beyond the login screen | Read or write any collection | interview (turn 8) |
| Cliente do fiado (~80; indirect) | Receive a plain-text statement on WhatsApp | Use the app; log in; any portal | EP1 p.7, p.11; EP2 p.5 |

All users have their own Android phone and their own Firebase email/password account; password recovery by email (DESIGN 03, 04). Two of the four staff have low tech literacy — UI must be large, high-contrast, everyday language ("Fiado", "Pagou", "Quanto deve"). source: interview (turn 7); EP1 p.7, p.9; DESIGN

## Domain entities

| Entity | States | Who moves it between them | source |
|---|---|---|---|
| Usuario (`usuarios/{uid}`): nome, email, papel (`dono`/`atendente`), ativo, criado_em | ativo → inativo (→ ativo) | Dono | EP2 p.15; interview (turn 8) |
| Cliente: nome (≤80), nome_busca, telefone (10–11 dígitos), endereco? (≤120), limite_credito_centavos? (empty = no limit), ativo, criado_em | ativo ⇄ em atraso (computed: saldo > 0 and no payment in 30 days) → inativo. Reactivation: **open** | Any active user (deactivate); system (overdue is derived) | EP2 p.15, p.21; DESIGN 06; interview |
| Lançamento (compra): cliente_id, valor_centavos (> 0, ≤ 9.999.999), descricao? (≤100), data_hora (auto), registrado_por (= auth uid), acima_do_limite, cancelado, cancelado_por | não enviado → enviado; either → cancelado (final). Never edited, deleted or reactivated | Any active user (create, cancel); Firestore sync (enviado) | EP2 p.15–16, p.20–21; DESIGN 07–08 |
| Pagamento: cliente_id, valor_centavos (> 0), data_hora, registrado_por, cancelado, cancelado_por | same as Lançamento | Any active user | EP2 p.16, p.20; DESIGN 09 |
| Saldo (derived, never stored) | Deve (> 0) · Crédito (< 0) · Sem débito (= 0) | Computed from non-cancelled lançamentos − pagamentos | EP2 p.15, p.32, p.34 |
| Extrato (derived text, never stored) | — | Generated on demand: header "Mercadinho da Família — Extrato de {nome} — {dd/mm/aaaa}", saldo, non-cancelled entries since saldo was last zero; sent via `wa.me/55{telefone}` | DESIGN 07; interview (C6-B, default) |

## Canonical data stores

- **Cloud Firestore** (`southamerica-east1`) is the single source of truth for `usuarios`, `clientes`, `lancamentos`, `pagamentos`. source: EP2 p.13, p.15; interview
- **Firestore offline persistence cache** is the only on-device store. source: EP1 p.9; EP2 p.13
- **Firebase Auth** holds credentials only; authorization comes from the `usuarios` doc. source: interview (turn 8)
- **CSV export** (owner, via share sheet) is a backup copy, never read back by the app. source: interview (turn 4)

May **not** be introduced: SQLite/Hive/Isar or any second local database; a stored saldo field or monthly balance snapshot; a separate backend or Cloud Functions; any store for CPF, birth date or income; a product/catalog collection. source: interview; EP2 p.15, p.17
