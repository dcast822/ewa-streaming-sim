
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select no_matching_pay_period
from "ewa"."main"."int_advance_requests"
where no_matching_pay_period is null



  
  
      
    ) dbt_internal_test