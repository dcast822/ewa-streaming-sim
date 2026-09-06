
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select pay_period_end_date
from "ewa"."main"."mart_employee_balances"
where pay_period_end_date is null



  
  
      
    ) dbt_internal_test