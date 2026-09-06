
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select pay_period_end_date
from "ewa"."main"."int_employee_pay_periods"
where pay_period_end_date is null



  
  
      
    ) dbt_internal_test