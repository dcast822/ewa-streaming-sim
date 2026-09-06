
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select transaction_id
from "ewa"."main"."int_transactions_deduped"
where transaction_id is null



  
  
      
    ) dbt_internal_test