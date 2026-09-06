

select
    employee_id,
    total_confirmed_earnings,
    max_earnings,
    total_confirmed_earnings - max_earnings as amount_over_cap

from "ewa"."main"."mart_employee_balances"

where total_confirmed_earnings > max_earnings