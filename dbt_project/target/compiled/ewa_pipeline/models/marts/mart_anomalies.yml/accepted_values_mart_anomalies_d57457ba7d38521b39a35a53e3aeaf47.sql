
    
    

with all_values as (

    select
        anomaly_type as value_field,
        count(*) as n_records

    from "ewa"."main"."mart_anomalies"
    group by anomaly_type

)

select *
from all_values
where value_field not in (
    'duplicate_transaction','late_arriving_transaction','high_value_transaction','over_cap_advance_request','unmatched_pay_period_advance_request'
)


