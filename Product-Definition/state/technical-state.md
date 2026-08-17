# Technical Role — State

Single-writer file for the Technical role. Updated after every validated answer.

## Session Metadata

- Started: 2026-08-01T15:27:21Z
- Technical Depth: **Quick** — `[CORE]` questions only
- Interaction: **conversational** — one question at a time in chat
- Pre-fill policy: **none**. The user explicitly declined pre-filling from
  `technical-research/recomendacion-tecnica.md`, on the grounds that this interview must record
  *real constraints*, not inherit assumptions from a recommendation. Questions are therefore
  presented clean, with no suggested answer and no recommendation line.
- Project Type: **Greenfield** — new codebase. TryController is a third-party product the client
  does not own, so there is no existing codebase to constrain; the `TB*` (Existing System)
  questions are out of scope. The historical-data migration (`CX-20`) is a data problem, not a
  codebase-inheritance problem.
- Status: ✅ **COMPLETE — 23/23, APPROVED BY THE USER 2026-08-02.** Quick pass (13) + extension (10),
  plus T12, `OQ-T-24` and T16-C answered as bonuses. The approval gate, open since 2026-08-01,
  is closed. Approved together with three stated assumptions the user did not override: TLS 1.2
  minimum, the four unconfirmed glossary terms, and the undecided encrypted-SQLite library.

## Scope extension #2 — 2026-08-07 (6 questions, AI-selected at the user's request)

The user asked for a **short** technical session "based on what is missing" and delegated the
selection, as in extension #1. The role stays **APPROVED**; this extension does not reopen any
answered question — it closes residuals that the approval explicitly carried as stated assumptions,
plus the technical `OQ-T` rows still marked open.

Selection rule applied: **only items the user can decide without the client.** Everything blocked on
the client (`OQ-T-15` LLM provider → `CX-30`, `OQ-T-25` TryController export → `CX-20`, `OQ-T-26`
SaaS payment gateway, the retention number `N` in `OQ-T-13`) is deliberately excluded — asking them
here would produce a guess, not a constraint.

- [x] **T30** — Encrypted on-device SQLite library → **A · `op-sqlite` + SQLCipher**, whole DB
      encrypted, key in `expo-secure-store`. ⚠️ AI-proposed / user-approved (**eighth approved
      exception** to the no-pre-fill policy). 🔴 **Closes the blocking project-setup requirement T18
      opened** and the `OQ-T-17` residual. Deciding argument: **T17 already committed to "local
      unlock decrypts the local SQLite"** — B cannot deliver that sentence (there is no *the* SQLite,
      only fields), C has no decryption at all. B rejected because it **works only while everyone
      remembers**, and forgetting is silent PII in clear on a phone with no test to catch it —
      unacceptable with `CX-27` + AI-generated code; **kept as plan B**. C rejected: FBE/Data
      Protection protect a phone that is *off*, which is never a field phone's state. D rejected as
      an alternative (breaks `C-65` + the T14 command queue) but **adopted as a complement** — purge
      uploaded photos and day data at cash-box close. Rule 2 objection was already paid: **Expo Go is
      impossible here anyway** (device key pair, QR reader, precise GPS, FCM all force a dev build).
      ⚠️ **Setup verification, before the first migration**: `op-sqlite`'s official config plugin
      must be current for the pinned Expo SDK, and SQLCipher's licensing terms confirmed — if either
      fails, fall back to B with a written closed list of sensitive fields.
      **Three binding traps recorded**: (1) 🔴 the **PIN unlocks the key, it does not derive it** —
      a 4-digit PIN (`V-18`) is 10.000 combinations and breaks offline in seconds; use a random
      256-bit device-generated key in Keystore/Keychain; (2) exclude DB and key from OS backups
      (`allowBackup=false`, iCloud exclusion, `WHEN_UNLOCKED_THIS_DEVICE_ONLY`); (3) **deleting the
      key IS the C-71 remote wipe** — write it down before someone builds a "real" one.
- [x] **T31** — Minimum supported OS versions → **A · Android 10+ / iOS 13+, TLS 1.3 mandatory.**
      **Supersedes the T18 stated assumption** ("TLS 1.2 min, 1.3 preferred") — the second of the
      three assumptions the 2026-08-02 approval carried is now an answer. Supporting fact already on
      record but not surfaced when asking: **`V-36` + `C-70` mean the device park is procured, not
      BYOD** ("el celular asignado por la empresa"), so an Android 10 (2019) floor excludes nothing a
      subscriber can buy today; the risk is confined to reusing existing old handsets.
      **Infrastructure consequences for T29 / `infra/`**: ALB must move to a **TLS 1.3-only security
      policy** (`ELBSecurityPolicy-TLS13-1-3-*`) — without it the decision does not exist; ⚠️
      **CloudFront cannot go 1.3-only**, so the SPA static bundle's effective floor stays TLS 1.2 —
      harmless (public bundle, no data) but **must be written down so nobody reads it as a breach or
      tries to "fix" it**. Expo's own rising floor (rule 5) wins if it ever passes this one.
