
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select amount
from "ewa"."main"."int_transactions_deduped"
where amount is null



  
  
      
    ) dbt_internal_test