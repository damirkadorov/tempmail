# RBAC

## Roles
- `guest`: unauthenticated visitor.
- `user`: authenticated baseline role.
- `domain_owner`: user with verified domain management capability.
- `renter`: user allowed to rent mailbox capacity.
- `moderator`: handles abuse and trust actions.
- `admin`: full operational and policy control.
- `system_worker`: internal service role for async processing.

## Permissions
| Permission | guest | user | domain_owner | renter | moderator | admin | system_worker |
|---|---:|---:|---:|---:|---:|---:|---:|
| View marketplace offers | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Create/verify domain | ❌ | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ |
| Publish/update offer | ❌ | ❌ | ✅ | ❌ | ❌ | ✅ | ❌ |
| Rent mailbox | ❌ | ❌ | ✅* | ✅ | ❌ | ✅ | ❌ |
| Read rented messages | ❌ | ❌ | owner scope | ✅ (own) | ✅ (review) | ✅ | ✅ |
| Manage wallet/self transactions | ❌ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| File abuse report | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Resolve abuse reports | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ |
| Apply suspensions/overrides | ❌ | ❌ | ❌ | ❌ | limited | ✅ | ❌ |
| Run expirations/retries/scans | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

`*` if policy permits owners to act as renters.

## Enforcement Points
- JWT claim validation at request entry (`sub`, role list, status).
- Route guards for coarse permissions.
- Service-layer ownership checks for fine-grained resource access.
- DB query scoping by tenant/user where applicable.
- Worker tokens scoped to internal-only endpoints and queues.
- All privileged actions recorded in `moderation_logs`.