- [x] **T9-b** — Second-order libraries → **`httpx` · `python-json-logger` · stdlib dates+money ·
      Recharts · Zustand.** Closes the gap T9 left open twice by depth decision, and with it the
      "AI-DLC will reach for its defaults there" caveat.
      **Three binding rules ride with the choices**: 🔴 **a `logging.Filter` injecting `tenant_id`,
      `request_id`, `device_id` from `contextvars`** — `python-json-logger` gives JSON output but no
      context binding, so without the filter attribution depends on the developer remembering
      `extra={...}`, the same failure mode that decided T30; plus **never log amounts, ID documents
      or borrower data** (LGPD/T21 — the ledger is the record, not CloudWatch). 🔴 **Zustand holds UI
      and session state only** — the offline queue and business data live in the T30 encrypted
      SQLite, and the `persist` middleware is **not** used (its default backend is AsyncStorage,
      banned by T10). ⚠️ **Pin a Recharts version compatible with React 19** and verify at install.
      Why stdlib is safe for dates/money **here specifically**: all financial maths lives in the
      Python functional core (T22, pure functions + injected clock), so the client receives computed
      values. 🔑 `America/Sao_Paulo` — **Brazil abolished DST in 2019**, so there are no transitions
      to break the daily instalment counter; **that property is lost if the product expands to the
      `C-02` countries** and date arithmetic must be re-examined then.
- [x] **T32** — Environments and test data (`OQ-T-21`) → **(a) A · production only + local Docker
      Compose** · **(b) A + B · synthetic generator *and* anonymised production copy.** Cost impact
      **$0** — infra stays at ~$210/mo; does not move `OQ-N-45`, which still depends on the
      never-declared budget `OQ-N-40`.
      🔴 **Raises `CX-39`: T25's slow gate has no environment to run in.** E2E + performance + DAST
      block the deploy, but Playwright, Maestro, k6 and ZAP now have only local Docker Compose or
      production — and **ZAP against production is not an option**. Mitigation agreed inside the
      decision: **the slow gate runs against the full local stack** (Compose: backend + PostgreSQL +
      seeded DB; Maestro on a dev build against `localhost`). ⚠️ **What it cannot give is a valid
      performance number** — no ALB, no NAT, no `sa-east-1` RDS latency. It does catch **algorithmic
      regressions** (N+1, missing indexes, a query that grows with tenant count), which is where a
      one-person team's performance bugs actually live. **This constrains T34**: the target must be
      measurable in that environment or it is measurable nowhere.
      **Part (b) ordering + LGPD trap**: 🔴 there is **no production to copy yet** (greenfield) — day
      1 is synthetic only; B is a future capability. 🔴 A copy keeping amounts, dates and route shape
      is **re-identifiable** across ~2.000 clients — that is pseudonymisation, still personal data
      under LGPD art. 13. **Binding rule: never `pg_dump` production to a local machine**; the
      transformation runs inside AWS. **Recommended path honouring both**: pull **statistical
      parameters** from production into the synthetic generator — same realism, no personal datum
      ever moves, and it scales to 10× for load tests where a real copy is fixed at real size.
- [x] **T33** — ISO 27001 scope + the code-review gate → **B · "aligned with ISO 27001", not
      certified.** ✅ **Closes `CX-31` (P0)**, ✅ **closes `CX-38`**, ✅ **closes `OQ-N-46`** — the
      aligned-vs-certified distinction T21 never made. Decided by `CX-38`, which did not exist when
      `CX-31` opened: **`V-53` — the client does not foresee anyone demanding the certificate**, so
      certifying is a months-long organisational project with no buyer. The practical difference is
      exactly what made `CX-31` unresolvable: **a standard used as a design guide admits documented
      exceptions; an audited certification does not.** A.5.3 (segregation of duties) is declared
      **not met**, in writing, in `technical-environment.md` §Compliance.
      **Four binding compensating controls**: (1) **T25's gate is rewritten** — "code review
      approved" stops meaning human approval (impossible with one person) and becomes **mandatory
      static analysis (Ruff + Bandit, already in T24) + a checklist ticked on the PR**; the gate
      still blocks, only who satisfies it changes. (2) 🔴 **Client approval for changes to money
      modules** (`payments/`, `cash_box/`, `ledger`) — **the only control producing real segregation**,
      since the approver is a different person; it is what keeps B from being paperwork. (3) 🔴
      **Never deploy from the laptop** — CI only, by tag. **This one holds up the other three**: if
      the developer can deploy from their machine the immutable deployment log records nothing and
      control 2 can be bypassed without trace. (4) **Audited, non-standing production access** —
      break-glass IAM role, CloudTrail, **alarm on use**. LGPD unaffected (obligatory by law).
- [ ] **T34** — Performance target (`OQ-N-44`, P1) → ⬜ **NOT ANSWERED. Session closed by the user
      before it.** `OQ-N-44` stays open and T22's performance test stays non-executable.
      Preserved for the next session: at ~1.200 payments/day and **0,05 req/s**, a throughput target
      measures nothing — **the real risk is ledger growth**. T14 made it append-only and defined
      balance as the **sum of movements**: ~1,1 M entries in 3 years, degrading **continuously and
      invisibly** until a Saturday's cash box will not close. T14 already has the mitigation (a
      **precomputed summary table** refreshed by a Procrastinate periodic task) but **nobody has set
      the threshold that would trigger it**. Options put on the table: (a) latency over aged volume
      (seed ~1,5 M entries; `p95` on sync-batch upload, cash-box close, dashboard summary) · (b)
      algorithmic guardrails only · (c) both · (d) defer until production exists. Proposed thresholds
      for (a)/(c): **p95 500 ms** / **300 ms** / **1 s**.

