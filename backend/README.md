# msmc-backend

Node.js + Express + PostgreSQL REST API for the MSMC Flutter app.

## Stack

- Express (HTTP layer)
- `pg` (node-postgres) for queries — no ORM
- `node-pg-migrate` for schema migrations (`migrations/`)
- `zod` for request validation
- `jsonwebtoken` for auth (issued after OTP verification)
- `multer` for file uploads (complaint attachments, verdict documents)

## Scripts

| Script | What it does |
| --- | --- |
| `npm run dev` | Start with nodemon, loads `.env` |
| `npm start` | Start once, loads `.env` |
| `npm run migrate` | Apply all pending migrations |
| `npm run migrate:down` | Roll back the last migration |
| `npm run migrate:create <name>` | Scaffold a new migration file |
| `npm run seed` | Seed content tables from `docs/prototype-reference` data (Phase 1) |

## Auth model

Citizens authenticate via phone + OTP (`/api/v1/auth/otp/request`, `/api/v1/auth/otp/verify`). SMS delivery is mocked in development — the OTP is returned in the response body / logged instead of sent, so the full auth flow can be exercised without a paid SMS provider. Swap in a real provider by implementing `src/sms/SmsSender.js`'s interface.

There is no separate officer app in scope. Officers share the same `users` table (`role = 'officer'`) and the same JWT-gated endpoints (`requireRole('officer')` middleware); a dev-only `POST /auth/dev/become-officer` endpoint (gated by `ALLOW_DEV_ROLE_SWITCH`) lets one test account exercise both the citizen and officer sides of the complaint workflow.

See the top-level project plan for the full schema, API surface, and phased build order.
