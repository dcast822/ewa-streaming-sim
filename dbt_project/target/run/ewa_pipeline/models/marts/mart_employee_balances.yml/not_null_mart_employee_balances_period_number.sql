
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select period_number
from "ewa"."main"."mart_employee_balances"
where period_number is null



  
  
      
    ) dbt_internal_test