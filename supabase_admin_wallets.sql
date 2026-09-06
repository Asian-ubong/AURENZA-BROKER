-- AURENZA FINANCE: SEPARATE COMPANY WALLET + USER WALLETS
--
-- Company treasury is NEVER a customer wallet.
-- Every authenticated customer gets exactly one user wallet.
-- Customer wallet rows start at zero and become non-zero only when
-- real wallet/ledger events are posted by trusted backend flows.
--
-- Apply this migration to the production Supabase project before
-- treating the admin finance screen as production financial data.

create extension if not exists pgcrypto;

create table if not exists public.wallet_accounts (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid references auth.users(id) on delete cascade,
  wallet_type text not null check (wallet_type in ('company', 'user')),
  currency text not null default 'USD',
  total_balance numeric(20,8) not null default 0,
  available_balance numeric(20,8) not null default 0,
  reserved_balance numeric(20,8) not null default 0,
  sandbox_capital numeric(20,8) not null default 0,
  trading_balance numeric(20,8) not null default 0,
  profit_balance numeric(20,8) not null default 0,
  withdrawable_balance numeric(20,8) not null default 0,
  deposit_status text not null default 'none',
  payout_status text not null default 'none',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint company_wallet_has_no_owner check (
    (wallet_type = 'company' and owner_user_id is null)
    or (wallet_type = 'user' and owner_user_id is not null)
  )
);

create unique index if not exists wallet_accounts_one_user_wallet
  on public.wallet_accounts(owner_user_id)
  where wallet_type = 'user';

create unique index if not exists wallet_accounts_one_company_wallet
  on public.wallet_accounts(wallet_type)
  where wallet_type = 'company';

create index if not exists wallet_accounts_owner_idx
  on public.wallet_accounts(owner_user_id);

create table if not exists public.wallet_movements (
  id uuid primary key default gen_random_uuid(),
  wallet_id uuid not null references public.wallet_accounts(id) on delete cascade,
  movement_type text not null,
  amount numeric(20,8) not null,
  balance_after numeric(20,8) not null,
  reference_id text,
  description text,
  created_at timestamptz not null default now()
);

create index if not exists wallet_movements_wallet_created_idx
  on public.wallet_movements(wallet_id, created_at desc);

-- Ensure the company wallet exists. This is the company treasury,
-- not money belonging to any customer.
insert into public.wallet_accounts (wallet_type, currency)
values ('company', 'USD')
on conflict do nothing;

-- Create a zeroed customer wallet automatically when a Supabase Auth user
-- is created. No deposit/profit is fabricated by this trigger.
create or replace function public.ensure_user_wallet()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.wallet_accounts (owner_user_id, wallet_type, currency)
  values (new.id, 'user', 'USD')
  on conflict do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created_wallet on auth.users;
create trigger on_auth_user_created_wallet
after insert on auth.users
for each row execute function public.ensure_user_wallet();

-- Backfill a zeroed wallet for existing authenticated users.
insert into public.wallet_accounts (owner_user_id, wallet_type, currency)
select u.id, 'user', 'USD'
from auth.users u
where not exists (
  select 1 from public.wallet_accounts w
  where w.owner_user_id = u.id and w.wallet_type = 'user'
);

alter table public.wallet_accounts enable row level security;
alter table public.wallet_movements enable row level security;

revoke all on table public.wallet_accounts from anon, authenticated;
revoke all on table public.wallet_movements from anon, authenticated;

-- Customers can read only their own wallet and movements.
create policy wallet_accounts_user_select
on public.wallet_accounts
for select to authenticated
using (wallet_type = 'user' and owner_user_id = (select auth.uid()));

create policy wallet_movements_user_select
on public.wallet_movements
for select to authenticated
using (
  exists (
    select 1 from public.wallet_accounts w
    where w.id = wallet_movements.wallet_id
      and w.wallet_type = 'user'
      and w.owner_user_id = (select auth.uid())
  )
);

-- Admin access is exposed only through tightly authorized SECURITY DEFINER
-- functions. The client never receives direct write access to wallet tables.
create or replace function public.is_aurenza_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    (select raw_app_meta_data ->> 'role' from auth.users where id = (select auth.uid()))
      in ('super_admin','admin','compliance','risk_manager','support'),
    false
  );
$$;

revoke execute on function public.is_aurenza_admin() from public, anon, authenticated;
grant execute on function public.is_aurenza_admin() to authenticated;

create or replace function public.get_admin_wallet_overview()
returns json
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  company json;
  users json;
begin
  if not public.is_aurenza_admin() then
    raise exception 'admin access required' using errcode = '42501';
  end if;

  select json_build_object(
    'wallet_id', w.id,
    'currency', w.currency,
    'total_balance', w.total_balance,
    'available_balance', w.available_balance,
    'reserved_balance', w.reserved_balance,
    'sandbox_capital', w.sandbox_capital,
    'trading_balance', w.trading_balance,
    'profit_balance', w.profit_balance,
    'withdrawable_balance', w.withdrawable_balance,
    'deposit_status', w.deposit_status,
    'payout_status', w.payout_status,
    'updated_at', w.updated_at
  ) into company
  from public.wallet_accounts w
  where w.wallet_type = 'company'
  limit 1;

  select coalesce(json_agg(row_to_json(x) order by x.display_name, x.user_id), '[]'::json)
  into users
  from (
    select
      w.id as wallet_id,
      w.owner_user_id as user_id,
      coalesce(
        nullif(trim(concat_ws(' ', u.raw_user_meta_data ->> 'first_name', u.raw_user_meta_data ->> 'last_name')), ''),
        nullif(u.raw_user_meta_data ->> 'full_name', ''),
        u.email,
        'User'
      ) as display_name,
      u.email,
      w.currency,
      w.total_balance,
      w.available_balance,
      w.reserved_balance,
      w.sandbox_capital,
      w.trading_balance,
      w.profit_balance,
      w.withdrawable_balance,
      w.deposit_status,
      w.payout_status,
      w.updated_at
    from public.wallet_accounts w
    join auth.users u on u.id = w.owner_user_id
    where w.wallet_type = 'user'
  ) x;

  return json_build_object(
    'company_wallet', coalesce(company, '{}'::json),
    'user_wallets', users
  );
end;
$$;

revoke execute on function public.get_admin_wallet_overview() from public, anon;
grant execute on function public.get_admin_wallet_overview() to authenticated;

-- A withdrawal approval must be implemented later as an atomic backend
-- transaction that locks the exact requesting wallet and checks its
-- withdrawable_balance. Admin UI must never transfer funds between users.
