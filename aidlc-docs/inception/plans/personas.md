# User Personas — ROYEXA v1

---

## Persona 1: Gabriel Cobrador (Field Collector)

**Archetype**: Blue-collar, field-based, low tech literacy

### Profile

| Attribute | Value |
|---|---|
| **Age** | 32 |
| **Education** | High school |
| **Tech Experience** | Android phone user for WhatsApp/messages, minimal apps |
| **Language** | Spanish (Brazil) |
| **Work Context** | Solo, routes routes (C-70 one device per route) |
| **Daily Tools** | Android smartphone (assigned by company), no laptop |
| **Pain Point** | "My boss doesn't trust me. I collect the money, but he never believes me." |

### Goals

1. **Collect money efficiently** — Complete daily route quickly
2. **Have proof** — Show his boss (and customers) that he did his job
3. **Stay connected** — Know when customers will be home before riding to them
4. **Avoid fraud accusations** — Prove he didn't keep money that wasn't his

### Frustrations

- Manual Excel lists + calls to boss (what I use now with TryController)
- Losing phone battery in the field (6–8 hours offline is normal)
- Customers don't believe him when he says "paid, pending registration"
- Boss won't approve a new loan until all prior loans are paid 100% (system enforces this, C-28)

### Success Criteria

✅ Register a payment in <3 taps while standing at customer's door
✅ Know system registered payment even without signal
✅ Customer receives WhatsApp proof within 10 seconds of caja closing
✅ Boss sees his route is completed (not "pending customers")

### Typical Day

**6 AM**: Opens app (PIN enters locally into SQLite, offline mode)
**6–11 AM**: Visits 20–30 customers, registers 10 payments, 5 "no payments", 3 promises-to-pay
**11 AM**: Returns to hub, phone connects to WiFi
**11:05 AM**: App syncs 18 operations to server
**11:10 AM**: System shows "All synced ✅" — customers get WhatsApp receipts
**11:15 AM**: Gabriel and boss review cash caja closing together

---

## Persona 2: Patricia Admin Primaria (Primary Admin / Operations Manager)

**Archetype**: Manager, risk-averse, compliance-focused

### Profile

| Attribute | Value |
|---|---|
| **Age** | 45 |
| **Role** | Operations manager, business owner |
| **Tech Experience** | Comfortable with web apps, Excel, email · has laptop |
| **Education** | Business degree, accounting knowledge |
| **Language** | Spanish (Brazil) |
| **Work Context** | Office-based, oversees 3–5 collectors |
| **Pain Point** | "I need to know WHERE the money is, and I can't trust people." |

### Goals

1. **Control and approve** — Every sale must pass me before money is released (C-31, QR approval)
2. **Detect fraud** — Identify mismatches between cash and register (C-99, descuadres)
3. **Delegate safely** — Create supervisors and give them only what they need to see
4. **Forecast cash** — Know by end of day if we met collection targets
5. **Sleep at night** — System immutable so nobody can edit records and hide fraud (C-99)

### Frustrations

- TryController doesn't block sales until they're approved (she uses phone calls, slow)
- No way to know which supervisor stole money vs. collector
- Employee creates "fake entries" by editing Excel later
- Reporting is manual (copy-paste from TryController to Excel)

### Success Criteria

✅ QR approval flow is fast (<30 sec per sale review)
✅ Can delegate approvals to a trusted supervisor without losing control
✅ Cash mismatch detected same day (not days later in reconciliation)
✅ Immutable audit trail proves who did what and when
✅ Dashboard shows metrics in real-time (not batch reports)

### Typical Day

