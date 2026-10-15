# Supabase database setup

This folder contains the first tenant-scoped PostgreSQL migration for MAGIXA Marketing OS.

## Before applying
- Create a dedicated Supabase project for this app; do not reuse the clinic demo project.
- Confirm the region, data retention, backup plan and pricing first.
- Review the migration with a database/security reviewer.
- Never commit API keys or service-role secrets.

## Apply with Supabase CLI
1. Install the Supabase CLI.
2. Link this repository to the new project with `supabase link`.
3. Run `supabase db push` after reviewing the SQL and confirming the linked project is correct.
4. Test with at least two independent accounts and two workspaces. Verify no cross-workspace reads or writes.
5. Confirm policies against the exact app queries before storing customer information.

## Included
- Profiles, workspaces, memberships and role enum.
- Brand profile, content drafts, leads, lead activities, campaigns, calendar entries and audit events.
- Row-level security (RLS) policies and an atomic `create_workspace` RPC.
- Updated-at triggers and a signup profile trigger.

## Important
This migration is a security-minded starting point, not a certification. Review RLS behavior, role changes, RPC grants, foreign-key ownership, audit immutability, deletion policy and performance before production. Do not store credentials, patient data, payment data or other sensitive information in the current demo UI.