**Not reached (bonus)**: **T23** (coverage number, P2) and the **four unconfirmed glossary terms**
(`sale`, `client`/`customer`, `partner`, `collector` — `OQ-T-24` residual). The glossary terms remain
a **precondition for writing code**.

Pre-fill policy unchanged: **none**. Explanation + recommendation only on explicit request.

**Status of extension #2: 5 of 6 answered, closed by the user 2026-08-07.** The role's 2026-08-02
approval is untouched — nothing answered was reopened. `technical-environment.md` re-rendered:
§Project Technical Summary, §Preferred Frameworks, §Encryption, §Compliance, §Testing (new
§Entornos y datos de prueba), §CI/CD Gates, §Open Questions and §Riesgos técnicos abiertos.

## Scope extension — 2026-08-02 (10 questions, AI-selected at the user's request)

The user asked for a 10-question session and delegated the selection. Chosen from the 16 unanswered,
ranked by leverage on AI-DLC code generation and by unmitigated risk:

- **T4** (team) — never recorded, yet T17/T14/T22 all committed to in-house builds
- **T11** (cloud allow-list) — only 6 services fixed in passing; push, transactional email and the
  photo-delivery decision are open (`OQ-T-13`, `OQ-T-14`)
- **T16** (project structure) — undeclared; 3 codebases sharing a generated OpenAPI contract.
  **Asked before T26–T29** because example-code file paths depend on the repo layout
- **T18** (encryption) — general declaration missing: DB at rest, backups, minimum TLS. Cross-checked
  against T21 per the question bank's own validation rule
- **T21** (compliance) — ID-document photos + third-party financial data; LGPD if `CX-11` = Brazil
- **T24** (test tooling) — six mandatory types, zero tools named (`OQ-T-20`)
- **T26 · T27 · T28 · T29** (example code) — `OQ-T-22`, **P0**, the document's most expensive gap.
  T29 also carries the undeclared IaC tool (`OQ-T-23`)

Deliberately excluded, with reasons: **T19** already resolved de facto by T8 (Pydantic v2 + Zod from
the same OpenAPI contract) · **T15** absorbed by T14 · **T12** derivable from T8 · **T6** and **T9**
declined by the user on 2026-08-01, decision respected · **T23** cheapest to close later, touched in
passing during T24.

Pre-fill policy unchanged: **none**. Explanation + recommendation given only on explicit request, as
in T10, T14, T17 and T20.

- [x] T4: Team size and experience → **1 person, junior.** Strong: **Python + FastAPI**, **AWS**
  (incl. AI services). **React web only — no mobile experience.** No declared experience in React
  Native, Expo, on-device cryptography, offline sync engines or multi-tier CI/CD. **Same person
  operates production.** → raises **`CX-27` (P0)**: the committed scope (D-03 collector app +
  in-house sync engine T14 + in-house auth T17 + six test types T22/T25) does not fit the team that
  exists. Backend falls inside the declared strength; **risk concentrates entirely on the mobile
  half, which is both the MVP and the zero-experience technology**. Architecture is not reverted —
  scope is the variable. Reopens D-03 at the join.
- [x] T11: Cloud services allow-list → **17 AWS services + 5 external, with a binding network
  architecture.** Key calls: **RDS, not Aurora** (~1.8× cost at idle, capabilities unusable at this
  scale; Aurora Serverless v2 kept in mind for dev/staging via 0-ACU auto-pause) · **X-Ray out**
  (single-service monolith — no chain to trace; Sentry covers performance tracing) · **SES in for
  v1**, decided by the weekly subscription (`CX-30`), not by password recovery · **ID photos by
  short-lived S3 pre-signed URL, never public CloudFront** · **`sa-east-1` firm** · **Telegram Bot
  API added** (`CX-29`) · **Bedrock conditional on `CX-30`**. Network: ALB public → Fargate private →
  RDS isolated, **one NAT** (justified by outbound to WhatsApp/Telegram/Sentry/FCM), free S3 Gateway
  endpoint. **Cost consequence ~$141 → ~$210/mo → `OQ-N-45`.** Closed `CX-28` (ECS wins — Lightsail
  cannot do private subnets), `OQ-T-14`; nearly closed `OQ-T-13` (retention still pending T21).
  Corrected the user's framing that RDS needs NAT/IGW to reach ECS — same VPC, local routing.
  ⚠️ Two new business facts surfaced: **Telegram for admin reports** and **AI in the base
  subscription tier**, the latter a P0 contradiction against D-03 and the client's own C-108.
