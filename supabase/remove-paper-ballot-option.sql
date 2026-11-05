-- Run once in Supabase SQL Editor after deploying the online-only website.
-- This blocks any remaining old paper-ballot endpoint from adding new in-person rows,
-- while preserving existing records for audit/history.
do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'votes_online_only_after_paper_ballots_removed'
      and conrelid = 'public.votes'::regclass
  ) then
    alter table public.votes
      add constraint votes_online_only_after_paper_ballots_removed
      check (source = 'online') not valid;
  end if;
end $$;
