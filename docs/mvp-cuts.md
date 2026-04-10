# MVP Cuts

## What to Ship Now
- Account auth + basic profile status.
- Domain onboarding + DNS verification + lifecycle state.
- Offer publish/browse + controlled rental creation.
- Inbound message ingest + mailbox message retrieval.
- Wallet + points reservation/settlement/refund ledger.
- Core anti-abuse: rate limits, velocity checks, message caps, report flow, moderator tools.
- Background workers for expirations, retries, notifications, abuse scans.
- Admin suspension controls for users/domains/offers.

## What to Delay
- Advanced pricing (dynamic auctioning, surge multipliers).
- Cross-tenant custom policy DSL.
- Rich analytics dashboards.
- Automated chargeback/dispute workflow sophistication.
- ML-heavy abuse scoring and attachment sandboxing.
- Multi-region active-active ingestion.

## Why
- Early risk is abuse and trust failure, not feature depth.
- Strong moderation + constrained mailbox lifecycle keeps operations manageable.
- A small startup team should optimize for enforceable policy, auditability, and reliability of core rent/receive/settle loop.
