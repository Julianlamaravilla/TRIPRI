# Requirement Verification Questions

This document consolidates the remaining **P0 (Priority 0 - Blocking)** questions from the discovery phase that must be resolved before Inception can proceed to design.

**Status**: Waiting for answers
**Depth**: Comprehensive (complex, multi-tenant, high-risk SaaS)
**Language**: Conversational mode

---

## Functional & Business Requirements

### Q1 [CORE]: Product Name and Branding

**Status**: Open since 2026-07-28 (OQ-B-1)

The product does not yet have a formal name. The client delegates naming to the development team.

**Current state**: Referred to as "sistema de gestión de cobranza y antifraude" or "TRIPRI" (internal codename).

**What we need**: 
- A formal product name for branding, documentation, and app store listings (Apple App Store and Google Play both require product names)
- Consider: bilingual implications (Portuguese for Brazil market, English for tech documentation)

**Options:**

A) Use a proposed name (you suggest one and we adopt it)

B) Keep internal codename ("TRIPRI") as the public name

C) Use a generic name like "Cobrador" (Spanish) or "Gestor" (Spanish)

X) Other (describe your preference)

[Answer]: X) ROYEXA

---

### Q2 [CORE]: Subscription Plans and Pricing

**Status**: Partial (OQ-B-4 - model scoped but no prices)

The document identifies a **tiered weekly model** with estimated cost of ~$430–470/month (WhatsApp consuming 61%), but **no prices are declared**.

**Key constraints**:
- ~$43/enterprise/month infrastructure cost
- WhatsApp Cloud API: ~$212/month
- Must work for small financieras (initial: ~50 customer routes)

**What we need**:
- Monthly price for **Plan Básico** (Basic plan for 50-customer routes)
- Monthly price for **Plan Profesional** (for larger operations)
- Which features are included in each plan (especially WhatsApp messaging - is it in Básico or professional-only?)
- Billing frequency (monthly, quarterly, annual)?

**Current assumption** (from C-04):
- Plan Básico: ~$35 (covers 50 routes + WhatsApp for base features)
- Plan Profesional: ~$100+ (for advanced features + unlimited routes)

**Please confirm or provide your price structure:**

[Answer]: Plan Básico $Reales 35 , Plan Profesional $Reales 55

---

### Q3 [CORE]: Success Metrics (Measurable)

**Status**: ⬜ Open — third failed attempt (OQ-B-7)

Attempts to establish measurable success metrics have failed three times:
- C-07: *"by number of subscribers"* (not causally linked to success)
- V-22: No answer provided
- B-04: *"depends on collector, we don't have a number"* (unmeasurable)

**Why this matters**: In 6 months, there will be no verifiable way to declare success. An antifraude system that cannot measure fraud reduction is a contradiction.

**What we need**:
A measurable baseline and target for **at least one metric** the system can track from day 1. Candidates identified in discovery:

- **Cash reconciliation mismatches per month** (descuadres de caja) — *recommended*
  - Measurable from day 1 (even if baseline is "unknown")
  - Directly linked to the stated problem (C-99)
  - Example target: reduce from X descuadres/month to Y

- **Internal fraud losses per month** (dinero perdido por fraude interno)
  - Depends on honest client reporting (may underestimate)
  
- **Payment registration complaints** (reclamos por pago mal registrado)
  - Captured via WhatsApp extraction process (system can log)

- **Admin daily close time** (tiempo de cierre diario)
  - Automatically measurable; high correlation with usability

- **Portfolio delinquency** (mora de la cartera)
  - Proxy for system adoption effectiveness

**Which ONE metric do you commit to track and improve?**

A) Cash reconciliation mismatches per month

B) Internal fraud losses per month

C) Admin daily close time (in minutes)

D) Portfolio delinquency rate

X) Other (specify your metric)

[Answer]: A, B and Low latency

---

### Q4 [CORE]: Written Budget Approval

**Status**: Partial (OQ-B-9 - agreed verbally, not in writing)

The client stated (in call notes, not in writing) that they approved ~$430–470/month operational budget, but **there is no written confirmation**.

