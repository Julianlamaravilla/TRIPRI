# Discovery Session Index
- Created: 2026-07-28T00:31:15Z
- Last Updated: 2026-08-02T06:00:00Z
- Project Type: Greenfield  (new codebase; TryController is third-party — data migration only, no inherited code)
- Depth: Quick (technical role) · Full (business role, already run via client questionnaire)
- Mode: sequential  (business first, technical now)
- Interaction: business = batch (.docx round-trip) · technical = conversational
- Business: in-progress  (**v3 returned answered 2026-08-02 — 52 of 55 questions**. Processed into
  `interview/business/client-answers-v3-2026-08-02.md`. **11 contradictions closed**, **7 new opened**
  (`CX-32`…`CX-38`), 5 new open questions. ⚠️ **`vision-document.md` STILL DOES NOT EXIST** — the
  business role has three rounds of answers and no artefact. Outstanding: V-21, V-22, V-23 unanswered;
  the **cash-box Excel promised in C-57 and V-25 has now failed to arrive twice**; V-26/27/28 deferred
  to a call the client offered for "hoy domingo en la noche".)
- Technical: **complete — 23/23, APPROVED 2026-08-02**  (Quick pass 13 + extension 10:
  T4, T11, T16, T18, T21, T24, T26–T29. Answered as bonuses: **T12**, **`OQ-T-24`** and **T16-C**.
  Out of scope by depth: T6, T9, T15, T19, T23. Interaction `conversational`; pre-fill policy `none`
  with **seven approved exceptions** — T10, T14, T17, T20, T11, T24, T26–T29.
  **`technical-environment.md` fully re-rendered**: §Cloud Services, §Project Structure,
  §Encryption, §Compliance, §Tooling and **§Example Code** — the last one closes `OQ-T-22`, the
  document's most expensive gap, which had been P0 since it was first rendered.
  ✅ **APPROVED BY THE USER 2026-08-02** — *"Apruebo rol técnico"*. The gate, open since 2026-08-01,
  is now closed. **Technical role COMPLETE.**
  Approved together with three stated assumptions the user did not override: **TLS 1.2 minimum**
  (phone models never declared), the **four unconfirmed glossary terms** (`sale`, `client`/`customer`,
  `partner`, `collector`), and the **still-undecided encrypted-SQLite library**, which T18 turned into
  a blocking project-setup requirement.)
- Join: blocked  (Business in-progress: questionnaire v3 issued, not yet returned. Technical in-progress: scope extended to 23 questions, not approved.)

## Confirmed Decisions
Answers already closed by the user. They take precedence over `context-discovery/` material.
Full record: `interview/business/vision-answers-history.md`; summary in `open-questions.md` §0.
- **D-01** (2026-07-28) — Money-handling scope: the system is **not a fund custodian**. It never
  receives, holds or transfers collection money (not a wallet / fintech / bank). Cash and PIX are
  recorded as **information** to represent collection management on both web and mobile. The only
  real money flow inside the product is **SaaS subscription billing — web only, never mobile**.
- **D-02** (2026-08-01) — Client questionnaire v2 returned answered (117 questions, highlight-marked).
  Closes the whole financial ruleset: fixed interest on principal, indivisible instalment, no late
  interest, no early-payment discount, **fractional instalment counter on partial payments**, Mon–Sat
  daily frequency, "Libre" modality dropped, 100%-paid rule for renewal, 4-step sale approval with a
  **QR to the client's WhatsApp to release the cash**, 3-panel cash box closing at zero pending.
  Establishes that the product is **an anti-fraud system**, not a collection CRM. Full record:
  `interview/business/client-answers-2026-08-01.md`.
  ⚠️ Two highlight colours detected (green 191 / cyan 8) — a second respondent contradicts the first
  on C-51, C-58 and C-61. No tie-breaker declared; asked as V-00 in v3.
- **D-03** (2026-08-01) — **TEAM POSITION, awaiting client sign-off in V-05.** MVP = **full collector
  app + minimal admin web**, not one or the other. Resolves CX-15 under the delegation the client
  granted in C-109. Out of v1: AI assistant, advanced reports, SaaS billing module, geographic route
  ordering. ⚠️ This scope depends entirely on CX-16 (WhatsApp Business API): without it, v1 ships
  with neither anti-fraud control and the product loses its purpose.

