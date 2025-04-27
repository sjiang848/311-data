select
  location as location_id,
  borough as borough,
  incident_zip as zip_code,
  latitude as latitude,
  longitude as longitude,
  street_Name as street_name,
  location_type as location_type,
  incident_address as incident_address,
  cross_street_1 as cross_street_1,
  cross_street_2 as cross_street_2,
  intersection_street_1 as intersection_street_1,
  intersection_street_2 as intersection_street_2,
  address_type as address_type
from `311_data.311_data_table`
where location is not null
and location_type is not null
and cross_street_1 is not null
and cross_street_2 is not null
and intersection_street_1 is not null
and intersection_street_2 is not null
and address_type is not null
and street_name is not null
and incident_address is not null