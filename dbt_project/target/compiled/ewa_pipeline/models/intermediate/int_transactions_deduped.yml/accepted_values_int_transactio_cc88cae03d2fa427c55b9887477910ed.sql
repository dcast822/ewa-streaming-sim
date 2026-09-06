
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from "ewa"."main"."int_transactions_deduped"
    group by status

)

select *
from all_values
where value_field not in (
    'confirmed','pending','reversed'
)


