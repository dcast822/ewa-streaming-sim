
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select anomaly_type
from "ewa"."main"."mart_anomalies"
where anomaly_type is null



  
  
      
    ) dbt_internal_test