
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select pay_period_start
from "ewa"."main"."stg_employees"
where pay_period_start is null



  
  
      
    ) dbt_internal_test