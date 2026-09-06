
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select employer_id
from "ewa"."main"."stg_transactions"
where employer_id is null



  
  
      
    ) dbt_internal_test