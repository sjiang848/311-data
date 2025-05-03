with
    complaints as (
        select *
        from {{ ref("staging_311") }}
        where 
            latitude is not null
            and longitude is not null
            and incident_zip is not null
            and borough is not null
            and created_date is not null
            and closed_date is not null
    ),
    location_dim_cte as (
        select * from {{ ref("location_dim") }}
    ),
    status as (
        select * from {{ ref("status_dim") }}
    ),
    complaint_type as (
        select * from {{ ref("complaint_type_dim") }}
    ),
    agency as (
        select * from {{ ref("agency_dim") }}
    ),
    join_tbl as (
        select
            row_number() over () as complaint_id,
            location_dim_cte.location_id,
            status.status_id,
            complaint_type.complaint_type_id,
            agency.agency_id,
            case
                when closed_date is not null and created_date is not null then
                    DATE_DIFF(DATE(closed_date), DATE(created_date), DAY)
                else null
            end as response_time_in_days
        from complaints
        left join location_dim_cte 
            on trim(complaints.borough) = location_dim_cte.borough
            and trim(complaints.incident_zip) = location_dim_cte.zip_code
            and CAST(complaints.latitude as FLOAT64) = location_dim_cte.latitude
            and CAST(complaints.longitude as FLOAT64) = location_dim_cte.longitude
            and trim(coalesce(complaints.street_Name, 'NA')) = location_dim_cte.street_name
            and trim(coalesce(complaints.incident_address, 'NA')) = location_dim_cte.incident_address
            and trim(coalesce(complaints.cross_street_1, 'NA')) = location_dim_cte.cross_street_1
            and trim(coalesce(complaints.cross_street_2, 'NA')) = location_dim_cte.cross_street_2
            and trim(coalesce(complaints.intersection_street_1, 'NA')) = location_dim_cte.intersection_street_1
            and trim(coalesce(complaints.intersection_street_2, 'NA')) = location_dim_cte.intersection_street_2
            and trim(coalesce(complaints.address_type, 'NA')) = location_dim_cte.address_type
        left join agency
            on trim(complaints.agency_name) = agency.agency_name
        left join status
            on trim(complaints.status) = status.status
        left join complaint_type
            on trim(complaints.complaint_type) = complaint_type.complaint_type
            and trim(complaints.descriptor) = complaint_type.complaint_descriptor
    )
select * 
from join_tbl

