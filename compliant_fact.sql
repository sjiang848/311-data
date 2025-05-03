with 
     complaint as (
        select * from {{ref("staging_311")}}
        where 
           agency is not null
           and complaint_type is not null
           and descriptor is not null
           and status is not null
           and location_type is not null
           and latitude is not null
           and longitude is not null 
           and borough is not null
           and incident_zip is not null
     ),
dates as (select * from {{ ref("group-5-data-warehousing.dbt_transformed_mvcc.date_dim")}}),
location as (select * from {{ref("location_dim")}}),
times as (select * from {{ref("group-5-data-warehousing.dbt_transformed_mvcc.time_dim")}}),
agency as (select * from {{ref("agency.dim")}}),
complaint_type as (select * from {{ref("complaint_type_dim")}}),
status as (select * from {{ref("status_dim")}}),
join_tbl as (
    select
        row_number() over () as complaint_id,
        created_date,
        closed_date,
        complaint_type.complaint_type_id,
        status.status_id,
        agency.agency_id,
        location.location_id,
        dates.date_id,
        times.time_id,
        latitude,
        longitude,
            case
                when closed_date is not null and created_date is not null
                then
                    timestamp_diff(
                        cast(closed_date as timestamp),
                        cast(created_date as timestamp),
                        day
                    )
                else null
            end as response_time  
    from complaint
    left join dates on CAST(FORMAT_DATE('%Y%m%d', SAFE.PARSE_DATE('%Y-%m-%d', SUBSTR(all_collisions.carsh_date, 1, 10))) AS INT64)
                    = dates.date_id
    left join {{ ref("complaint_type_dim") }} ct on c.complaint_type = ct.complaint_type

    left join {{ ref("agency_dim") }} ag on c.agency = ag.agency_name

    left join {{ ref("status_dim") }} st on c.status = st.status

    left join
              {{ ref("location_dim") }} loc
              on cast(c.latitude as float64) = loc.latitude
              and cast(c.longitude as float64) = loc.longitude
    left join 
        times
           on lpad(split(all_collisions.crash_time, ':')[OFFSET(0)], 2, '0') || ':' ||
              lpad(split(all_collisions.crash_time, ':')[OFFSET(1)], 2, '0') || ':00'
            = times.time_id
   )
select * 
from join_tbl
             

                      
    
