
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select employer_id as from_field
    from "ewa"."main"."stg_employees"
    where employer_id is not null
),

parent as (
    select employer_id as to_field
    from "ewa"."main"."stg_employers"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test