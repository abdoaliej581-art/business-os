# MAGIXA Marketing OS — Product Specification

## Purpose
One workspace for marketing planning, content operations, lead tracking, campaigns, and transparent performance reporting for Magixa first, with a path to multi-tenant SaaS.

## User groups
- Workspace owner: brand configuration, access control, billing later.
- Marketer: drafts, calendar, campaigns, analytics.
- Sales / business development: lead pipeline and follow-ups.
- Client viewer: approved reporting and assets, once access control exists.

## Core modules
1. Overview: work counts, actionable priorities, honest data-source status.
2. Brand profile: positioning, audience, tone, services, approved claims, CTA and language.
3. Content studio: briefs, platform-specific drafts, variants, review states, media links, tags and reuse.
4. Calendar: draft/review/approved/scheduled/published states, timezone, reminders and future publisher integration.
5. Leads CRM: source, stage, contact history, consent/legal basis, owner, next action and estimated opportunity value.
6. Campaigns: objective, target audience, channel, budget, dates, assets, owner, KPI definitions and status.
7. Analytics: source-attributed data, date ranges, UTM tracking, comparisons and export.
8. Integrations: OAuth, least privilege, token encryption, webhook verification and connection status.
9. Automation: event triggers, conditions, actions, schedules, retries, idempotency, pause/kill switch and audit history.
10. Settings: organization, members, roles, localization, data export/deletion and provider configuration.

## MVP acceptance criteria
- Responsive Arabic-first RTL UI with keyboard navigation.
- Drafts, lead records and campaigns can be created, edited, searched and exported.
- User-visible labels distinguish local/demo data from connected data.
- No AI or social-publishing capability is represented as connected until verified.
- Server-side validation, organization isolation, authorization, rate limits, audit logs and tests precede production use.

## Boundaries
No fabricated engagement, autonomous spam, scraping private data, unapproved outbound campaigns, direct ad spend, or patient/financial sensitive data in local demo storage.
