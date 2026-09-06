
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select exceeds_max_earnings
from "ewa"."main"."int_advance_requests"
where exceeds_max_earnings is null



  
  
      
    ) dbt_internal_test