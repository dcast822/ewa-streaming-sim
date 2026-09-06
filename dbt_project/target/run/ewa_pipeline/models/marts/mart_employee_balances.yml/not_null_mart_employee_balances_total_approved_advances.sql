
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_approved_advances
from "ewa"."main"."mart_employee_balances"
where total_approved_advances is null



  
  
      
    ) dbt_internal_test