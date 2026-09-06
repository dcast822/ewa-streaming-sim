
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select requested_amount
from "ewa"."main"."int_advance_requests"
where requested_amount is null



  
  
      
    ) dbt_internal_test