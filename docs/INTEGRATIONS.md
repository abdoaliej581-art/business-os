# Integration Readiness

## AI provider
A provider API key must be added only to server-side environment storage. Implement request limits, schema validation, timeout/cancellation, retry policy, model allowlist, cost caps, safe errors and usage audit records. The current UI idea helper is local/template-based, not a live AI call.

## Social platforms
Use official developer applications, OAuth and supported APIs. Confirm eligibility, scopes, review requirements, media formats and publishing limits per platform. Tokens are encrypted server-side and refresh/revoke flows are required. Never collect passwords or simulate successful publishing.

## Email and messaging
Use approved providers and permission-based contacts. Support opt-out/suppression, bounce handling, rate controls, sender authentication and consent records. No unsolicited bulk messaging or automatic scraping.

## Analytics
Only display imported or verified metrics with source and timestamp. Keep planned reach/budget separate from actual results. Provide UTM tracking and data freshness labels.

## Current status
AI provider: not connected. Database/auth: not connected. Social publishing: not connected. Email: not connected. Analytics imports: not connected.
