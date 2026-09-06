

select
    transaction_id,
    employee_id,
    employer_id,
    cast(amount as decimal(10, 2)) as amount,
    status,
    cast(event_time as timestamp) as event_time,
    loaded_at

from "ewa"."main"."raw_transactions"


where loaded_at > (select max(loaded_at) from "ewa"."main"."stg_transactions")
