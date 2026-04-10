# Architecture

## High-Level Architecture
- **Client Apps** call API over HTTPS.
- **API Service** enforces auth, RBAC, rate limits, policy gates, and persists state in PostgreSQL.
- **Redis** supports queues, distributed locks, idempotency, and abuse counters.
- **Worker Service** processes asynchronous jobs (expiration, abuse scans, notifications).
- **Mail Ingress Adapter** receives provider webhooks and forwards signed payloads to API ingest endpoint.
- **Object Storage** optionally stores raw MIME content; metadata and sanitized extracts remain in PostgreSQL.

## Request Flow
1. Request enters API gateway/reverse proxy.
2. API validates JWT and tenant/user context.
3. Module-level policy checks run (RBAC + business constraints).
4. Transactional write/read in PostgreSQL.
5. Side effects are queued in Redis (notifications, scans, delayed expiration).
6. API returns normalized response + trace id.

## Email Receiving Flow
1. Inbound message arrives to provider MX for a verified domain.
2. Provider webhook hits mail ingress with signature.
3. API verifies signature, domain status, and mailbox rental validity.
4. Message is scanned (size/type/pattern checks), metadata stored.
5. Raw payload optionally written to object storage with retention tag.
6. Message event queued; renter notified asynchronously.
7. Suspicious patterns increment abuse counters and may trigger moderation action.

## Rental Flow
1. Domain owner creates offer with capacity, price, constraints.
2. Renter reserves mailbox through marketplace.
3. Wallet service checks available points and places reservation hold.
4. Rented mailbox record is created with expiration timestamp.
5. Worker schedules expiration and reminder notifications.
6. On expiration/cancellation, wallet settles or refunds based on policy.

## Abuse Prevention Flow
1. Every critical endpoint has rate-limits and idempotency requirements.
2. Domain listing/rental actions require verified account and reputation threshold.
3. Ingress enforces inbound-only behavior; outbound relay paths are absent.
4. Automated scanners flag disposable abuse patterns, bulk bursts, malicious attachments.
5. Flags create abuse reports and optionally auto-restrict actors/domains.
6. Moderator/admin review updates status, logs actions, and applies reputation events.
