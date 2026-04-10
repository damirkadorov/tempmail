-- TempMail Marketplace MVP initial schema
-- PostgreSQL 15+

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE user_status AS ENUM ('active', 'suspended', 'deleted');
CREATE TYPE domain_status AS ENUM ('pending_verification', 'verified', 'suspended', 'rejected');
CREATE TYPE verification_type AS ENUM ('txt', 'cname', 'http_file');
CREATE TYPE verification_status AS ENUM ('pending', 'verified', 'failed', 'expired');
CREATE TYPE offer_status AS ENUM ('draft', 'active', 'paused', 'disabled');
CREATE TYPE rental_status AS ENUM ('reserved', 'active', 'expired', 'cancelled', 'suspended');
CREATE TYPE message_status AS ENUM ('accepted', 'quarantined', 'rejected', 'deleted');
CREATE TYPE transaction_type AS ENUM ('grant', 'hold', 'release', 'settlement', 'refund', 'penalty', 'adjustment', 'fee');
CREATE TYPE abuse_status AS ENUM ('open', 'investigating', 'resolved', 'dismissed');
CREATE TYPE moderation_action AS ENUM ('warn', 'limit', 'suspend_user', 'suspend_domain', 'disable_offer', 'reinstate', 'note');

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  display_name TEXT,
  status user_status NOT NULL DEFAULT 'active',
  trust_score INTEGER NOT NULL DEFAULT 0,
  role_flags JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE domains (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id UUID NOT NULL REFERENCES users(id),
  domain_name TEXT NOT NULL UNIQUE,
  status domain_status NOT NULL DEFAULT 'pending_verification',
  max_active_mailboxes INTEGER NOT NULL DEFAULT 10 CHECK (max_active_mailboxes > 0),
  max_messages_per_mailbox_per_day INTEGER NOT NULL DEFAULT 100 CHECK (max_messages_per_mailbox_per_day > 0),
  reputation_score INTEGER NOT NULL DEFAULT 0,
  suspended_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE domain_verifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  domain_id UUID NOT NULL REFERENCES domains(id) ON DELETE CASCADE,
  type verification_type NOT NULL,
  challenge_name TEXT NOT NULL,
  challenge_value TEXT NOT NULL,
  status verification_status NOT NULL DEFAULT 'pending',
  verified_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ NOT NULL,
  last_check_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE domain_offers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  domain_id UUID NOT NULL REFERENCES domains(id) ON DELETE CASCADE,
  created_by_user_id UUID NOT NULL REFERENCES users(id),
  status offer_status NOT NULL DEFAULT 'draft',
  title TEXT NOT NULL,
  points_per_mailbox_hour INTEGER NOT NULL CHECK (points_per_mailbox_hour > 0),
  capacity_total INTEGER NOT NULL CHECK (capacity_total > 0),
  capacity_in_use INTEGER NOT NULL DEFAULT 0 CHECK (capacity_in_use >= 0),
  min_duration_hours INTEGER NOT NULL DEFAULT 1 CHECK (min_duration_hours > 0),
  max_duration_hours INTEGER NOT NULL DEFAULT 168 CHECK (max_duration_hours >= min_duration_hours),
  rules JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (capacity_in_use <= capacity_total)
);

CREATE TABLE rented_mailboxes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  offer_id UUID NOT NULL REFERENCES domain_offers(id),
  domain_id UUID NOT NULL REFERENCES domains(id),
  renter_user_id UUID NOT NULL REFERENCES users(id),
  local_part TEXT NOT NULL,
  email_address TEXT NOT NULL,
  status rental_status NOT NULL DEFAULT 'reserved',
  starts_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at TIMESTAMPTZ NOT NULL,
  cancelled_at TIMESTAMPTZ,
  points_reserved INTEGER NOT NULL CHECK (points_reserved >= 0),
  points_settled INTEGER NOT NULL DEFAULT 0 CHECK (points_settled >= 0),
  messages_received_count INTEGER NOT NULL DEFAULT 0 CHECK (messages_received_count >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (email_address),
  CHECK (expires_at > starts_at)
);

CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  rented_mailbox_id UUID NOT NULL REFERENCES rented_mailboxes(id) ON DELETE CASCADE,
  provider_event_id TEXT,
  status message_status NOT NULL DEFAULT 'accepted',
  from_email TEXT NOT NULL,
  from_domain TEXT,
  subject TEXT,
  received_at TIMESTAMPTZ NOT NULL,
  headers JSONB NOT NULL DEFAULT '{}'::jsonb,
  text_preview TEXT,
  storage_key TEXT,
  size_bytes BIGINT CHECK (size_bytes >= 0),
  abuse_score INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(provider_event_id)
);

CREATE TABLE wallets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
  balance_points BIGINT NOT NULL DEFAULT 0 CHECK (balance_points >= 0),
  held_points BIGINT NOT NULL DEFAULT 0 CHECK (held_points >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE points_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_id UUID NOT NULL REFERENCES wallets(id),
  user_id UUID NOT NULL REFERENCES users(id),
  type transaction_type NOT NULL,
  amount BIGINT NOT NULL,
  reference_type TEXT NOT NULL,
  reference_id UUID,
  idempotency_key TEXT,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (amount <> 0),
  UNIQUE (idempotency_key)
);

CREATE TABLE abuse_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_user_id UUID REFERENCES users(id),
  target_user_id UUID REFERENCES users(id),
  target_domain_id UUID REFERENCES domains(id),
  target_mailbox_id UUID REFERENCES rented_mailboxes(id),
  reason_code TEXT NOT NULL,
  description TEXT,
  status abuse_status NOT NULL DEFAULT 'open',
  severity SMALLINT NOT NULL DEFAULT 1 CHECK (severity BETWEEN 1 AND 5),
  opened_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  resolved_at TIMESTAMPTZ,
  resolved_by UUID REFERENCES users(id)
);

CREATE TABLE moderation_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_user_id UUID REFERENCES users(id),
  action moderation_action NOT NULL,
  target_user_id UUID REFERENCES users(id),
  target_domain_id UUID REFERENCES domains(id),
  target_offer_id UUID REFERENCES domain_offers(id),
  target_mailbox_id UUID REFERENCES rented_mailboxes(id),
  abuse_report_id UUID REFERENCES abuse_reports(id),
  note TEXT,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE reputation_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  domain_id UUID REFERENCES domains(id),
  mailbox_id UUID REFERENCES rented_mailboxes(id),
  source TEXT NOT NULL,
  delta INTEGER NOT NULL,
  reason TEXT NOT NULL,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK ((user_id IS NOT NULL) OR (domain_id IS NOT NULL))
);

CREATE INDEX idx_domains_owner ON domains(owner_user_id);
CREATE INDEX idx_domain_offers_domain_status ON domain_offers(domain_id, status);
CREATE INDEX idx_rented_mailboxes_renter_status ON rented_mailboxes(renter_user_id, status);
CREATE INDEX idx_rented_mailboxes_expiration ON rented_mailboxes(expires_at) WHERE status IN ('reserved', 'active');
CREATE INDEX idx_messages_mailbox_received ON messages(rented_mailbox_id, received_at DESC);
CREATE INDEX idx_points_transactions_user_time ON points_transactions(user_id, created_at DESC);
CREATE INDEX idx_abuse_reports_status_severity ON abuse_reports(status, severity, opened_at DESC);
CREATE INDEX idx_reputation_events_user_time ON reputation_events(user_id, created_at DESC);
