-- MAGIXA Marketing OS initial schema.
-- Apply with Supabase CLI after reviewing the project and environment.
create extension if not exists pgcrypto;

create type public.workspace_role as enum ('owner', 'admin', 'marketer', 'sales', 'viewer');
create type public.content_status as enum ('idea', 'draft', 'in_review', 'approved', 'scheduled', 'published', 'archived');
create type public.lead_stage as enum ('new', 'contacted', 'qualified', 'proposal', 'won', 'lost');
create type public.campaign_status as enum ('planning', 'active', 'paused', 'completed', 'cancelled');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.workspaces (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(trim(name)) between 2 and 120),
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  created_by uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.workspace_members (
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role public.workspace_role not null default 'viewer',
  created_at timestamptz not null default now(),
  primary key (workspace_id, user_id)
);
create index workspace_members_user_idx on public.workspace_members(user_id);

create table public.brand_profiles (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null unique references public.workspaces(id) on delete cascade,
  brand_name text not null default '',
  website_url text,
  description text not null default '',
  audience text not null default '',
  services jsonb not null default '[]'::jsonb check (jsonb_typeof(services) = 'array'),
  tone_of_voice text not null default 'professional, clear, natural',
  language text not null default 'ar-EG',
  primary_cta text not null default '',
  approved_claims jsonb not null default '[]'::jsonb check (jsonb_typeof(approved_claims) = 'array'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.content_drafts (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  title text not null check (char_length(trim(title)) between 1 and 240),
  body text not null default '',
  platform text not null default 'general',
  status public.content_status not null default 'draft',
  tags text[] not null default '{}',
  scheduled_at timestamptz,
  published_at timestamptz,
  created_by uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index content_drafts_workspace_updated_idx on public.content_drafts(workspace_id, updated_at desc);

create table public.leads (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  name text not null check (char_length(trim(name)) between 1 and 200),
  company text not null default '',
  email text,
  phone text,
  source text not null default 'manual',
  stage public.lead_stage not null default 'new',
  estimated_value numeric(12,2) not null default 0 check (estimated_value >= 0),
  currency char(3) not null default 'EGP',
  owner_id uuid references auth.users(id) on delete set null,
  next_follow_up_at timestamptz,
  consent_basis text,
  notes text not null default '',
  created_by uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index leads_workspace_stage_idx on public.leads(workspace_id, stage);
create index leads_workspace_followup_idx on public.leads(workspace_id, next_follow_up_at);

create table public.lead_activities (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  lead_id uuid not null references public.leads(id) on delete cascade,
  activity_type text not null check (activity_type in ('note','call','email','meeting','stage_change','task')),
  summary text not null check (char_length(trim(summary)) between 1 and 2000),
  due_at timestamptz,
  completed_at timestamptz,
  created_by uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now()
);
create index lead_activities_lead_idx on public.lead_activities(lead_id, created_at desc);

create table public.campaigns (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  name text not null check (char_length(trim(name)) between 1 and 200),
  objective text not null default '',
  channel text not null default 'social',
  audience text not null default '',
  budget numeric(12,2) not null default 0 check (budget >= 0),
  currency char(3) not null default 'EGP',
  starts_on date,
  ends_on date,
  status public.campaign_status not null default 'planning',
  kpis jsonb not null default '{}'::jsonb check (jsonb_typeof(kpis) = 'object'),
  created_by uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (ends_on is null or starts_on is null or ends_on >= starts_on)
);
create index campaigns_workspace_status_idx on public.campaigns(workspace_id, status);

create table public.calendar_entries (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  draft_id uuid references public.content_drafts(id) on delete set null,
  title text not null check (char_length(trim(title)) between 1 and 240),
  channel text not null default 'social',
  scheduled_at timestamptz not null,
  status public.content_status not null default 'draft',
  provider_post_id text,
  last_error text,
  created_by uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index calendar_workspace_schedule_idx on public.calendar_entries(workspace_id, scheduled_at);

create table public.audit_events (
  id bigint generated always as identity primary key,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  actor_id uuid references auth.users(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id text,
  metadata jsonb not null default '{}'::jsonb check (jsonb_typeof(metadata) = 'object'),
  created_at timestamptz not null default now()
);
create index audit_events_workspace_created_idx on public.audit_events(workspace_id, created_at desc);

create or replace function public.set_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_updated_at before update on public.profiles for each row execute function public.set_updated_at();
create trigger workspaces_updated_at before update on public.workspaces for each row execute function public.set_updated_at();
create trigger brand_profiles_updated_at before update on public.brand_profiles for each row execute function public.set_updated_at();
create trigger content_drafts_updated_at before update on public.content_drafts for each row execute function public.set_updated_at();
create trigger leads_updated_at before update on public.leads for each row execute function public.set_updated_at();
create trigger campaigns_updated_at before update on public.campaigns for each row execute function public.set_updated_at();
create trigger calendar_entries_updated_at before update on public.calendar_entries for each row execute function public.set_updated_at();

create or replace function public.is_workspace_member(target_workspace uuid)
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.workspace_members wm
    where wm.workspace_id = target_workspace and wm.user_id = (select auth.uid())
  );
$$;

create or replace function public.has_workspace_role(target_workspace uuid, allowed_roles public.workspace_role[])
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.workspace_members wm
    where wm.workspace_id = target_workspace
      and wm.user_id = (select auth.uid())
      and wm.role = any(allowed_roles)
  );
$$;

-- Atomic workspace bootstrap for the signed-in user. Slug must be unique.
create or replace function public.create_workspace(workspace_name text, workspace_slug text)
returns uuid language plpgsql security definer set search_path = '' as $$
declare new_workspace_id uuid;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  if char_length(trim(workspace_name)) not between 2 and 120 then raise exception 'Invalid workspace name'; end if;
  if workspace_slug !~ '^[a-z0-9]+(-[a-z0-9]+)*$' then raise exception 'Invalid workspace slug'; end if;
  insert into public.workspaces(name, slug, created_by)
    values (trim(workspace_name), workspace_slug, auth.uid())
    returning id into new_workspace_id;
  insert into public.workspace_members(workspace_id, user_id, role)
    values (new_workspace_id, auth.uid(), 'owner');
  insert into public.brand_profiles(workspace_id, brand_name)
    values (new_workspace_id, trim(workspace_name));
  return new_workspace_id;
end;
$$;

alter table public.profiles enable row level security;
alter table public.workspaces enable row level security;
alter table public.workspace_members enable row level security;
alter table public.brand_profiles enable row level security;
alter table public.content_drafts enable row level security;
alter table public.leads enable row level security;
alter table public.lead_activities enable row level security;
alter table public.campaigns enable row level security;
alter table public.calendar_entries enable row level security;
alter table public.audit_events enable row level security;

create policy "profiles_read_self" on public.profiles for select to authenticated using (id = (select auth.uid()));
create policy "profiles_insert_self" on public.profiles for insert to authenticated with check (id = (select auth.uid()));
create policy "profiles_update_self" on public.profiles for update to authenticated using (id = (select auth.uid())) with check (id = (select auth.uid()));

create policy "workspaces_read_member" on public.workspaces for select to authenticated using (public.is_workspace_member(id));
create policy "workspaces_update_admin" on public.workspaces for update to authenticated using (public.has_workspace_role(id, array['owner','admin']::public.workspace_role[])) with check (public.has_workspace_role(id, array['owner','admin']::public.workspace_role[]));
create policy "members_read_workspace" on public.workspace_members for select to authenticated using (public.is_workspace_member(workspace_id));
create policy "members_manage_admin" on public.workspace_members for all to authenticated using (public.has_workspace_role(workspace_id, array['owner','admin']::public.workspace_role[])) with check (public.has_workspace_role(workspace_id, array['owner','admin']::public.workspace_role[]));

create policy "brand_member_read" on public.brand_profiles for select to authenticated using (public.is_workspace_member(workspace_id));
create policy "brand_editor_write" on public.brand_profiles for all to authenticated using (public.has_workspace_role(workspace_id, array['owner','admin','marketer']::public.workspace_role[])) with check (public.has_workspace_role(workspace_id, array['owner','admin','marketer']::public.workspace_role[]));

create policy "draft_member_read" on public.content_drafts for select to authenticated using (public.is_workspace_member(workspace_id));
create policy "draft_editor_write" on public.content_drafts for all to authenticated using (public.has_workspace_role(workspace_id, array['owner','admin','marketer']::public.workspace_role[])) with check (public.has_workspace_role(workspace_id, array['owner','admin','marketer']::public.workspace_role[]));

create policy "lead_member_read" on public.leads for select to authenticated using (public.is_workspace_member(workspace_id));
create policy "lead_sales_write" on public.leads for all to authenticated using (public.has_workspace_role(workspace_id, array['owner','admin','sales']::public.workspace_role[])) with check (public.has_workspace_role(workspace_id, array['owner','admin','sales']::public.workspace_role[]));

create policy "activity_member_read" on public.lead_activities for select to authenticated using (public.is_workspace_member(workspace_id));
create policy "activity_sales_write" on public.lead_activities for all to authenticated using (public.has_workspace_role(workspace_id, array['owner','admin','sales']::public.workspace_role[])) with check (public.has_workspace_role(workspace_id, array['owner','admin','sales']::public.workspace_role[]));

create policy "campaign_member_read" on public.campaigns for select to authenticated using (public.is_workspace_member(workspace_id));
create policy "campaign_marketer_write" on public.campaigns for all to authenticated using (public.has_workspace_role(workspace_id, array['owner','admin','marketer']::public.workspace_role[])) with check (public.has_workspace_role(workspace_id, array['owner','admin','marketer']::public.workspace_role[]));

create policy "calendar_member_read" on public.calendar_entries for select to authenticated using (public.is_workspace_member(workspace_id));
create policy "calendar_marketer_write" on public.calendar_entries for all to authenticated using (public.has_workspace_role(workspace_id, array['owner','admin','marketer']::public.workspace_role[])) with check (public.has_workspace_role(workspace_id, array['owner','admin','marketer']::public.workspace_role[]));

create policy "audit_member_read" on public.audit_events for select to authenticated using (public.is_workspace_member(workspace_id));
create policy "audit_admin_insert" on public.audit_events for insert to authenticated with check (
  public.is_workspace_member(workspace_id) and actor_id = (select auth.uid())
);

grant execute on function public.create_workspace(text, text) to authenticated;
grant execute on function public.is_workspace_member(uuid) to authenticated;
grant execute on function public.has_workspace_role(uuid, public.workspace_role[]) to authenticated;

-- New signups get a profile row. No role is inferred from email or user metadata.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles(id, display_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'name', ''))
  on conflict (id) do nothing;
  return new;
end;
$$;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();
