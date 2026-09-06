
    

    create  table
      "ewa"."main"."mart_employee_balances__dbt_tmp"
  
    
    as (
      with current_period as (

    select
        employee_id,
        employer_id,
        max_earnings,
        period_number,
        pay_period_start_date,
        pay_period_end_date

    from "ewa"."main"."int_employee_pay_periods"
    where current_date between pay_period_start_date and pay_period_end_date

),

confirmed_transactions as (

    select
        current_period.employee_id,
        current_period.employer_id,
        sum(transactions.amount) as total_confirmed_earnings

    from current_period
    left join "ewa"."main"."int_transactions_deduped" as transactions
        on current_period.employee_id = transactions.employee_id
        and transactions.status = 'confirmed'
        and cast(transactions.event_time as date) between current_period.pay_period_start_date and current_period.pay_period_end_date

    group by current_period.employee_id, current_period.employer_id

),

approved_advances as (

    select
        current_period.employee_id,
        current_period.employer_id,
        sum(requests.requested_amount) as total_approved_advances

    from current_period
    left join "ewa"."main"."int_advance_requests" as requests
        on current_period.employee_id = requests.employee_id
        and requests.status = 'approved'
        and cast(requests.request_time as date) between current_period.pay_period_start_date and current_period.pay_period_end_date

    group by current_period.employee_id, current_period.employer_id

)

select
    current_period.employee_id,
    current_period.employer_id,
    current_period.period_number,
    current_period.pay_period_start_date,
    current_period.pay_period_end_date,
    current_period.max_earnings,
    coalesce(confirmed_transactions.total_confirmed_earnings, 0) as total_confirmed_earnings,
    coalesce(approved_advances.total_approved_advances, 0) as total_approved_advances,
    coalesce(confirmed_transactions.total_confirmed_earnings, 0) - coalesce(approved_advances.total_approved_advances, 0) as current_balance

from current_period
left join confirmed_transactions
    on current_period.employee_id = confirmed_transactions.employee_id
left join approved_advances
    on current_period.employee_id = approved_advances.employee_id
    );
    
  