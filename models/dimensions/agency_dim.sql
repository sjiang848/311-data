select
  row_number () over () as Agency_id,
  agency_Name as agency_name,
from {{ ref('staging_311') }}
where agency is not null




