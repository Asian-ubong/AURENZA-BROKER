-- AURENZA BACKEND CONTRACT
--
-- The mobile application expects these backend RPCs.
-- They must return backend-owned data.
--
-- IMPORTANT:
-- Do not expose service-role keys in Flutter.
-- Use Supabase RLS and SECURITY DEFINER functions
-- with strict authorization in the real implementation.

create or replace function public.get_backend_health()
returns json
language sql
security invoker
as $$
  select json_build_object(
    'status', 'ok',
    'service', 'aurenza-broker'
  );
$$;

-- The production dashboard function should be implemented
-- against the canonical wallet/ledger tables.
--
-- Expected JSON:
--
-- {
--   "balance": 0,
--   "available": 0,
--   "reserved": 0,
--   "pnl": 0,
--   "portfolio_value": 0,
--   "currency": "USD",
--   "sandbox_mode": true
-- }
--
-- This placeholder intentionally does not fabricate financial data.
-- Replace it after the canonical wallet/ledger schema is connected.

create or replace function public.get_broker_dashboard()
returns json
language sql
security invoker
as $$
  select json_build_object(
    'balance', 0,
    'available', 0,
    'reserved', 0,
    'pnl', 0,
    'portfolio_value', 0,
    'currency', 'USD',
    'sandbox_mode', true
  )
  where auth.uid() is not null;
$$;
