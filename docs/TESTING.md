# Testing and Release Gates

## Automated
- Unit: content formatting, stage transitions, date/time, currency and validation.
- Integration: authenticated API authorization, tenant isolation, database transactions, token encryption and webhook signature verification.
- End-to-end: sign in, switch workspace, create/edit draft, add lead, move stage, create campaign, export data, revoke integration.
- Security: unauthenticated access, role escalation, cross-tenant IDs, XSS, CSRF, rate limits, prompt injection, webhook replay and secrets scanning.
- Accessibility: keyboard-only flows, focus visibility, semantic labels, contrast and screen-reader names.

## Manual smoke test
1. Check desktop and mobile widths; no horizontal overflow.
2. Navigate every sidebar item and verify active state.
3. Create/edit/delete draft and verify persistence.
4. Add a lead, update stage and export data.
5. Create/toggle/delete campaign.
6. Change settings and reload.
7. Verify integration status does not claim unconnected services are live.

## Release gate
Do not use for customer data or production publishing until build and lint pass, automated tests pass, auth and database are live, tenant isolation is verified, backups are tested, secrets are configured safely, and a human security review is complete.
