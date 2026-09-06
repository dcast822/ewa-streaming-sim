
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select amount
from "ewa"."main"."mart_anomalies"
where amount is null



  
  
      
    ) dbt_internal_test