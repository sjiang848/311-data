with complaints as (

  select
    unique_key as Complaint_id,          
    created_date,
    closed_date,
    complaint_type,     
    status,             
    agency,             
    location,            
    case
      when closed_date is not null then 
        TIMESTAMP_DIFF(TIMESTAMP(closed_date), TIMESTAMP(created_date), HOUR)
      else 
        null
    end as Response_time
  from `311_data.311_data_table`
  where latitude is not null and longitude is not null
)

select * from complaints
