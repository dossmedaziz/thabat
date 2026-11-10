-- Thabat (ثبات) schema for the dedicated "thabat" Supabase project.
-- Every row belongs to one auth user and RLS only lets that user read or write it.

-- ---------- profiles ----------
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  email text,
  photo_url text,
  locale text not null default 'ar' check (locale in ('ar', 'en', 'fr')),
  week_start text not null default 'monday' check (week_start in ('monday', 'saturday', 'sunday')),
  theme_mode text not null default 'system' check (theme_mode in ('light', 'dark', 'system')),
  created_at timestamptz not null default now()
);

-- ---------- habits ----------
create table public.habits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  type text not null check (type in ('good', 'bad')),
  name text not null check (char_length(name) between 1 and 40),
  emoji text not null default 'icon:star',
  color_hex text not null default '#14A383',
  note text check (note is null or char_length(note) <= 300),
  frequency text not null default 'daily' check (frequency in ('daily', 'weekly', 'monthly')),
  target_per_period int not null default 1 check (target_per_period between 1 and 31),
  weekdays int[] not null default '{}',
  goal jsonb,
  reminder jsonb,
  archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index habits_user_id_idx on public.habits (user_id);

-- ---------- logs (one per habit per day) ----------
create table public.habit_logs (
  habit_id uuid not null references public.habits (id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  date date not null,
  status text not null check (status in ('done', 'skipped', 'slipped')),
  count int not null default 1 check (count >= 0),
  note text,
  created_at timestamptz not null default now(),
  primary key (habit_id, date)
);
create index habit_logs_user_id_idx on public.habit_logs (user_id);

-- ---------- achievements ----------
create table public.achievements (
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  achievement_id text not null,
  unlocked_at timestamptz not null default now(),
  primary key (user_id, achievement_id)
);

-- ---------- updated_at ----------
create function public.touch_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create trigger habits_touch_updated_at
before update on public.habits
for each row execute function public.touch_updated_at();

-- ---------- row level security ----------
alter table public.profiles enable row level security;
alter table public.habits enable row level security;
alter table public.habit_logs enable row level security;
alter table public.achievements enable row level security;

create policy "profiles: own row" on public.profiles
  for all to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

create policy "habits: own rows" on public.habits
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- A log may only point at one of the user's own habits.
create policy "habit_logs: own rows" on public.habit_logs
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check (
    (select auth.uid()) = user_id
    and exists (
      select 1 from public.habits h
      where h.id = habit_id and h.user_id = (select auth.uid())
    )
  );

create policy "achievements: own rows" on public.achievements
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- ---------- delete account ----------
-- Deletes the caller's auth user; every table cascades from auth.users, so all
-- of their habits, logs, badges and profile go with it.
create function public.delete_my_account()
returns void
language sql
security definer
set search_path = ''
as $$
  delete from auth.users where id = (select auth.uid());
$$;

revoke execute on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;