- [x] T12: Cloud services disallow-list → answered in passing during T11 (12 rows, reason per row)
- [x] T16: Project structure conventions → **A · Monorepo**, with **independent versioning by
  namespaced tags** (`mobile-v1.4.2`, `backend-v2.1.0`), path-filtered CI, and deploys driven by
  tag + environment. Layout: `backend/ web/ mobile/ infra/ contracts/`. **The user first proposed
  5 submodule-linked repos with a same-named branch in each; reviewed it at their own invitation
  and changed position.** Three reasons: the OpenAPI contract (the system's main coupling) turned a
  single logical change into 5+ commits across 4 repos **and broke what the T25 contract gate exists
  to protect** — in one repo the breaking change and its client fixes ride the same commit; a
  same-named branch across 5 repos is **a coordination protocol with no coordinator** (nothing stops
  deploying an incompatible pair); and `CX-27` — 5 CI configs and the submodule tax are paid in
  debugging time. **Deciding argument: reversibility** — splitting a monorepo later is easy
  (`git filter-repo`), merging repos while keeping history is not. Revisit if separate orgs own the
  pieces, mobile goes open-source, or a client contractually demands the backend repo standalone.
  **Terraform confirmed as the IaC tool** → closes `OQ-T-23`, advances part of T29.
  **T16-C layering — CLOSED 2026-08-02: modular monolith · vertical slices · bounded hexagonal per
  module · functional core.** Each module: `router · service · domain · repository · models`.
  **Six ports, closed list** (clock, messaging, files, AI, repository, push) under the rule *"a port
  for each thing that could genuinely change or that gets in the way of tests"*; **the repository is
  NOT shared** — it lives inside each module (*a port lives where its users are*). `ports/` imports
  no external libraries and holds no logic; `shared/` admits code only once two modules already use
  it. ⚠️ **Hexagonal applies to `backend/` only** — the monorepo root has projects, not architecture,
  and `web/`/`mobile/` organise by screens and components.
  **The user disagreed with the initial recommendation to skip hexagonal, and was right.** The
  supporting argument is observed, not speculative: in this same session the messaging layer changed
  twice and a new service appeared (`CX-16` unconfirmed, `CX-29` Telegram, `CX-30` Bedrock).
  Named what T22 and T14 had already committed to without naming: **Functional Core / Imperative
  Shell**, **bounded event log** (the append-only ledger) and **Command** (the offline queue).
  Rejected with reasons: full Clean Architecture, full tactical DDD, CQRS, full Event Sourcing.
  **`OQ-T-24` code language — CLOSED 2026-08-02: EVERYTHING IN ENGLISH.** B was recommended and the
  user chose A. **Mandatory mitigation of the risk that recommendation flagged**: since A's danger is
  translation ambiguity in a system that must be exact, a **binding 19-term glossary** was fixed
  (`loan`, `installment`, `cash_box`, `ledger_entry`, `reversal_entry`, `collector`, `arrears`,
  `payment_allocation`…) — without it the same concept would appear as `fee`, `quota` and
  `installment` in three modules. **The T16 structure was renamed immediately** while it was still
  free: `payments/ loans/ cash_box/ clients/`, `ports/clock.py`, `shared/money.py`.
  ⚠️ Four terms still to confirm before writing code: `sale` (sale or loan disbursement?), `client`
  vs `customer` (the debtor/subscriber distinction must be unambiguous per D-01), `partner`, and
  whether `collector` covers both "cobrador" and "gestor".
- [x] T18: Encryption at rest and in transit → **A · everything encrypted at rest AND in transit.**
  Adds on top of what was already fixed: **RDS with KMS** (⚠️ **only enablable at instance creation**
  — irreversible step of the initial `terraform apply`, must appear in T29), **encrypted backups and
  snapshots**, and **`sslmode=require` between ECS and RDS** — not automatic, and without it traffic
  runs in clear **inside the VPC**; the most commonly forgotten piece of "everything encrypted in
  transit". **Public TLS: 1.2 minimum, 1.3 preferred** — ⚠️ **stated assumption, not a user answer**:
  collector phone models were never declared and **mandatory TLS 1.3 requires Android 10+**, whose
  failure mode reads as *"it won't sync"*. Because A is the question's maximum, the T18↔T21 validation
  cross-check holds by construction. 🔴 **Does not resolve the encrypted-SQLite library** — T18 turns
  it into a **blocking project-setup requirement**: `expo-sqlite` does not encrypt, and
  `op-sqlite` + SQLCipher falls outside the SDK, against rule 2 of `mobile-platform-constraints.md`.
- [x] T21: Compliance framework → **X · ISO 27001 + LGPD** (stacked).
  🔴 **User's explicit instruction, recorded as a development precondition: the developer must study
  ISO 27001 and LGPD before building any module.** With a one-person team (`CX-27`) nobody else
  supplies that knowledge, and both standards drive design decisions that are expensive to reverse.
  **AI-DLC must treat this as a precondition of Requirements Analysis.**
  Effect on `CX-11`: declaring LGPD presupposes Brazil and removes the "which framework" uncertainty,
  but **currency and UI language remain undeclared** — CX-11 drops from total blocker to two fields.
  Reinforces `sa-east-1` and the Bedrock-in-São-Paulo option if `CX-30` returns AI to scope.
  **Already covered** by T14/T17/T18/T20/T25: encryption, traceability, erasure-vs-ledger, access
  control, tenant isolation, secrets, secure development. **Newly required and previously absent**:
  🔴 **`OQ-F-100` — subject data export (LGPD art. 18), a feature in no requirement anywhere**;
  legal basis; designated DPO; **`OQ-N-47`** breach-detection capability; documented retention;
  asset inventory; **supplier risk assessment for six untouched third parties** (AWS, Meta, Telegram,
  Sentry, Google/FCM, Expo); incident response; access review; tested continuity plan.
  ⚠️ **`OQ-N-46`**: "aligned with ISO 27001" and "ISO 27001 certified" were not distinguished — the
  first is engineering work largely done, the second a months-long organisational project.
  🔴 **`CX-31` (P0)**: **ISO 27001 A.5.3 requires segregation of duties and T25 made "code review
  approved" a blocking merge gate — with one developer there is no reviewer.** The same person
  writes, approves, deploys and operates the cash-box code, which is precisely what the control
  exists to prevent, **in a product whose reason to exist is anti-fraud**. T25's gate cannot be met
  as written.
- [x] T24: Tooling per test type → **proposal accepted in full** (sixth approved exception to the
  no-pre-fill policy). **pytest** · **Vitest** · **pytest + Testcontainers** (T22 demands a real
  PostgreSQL — RLS, transactions and the uniqueness constraint behind idempotency exist nowhere else)
  · **`oasdiff`** in the fast gate for contract compatibility — **deliberately not Pact**, since there
  are no independent consumers negotiating, there is one published schema and clients generated from
  it · **Playwright** (web E2E) · **Maestro** (mobile E2E, far less brittle than Detox on React
  Native) · **k6** (⚠️ not executable until `OQ-N-44` supplies a target) · **Ruff · Bandit ·
  pip-audit · npm audit · Trivy** (Trivy also covers the **Terraform**, since IaC is code and belongs
  in the same gate) · **OWASP ZAP** (DAST, slow gate). Closes `OQ-T-20`.
  **Phasing — CONFIRMED**: phase 1 = the four fast-gate tools (pytest · Testcontainers · oasdiff ·
  Ruff/Bandit) from the first commit; phase 2 = Playwright, Maestro, k6, ZAP once there are flows to
  test. The six T22 test types remain **mandatory** — this orders when each tool appears, it does not
  reduce scope, and the split matches the two gate tiers T25 already defined.
  **E2E flow list — CONFIRMED, closed by design, exactly three**: offline payment + sync (the hardest
  piece in the system, T14) · cash-box closing at zero pending (`C-50`; the client's declared number-one
  fear in `C-110`) · 4-step sale approval with QR (anti-fraud control #2, `C-99`). Closes the item T22
  left open. **Three untouchable flows beat twenty nobody looks at** — T22 warned E2E rots if it covers
  everything.
- [x] T26: Example endpoint pattern → **written by the technical role from the 23 interview answers, approved by the user 2026-08-02** (seventh approved exception to the no-pre-fill policy). See `technical-environment.md` §Example Code.
- [x] T27: Example function / module pattern → **written by the technical role from the 23 interview answers, approved by the user 2026-08-02** (seventh approved exception to the no-pre-fill policy). See `technical-environment.md` §Example Code.
- [x] T28: Example test pattern → **written by the technical role from the 23 interview answers, approved by the user 2026-08-02** (seventh approved exception to the no-pre-fill policy). See `technical-environment.md` §Example Code.
- [x] T29: Example infrastructure snippet → **written by the technical role from the 23 interview answers, approved by the user 2026-08-02** (seventh approved exception to the no-pre-fill policy). See `technical-environment.md` §Example Code.

## Scope: 12 `[CORE]` questions + T25 (pulled in 2026-08-01)

### Section T1: Project Technical Summary
- [x] T1 [CORE]: Runtime environment → **A · Cloud only**
- [x] T2 [CORE]: Cloud provider → **A · AWS** (single provider)
- [x] T3 [CORE]: Deployment model → **B · Containers on ECS Fargate from day 1** (EKS, Lambda and App Runner explicitly rejected)
- ⊘ T4: Team size and experience — *out of Quick scope*

### Section T2: Programming Languages
- [x] T5 [CORE]: Required languages → **Python >= 3.14 · TypeScript 5.x · PostgreSQL >= 17** (two-language architecture; TS-everywhere evaluated and rejected)
- ⊘ T6: Permitted languages — *out of Quick scope*
- [x] T7 [CORE]: Prohibited languages → **Java, C#, C/C++, Ruby, Pascal** (all: no team expertise). **Go = deferred, not banned.** Angular moved to T10 (it is a framework). Default policy: deny-by-default outside the T5 three

### Section T3: Frameworks and Libraries
- [x] T8 [CORE]: Required frameworks → **FastAPI · Pydantic v2 · SQLAlchemy 2.0 + asyncpg · Alembic · Procrastinate · React 19 + Vite · TanStack Query · Tailwind + shadcn/ui · RN + Expo · Expo Router · SQLite (encrypted, lib TBD) · openapi-typescript**. Architectural calls: **job queue lives in PostgreSQL** (transactional enqueue, no Redis) and **Vite, not Next.js** (no second Node runtime)
- ⊘ T9: Preferred frameworks — *out of Quick scope*. **Reconfirmed by the user on 2026-08-01**
  after being offered a Quick+T9 upgrade; declined. Partially absorbed by T8, which already records
  admissible alternatives (Celery + SQS with an own outbox table in place of Procrastinate; the
  encrypted-SQLite library left open). Second-order libraries (HTTP client, structured logging,
  date/money handling, charting, mobile local state) therefore remain **undeclared** — AI-DLC will
  reach for its defaults there.
- [x] T10 [CORE]: Prohibited libraries → **20 rows in 3 blocks** (A: breaks the system · B: breaks
  decisions already taken · C: hygiene). ⚠️ **AI-proposed / user-approved** — the single exception
  to this interview's no-pre-fill policy, made at the user's explicit request. Block A is
  non-negotiable; block C is opinionated and may be trimmed. Every row carries reason + alternative
  (T10 validation rule satisfied). Highlights: **no `float` for money**, **no `BackgroundTasks` as a
  queue** (would silently drop the WhatsApp evidence of anti-fraud control #2), **no tenant filtering
  in the Python layer** (RLS is the isolation boundary), **no `python-jose` / `passlib`** (both leak
  in from the official FastAPI tutorial), **no AsyncStorage for tokens or business data**

### Section T4: Cloud Services
- ⊘ T11, T12 — *out of Quick scope*

### Section T5: Architecture and Patterns
- [x] T13 [CORE]: API style → **A · REST described with OpenAPI**, single style, no mix. Consistent
  with T8 (`openapi-typescript` presupposes OpenAPI). GraphQL rejected (field-level authorisation is
  added risk under multi-tenant isolation), gRPC rejected (browsers need a proxy; no internal
  microservices), event-driven rejected as the public API (the collector needs an immediate answer).
  **Clarified during the interview:** the offline batch upload is *not* a style mix — it is a REST
  endpoint whose body is a list. **WebSocket/SSE deliberately not adopted**: the C-83 dashboard
  refreshes by polling; at 30–40 users that is sufficient and costs no new infrastructure. Reopen if
  the real-time requirement hardens
- [x] T14 [CORE]: Data patterns → **A · Relational only — one database, PostgreSQL, for everything.**
  ⚠️ AI-proposed / user-approved (second approved exception to the no-pre-fill policy; the user
  declared no prior knowledge of the patterns and asked for explanation + recommendation).
  Rejected: **C** (Redis by another name, already dropped in T8), **D** (1.200 clients — `pg_trgm`
  suffices; reconsider at hundreds of thousands), **E** (a precomputed summary table refreshed by a
  Procrastinate periodic task beats a volatile cache — it is backed up, survives restarts and is
  auditable). Accepted with nuance: **B as `JSONB` columns**, not a second database; **F as a
  pattern, not as Kafka**. Two binding design commitments + one item outside the list:
  - **Append-only ledger** — the movements table takes `INSERT` only; never `UPDATE`, never
    `DELETE`. A wrong payment is fixed by a **compensating reversal entry**, both visible. Balance
    is the **sum of movements**, not an editable number. Enforced by PostgreSQL permissions. This is
    C-99 translated into a technical constraint — it is what makes the product anti-fraud rather
    than a collection CRM.
  - **`JSONB`** for variable-shape data: per-tenant config, raw WhatsApp webhook payloads kept
    verbatim, audit before/after snapshots.
  - **S3 for ID photos** — never in the database; the table stores reference + hash only.
  - **Offline sync engine → OWN COMMAND QUEUE** (resolved 2026-08-01, AI-proposed / user-approved).
    WatermelonDB, PowerSync and ElectricSQL rejected — not on maturity or price, but because they
    **replicate state** while this system must transmit **intents the server validates**. Letting a
    device write straight into the ledger makes the collector the author of the accounting record
    instead of the audited subject, and "last write wins" would resurrect money the server had
    already reversed. The need is also asymmetric: download = the day's route (small, read-only),
    upload = an ordered command list. Binding order rules: **ordering per aggregate, not global**
    (mandatory only between operations touching the same loan or cash box — the D-02 fractional
    counter depends on sequence), and **a rejection does not block the queue** (only operations on
    the same loan wait). Mandatory test scenarios: airplane mode all morning · app killed
    mid-upload · **device clock changed by hand** · duplicate upload after a network drop ·
    out-of-order arrival.
- ⊘ T15, T16 — *out of Quick scope*

### Section T6: Security
- [x] T17 [CORE]: Authentication method → **B · JWT issued by our own auth service.** A (Cognito /
  Auth0) rejected because **device binding must be written in-house either way** — no provider ships
  it — and wiring it into Cognito needs Lambda triggers, more surface to debug. C and D never
  applied (users are people with phones and browsers, not services). Cost accepted: password
  storage, recovery, lockout and session expiry are maintained in-house.
  **Session design (AI-proposed / user-approved), two separate mechanisms:**
  - **Local unlock** — PIN or biometrics (`expo-local-authentication`) **decrypts the local SQLite**.
    Validates nothing against the server, so it works with no signal. This is what lets a collector
    start work at 7am offline.
  - **Server authentication** — the **device key pair replaces the refresh token**: the phone signs a
    server challenge with the private key held in the Keystore, the server verifies it against the
    registered public key and issues a **short-lived access token** for that sync. **No stealable
    persistent credential lives on the device**; revoking a device is deleting its public key,
    effective immediately (covers part of C-71). The **password is required at device enrolment and
    periodically while online**, not every morning — satisfying the client's requirement without
    blocking field work.
  - **Non-negotiable rule: `tenant_id` comes from the verified token**, never from a header or
    request body. It is the value feeding PostgreSQL RLS; if the client could influence it, tenant
    isolation collapses and the T10 prohibitions become pointless.
  - **Web: `httpOnly` + `Secure` + `SameSite` cookie, never `localStorage`** (closes the item T13
    deferred). **HS256 with `PyJWT`** (`python-jose` banned in T10); the secret lives in the secret
    store → T20.
  - ⚠️ Business decision raised and handed to the client as **`OQ-F-99` (P0)**: what happens to
    unsynced operations on a revoked device — rejecting them destroys records of money that really
    moved; quarantine for admin review is the proposed middle ground.
- ⊘ T18, T19 — *out of Quick scope*
- [x] T20 [CORE]: Secrets management → **A · AWS Secrets Manager for every secret**, not split with
  Parameter Store. Non-sensitive configuration stays as ordinary environment variables — the rule
  being that only what compromises the system when leaked goes in the secret store, because if
  everything is treated as critical nothing gets the attention it deserves. Access from ECS Fargate
  via IAM role, no stored credentials; **AWS↔AWS always by IAM role**, which shrinks the inventory to
  three real secrets (PostgreSQL password, JWT signing key, WhatsApp API token) — *the safest secret
  is the one that does not exist*. Automatic rotation enabled for the PostgreSQL password (AWS ships
  the rotation function); manual scheduled rotation for the rest. Split rejected on uniformity, not
  cost (~4 USD/month): two stores mean two mental models, two IAM policy sets and two places to look
  when nothing starts at 7am — the same criterion that removed Redis in T8.
  - **Implementation decision:** the **JWT signing key is fetched at runtime with a short cache**,
    **not injected at container start**. ECS injects secrets at task start, so a rotated secret never
    reaches a running container until redeploy — acceptable for the DB password, not for the signing
    key, whose **key overlap (T17)** must work without restarting anything. Swapping the key outright
    invalidates every issued token and throws out every connected user at once; a collector mid-route
    would just see sync fail.
  - **Operational warning:** deleting a secret leaves AWS holding the name for 7–30 days, blocking
    recreation with the same name — this breaks tear-down/rebuild cycles in IaC. Force-delete without
    recovery exists; it must be known in advance.
- ⊘ T21: Compliance framework — *out of Quick scope*

### Section T7: Testing
- [x] T22 [CORE]: Test types required → **ALL SIX mandatory** — unit, integration, contract, E2E,
  performance, security (SAST/DAST). User's declared position: *"el sistema debe ser altamente
  testeable"*.
  - **Contract testing has a non-standard justification here**: the mobile app ships through the app
    stores, so old versions stay installed on collectors' phones for weeks. The API must remain
    compatible with versions already in the field, and **no other test type catches breaking that**.
    `openapi-typescript` checks types at compile time, which only protects code compiled today.
  - **D must be scoped** to a short, untouchable list of critical flows or it rots (slow and brittle;
    covering everything trains the team to ignore red). Candidates: offline payment + sync · cash box
    closing · 4-step sale approval with QR. **Concrete list still to fix.**
  - **E is not executable** — performance tests are mandatory but **no target exists**. Raised as
    `OQ-N-44` (P1). A test that cannot fail is not a test.
  - **"Highly testable" recorded as four binding design constraints**: money maths in **pure
    functions** (no DB, no network, no clock); **the clock is injected, not invoked** (reinforces the
    T10 ban on `datetime.utcnow()` — otherwise arrears, day close and the Mon–Sat frequency cannot be
    tested without changing the machine's time); **integration tests need a real PostgreSQL** because
    RLS, transactions and the uniqueness constraint behind idempotency exist nowhere else; **the
    mobile command queue is written separately from React Native** so the five T14 scenarios are
    ordinary fast tests instead of emulator runs.
- ⊘ T23, T24 — *out of Quick scope*
- [x] T25: CI/CD gates — **PULLED INTO SCOPE 2026-08-01** at the user's choice → **E · all gates
  mandatory, split across two tiers.**
  - **Per change, blocks the merge** (minutes): types and formatting · unit · **integration against a
    real PostgreSQL** · SAST + dependency scan · **OpenAPI contract compatibility check** · code
    review approved.
  - **Before release, blocks the deploy but not the merge** (tens of minutes): E2E over critical
    flows · performance against the `OQ-N-44` target · DAST.
  - **Why split:** E2E and performance are slow and **fail sometimes when nobody broke anything** —
    a timeout, a slow browser, a container that started late. Gating every merge on them teaches the
    team to retry until green within three weeks, and the gate stops meaning anything. This is how
    test discipline usually dissolves: not from missing tests, but from gates people learn to ignore.
  - The **contract compatibility check belongs in the fast gate**: diff the change's OpenAPI against
    the published one and fail on a breaking change. It is the only thing standing between an
    innocent change and **the app versions collectors already have installed**, which cannot be
    updated at once because they ship through the stores.

### Section T8: Example Code Patterns
- ⊘ T26–T29 — *out of Quick scope*

### Existing System
- ⊘ TB1–TB4 — *not applicable (Greenfield)*

## Progress

**13 / 13 answered — interview complete.** Sections T1, T2, T3, T5, T6 and T7 complete

Out of Quick scope: T4, T6, T9, T11, T12, T15, T16, T18, T19, T21, T23, T24, T26–T29.
Not applicable (Greenfield): TB1–TB4.

## Open technical risks raised during this interview

- **Encrypted on-device SQLite (T8)** — unresolved tension between `mobile-platform-constraints.md`
  rule 2 (prefer Expo SDK libraries → `expo-sqlite`) and mandatory at-rest encryption for ID
  photos and financial data (→ `op-sqlite` + SQLCipher). **Verify at project setup. Do not assume
  `expo-sqlite` encrypts.**
- **Charting library undeclared (T10)** — no charting library was chosen (T9 out of scope), so none
  could be prohibited either. The C-83 dashboard needs one. Left open on purpose: prohibiting
  without a declared alternative would leave AI-DLC with no way out. **Decide at project setup.**
- ~~Offline sync approach~~ — **CLOSED in T14**: own command queue, tools rejected because they
  replicate state rather than transmit validated intents. The risk is no longer "which engine" but
  **execution quality**: this code is written in-house and the five mandatory test scenarios are
  where it will fail if rushed.

## Scope gaps to carry into the join

- ⚠️ **T21 (compliance framework) was left out of the Quick pass**, but the product handles **ID
  document photos** and third-party financial data. If the country turns out to be Brazil (`CX-11`
  unresolved), **LGPD applies**. The Quick-pass exclusion was a depth decision, not a finding that
  no framework applies.

## Binding constraints produced by this interview

- **`interview/technical/mobile-platform-constraints.md`** — the six rules that keep Expo SDK
  upgrades cheap, plus the maintenance calendar. Recorded at the user's explicit request during
  T5. **Binding, not advisory**: AI-DLC must honour these when generating mobile code. Merges
  into `technical-environment.md` §Frameworks at completion.

## Conflicts with prior artefacts

- ⚠️ **`technical-research/recomendacion-tecnica.md` needs revision 3.** T2 and T5 overrode it:
  it proposed Supabase + Fly.io + Cloudflare R2 (§5.3) against the chosen **AWS**, and
  TypeScript + NestJS everywhere (§4.1, §4.2, §4.13) against the chosen **Python + FastAPI**
  backend with TypeScript only on the client side.

## New information surfaced during the technical interview

- **2026-08-01 (T3)** — The user stated the real initial scale: **30–40 users and 1.200 end
  clients**. This is business information that was never in the client material. It does not
  close `CX-19` (the "5.000" of C-05 — still unclear whether tenants or clients), but it gives a
  concrete basis for phase-1 sizing: ~1.200 payment registrations/day, ~3/minute at peak.
  **Carry this into the join stage and confirm it with the client.**
- **2026-08-01 (T3)** — Verified by the user: **AWS App Runner is not available in `sa-east-1`**.
- **2026-08-01 (T17)** — ⚠️ **New client requirement, NOT implementable as worded.** The user
  reported that the client wants *"a user tied to the IP of their phone, plus a password"*.
  **An IP address does not identify a device**: mobile carriers use CGNAT so thousands of
  subscribers share one public IP; it changes many times during a single route as the phone moves
  between cells and WiFi; **there is no IP at all while offline**, which is exactly when operations
  are created; and a free VPN changes it in seconds, so it stops legitimate users without stopping
  anyone determined. **IMEI is not an alternative** — Android blocked it for apps from version 10
  and iOS never exposed it.
  **Translation the technical role proposes**: the client is describing **device binding**, which is
  already a recorded requirement (**C-70, one device per route**) and is stronger than any IP check.
  Implementation: a **key pair generated on the device at first launch**, private key held in
  Keychain/Keystore via `expo-secure-store` (already fixed by T10) and never leaving it; every
  request signed with it; the server keeps user ↔ device, status, registration date **and who
  authorised it**. A login attempt from another handset is an **audit event requiring explicit
  admin approval**, not a convenience.
  **Consequence that needs a client decision**: uninstall/reinstall destroys the key, so the device
  stops being recognised. That is the desired property, not a bug — but it **requires a
  re-authorisation flow**, otherwise a phone that breaks on a Saturday leaves the collector unable
  to work.
  **IP is still recorded** — as audit metadata alongside the device id and the two timestamps, never
  as an access control.
  **Carry to the join and confirm with the client.**

## Notes carried into this interview

Constraints already fixed by the Business role that the Technical role must respect (they are
inputs, not questions):

- **D-01** — the system never custodies funds. The only real money flow is SaaS billing, **web only**.
- **D-02** — fractional instalment counter on partial payments; immutable audit is the product's
  reason to exist (C-99); cash box closes only at zero pending (C-50); offline field work is
  mandatory (C-65); one device per route (C-70).
- **D-03** — MVP = full collector app + minimal admin web *(team position, pending client sign-off)*.

Open technical questions that this interview does **not** resolve because they are blocked on the
client: `CX-11` (country → data residency, `OQ-N-25`), `CX-16` (WhatsApp Business API),
`CX-19` (scale: 5.000 tenants or clients), `CX-20` (TryController has no export).
