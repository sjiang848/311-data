with location as (
 select
  ROW_NUMBER() OVER () as location_id,
  borough as borough,
  incident_zip as zip_code,
  CAST(latitude as FLOAT64) as latitude,
  CAST(longitude as FLOAT64) as longitude,
  trim(coalesce(street_Name, 'NA')) as street_name,
  location_type as location_type,
  trim(coalesce(incident_address, 'NA')) as incident_address,
  trim(coalesce(cross_street_1, 'NA')) as cross_street_1,
  trim(coalesce(cross_street_2, 'NA')) as cross_street_2,
  trim(coalesce(intersection_street_1, 'NA')) as intersection_street_1,
  trim(coalesce(intersection_street_2, 'NA')) as intersection_street_2,
  trim(coalesce(address_type, 'NA')) as address_type
  FROM (
        SELECT DISTINCT
            borough, 
            incident_zip, 
            latitude, 
            longitude, 
            street_name, 
            location_type,
            incident_address,
            cross_street_1,
            cross_street_2,
            intersection_street_1,
            intersection_street_2,
            address_type
        FROM {{ ref('staging_311') }}
        where location is not null
            and location_type is not null
            and latitude is not null
            and longitude is not null
            and incident_zip is not null 
            and borough is not null
  )
)

select * from location
order by location_id