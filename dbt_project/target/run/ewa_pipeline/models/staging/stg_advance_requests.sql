
  
  create view "ewa"."main"."stg_advance_requests__dbt_tmp" as (
    select
    request_id,
    employee_id,
    employer_id,
    cast(requested_amount as decimal(10, 2)) as requested_amount,
    status,
    cast(request_time as timestamp) as request_time,
    loaded_at

from "ewa"."main"."raw_advance_requests"
  );
