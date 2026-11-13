-- AQILEXA starter cloud schema
-- Review this schema and test RLS in a non-production Supabase project first.
-- Run in Supabase SQL Editor. Never expose service_role keys in Flutter.

create table if not exists public.aqilexa_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  record_type text not null,
  record_id text not null,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (user_id, record_type, record_id)
);

create index if not exists aqilexa_records_user_updated_idx
  on public.aqilexa_records (user_id, updated_at);

alter table public.aqilexa_records enable row level security;

drop policy if exists "Users can read own AQILEXA records"
  on public.aqilexa_records;
create policy "Users can read own AQILEXA records"
  on public.aqilexa_records for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert own AQILEXA records"
  on public.aqilexa_records;
create policy "Users can insert own AQILEXA records"
  on public.aqilexa_records for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update own AQILEXA records"
  on public.aqilexa_records;
create policy "Users can update own AQILEXA records"
  on public.aqilexa_records for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete own AQILEXA records"
  on public.aqilexa_records;
create policy "Users can delete own AQILEXA records"
  on public.aqilexa_records for delete
  using (auth.uid() = user_id);
