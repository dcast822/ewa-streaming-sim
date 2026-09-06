
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_advances
from "ewa"."main"."mart_employer_utilization"
where total_advances is null



  
  
      
    ) dbt_internal_test