
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select max_earnings
from "ewa"."main"."stg_employees"
where max_earnings is null



  
  
      
    ) dbt_internal_test