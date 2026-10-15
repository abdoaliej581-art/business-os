# MAGIXA Marketing OS

Arabic-first marketing workspace for content planning, campaign organization, lead tracking, and transparent marketing operations for Magixa.

## Current foundation release

The initial UI includes a responsive RTL workspace with:
- Dashboard and sample overview
- Content studio with editable drafts and local persistence
- Lead pipeline with stage updates and opportunity estimates
- Campaign planning and internal status changes
- Content calendar, analytics overview, and workspace settings
- Local JSON export and a health endpoint at /api/health

## Run locally

Requirements: Node.js 20+

1. Install dependencies: npm install
2. Copy .env.example to .env.local if you need environment settings
3. Start: npm run dev
4. Open http://localhost:3000

## Honest status

This is a foundation/demo release, not production-ready SaaS. Demo records are sample data. Current storage is browser-local, and there is no real authentication, shared database, live AI provider, official social publishing, email sending, or imported analytics yet. Do not use it for sensitive customer data.

## Production roadmap

1. Add authentication, workspace membership, server-side roles, and recovery.
2. Add PostgreSQL schema, migrations, row-level security, tenant isolation, audit logs and durable APIs.
3. Add server-side AI provider integration with structured outputs, quotas, safety checks and cost controls.
4. Add official platform OAuth/API integrations only after permission and review requirements are confirmed.
5. Add background jobs, scheduling, retries, idempotency, webhooks, observability, backups and recovery tests.
6. Complete automated tests, accessibility and security reviews before customer use.

Do not put secrets in client code or NEXT_PUBLIC variables. Do not claim social publishing is connected until verified. The separate magixa-clinic-os repository is not part of this project.
