





with validation_errors as (

    select
        employee_id, period_number
    from "ewa"."main"."int_employee_pay_periods"
    group by employee_id, period_number
    having count(*) > 1

)

select *
from validation_errors