- **D-04** (2026-08-02) — **Client questionnaire v3 returned answered, 52 of 55.** Closes the
  identity of the product: **Brasil · reales (BRL) · app en español** (V-01), **real scale ~10
  tenants × ~5 routes × ~40 clients ≈ 2.000 clients** (V-09), **interest rate set per sale within an
  admin range, 20 % default, immutable once the sale exists** (V-08), **`D-03` signed off by the
  client** (V-05), **device binding confirmed as a business requirement against portfolio theft**
  (V-36), **audit immutable for everyone including the technical team** (V-35), **amounts never
  editable once registered** (V-33), **photo retention: max 5 files, deletable on renewal** (V-41).
  🔴 **And one finding that outweighs all of the above: `CX-33`.** The subscribers **cannot obtain
  WhatsApp Business API at all** — Meta requires a verified registered company and, in the client's
  own words, *"la mayoría de suscriptores no es empresa formal… es algo alegal"*. Both anti-fraud
  controls depend on that channel. Full record:
  `interview/business/client-answers-v3-2026-08-02.md`.
  ⚠️ **Provenance note**: the file first pointed to (`respuestas-cuestionario-cliente-v3.docx`)
  contained **no answers** — its extracted text was byte-identical to the blank questionnaire. The
  real one was found at `~/Downloads/cuestionario-cliente-v3.docx` and copied in as
  `respuestas-cuestionario-cliente-v3-REAL.docx`.

## Open Questions
- Last Compiled: 2026-07-28T00:52:00Z  (pre-interview gap analysis, user-requested)
- Last Updated: 2026-08-02T01:30:00Z  (technical T4 + T11: CX-27, CX-29, CX-30 opened; CX-28 opened and closed; OQ-T-14 closed, OQ-T-13 near-closed, OQ-T-15 reactivated to P0, OQ-N-45 opened)
- Contradictions `CX`: 38 rows — **20 closed · 1 partial · 17 open → 53,9 %**
  - **CX-31 opened 2026-08-02 during T21 — P0.** **ISO 27001 A.5.3 requires segregation of duties;
    T25 made "code review approved" a blocking merge gate; `CX-27` says the team is one person.**
    There is no reviewer. The same person writes, approves, deploys and operates the cash-box code —
    what the control exists to prevent, in an anti-fraud product. T25's gate cannot be met as written.
  - **CX-27 opened 2026-08-02 during technical T4** — the team is **one junior developer**; the
    committed scope (D-03 collector app · in-house sync engine T14 · in-house auth T17 · six test
    types T22/T25) does not fit it. **P0.** Reopens D-03.
  - **CX-28 opened AND closed 2026-08-02 during T11** — ECS Fargate (T3) vs Lightsail
    (`technical-research/infraestructura-aws.md`). ✅ Closed in favour of **ECS**: the declared
    private-network architecture is technically impossible on Lightsail. Cost consequence
    `OQ-N-45` (~$141 → ~$210/mo, NAT now mandatory).
  - **CX-29 opened 2026-08-02 during T11** — **admin reports go to Telegram, not WhatsApp**.
    Telegram appears **zero times** in ~180 KB of material. Does not close CX-16, does not reduce
    the WhatsApp bill; adds a second messaging integration. P1.
  - **CX-30 opened 2026-08-02 during T11 — P0, the most consequential finding of the day.**
    Weekly subscription whose **base tier includes AI**. Contradicts **D-03** (AI out of v1) **and
    the client's own C-108** (*"la IA puede esperar"*). Second-hand information answering
    `OQ-F-97` without an authoritative source. **Enlarges scope right after CX-27 established it
    does not fit**, and puts a feature whose behaviour was never specified (`OQ-F-68`, `OQ-F-70`,
    `OQ-F-72`, all P0 open) into the entry-level plan. Reactivates `OQ-T-15` to P0.
  - **Correction to `technical-research/infraestructura-aws.md` §7.4** (user-reported 2026-08-02):
    **Claude IS available in Bedrock `sa-east-1`**. The document's finding that "AI inside AWS
    without breaking data residency does not exist in São Paulo" no longer holds.
- Business `OQ-B`: 18 rows — **9 closed · 6 partial · 3 open → 66,7 %**
- Functional `OQ-F`: 104 rows — **34 closed · 26 partial · 44 open → 45,2 %**
- Non-functional `OQ-N`: 48 rows — **23 closed · 14 partial · 11 open → 62,5 %**
- Technical `OQ-T`: 26 rows — **21 closed · 1 partial · 4 open → 82,7 %**
- **TOTAL: 234 rows — 107 closed · 48 partial · 79 open → COVERAGE 56,0 % (measured)**
- Next Index: {contradiction: 39, business: 19, functional: 105, non-functional: 49, technical: 27}
- ⚠️ The previously reported *~72 % global* was **never measured** and is superseded by the 56,0 % above.
- ✅ **REGISTER RECONCILED ROW BY ROW — 2026-08-02.** The measurement caveat that stood here is
  resolved: **all 234 rows now carry a status marker with its supporting evidence** (`C-xx` from v2,
  `V-xx` from v3, `T-xx` from the technical interview, or `D-0x`). Coverage is now a **measurement**,
  not a judgement.
