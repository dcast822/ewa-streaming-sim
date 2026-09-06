
  
  create view "ewa"."main"."int_advance_requests__dbt_tmp" as (
    with requests as (

    select * from "ewa"."main"."stg_advance_requests"

),

pay_periods as (

    select * from "ewa"."main"."int_employee_pay_periods"

),

matched_requests as (

    select
        requests.request_id,
        requests.employee_id,
        requests.employer_id,
        requests.requested_amount,
        requests.status,
        requests.request_time,
        pay_periods.period_number,
        pay_periods.pay_period_start_date,
        pay_periods.pay_period_end_date,
        pay_periods.max_earnings

    from requests
    left join pay_periods
        on requests.employee_id = pay_periods.employee_id
        and cast(
            requests.request_time as date
        ) between pay_periods.pay_period_start_date and pay_periods.pay_period_end_date

)

select
    request_id,
    employee_id,
    employer_id,
    requested_amount,
    status,
    request_time,
    period_number,
    pay_period_start_date,
    pay_period_end_date,
    max_earnings,
    (pay_period_start_date is null) as no_matching_pay_period,
    (requested_amount > max_earnings) as exceeds_max_earnings

from matched_requests
  );
