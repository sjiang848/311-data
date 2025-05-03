select
  row_number () over () as complaint_type_id,
  complaint_type as complaint_type,
  Descriptor as complaint_descriptor
from {{ ref('staging_311') }}
where complaint_type is not null
and descriptor is not null






