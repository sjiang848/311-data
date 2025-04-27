select
  agency as Agency_id,
  agency_Name as Agency_name,
  Location as Location
from `311_data.311_data_table`
where agency is not null
and location is not null


