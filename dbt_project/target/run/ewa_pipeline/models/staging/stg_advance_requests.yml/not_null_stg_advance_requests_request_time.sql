
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select request_time
from "ewa"."main"."stg_advance_requests"
where request_time is null



  
  
      
    ) dbt_internal_test