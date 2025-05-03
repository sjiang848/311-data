select
  row_number () over () as status_id,
  status as status
from {{ ref('staging_311') }}
where status is not null

order by status_id