**7 AM**: Arrives at office, opens ROYEXA dashboard
**7–10 AM**: Reviews overnight sync; any descuadres? Any failed approvals?
**10 AM**: Creates new secondary admin for a trusted supervisor (matrix permissions)
**11 AM–12 PM**: Approves 8 sales via QR (each takes 20 seconds)
**1 PM**: Closes first collector's cash caja (descuadre = 0 ✅) — excellent
**2 PM**: Closes second collector's cash caja (descuadre = 150 BRL short) — investigates, flags
**4 PM**: Admin dashboard shows "1 descuadre today" (metrics #1)
**5 PM**: Exports weekly report, shows business owner

---

## Persona 3: Marcus Admin Secundario (Secondary Admin / Supervisor)

**Archetype**: Trusted employee, limited authority, audited

### Profile

| Attribute | Value |
|---|---|
| **Age** | 28 |
| **Role** | Supervisor, junior admin |
| **Tech Experience** | Moderate web apps, some accounting software |
| **Education** | High school + on-job training |
| **Language** | Spanish (Brazil) |
| **Work Context** | Office or field-adjacent, oversees 1–2 collectors |
| **Pain Point** | "I can approve sales, but Patricia doesn't want me to see everything" |

### Goals

1. **Authorize sales** — Approve collector's sales up to a limit ($500/day, configurable)
2. **View own collectors** — See only the routes he supervises (T10 RLS)
3. **Help collectors** — Reset a PIN if collector loses it, etc.
4. **Stay audited** — Know his actions are logged (he could be blamed if fraud happens)

### Frustrations

- Permissions are unclear (can I see other supervisor's routes? No idea)
- Can't approve sale over limit, always has to call Patricia (bottleneck)
- If money goes missing, admin says "it was Marcus's fault" but no proof in system

### Success Criteria

✅ Permissions matrix is clear (can do X, cannot do Y)
✅ Action requires approval from Patricia (e.g., change collector PIN)
✅ Audit log shows exactly what I did and when (proof for legal defense)
✅ Can approve sales <$500 without calling Patricia (autonomy)

### Typical Day

**9 AM**: Arrives, checks inbox for pending approvals
**9–10 AM**: Reviews his 2 collectors' routes
**10:30 AM**: Gabriel (collector) calls: "Can you approve a $250 sale?"
**10:31 AM**: Marcus logs in, sees the sale, approves (within his $500/day limit)
**10:32 AM**: QR sent to customer (Marcus is 1 of 3 approvers in chain, C-31)
**4 PM**: At end of day, audit log shows "Marcus approved 4 sales, total $1.200 — all within limits"

---

## Persona 4: Felipe Socio (Partner / Business Owner)

**Archetype**: Executive, read-only, strategic

### Profile

| Attribute | Value |
|---|---|
| **Age** | 52 |
| **Role** | Business owner, investor |
| **Tech Experience** | Email, maybe looks at web reports |
| **Education** | Accountant or business degree |
| **Language** | Spanish (Brazil) |
| **Work Context** | Occasional office visits, mostly remote |
| **Pain Point** | "Is the money where it should be?" |

### Goals

1. **Know portfolio health** — Delinquency rates, collection rates, fraud losses
2. **Verify cash** — Confirm collections match ledger (no fraud)
3. **Delegate** — Trust Patricia (admin) to run day-to-day, but verify quarterly
4. **Simple reports** — Don't want a 50-tab Excel, just key numbers

### Frustrations

- TryController doesn't give him the reports he needs (manual extraction)
- "Who stole the money?" is a guessing game (no immutable audit trail)
- Quarterly review takes Patricia 2 days of work (data extraction)

### Success Criteria

✅ Dashboard shows collection rate, delinquency, fraud losses (KPIs)
✅ Can filter by collector/route (forensics if needed)
✅ Immutable audit trail (can prove if money went missing)
✅ Monthly report auto-generated, not hand-crafted

### Typical Day

**Usually**: Checks dashboard monthly, not daily
**End of month**: Receives auto-generated report (collections, delinquency, fraud metrics)
**Quarterly review**: Meets with Patricia, reviews KPIs for growth/profitability

---

## Persona 5: Dolores Cliente Final (End Customer / Debtor)

**Archetype**: Low-income, suspicious, needs proof

### Profile

| Attribute | Value |
|---|---|
| **Age** | 35 |
| **Literacy** | Basic (reads Spanish well, uses WhatsApp) |
| **Tech Experience** | WhatsApp user, no apps |
| **Language** | Spanish (Brazil) |
| **Work Context** | Informal work (day labor, vendor), cash income |
| **Pain Point** | "Collector says I paid, but I have no proof." |

### Goals

1. **Have proof of payment** — Can show WhatsApp message if there's a dispute
2. **Know what I owe** — SMS/WhatsApp shows next payment date and amount
3. **Trust the system** — Payment goes to the right company (not collector's pocket)
4. **Avoid overpaying** — Know exactly how much is left to pay

### Frustrations

- With old system: collector says "you paid" → no proof in account
- Customer/collector dispute → company sides with employee
- No way to know what she owes (collector says different number each time)
- WhatsApp isn't available (she uses it), she just gets paper receipts

### Success Criteria

✅ Receives WhatsApp message within 10 seconds of payment (real-time)
✅ Message shows: amount paid, balance left, next date
✅ Can show WhatsApp to collector if there's a dispute (proof)
✅ If she pays extra, system shows "credit" (she gets money back)

### Typical Day

**Morning**: Collector (Gabriel) visits
**"I paid 30 real last week"**: Dolores disputes, Gabriel says "let me ask boss"
**Same day, 11:05 AM**: Dolores gets WhatsApp: "Payment of 30 BRL received. Balance: 420 BRL remaining. Next due: [date]"
**Proof**: She shows WhatsApp to collector if he disputes again

---

## User Persona Relationships & Workflows

```
ROYEXA Multi-Tenant Architecture

Tenant (Financiera)
│
├── Felipe (Socio) ─┐
│                   ├─→ Dashboard (read-only KPIs)
├── Patricia (Admin Primary) ─┐
│                             ├─→ Web App (approvals, delegation, reporting)
├── Marcus (Admin Secondary)  ┤
│       (created by Patricia)  ├─→ Web App (limited permissions)
│
├── Gabriel (Cobrador) ───────┐
│ (device assigned by Patricia) ├─→ Mobile App (offline-first, sync)
├── [Other Collectors...]      │
│
└── Dolores + 1999 more ───────┴─→ WhatsApp (receipts, alerts)
    (End Customers — no app access)
```

---

## Acceptance Criteria Patterns (by Persona)

### Gabriel (Collector)

**Pattern**: "As Gabriel, I want to [register payment offline], so that [I can prove I did my job even without signal]"

**Acceptance**:
- [ ] Can register payment without internet connection
- [ ] Payment queued locally (SQLite)
- [ ] UI shows "Offline ✓" status
- [ ] When signal returns, payment syncs automatically
- [ ] UI shows "Synced ✓" only after server ACK

### Patricia (Admin Primary)

**Pattern**: "As Patricia, I want to [approve sales with QR], so that [money is only released when I've verified it]"

**Acceptance**:
- [ ] Can see pending sales in dashboard
- [ ] Can approve/reject each sale (comment required for reject)
- [ ] QR generated only after approval
- [ ] QR sent to customer via WhatsApp instantly
- [ ] Audit log shows "Patricia approved sale X at [time]"

### Marcus (Admin Secondary)

**Pattern**: "As Marcus, I want to [have limited permissions], so that [I can do my job but Patricia still has control]"

**Acceptance**:
- [ ] Can see only assigned routes (RLS)
- [ ] Can approve sales up to $500/day (configurable)
- [ ] Cannot create new users (only Patricia can)
- [ ] Cannot see Patricia's audit log (only his own)
- [ ] Audit log shows all his actions

### Felipe (Partner)

**Pattern**: "As Felipe, I want to [see KPIs monthly], so that [I can verify the business is healthy]"

**Acceptance**:
- [ ] Dashboard shows: collection rate, delinquency, descuadres, fraud losses
- [ ] Can drill down by route/collector
- [ ] Monthly report auto-generated, downloadable
- [ ] All numbers match immutable ledger

### Dolores (End Customer)

**Pattern**: "As Dolores, I want to [receive payment proof via WhatsApp], so that [I have proof if there's a dispute]"

**Acceptance**:
- [ ] WhatsApp message sent within 10 seconds of caja closing
- [ ] Shows: payment amount, balance left, next date
- [ ] Message is permanent (can screenshot, forward)
- [ ] Sent to her phone number (configured at loan signup)
