
    

    create  table
      "ewa"."main"."mart_employer_utilization__dbt_tmp"
  
    
    as (
      select
    employer_id,
    sum(total_confirmed_earnings) as total_earned_wages,
    sum(total_approved_advances) as total_advances,
    case
        when sum(total_confirmed_earnings) = 0 then null
        else round((sum(total_approved_advances) / sum(total_confirmed_earnings)) * 100, 2)
    end as utilization_rate_pct

from "ewa"."main"."mart_employee_balances"
group by employer_id
    );
    
  