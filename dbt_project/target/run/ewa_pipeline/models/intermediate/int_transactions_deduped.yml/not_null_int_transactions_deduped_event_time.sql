
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select event_time
from "ewa"."main"."int_transactions_deduped"
where event_time is null



  
  
      
    ) dbt_internal_test