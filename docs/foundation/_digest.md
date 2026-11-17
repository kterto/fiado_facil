# Source digest

<!-- Written by context-builder on 2026-11-17. One record per ingested source.
     Resolution branch: docs/foundation/ (2 documents), fan-out ingest (one subagent per document).
     docs/design/ was added by the user mid-interview and digested on the user's explicit request
     (exception to the "html is pointer-only" rule; no same-stem .md companions exist).
     No embedded instructions aimed at an AI/reader were found in any source. -->

```yaml
- path: docs/foundation/Projeto de software - pratica .pdf   # "EP1"
  type: prd
  summary: Academic MVP proposal (Experiência Prática 1) for an offline-first Flutter/Firebase Android app replacing paper fiado notebooks at a Recife family grocery; problem, personas, RF01–07, KPIs, schedule.
  scope_nouns: [fiado, caderneta, cliente, lançamento, pagamento, saldo devedor, limite de crédito, extrato, WhatsApp, painel de recebíveis, clientes em atraso, sync offline, contestação]
  cross_refs: [Figma prototype (not included), ODS 8.2/8.3, Firebase Auth, Cloud Firestore, LGPD, termo de aceite]
  locked: false
  source: pdftotext pages 1-18 (p.2, 4, 17 no text); p.16 states the scenario is simulated

- path: docs/foundation/Mercadinho da familia pratica .pdf   # "EP2"
  type: spec
  summary: Academic spec (Experiência Prática 2) for Fiado Fácil: RF01–10, data model, Firestore rules, offline, accessibility, prototype and validation plan for the same grocery.
  scope_nouns: [fiado, Cliente, Lancamento, Pagamento, Usuario, saldo, limite de crédito, extrato, cancelamento, painel, offline sync, acessibilidade]
  cross_refs: [EP1, Kyte, Khatabook, firestore rules/indexes, plano de testes, OWASP Top 10 2021, WCAG 2.1 AA]
  locked: false
  source: pdftotext pages 1-45 (p.2, 4 image-only; p.35-36 captions only); p.39, 45 state persona/scenario is simulated

- path: docs/design/   # "DESIGN" — 00-indice … 09-registrar-pagamento (10 static HTML files, v1.0, 17/11/2026)
  type: design
  summary: Screen designs for splash, login, password recovery, client list, new client, ficha, new fiado, payment; tokens (Atkinson Hyperlegible, green #1e6b43, light only), copy, states, validations.
  scope_nouns: [Entrar, Recuperar senha, Lista de clientes, Novo cliente, Ficha do cliente, Novo fiado, Pagamento, alerta de limite, cancelamento, extrato, offline banner]
  cross_refs: [RF01–RF09, RNF01–RNF04 (defined in EP2), tokens.json (not present)]
  locked: false
  source: subagent text extraction of all 10 files (no scripts, no comments)
```

## Conflicts surfaced and how they were resolved

| Conflict | Variants | Resolution | source |
|---|---|---|---|
| Role model | EP1: atendente + proprietário · EP2: single atendente | Owner + atendente; owner-only = users + CSV | interview (turn 2, validation C4-B + section 2) |
| Login | Interview draft: shop account + PIN · DESIGN 02: per-person email/password + Google | Per-person email/password, no Google | interview (validation C1-B, C2-A) |
| Logout | Draft: block while pending · DESIGN 05: warn, allow "Sair mesmo assim" | DESIGN 05 | interview (validation C3-B) |
| Base text size | EP2: 18sp · DESIGN: 16/15 | 18sp | interview (validation C5-A) |
| Statement delivery | DESIGN: generic share sheet · alternative: wa.me to customer | wa.me to customer | interview (validation C6-B) |
| Speed target | EP2 p.19: ≤ 20 s / ≤ 4 taps · EP2 p.42: ≤ 60 s acceptance | ≤ 20 s / ≤ 4 navigation taps | interview (turn 5, C7-A) |
| Cost | EP1: zero cost · EP2: Blaze for backups | Spark only; CSV export | interview (turns 3–4) |
| Platform | EP1: "multiplataforma, foco Android" · EP2: Android only | Android only | interview (turns 3, 8) |
| Customer limit field | EP1 RF01 lacks it · EP1 p.9 / EP2 include it | Optional limit, any user may set | EP2 p.20; interview |

Validation page shown to the user: https://claude.ai/artifact/8Y99pS4Ws7KoU95GYTpj3M (reflects the pre-correction draft; superseded by these files).
