
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_earned_wages
from "ewa"."main"."mart_employer_utilization"
where total_earned_wages is null



  
  
      
    ) dbt_internal_test