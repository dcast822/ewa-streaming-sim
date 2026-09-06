
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select loaded_at
from "ewa"."main"."int_transactions_deduped"
where loaded_at is null



  
  
      
    ) dbt_internal_test