- ⚠️ **`vision-document.md` DOES NOT EXIST.** One of the three Discovery deliverables has never been
  rendered. The business role has answers (D-01, D-02, client-answers-2026-08-01.md) but no artefact.
- Top blockers: CX-16 (no WhatsApp Business API — both anti-fraud controls depend on it),
  CX-11 (country/currency/language never declared), CX-15 (app-first vs web-first),
  CX-12 + CX-13 (cash box cannot balance as currently specified), CX-20 (TryController has no export),
  CX-26 (the "tie the user to the phone's IP" requirement is not implementable — needs the client to
  confirm the device-binding translation and decide the re-authorisation flow),
  **CX-30 (AI in the base subscription tier — contradicts D-03 and the client's own C-108, and
  enlarges scope right after CX-27 established it does not fit the one-person team)**,
  **CX-27 (the committed scope does not fit a single junior developer)**

## Derived Artefacts (kept in sync with open-questions.md)
- `interview/client-questionnaire.md` — v2, 117 questions in 16 blocks — **SUPERSEDED**, kept for traceability
- `interview/cuestionario-cliente.docx` — Word export of v2, 2026-07-28
- `interview/respuesta-cuestionario-cliente.docx` — v2 **returned answered** by stakeholders, 2026-08-01
- `interview/business/client-answers-2026-08-01.md` — literal per-question record of the answers
- `interview/client-questionnaire-v3.md` + `interview/cuestionario-cliente-v3.docx` — **current**,
  **54 questions** (V-00 governance + V-01…V-54): 14 contradictions, 10 half-answers, 7 pending
  items, and 23 never asked in v2 (audit, security, alerting, performance, store distribution,
  tenant onboarding, PCI scope). Answering it takes the product definition from ~65% to ~90%;
  the remainder is the technical interview, which does not depend on the client.
- `interview/md2docx.py` — markdown → .docx renderer used for the export (python-docx installed 2026-08-02)
- 🆕 **Gap-closing questionnaires issued 2026-08-02**, generated from the reconciled register. Format
  per item: **Contexto · Pregunta · Opciones de respuesta · Descripción**.
  - `interview/Negocio.docx` (+ `negocio.md`) — **9 questions**, the OQ-B rows still open or partial
  - `interview/Contradicciones.docx` (+ `contradicciones.md`) — **14 contradictions**, ordered by
    severity. The first three block v1 planning: `CX-33` WhatsApp unobtainable, `CX-35` PIX vs cash,
    `CX-30` AI in the base plan
  - `interview/Funcional.docx` (+ `funcional.md`) — **52 questions in 12 blocks**, splittable across
    people. Six functional items were deliberately routed to Contradicciones instead of duplicated
- `../technical-research/recomendacion-tecnica.md` — revision 2, D-01 applied — **needs revision 3**
  (D-02 changes the financial model, the WhatsApp dependency and the MVP scope)
- `../technical-research/infraestructura-aws.md` — 🆕 **found during T11 on 2026-08-02, was not
  indexed**. 48 KB, dated 2026-07-28: real load sizing, `sa-east-1` prices claimed as verified
  against the AWS pricing API, and five costed architecture scenarios. **Two corrections now apply**:
  its Lightsail recommendation is void (`CX-28` — the private network requires ECS) and its §7.4
  finding that Claude is absent from Bedrock `sa-east-1` is contradicted by the user. Its §8.3 cost
  rule "never buy a NAT Gateway until something demands it" is now formally overridden — see
  `OQ-N-45`

## Context Sources (pre-loaded, read-only)
Material provided by the user in `context-discovery/notebooklm/`, used to pre-fill answers:
- `sources/01-requirements-gdoc.md` — DOCUMENTO DE REQUERIMIENTOS DEL PROYECTO (13 sections, functional requirements)
- `reports/01-especificacion-requerimientos.md` — Especificación de Requerimientos (SaaS, modules, NFRs)
- `reports/02-sistema-inteligente-prestamos-ia.md` — requirements.md + funcionalidad.md (multi-tenant vision, flows)
- `reports/03-guia-maestra-trycontroller.md` — Guía Maestra TryController (legacy platform behaviour)
- `chat/historial.md` — 5-turn NotebookLM conversation (feature inventory from 2 webinars)