**Why this matters**: 
- This directly funds WhatsApp integration (the two core antifraude controls)
- Without written approval, the team risks deploying to an unsustainable operational cost

**What we need**:
- Written confirmation from client leadership that the ~$430–470/month AWS + WhatsApp budget is approved
- OR if budget needs adjustment, new approved amount in writing

**Options:**

A) Budget is approved as stated (~$430–470/month)

B) Budget needs to be renegotiated (provide target number)

X) Other

[Answer]: x) 555 Aprox per month

---

## Technical Requirements & Design Decisions

### Q5 [CORE]: Artificial Intelligence in MVP (v1)?

**Status**: Open (CX-30 — deferred decision)

The vision document (V-08, B-06) proposed **AI-assisted credit scoring**. It was later (D-05) moved to **Future Phases ("AI en fase futura")**. However, the question **"is AI in scope for MVP v1?"** was deferred rather than decided.

**Context**:
- Current scoring is manual (client does it by hand per C-12)
- Bedrock is available in sa-east-1 (confirmed by tech lead, T10)
- 7 functional requirements depend on this answer (OQ-F-67…OQ-F-73)
- Cost impact: Bedrock adds ~$X/month to operations

**What we need**:
Does the MVP must include **any form** of AI assistance (even if only for scoring), or is **100% manual scoring** acceptable for v1?

**Options:**

A) AI-assisted scoring IS in v1 MVP (basic Claude prompt for credit scoring)

B) AI-assisted scoring is in v2+ only (full manual scoring in v1)

C) Conditional: only include if it costs <$50/month to operate

X) Other (describe your requirement)

[Answer]: B

---

### Q6 [CORE]: Resource-Level Permission Matrix

**Status**: Open and P0 (CX-40 — declared without resolution path, 2026-08-08)

D-05 established that **admin users can delegate permissions to secondary admins**. This creates an authorization layer within each tenant. However, **the scope is undefined**:

**Options described in open questions**:
- **Exception-based** (CX-40 option A): Role-based access control with exceptional overrides per resource
  - Example: "Admin can create loans, but NOT approve loans > $500"
  - Simpler to build, but needs business rules pre-defined
  - Estimated: 1 if statement in code

- **Matrix-based** (CX-40 option B): Full permission matrix (user × resource × action)
  - Example: Admin A can {create, read, approve} loans; Admin B can {read, approve} but NOT create
  - Complex: requires permission tables, UI builder, potentially a full module
  - Estimated: 1+ month design + implementation

**Current constraint**: Team is one person (CX-27).

**What we need**:
Which model fits your operational reality?

**Options:**

A) Exception-based (role + overrides) — simpler, fewer moving parts

B) Matrix-based (full permission table) — powerful, but requires significant build

C) No permission delegation — all secondary admins get the same permissions as primary

D) Defer to v2 — v1 has basic role-based access only (primary admin, cobrador, partner read-only)

X) Other (describe your model)

[Answer]: B

---

### Q7 [CORE]: Currency and UI Language Formalization

**Status**: Partial (CX-11 — noted but not formally decided)

The system treats **Real (BRL)** as implicit (Brazil, V-01). However, **no formal decision exists** on:
- What happens if the product expands to other Latin American countries (C-02 mentions Argentina, Paraguay, Colombia as future)?
- Whether the UI is locked to Spanish or can support Portuguese (client's market is Brazil, but tech documentation in English)?

**Current implicit state**:
- Currency: BRL (inferred from V-01 Brazil context)
- UI Language: Spanish (specified in V-01)
- API/Code Language: English (specified in technical-environment.md)

**Impact on design**:
- If locked to BRL+Spanish: simpler, no multi-currency or i18n infrastructure needed
- If flexible: requires currency table, locale detection, translation strings — non-trivial foundation work

**What we need**:
Is this v1 **locked to BRL + Spanish** (definitive), or should we **design for multi-currency/multi-language from day 1**?

**Options:**

A) v1 is locked to BRL and Spanish (definitive, no multi-locale support needed)

B) v1 must support BRL but design for future localization (Portuguese, etc.)

C) v1 must support multiple currencies (BRL, ARS, COP, etc.) — expansion is a v1 requirement

X) Other

