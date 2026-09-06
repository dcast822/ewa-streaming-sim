
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select status
from "ewa"."main"."stg_ewa__transactions"
where status is null



  
  
      
    ) dbt_internal_test