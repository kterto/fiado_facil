# Roadmap addendum — Fiado Fácil

Base context: [`.orchestrator/PROJECT-CONTEXT.md`](../.orchestrator/PROJECT-CONTEXT.md) (owned by context-builder; not duplicated here). This file records only the roadmap decisions, confirmed by the product owner on 2026-11-17.

## Release target

- One release train: **`mvp`**. No external date or contractual milestone — the original academic schedule (ending 2026-11-17) is historical.
- `mvp` is shippable when milestone 005 is done: signed APK on every staff phone against the production Firebase project, ready for the ~2-week parallel pilot.

## Milestones and "done"

| Milestone | Done when |
|---|---|
| 001 Foundation | App builds; format, analyze and tests green; Firebase emulators run; domain layer fully unit-tested. |
| 002 Access | Login, password recovery and logout work against the emulators; Firestore rules tests green. |
| 003 Ledger | Critical flows 2–6 and 8 work online and offline against the emulators. |
| 004 Management | Critical flows 7, 9, 10 and client editing work; every new screen flagged for design validation. |
| 005 Pilot ready | End-to-end suite green; signed APK on staff phones against production; pilot can start. |

## Sequencing

- Milestones run strictly in order 001 → 005. Inside a milestone, stories follow `depends_on` (only real dependencies are declared, so independent stories may run in any order).
- Security rules (002.1.1) land before any screen that reads or writes Firestore.

## Decisions

- **Missing designs** (dashboard, edit client, user management, CSV export, statement preview): build from the existing design system and flag each screen for design validation by the product owner — not blocked on new design files.
- **Rigor:** domain rules (001.2.1, 001.2.2) and security rules (002.1.1) are `hardened`; every other story is `delivery`.
- **Firebase:** all development and tests run on the local Emulator Suite (`demo-fiado-facil`) until 005.2.1, where the product owner creates the real Spark project and runs `flutterfire configure`.
- **Human-validation spots:** 005.2.1 (owner account, Firebase project, keystore, real-phone check) and the design-validation flags in 003.2.5 and milestone 004.
