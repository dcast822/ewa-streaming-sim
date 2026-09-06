
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select employee_id as from_field
    from "ewa"."main"."int_employee_pay_periods"
    where employee_id is not null
),

parent as (
    select employee_id as to_field
    from "ewa"."main"."stg_employees"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test