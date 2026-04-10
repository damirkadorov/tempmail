# Domain Marketplace

## Domain Owner Flow
1. Add domain.
2. Complete DNS verification challenge.
3. Configure constraints (max concurrent rentals, message caps, allow/deny patterns).
4. Create active offer with price per time slice and mailbox capacity.
5. Monitor rentals, delivery stats, abuse flags, earnings.
6. Pause or retire offer at any time (existing rentals handled by policy).

## Renter Flow
1. Complete account verification and hold minimum points.
2. Browse eligible offers filtered by policy/reputation.
3. Reserve mailbox capacity for selected duration.
4. Receive mailbox alias + expiration metadata.
5. Read inbound messages until expiration.
6. Extend (if allowed) or end rental and settle points.

## Pricing and Points Logic
- Unit: internal **points** only.
- Offer pricing: `points_per_mailbox_per_hour` (or per day).
- Reservation hold at rental start (prevents overspending).
- Settlement finalizes owner credit and platform fee on completion.
- Refund rules:
  - full refund if verification/activation fails before use,
  - partial refund for early forced termination by platform,
  - no refund for policy-violating renter behavior.
- All movements are immutable `points_transactions` with reference ids.

## Moderation Checkpoints
- Before listing: domain verification + owner trust score checks.
- Before rental: renter trust and velocity checks.
- During rental: message throughput, suspicious sender/content fingerprints.
- On complaint: abuse report triage SLA and temporary containment actions.
- After enforcement: reputation event and audit trail in moderation logs.
