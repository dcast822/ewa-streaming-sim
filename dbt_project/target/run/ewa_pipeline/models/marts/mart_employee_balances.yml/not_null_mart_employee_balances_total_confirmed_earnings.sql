
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_confirmed_earnings
from "ewa"."main"."mart_employee_balances"
where total_confirmed_earnings is null



  
  
      
    ) dbt_internal_test