[Answer]: A

---

## Non-Functional Requirements & Implementation Approach

### Q8 [CORE]: Test Automation Gates — Local vs. Staging

**Status**: Open — resolves CX-39 (conflicting gates)

Technical environment specifies **six test types as mandatory** (T22: unit, integration, contract, E2E, performance, security/SAST).

However, **CI/CD gates present a blocker**:
- T25 declares: E2E + performance + DAST must **block deployment**
- T32 declares: **No staging environment** (to save cost under single-developer constraint)

**Result**: The "slow gate" (E2E + performance + DAST) has nowhere to run without staging.

**Current mitigation** (T32 footnote):
- E2E and DAST run against **local Docker Compose stack** (not production-equivalent)
- Blocks deployment quality but unblocks the gate

**What we need**:
Does this mitigation satisfy your risk tolerance, or should we:

A) Accept the mitigation: run tests on local stack, E2E/DAST don't measure production latency

B) Add a staging environment (~$40–50/month) to test against production-equivalent infrastructure

C) Remove E2E/DAST from deployment gates (keep them as post-release monitoring)

X) Other approach

[Answer]: B

---

### Q9: DPIA / Data Protection Impact Assessment

**Status**: Pre-required for LGPD (T21)

The system handles **fotos de documentos de identidad** (identity photos) and is subject to **LGPD**.

**Prerequisites not yet addressed**:
- No formal DPIA (Data Protection Impact Assessment) exists
- No data retention policy written
- No incident response plan documented
- No DPO (Data Protection Officer) designated

**Question**: Should these be prerequisites for Inception completion, or should they be **documented as work items in the Construction phase**?

**Options:**

A) Complete a formal DPIA before Inception closes (blocking)

B) Document DPIA, retention policy, and incident response as work items in Requirements

C) Treat as post-launch compliance work (v1.1 or v2)

X) Other

[Answer]: C

---

### Q10: Deployment & Release Cadence

**Status**: Not yet declared (implied: on-demand, no schedule)

**What we need to clarify**:
- **Release frequency**: On-demand (as soon as code is ready)? Weekly? Monthly?
- **Change window**: Is there a preferred time window for deployments (e.g., Sunday nights)? Or 24/7 deployments allowed?
- **Rollback procedure**: How quickly must a bad deploy be reverted? How long is acceptable downtime?

**Options:**

A) On-demand deployments, 24/7 allowed (fastest iteration)

B) Weekly releases on Sunday evenings (v1.0.0 on Sundays, hotfixes as needed)

C) Monthly releases (v1.1 on the 1st of each month)

X) Other cadence

[Answer]: A

---

## Clarification on Existing Decisions

### Q11: Confirmation — Two Antifraude Controls

**Status**: Clear (C-99, D-02, but confirming for Requirements)

The system's core value is preventing **two specific frauds**:

1. **Cobrador registra pago pero no entrega dinero** → Controlled by **QR al WhatsApp** (venta en 4 pasos, C-31)
2. **Cobrador cobra y no registra** → Controlled by **extracto por WhatsApp al cliente final** (C-99)

**Confirmation question**: Are these **both non-negotiable** for v1? Or could v1 launch with just one control if the other (WhatsApp integration) faced delays?

[Answer]: 1 And 2

---

### Q12: Confirmation — Offline-First Mobile

**Status**: Clear (C-65, T5, but confirming)

Cobradores work without mobile signal for entire mornings. The app must:
- Work completely offline
- Queue operations locally (SQLite)
- Sync when signal returns

**Confirmation**: This is **non-negotiable for v1**? Or is online-only acceptable if "some routes have better coverage"?

[Answer]: Sync when signal returns

---

## Instructions for Completion

1. **Fill in each [Answer]: tag** directly in this document
2. **For multiple-choice options**, write just the letter (A, B, C, X) or the letter + brief rationale
3. **For open-ended questions**, write a sentence or two
4. **When done**, reply to me with the word **`ready`** (just that word, in a separate message)
5. I will validate your answers, ask follow-ups if needed, and we'll proceed to the **Requirement Document** generation

**Do not skip questions.** Each P0 blocks subsequent phases.
