-- Excel-friendly export of online family predictions. Historic in-person rows, if any, remain labelled accurately.
-- Run in Supabase Dashboard > SQL Editor after real votes have been collected.
-- In the results grid, use Download CSV / Export to CSV, then open the CSV in Excel.

select
  created_at at time zone 'America/Edmonton' as submitted_at_mountain,
  first_name,
  last_name,
  to_be as future_relation,
  email,
  initcap(prediction) as guess,
  case source
    when 'online' then 'Online'
    when 'in_person' then 'In person'
    else source
  end as voting_method
from public.votes
order by created_at asc;
