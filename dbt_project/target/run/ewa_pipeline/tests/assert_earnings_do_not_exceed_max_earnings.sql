
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

select
    employee_id,
    total_confirmed_earnings,
    max_earnings,
    total_confirmed_earnings - max_earnings as amount_over_cap

from "ewa"."main"."mart_employee_balances"

where total_confirmed_earnings > max_earnings
  
  
      
    ) dbt_internal_test