select
    employee_id,
    employer_id,
    cast(max_earnings as decimal(10,2)) as max_earnings,
    cast(pay_period_start as date) as pay_period_start

from "ewa"."main"."employees"