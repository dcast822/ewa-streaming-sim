
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from "ewa"."main"."stg_advance_requests"
    group by status

)

select *
from all_values
where value_field not in (
    'approved','pending','denied'
)


