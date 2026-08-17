# User Stories — ROYEXA v1 MVP

**Format**: INVEST-compliant stories with acceptance criteria, edge cases, and audit trail requirements.

**Organization**: By feature area, then by persona.

---

## Feature Area 1: Offline-First Collection (Mobile)

### STORY-001: Register Payment Offline (Gabriel)

**As a** collector (Gabriel)
**I want to** register a payment while offline
**So that** I can prove to the boss I collected the money, even if there's no signal

**Context**: Gabriel works 6–8 hours without cell signal. He needs to register payments locally and sync when connected.

**Acceptance Criteria**:
- [ ] Payment can be registered with no internet connection
- [ ] Payment stored in encrypted local SQLite
- [ ] UI shows "Offline mode ⚠️" indicator
- [ ] Payment queued with state: `pending`
- [ ] When signal returns, payment auto-queues for sync (no manual "sync" button needed)

**Given**: Gabriel is in offline mode (no signal), has customer ready
**When**: He enters payment amount and taps "Confirm"
**Then**: 
- Payment appears in local list (pending)
- UI shows "✓ Saved locally (pending sync)"
- No server request is made
- Payment is NOT confirmed until server ACKs

**Edge Cases**:
- [ ] App closes during payment entry → payment recovery (partial entry lost, but that's OK)
- [ ] Battery dies mid-payment → SQL transaction rollback (no duplicates)
- [ ] Signal returns while registering → stays local until full entry complete
- [ ] User manually changes phone time → timestamp conflict registered in audit trail (not error)

**Audit Trail**:
- [ ] Ledger entry created only after server confirmation
- [ ] Two timestamps: `occurred_at` (device time, informative) + `received_at` (server time, authoritative)
- [ ] If times diverge >1 hour → flag in admin dashboard (potential fraud signal)

**Story Points**: 8 (involves SQLite cipher + queue + idempotency logic)

---

### STORY-002: Sync Payments When Signal Returns (Gabriel + System)

**As a** collector (Gabriel)
**I want to** have my offline payments automatically synced when I get signal
**So that** I don't have to remember to click a "sync" button

**Context**: Gabriel exits the field, arrives at hub with WiFi. His phone auto-syncs pending payments.

**Acceptance Criteria**:
- [ ] When app detects network available, queued payments auto-sync
- [ ] UI shows sync progress ("Syncing 3/5 payments...")
- [ ] Each payment's sync result shown independently (not all-or-nothing)
- [ ] Payment marked `confirmed` ONLY after server ACK (HTTP 201)
- [ ] Failed payment stays in queue for retry (manual sync button available as fallback)

**Given**: Gabriel's phone now has WiFi, app has 5 queued payments
**When**: System detects network is available
**Then**:
- App sends: POST `/sync/operaciones` with 5 operations
- Server returns: `[{id, success, new_balance}, ...]` (one result per operation)
- UI updates each payment's status: `pending` → `confirmed`
- Payment's balance field updates on screen

**Edge Cases**:
- [ ] Server rejects 1 of 5 operations (invalid loan) → other 4 marked confirmed, 1 stays pending
- [ ] Network drops mid-sync → resume from last successful operation (idempotent)
- [ ] Duplicate sync request (network timeout → retry) → server ignores by `idempotency_key` (T14)
- [ ] Server is slow (5+ seconds) → show spinner, don't freeze app

**Audit Trail**:
- [ ] Each sync creates ledger entry marked `synced_at` server timestamp
- [ ] Failed operations logged to `/audit/sync_failures.md` (with reason)

**Story Points**: 5 (queue management, idempotency, result handling)

---

### STORY-003: Cash Box Closing (Gabriel + Patricia)

**As a** collector (Gabriel)
**I want to** close my daily cash box
**So that** I can prove how much money I collected and Patricia can reconcile cash

**Context**: End of route, Gabriel returns to hub. Must close cash box before leaving.

**Acceptance Criteria**:
- [ ] Gabriel opens cash box view (3-panel layout)
- [ ] System shows: [Pending] [Paid] [Not Paid] panels with counts
- [ ] Gabriel can only close if [Pending] panel = 0
- [ ] Gabriel enters: cash in hand (BRL)
- [ ] System shows: registered amount - cash in hand = descuadre (if any)
- [ ] Descuadre logged to ledger (immutable)
- [ ] WhatsApp receipts auto-sent to all customers (extraction, C-99)

**Given**: Gabriel's route has 25 customers (0 pending, 15 paid, 10 no-pay)
**When**: He enters cash = 725 BRL, but system says 750 should be there
**Then**:
- System shows: "⚠️ Descuadre: 25 BRL missing"
- Descuadre logged to ledger (audit trail: Gabriel found 25 BRL short)
- Patricia gets alert: "Descuadre detected: Route 3, 25 BRL short"
- Cash box marked CLOSED (irreversible)

**Edge Cases**:
- [ ] Gabriel doesn't have exact cash (has 720 instead of 725) → shows "5 BRL overage" (possible error in change, OK)
- [ ] Gabriel refuses to report descuadre → system won't let him close until he enters true amount
- [ ] Network goes down mid-close → close completes locally, syncs later (box is actually closed, pending network)

**Audit Trail**:
- [ ] Ledger entry: `cash_box_closing` with Gabriel's ID, amount, descuadre
- [ ] Timestamp: when close was initiated + completed
- [ ] Metric #1 (Q3): Auto-increments "descuadres_this_month" counter (Patricia sees trending)

**Story Points**: 5

---

## Feature Area 2: Approval & QR Flow

### STORY-004: Approve Sale with QR (Patricia)

**As a** primary admin (Patricia)
**I want to** approve a collector's sale with a one-time QR code
**So that** money is only released after I've reviewed it (antifraude control #1, C-31)

**Context**: Gabriel collected payment from Dolores, requests approval. Patricia reviews and approves. QR sent to Dolores. Dolores scans QR with Gabriel's phone to confirm. Money released.

**Acceptance Criteria**:
- [ ] Patricia sees pending sales in web dashboard
- [ ] Can approve or reject each sale (comment required for reject)
- [ ] QR generated ONLY after approval (one-time, 10 min expiry)
- [ ] QR sent to customer via WhatsApp within 5 seconds
- [ ] Collector can show QR to customer (displays on his phone, URL safe)
- [ ] Customer scans QR (or clicks link from WhatsApp) → system shows "✓ Confirmed by [customer name]"
- [ ] Once scanned, money is released to caja (Gabriel can include in daily close)
- [ ] Expired QR cannot be used (10 min window)

**Given**: Gabriel submits sale approval: 100 BRL from Dolores, loan ABC123
**When**: Patricia reviews the sale and clicks "Approve"
**Then**:
- QR generated (contains: tenant_id, sale_id, timestamp_expiry)
- Message sent to Dolores: "Please confirm receipt: [QR image] [URL to scan]"
- Sale status changes: `pending_approval` → `approved_pending_confirmation`
- Gabriel sees in his app: "✓ Sale approved, waiting for customer confirmation"

**When**: Dolores scans QR (or opens link)
**Then**:
- System verifies QR validity (not expired, correct sale)
- Shows Dolores: "¿Confirmar receipt of 100 BRL from [Gabriel]?" with Yes/No
- Dolores taps Yes
- Sale status changes: `approved_pending_confirmation` → `confirmed`
- Gabriel's app refreshes: sale shows "✓ Confirmed" (can include in caja close)

**Edge Cases**:
- [ ] QR expires (>10 min) → customer clicks anyway → "QR expired, ask collector to request new approval"
- [ ] Patricia rejects sale → rejection reason sent to Gabriel via app + WhatsApp
- [ ] Gabriel closes cash box before customer confirms QR → sale stays in `pending_confirmation`, not released to caja
- [ ] Dolores loses phone, can't scan → Gabriel can request new QR (new URL to WhatsApp)

**Audit Trail**:
- [ ] Ledger entries:
  - `sale_approval`: Patricia approved, timestamp
  - `sale_confirmation`: Dolores confirmed, timestamp
- [ ] All four actors logged: Gabriel (submitter), Patricia (approver), Dolores (confirmer), Supervisor (if supervisor approved step 2 — C-31 4-step)

**Story Points**: 13 (QR generation, WhatsApp integration, state machine, expiry logic)

---

## Feature Area 3: Multi-Tenant Permissions

### STORY-005: Create Secondary Admin with Limited Permissions (Patricia)

**As a** primary admin (Patricia)
**I want to** create a secondary admin (supervisor) and give him specific permissions
**So that** I can delegate work without losing control (resolves Q6: matrix permissions)

**Context**: Patricia trusts Marcus (supervisor). She wants to let him approve sales <$500/day but nothing else. Matrix-based permission model (Q6 answer B).

**Acceptance Criteria**:
- [ ] Patricia clicks "Add Admin" in settings
- [ ] Creates user: name, email, phone
- [ ] Permission matrix appears (table format)
- [ ] Patricia checks: "Approve sales" → ✓ limit: $500/day, "Create loans" → ☐ disabled
- [ ] Marcus receives email link + PIN to activate account
- [ ] When Marcus logs in, he sees only what he's allowed (RLS enforced)
- [ ] Audit log shows: "Patricia created Marcus, assigned permissions [list]"

**Given**: Patricia opens "Team" settings, clicks "Add Admin"
**When**: She fills name="Marcus", email="m@example.com"
**Then**: Marcus receives invite email with temporary PIN

**When**: Marcus sets password and logs in
**Then**: 
- His dashboard shows only routes assigned to him (RLS filter)
- His approvals have $500/day cap (enforced by API)
- He cannot see "Create Loan" button (UI hides, API denies if he tries)
- His audit trail is separate from Patricia's

**Edge Cases**:
- [ ] Patricia assigns conflicting permissions (e.g., "Approve sales" without "View sales") → system warns, clarifies
- [ ] Marcus tries to approve $600 sale → API rejects with "Exceeds your $500/day limit"
- [ ] Patricia revokes "Approve sales" permission → Marcus's account is not deleted, just access removed
- [ ] Marcus logs in during revocation → session ends, must re-login (shows "Permissions changed")

**Audit Trail**:
- [ ] Ledger: permission_matrix_created, permission_matrix_modified (by Patricia)
- [ ] Each action by Marcus logged with his ID, permission checked, granted/denied

**Story Points**: 13 (matrix design, RLS integration, audit logging, permission validation)

---

## Feature Area 4: Ledger & Immutability

### STORY-006: Ledger Entry for Every Financial Operation (System)

**As a** system (process)
**I want to** create immutable ledger entries for every payment, reversal, and reconciliation
**So that** the audit trail is complete and nobody can hide fraud (C-99, antifraude control foundation)

**Context**: Every payment, no-payment, reversal, cash close goes to ledger. Ledger is append-only (no UPDATE/DELETE).

**Acceptance Criteria**:
- [ ] Every operation creates exactly one ledger entry
- [ ] Ledger table has: `id` (UUID), `operation_type`, `amount` (Decimal), `occurred_at`, `received_at`, `tenant_id`, `created_at`
- [ ] Ledger entries cannot be edited or deleted (SQL permissions enforced)
- [ ] Reversal operations create new ledger entries (not edits), offset original
- [ ] Ledger sum = account balance (always reconcilable)

**Given**: Gabriel registers 100 BRL payment for Dolores (loan ABC)
**When**: Server confirms sync
**Then**: Ledger entry created:
```json
{
  "id": "uuid-xxx",
  "operation_type": "payment",
  "tenant_id": "financiera-1",
  "amount": "100.00",
  "loan_id": "abc-123",
  "client_id": "dolores-xyz",
  "collector_id": "gabriel-123",
  "occurred_at": "2026-08-16 10:32:00 (device time)",
  "received_at": "2026-08-16 10:32:15 (server time, authoritative)",
  "created_at": "2026-08-16 10:32:15",
  "metadata": { "sync_batch_id": "batch-555" }
}
```

**Given**: Patricia rejects a $50 payment by mistake
**When**: She finds the error and requests reversal
**Then**: NEW ledger entry created:
```json
{
  "id": "uuid-yyy",
  "operation_type": "reversal_entry",
  "original_operation_id": "uuid-xxx",
  "amount": "-100.00",  // negative, offsets original
  "reason": "Patricia: Duplicate, please reverse",
  "created_by": "patricia-admin-1",
  "created_at": "2026-08-16 11:00:00"
}
```

**Edge Cases**:
- [ ] Hacker tries to UPDATE ledger entry → database permission denied (error logged)
- [ ] Reversal is requested for wrong operation → audit shows Patricia's mistake, still creates reversals
- [ ] Tenant accidentally queries other tenant's ledger → RLS blocks (query returns 0 rows)

**Audit Trail**:
- [ ] Every ledger entry is immutable (PostgreSQL constraints + application code)
- [ ] Deletes are forbidden (no soft-deletes)
- [ ] Reversals are visible in ledger (transparency)

**Story Points**: 8

---

## Feature Area 5: WhatsApp Messaging

### STORY-007: Send Payment Receipt via WhatsApp (System)

**As a** system (automated process)
**I want to** send a payment receipt to the customer via WhatsApp
**So that** customers have proof of payment independent of the collector (antifraude control #2, C-99)

**Context**: When Gabriel closes his cash box, system extracts all his payments for that day and sends WhatsApp to each customer.

**Acceptance Criteria**:
- [ ] After cash box close, system generates extracto (receipt list)
- [ ] For each payment, WhatsApp message sent to customer phone
- [ ] Message sent within 10 seconds of caja closing
- [ ] Message contains: amount paid, date, balance left, next payment due date
- [ ] Message is in Spanish
- [ ] Message cannot be edited/revoked (permanent proof)

**Given**: Gabriel closes caja at 11:15 AM with 5 payments registered
**When**: Caja close is confirmed
**Then**: System queues 5 WhatsApp messages (via Procrastinate queue in PostgreSQL)

**When**: Messages are sent (queue processes them)
**Then**: Each customer (Dolores, etc.) receives:
```
Hola Dolores,

Pago recibido: 100 BRL
Saldo restante: 420 BRL
Próximo vencimiento: 22/08/2026

Consultas: [contact info]
```

**Edge Cases**:
- [ ] Phone number is wrong/invalid → WhatsApp delivery fails, logged but doesn't block caja close
- [ ] WhatsApp API is down → message queued, retried hourly (Procrastinate retry policy)
- [ ] Customer opts out of WhatsApp → system respects (uses SMS fallback, if configured)
- [ ] Message contains special characters (é, ñ) → encoded correctly in UTF-8

**Audit Trail**:
- [ ] Ledger entry: `whatsapp_message_sent` with timestamp, customer phone (hashed), message ID
- [ ] Retry log: if delivery failed, number of retries + final status

**Story Points**: 5

---

## Feature Area 6: Reporting & Dashboards

### STORY-008: Admin Dashboard — Descuadres Metric (Patricia)

**As a** primary admin (Patricia)
**I want to** see descuadres (cash mismatches) on my dashboard
**So that** I can spot fraud immediately and investigate (metric #1, Q3)

**Context**: Patricia checks dashboard daily. She wants to see trending: how many descuadres per day/month, amounts, by collector.

**Acceptance Criteria**:
- [ ] Dashboard home shows: "Descuadres today: 0" (or count)
- [ ] If descuadres exist, shows severity: ✓ <50 BRL, ⚠️ 50–200 BRL, 🔴 >200 BRL
- [ ] Can click to see list: [route], [collector], [amount], [date/time]
- [ ] Can filter by date range, route, collector
- [ ] Monthly report includes: total descuadres, trend (up/down), largest descuadre

**Given**: Gabriel's caja closing shows 25 BRL descuadre, Marcus's shows 0
**When**: Patricia opens dashboard
**Then**: Shows "Descuadres today: 1 (25 BRL)"
**And**: Clicking link shows: "Route 3 (Gabriel): 25 BRL short, 11:15 AM"

**Edge Cases**:
- [ ] No descuadres for a week → dashboard shows "✓ No descuadres (excellent!)"
- [ ] Large descuadre (>500 BRL) → automated alert email to Patricia + Felipe
- [ ] Descuadre from invalid caja close → system prevents close (pending items >0)

**Audit Trail**:
- [ ] Dashboard metric is calculated from ledger (no duplication)
- [ ] Metric source: `ledger_entries` filtered by `operation_type = 'cash_box_closing' AND descuadre != 0`

**Story Points**: 8

---

## Feature Area 7: System Alerts

### STORY-009: Alert: Descuadre Detected (Patricia + System)

**As the** system
**I want to** alert Patricia when a descuadre is detected
**So that** she can investigate immediately (fraud prevention)

**Acceptance Criteria**:
- [ ] When caja close creates descuadre >0, alert is triggered
- [ ] Alert sent to Patricia via: in-app notification + email + (optional) Telegram
- [ ] Alert shows: route, collector, amount, time
- [ ] Patricia can mark alert as "Reviewed" (not deleted, just acknowledged in audit)
- [ ] Unreviewed alerts persist until Patricia marks them

**Given**: Gabriel's caja shows 100 BRL descuadre
**When**: He completes caja close
**Then**: Patricia's app shows red badge: "🔴 Alert: Descuadre"
**And**: Email sent: "ROYEXA: Descuadre detected - Route 3 (Gabriel), 100 BRL, time: 11:30 AM"

**Edge Cases**:
- [ ] Patricia is offline when alert is triggered → alert waits for next login (shown in inbox)
- [ ] Multiple descuadres in same hour → batched into single alert
- [ ] False alarm (Gabriel recounts, actually cash matches) → Patricia marks "False alarm" + comment

**Story Points**: 3

---

## Feature Area 8: Offline-First Edge Cases

### STORY-010: Handle App Crash During Sync (Gabriel + System)

**As a** system (recovery process)
**I want to** gracefully handle app crashes mid-sync
**So that** no payments are lost and Gabriel doesn't have to re-enter them

**Acceptance Criteria**:
- [ ] If app crashes during sync, payment remains in queue (SQLite transaction rolled back)
- [ ] When app restarts, payment is still pending (visible in Gabriel's list)
- [ ] Gabriel can retry sync (button available)
- [ ] Idempotency key prevents duplicate if sync partially succeeded

**Given**: Gabriel's app syncing 5 payments, crashes mid-sync (after 2 succeeded)
**When**: App restarts
**Then**: Gabriel sees "3 payments still pending sync"
**And**: Retrying sync doesn't re-send the 2 confirmed payments (idempotency)

**Edge Cases**:
- [ ] Device battery dies mid-sync → on restart, same recovery (above)
- [ ] Network timeout (not crash) → automatic retry (Procrastinate queue handles)

**Story Points**: 5

---

## Feature Area 9: Permissions & Security

### STORY-011: Verify Collector Can't See Other Routes (RLS)

**As** the system (security control)
**I want to** enforce RLS at the database level
**So that** Gabriel can't see Rodrigo's route (even if he finds the URL hack)

**Acceptance Criteria**:
- [ ] Gabriel logs in with his token (contains: user_id=gabriel-123, tenant_id=financiera-1, route_id=route-3)
- [ ] API calls `SET LOCAL app.tenant_id = 'financiera-1'` per transaction
- [ ] Gabriel queries GET /routes → returns only route-3 (RLS filters)
- [ ] If Gabriel somehow queries Gabriel queries `SELECT * FROM routes WHERE id = 'route-5'` (Rodrigo's route) → RLS blocks (0 rows returned)
- [ ] Audit log: "Gabriel attempted to query route-5, RLS denied" (logged, not error to user, just returns empty)

**Edge Cases**:
- [ ] Gabriel is a secondary admin with `view_all_routes` permission → RLS allows it (policy checks permission)
- [ ] Bug in app: developer forgets to set `app.tenant_id` → RLS still blocks (defense-in-depth, T10)

**Story Points**: 8

---

## Feature Area 10: First-Time User Onboarding

### STORY-012: First Launch — PIN Setup & Device Binding (Gabriel)

**As a** collector (Gabriel)
**I want to** set a PIN and bind my device to ROYEXA
**So that** I can work offline securely and only I can use my phone

**Context**: Gabriel's employer (Patricia) has approved his device. Device is new, not yet bound. Gabriel downloads app, needs PIN.

**Acceptance Criteria**:
- [ ] On first launch, app shows "Welcome to ROYEXA"
- [ ] Prompts to enter 4-digit PIN (numbers only, simple for low-tech users)
- [ ] PIN is stored in Keystore (Android) or Keychain (iOS), not visible to app code
- [ ] PIN unlocks local SQLite (T30)
- [ ] App generates device keypair (stored in Keystore, not exportable)
- [ ] App shows: Device ID (e.g., "Samsung A12 Rev 3") + activation PIN (6 characters)
- [ ] Patricia sees pending device in web app, approves it
- [ ] On Patricia's approval, server sends device password back to app (via secure channel)
- [ ] Gabriel can now sync (device is "bound")

**Given**: Gabriel installs app for first time
**When**: App launches
**Then**: Shows "Bienvenido, Gabriel! Crea un PIN para desbloquear."

**When**: Gabriel enters PIN: 1234, taps Next
**Then**: 
- App encrypts: PIN → 1234 (becomes key to local SQLite via Keystore)
- App generates keypair (private key never leaves device)
- Shows activation screen: "Device ID: Samsung-A12-rev3 | Activation PIN: 5K7M2P"
- "Envíale esto a Patricia para que apruebe tu dispositivo"

**Given**: Patricia opens "Devices" in web app, sees "Samsung-A12-rev3 (Pending)" with PIN "5K7M2P"
**When**: Patricia clicks "Approve"
**Then**:
- System generates device password (cryptographically secure)
- Sends password to app (via encrypted channel)
- Gabriel's app shows "✓ Device approved! You can now work offline."

**Edge Cases**:
- [ ] Gabriel forgets PIN → app is locked (no bypass). Patricia can revoke device, Gabriel re-binds on next activation.
- [ ] Gabriel loses phone → Patricia revokes device from web app (immediate, doesn't require phone cooperation)
- [ ] Gabriel enters wrong PIN 3x → device locks for 5 minutes (brute-force protection)

**Audit Trail**:
- [ ] Ledger: device_binding_requested, device_binding_approved
- [ ] Device revocation logged with Patricia's ID

**Story Points**: 8 (cryptography, device binding, encryption)

---

## Summary Statistics

**Total Stories**: 12 core stories (+ additional stories for web, admin, partner flows)

**Distribution by Persona**:
- Gabriel (Collector): 6 stories
- Patricia (Admin Primary): 4 stories
- Marcus (Admin Secondary): 1 story
- Felipe (Partner): 1 story
- Dolores (Customer): 1 story
- System (automated): 3 stories

**Estimated Total Story Points** (all stories across full scope): ~180 points

**Mandatory E2E Scenarios** (from T22, T24):
1. ✅ STORY-002 + STORY-003 = "Offline payment + sync + cash close"
2. ✅ STORY-004 = "4-step approval with QR"
3. ✅ (Additional story) = "Mobile-to-web integration (collector → admin flow)"

---

## Changelog

| Date | Event | Author |
|---|---|---|
| 2026-08-16 | Generated from Requirements.md · 12 core stories | AI-DLC Inception |
| 2026-08-16 | Personas: 5 archetypes (Gabriel, Patricia, Marcus, Felipe, Dolores) | AI-DLC Inception |
