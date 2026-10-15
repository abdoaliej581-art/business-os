# Security and Privacy Baseline

- Authentication and authorization must be enforced server-side for every private operation.
- Use workspace membership roles (owner, admin, marketer, sales, viewer); default deny and least privilege.
- Enforce database row-level security and workspace-scoped queries; test tenant isolation.
- Keep API keys and OAuth tokens in server-only encrypted secret storage. Never put secrets in NEXT_PUBLIC variables, source control, browser storage, logs, or AI prompts.
- Validate input schemas, limit payload sizes, sanitize rendered user content and use parameterized database queries.
- Add CSRF protections where applicable, strict CORS, secure cookies, rate limiting, abuse controls, and security headers.
- Verify webhooks cryptographically; reject stale/replayed events and use idempotency keys.
- Minimize personal data; define retention, export, deletion, consent, and incident response processes.
- Never place patient records, credentials, payment card data or other sensitive production data in the current local-storage demo.
- Use audit logs for login, role changes, exports, integration changes, and external publish actions.
- Production launch requires dependency scanning, secret scanning, SAST, DAST, backup-restore drill and human security review.
