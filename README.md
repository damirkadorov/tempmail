# TempMail Marketplace MVP Starter

## Product Overview
TempMail Marketplace is a controlled platform where verified domain owners can rent temporary mailbox capacity to other users in exchange for internal points. The platform focuses on abuse-resistant temporary inbound email use cases (testing, QA, disposable workflows) while preventing open-relay behavior.

Core principles:
- Domain ownership must be verified before listing.
- Mailboxes are rented from existing offers, not created without policy checks.
- Inbound-only mailbox model for MVP (no outbound SMTP relay).
- Points-based internal economy with full transaction auditability.
- Strong moderation and abuse prevention from day one.

## Architecture Overview
- **API (`/apps/api`)**: modular backend with domain management, marketplace rentals, mailbox lifecycle, messages, wallets, moderation, and admin controls.
- **Worker (`/apps/worker`)**: background jobs for expiration, retries, notifications, abuse scanning.
- **Database (`/packages/db/schema`)**: PostgreSQL schema for users, domains, offers, rentals, messages, wallets, abuse/moderation, reputation.
- **Redis**: queueing, rate-limits, idempotency keys, abuse counters.
- **Object Storage**: optional raw MIME/message body archival with retention policy.

## Local Setup
1. Install PostgreSQL 15+, Redis 7+, and object storage emulator (e.g., MinIO) or cloud bucket.
2. Create database and apply `/packages/db/schema/001_init.sql`.
3. Configure environment variables (see below).
4. Start API service from `/apps/api`.
5. Start worker service from `/apps/worker`.

## Environment Variables
- `NODE_ENV` (`development|staging|production`)
- `API_PORT`
- `DATABASE_URL` (PostgreSQL DSN)
- `REDIS_URL`
- `JWT_ISSUER`
- `JWT_AUDIENCE`
- `JWT_PRIVATE_KEY`
- `JWT_PUBLIC_KEY`
- `OBJECT_STORAGE_ENDPOINT`
- `OBJECT_STORAGE_BUCKET`
- `OBJECT_STORAGE_ACCESS_KEY`
- `OBJECT_STORAGE_SECRET_KEY`
- `MAIL_INGRESS_SHARED_SECRET`
- `DEFAULT_POINTS_GRANT`
- `MAX_ACTIVE_RENTALS_PER_USER`
- `MAX_MAILBOXES_PER_DOMAIN`
- `MAX_MESSAGES_PER_MAILBOX_PER_DAY`
- `ABUSE_AUTO_SUSPEND_THRESHOLD`
- `NOTIFICATION_PROVIDER`

## Key Modules
### API Modules
- `auth`: registration, login, token issuance, session and policy checks.
- `domains`: domain onboarding, DNS verification, status management.
- `marketplace`: offers, availability, renting workflows.
- `mailboxes`: rental mailbox lifecycle and expiration state.
- `messages`: inbound message storage and renter retrieval.
- `wallets`: balances, reservation/settlement/refunds.
- `moderation`: abuse reports, review actions, reputation impact.
- `admin`: policy, enforcement, manual overrides.

### Worker Jobs
- mailbox expiration processor
- rental expiration settlement
- retry/dead-letter recovery
- notification dispatch
- abuse scanning and automated escalations
