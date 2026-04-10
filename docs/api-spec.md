# API Spec (MVP Draft)

## Auth Model
- Bearer JWT access token.
- Short-lived access token + refresh strategy (implementation choice).
- Claims: `sub`, `roles`, `status`, `iat`, `exp`, `iss`, `aud`.
- Disabled/suspended users rejected even with otherwise valid token.

## Error Model
```json
{
  "error": {
    "code": "INSUFFICIENT_POINTS",
    "message": "Not enough points to reserve mailbox",
    "details": {"required": 100, "available": 40},
    "traceId": "trc_123"
  }
}
```

## Endpoint List
### Auth
- `POST /v1/auth/register`
- `POST /v1/auth/login`
- `POST /v1/auth/refresh`
- `GET /v1/auth/me`

### Domains
- `POST /v1/domains`
- `POST /v1/domains/{domainId}/verify`
- `GET /v1/domains`
- `PATCH /v1/domains/{domainId}`

### Marketplace
- `POST /v1/offers`
- `GET /v1/offers`
- `PATCH /v1/offers/{offerId}`
- `POST /v1/offers/{offerId}/rent`

### Mailboxes
- `GET /v1/mailboxes`
- `GET /v1/mailboxes/{mailboxId}`
- `POST /v1/mailboxes/{mailboxId}/extend`
- `POST /v1/mailboxes/{mailboxId}/cancel`

### Messages
- `POST /v1/ingress/messages` (internal/provider signed)
- `GET /v1/mailboxes/{mailboxId}/messages`
- `GET /v1/messages/{messageId}`

### Wallets
- `GET /v1/wallets/me`
- `GET /v1/wallets/me/transactions`

### Moderation
- `POST /v1/abuse-reports`
- `GET /v1/moderation/reports` (moderator+)
- `POST /v1/moderation/reports/{reportId}/resolve`

### Admin
- `POST /v1/admin/domains/{domainId}/suspend`
- `POST /v1/admin/users/{userId}/suspend`
- `POST /v1/admin/offers/{offerId}/disable`

## Request/Response Examples
### Create Domain
`POST /v1/domains`
```json
{
  "domain": "example.com"
}
```
Response:
```json
{
  "id": "dom_123",
  "domain": "example.com",
  "status": "pending_verification",
  "verification": {
    "type": "txt",
    "name": "_tm_verify.example.com",
    "value": "tm-challenge-abc"
  }
}
```

### Rent Mailbox
`POST /v1/offers/ofr_123/rent`
```json
{
  "durationHours": 24,
  "quantity": 1
}
```
Response:
```json
{
  "rentalId": "rnt_123",
  "mailboxes": [
    {
      "id": "mbx_123",
      "address": "qa-7f2@example.com",
      "expiresAt": "2026-04-12T10:00:00Z"
    }
  ],
  "points": {
    "reserved": 120,
    "walletBalance": 880
  }
}
```

### Ingress Message (Internal)
`POST /v1/ingress/messages`
```json
{
  "providerEventId": "evt_123",
  "domain": "example.com",
  "recipient": "qa-7f2@example.com",
  "from": "sender@vendor.io",
  "subject": "Test OTP",
  "receivedAt": "2026-04-10T10:00:00Z",
  "storageKey": "messages/raw/evt_123.eml"
}
```
Response:
```json
{
  "status": "accepted",
  "messageId": "msg_123"
}
```
