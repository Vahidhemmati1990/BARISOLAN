-- BARISOLAN v2 database foundation

create table if not exists public.site_content (
  id bigint generated always as identity primary key,
  locale text not null check (locale in ('fa','ar')),
  page_slug text not null,
  section_key text not null,
  content jsonb not null default '{}'::jsonb,
  is_published boolean not null default true,
  updated_at timestamptz default now(),
  unique(locale,page_slug,section_key)
);

create table if not exists public.site_settings (
  setting_key text primary key,
  setting_value jsonb not null default '{}'::jsonb,
  updated_at timestamptz default now()
);

create table if not exists public.site_themes (
  id bigint generated always as identity primary key,
  theme_key text unique not null,
  theme_name text not null,
  theme_config jsonb not null default '{}'::jsonb,
  is_active boolean default false,
  updated_at timestamptz default now()
);

alter table public.site_content enable row level security;
alter table public.site_settings enable row level security;
alter table public.site_themes enable row level security;

create policy "Public read published content"
on public.site_content for select
using (is_published = true);

create policy "Public read settings"
on public.site_settings for select
using (true);

create policy "Public read active theme"
on public.site_themes for select
using (is_active = true);

create policy "Admins manage content"
on public.site_content for all to authenticated
using ((auth.jwt()->'app_metadata'->>'role')='admin')
with check ((auth.jwt()->'app_metadata'->>'role')='admin');

create policy "Admins manage settings"
on public.site_settings for all to authenticated
using ((auth.jwt()->'app_metadata'->>'role')='admin')
with check ((auth.jwt()->'app_metadata'->>'role')='admin');

create policy "Admins manage themes"
on public.site_themes for all to authenticated
using ((auth.jwt()->'app_metadata'->>'role')='admin')
with check ((auth.jwt()->'app_metadata'->>'role')='admin');
