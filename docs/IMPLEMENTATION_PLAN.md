# Implementation Roadmap

## Phase 0 — Foundation
- [x] Separate marketing project from clinic demo.
- [x] Arabic-first responsive application shell.
- [x] Overview, content drafts, local CRM, campaigns, calendar, analytics and settings UI.
- [x] Clear demo/integration status and local export.
- [ ] Build, lint and browser QA.

## Phase 1 — Durable MVP
- [ ] Choose database/auth providers and verify pricing, region, and ownership.
- [ ] Workspace authentication, invitations, roles and recovery.
- [ ] PostgreSQL schema, migrations, seed data, RLS and tenant-isolation tests.
- [ ] CRUD APIs for brands, drafts, leads, activities, campaigns, assets and approvals.
- [ ] Server validation, audit history, pagination and robust errors.

## Phase 2 — AI Content Engine
- [ ] Provider adapter and secret configuration.
- [ ] Brand voice profile, content brief and structured outputs.
- [ ] Platform-aware variants, editorial checks, claims/CTA guardrails.
- [ ] Cost/usage limits, retries, cancellation and observability.
- [ ] Evaluation set for Arabic quality and factual claims.

## Phase 3 — CRM and workflows
- [ ] Lead activity timeline, tasks, next follow-up and deduplication.
- [ ] Consent-aware email templates and outbound safeguards.
- [ ] Automation builder with schedules, queue, retries, idempotency and kill switch.

## Phase 4 — Integrations
- [ ] Official social OAuth and API review per platform.
- [ ] Asset storage and media validation.
- [ ] Provider-confirmed publishing state and webhook reconciliation.
- [ ] UTM builder and verified analytics imports.

## Phase 5 — Commercial readiness
- [ ] Workspace plans, usage metering and billing after cost review.
- [ ] Support/admin tools, documentation, onboarding and data export/deletion.
- [ ] Accessibility, load, penetration and recovery tests.
- [ ] Terms/privacy notices and compliance review.

## Definition of done
A feature is done only when implemented, validated, tested, authorized, observable, documented, and honest about provider limitations. A mock screen or localStorage record is not a production integration.
