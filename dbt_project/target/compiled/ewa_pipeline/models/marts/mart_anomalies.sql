with duplicate_transactions as (

    select
        'duplicate_transaction' as anomaly_type,
        transaction_id as source_id,
        employee_id,
        employer_id,
        amount,
        event_time as event_timestamp,
        'Transaction was redelivered more than once by the streaming producer' as detail

    from "ewa"."main"."int_transactions_deduped"
    where duplicate_flag = true

),

late_arriving_transactions as (

    select
        'late_arriving_transaction' as anomaly_type,
        transaction_id as source_id,
        employee_id,
        employer_id,
        amount,
        event_time as event_timestamp,
        'Event arrived more than 1 hour after it occurred' as detail

    from "ewa"."main"."int_transactions_deduped"
    where loaded_at > event_time + interval '1 hour'

),

high_value_transactions as (

    select
        'high_value_transaction' as anomaly_type,
        transaction_id as source_id,
        employee_id,
        employer_id,
        amount,
        event_time as event_timestamp,
        'Transaction amount exceeds the $1,000 review threshold' as detail

    from "ewa"."main"."int_transactions_deduped"
    where amount > 1000

),

over_cap_advance_requests as (

    select
        'over_cap_advance_request' as anomaly_type,
        request_id as source_id,
        employee_id,
        employer_id,
        requested_amount as amount,
        request_time as event_timestamp,
        'Requested amount exceeds employee max_earnings for the pay period' as detail

    from "ewa"."main"."int_advance_requests"
    where exceeds_max_earnings = true

),

unmatched_advance_requests as (

    select
        'unmatched_pay_period_advance_request' as anomaly_type,
        request_id as source_id,
        employee_id,
        employer_id,
        requested_amount as amount,
        request_time as event_timestamp,
        'Request did not fall within any known pay period window for this employee' as detail

    from "ewa"."main"."int_advance_requests"
    where no_matching_pay_period = true

),

over_cap_earnings as (

    select
        'over_cap_earnings' as anomaly_type,
        employee_id as source_id,
        employee_id,
        employer_id,
        total_confirmed_earnings as amount,
        cast(pay_period_end_date as timestamp) as event_timestamp,
        'Total confirmed earnings for this pay period exceed max_earnings' as detail

    from "ewa"."main"."mart_employee_balances"
    where total_confirmed_earnings > max_earnings

)

select * from duplicate_transactions
union all
select * from late_arriving_transactions
union all
select * from high_value_transactions
union all
select * from over_cap_advance_requests
union all
select * from unmatched_advance_requests
union all
select * from over_cap_earnings