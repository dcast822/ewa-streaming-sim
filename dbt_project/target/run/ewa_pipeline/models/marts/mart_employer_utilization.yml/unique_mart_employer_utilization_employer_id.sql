
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    employer_id as unique_field,
    count(*) as n_records

from "ewa"."main"."mart_employer_utilization"
where employer_id is not null
group by employer_id
having count(*) > 1



  
  
      
    ) dbt_internal_test