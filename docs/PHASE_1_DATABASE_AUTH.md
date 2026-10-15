# Phase 1 — Database and Authentication

## Scope
Move from browser-local demo records toward a durable, multi-workspace application without claiming production readiness before verification.

## Database foundation
- Initial schema lives in `supabase/migrations/202610150001_initial_schema.sql`.
- All tenant-owned records carry `workspace_id`.
- RLS must remain enabled for every workspace table.
- Workspace creation is performed through the authenticated `create_workspace(name, slug)` RPC, which atomically creates owner membership and a default brand profile.
- Never use service-role credentials in browser code.

## Implementation gates
1. Create a dedicated Supabase project and set the project URL/key in deployment environment settings.
2. Apply and review the migration; confirm policies using separate users and workspaces.
3. Add server-side session handling and protected routes; anonymous users must not read or mutate private records.
4. Replace local demo persistence with authenticated database APIs incrementally, preserving explicit demo mode when credentials are absent.
5. Add audit events for security-sensitive actions and avoid logging personal content.
6. Add integration tests for tenant isolation and role restrictions.
7. Only then invite internal testers with non-sensitive records.

## Not included yet
The current front end is not yet wired to this schema. Login, password recovery, workspace switching, durable CRUD, invitations and connected AI remain implementation tasks. Do not describe these as active features until implemented and tested.
