
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select status
from "ewa"."main"."int_transactions_deduped"
where status is null



  
  
      
    ) dbt_internal_test