# Architecture

## Target shape
- Next.js App Router + TypeScript for UI and server endpoints.
- PostgreSQL for durable workspace data.
- Authentication provider with organization membership and server-enforced roles.
- Object storage for uploaded assets with signed URLs and content validation.
- Background queue + scheduler for reminders, approved publishing jobs, webhooks and reports.
- Server-only AI provider adapter with schema validation, per-workspace quotas and cost tracking.
- Observability: structured logs, error monitoring, queue health, audit events and provider status.

## Data ownership
Every tenant-owned row must include workspace_id and enforce authorization on the server and database. Never trust workspace IDs or roles supplied by the browser. Cross-tenant access tests are mandatory.

## Suggested entities
User, Workspace, Membership, BrandProfile, BrandVoiceRule, ContentBrief, ContentDraft, ContentVersion, Asset, CalendarEntry, Lead, LeadActivity, Campaign, CampaignMetric, IntegrationConnection, Automation, AutomationRun, Approval, AuditEvent, UsageRecord, WebhookEvent.

## Integration lifecycle
1. Connect through official OAuth/provider flow with minimal scopes.
2. Store tokens encrypted on the server; never expose them to the browser.
3. Verify webhook signatures, replay protection and timestamps.
4. Queue actions with idempotency keys and bounded retries.
5. Require explicit approval before external publishing until workspace policy permits it.
6. Reconcile remote state and show actionable errors; never mark a post published without provider confirmation.

## AI pipeline
Build structured input from authorized workspace data -> label untrusted user content -> call provider server-side -> validate structured response -> enforce brand/safety checks -> record model/usage/cost -> present editable draft for human review. Imported content must never override system policy or trigger tools.
