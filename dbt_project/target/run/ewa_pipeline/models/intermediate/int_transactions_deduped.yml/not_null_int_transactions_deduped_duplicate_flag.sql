
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select duplicate_flag
from "ewa"."main"."int_transactions_deduped"
where duplicate_flag is null



  
  
      
    ) dbt_internal_test