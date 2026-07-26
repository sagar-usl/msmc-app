# MSMC — Maharashtra State Minority Commission

This repo contains:

- **Root `*.dc.html` files, images, `support.js`, `android-frame.jsx`** — the original browser-based prototype. Left untouched as design reference; not part of the build.
- **`mobile/`** — the real Flutter app (bilingual EN/मराठी), rebuilt to match the prototype's look and flows.
- **`backend/`** — a Node.js + Express + PostgreSQL REST API backing the app (auth via phone OTP, complaints workflow, feedback, content).

See `docs/prototype-reference/` for notes on how prototype content maps onto the backend's content tables.

## Local dev setup

### Backend

```
cd backend
cp .env.example .env      # edit if your local Postgres differs
npm install
npm run migrate           # creates all tables (uses PostgreSQL 14 via Homebrew, or docker-compose up postgres)
npm run dev                # http://localhost:4000, health check at /health
```

Postgres can either be your existing local install (`brew services start postgresql@14`, `createdb msmc`) or the bundled `docker-compose.yml` (`docker compose up -d postgres`, then point `DATABASE_URL` at `localhost:5433`).

### Mobile app

```
cd mobile
flutter pub get
flutter run                # pick a connected device/emulator
```

The app currently runs against local/static content data (Phase 0 of the build). Backend wiring lands in later phases — see the project plan for the full phase breakdown.
