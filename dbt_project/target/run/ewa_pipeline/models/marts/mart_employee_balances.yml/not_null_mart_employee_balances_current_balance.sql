
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select current_balance
from "ewa"."main"."mart_employee_balances"
where current_balance is null



  
  
      
    ) dbt_internal_test