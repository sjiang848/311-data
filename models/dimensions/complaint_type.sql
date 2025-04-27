select
  complaint_type as complaint_type_id,
  complaint_type as complaint_type,
  descriptor as descriptor
from `311_data.311_data_table`
where complaint_type is not null
and descriptor is not null
