
  
  create view "ewa"."main"."int_employee_pay_periods__dbt_tmp" as (
    with employees as (

    select * from "ewa"."main"."stg_employees"

),

date_spine as (

    





with rawdata as (

    

    

    with p as (
        select 0 as generated_number union all select 1
    ), unioned as (

    select

    
    p0.generated_number * power(2, 0)
     + 
    
    p1.generated_number * power(2, 1)
     + 
    
    p2.generated_number * power(2, 2)
     + 
    
    p3.generated_number * power(2, 3)
     + 
    
    p4.generated_number * power(2, 4)
     + 
    
    p5.generated_number * power(2, 5)
     + 
    
    p6.generated_number * power(2, 6)
    
    
    + 1
    as generated_number

    from

    
    p as p0
     cross join 
    
    p as p1
     cross join 
    
    p as p2
     cross join 
    
    p as p3
     cross join 
    
    p as p4
     cross join 
    
    p as p5
     cross join 
    
    p as p6
    
    

    )

    select *
    from unioned
    where generated_number <= 97
    order by generated_number



),

all_periods as (

    select (
        

    ((select min(pay_period_start) from "ewa"."main"."stg_employees") + cast(row_number() over (order by generated_number) - 1 as bigint) * interval 1 day)
    ) as date_day
    from rawdata

),

filtered as (

    select *
    from all_periods
    where date_day <= (cast(current_date as date) + interval '90 day')

)

select * from filtered



),

exploded as (

    select
        employees.employee_id,
        employees.employer_id,
        employees.max_earnings,
        date_spine.date_day,
        cast(
            floor(
                
        (date_diff('day', employees.pay_period_start::timestamp, date_spine.date_day::timestamp ))
     / 14
            ) as integer
        ) as period_number

    from employees
    inner join date_spine
        on date_spine.date_day >= employees.pay_period_start

),

period_bounds as (

    select
        employee_id,
        employer_id,
        max_earnings,
        period_number,
        min(date_day) as pay_period_start_date,
        max(date_day) as pay_period_end_date

    from exploded
    group by employee_id, employer_id, max_earnings, period_number

)

select
    employee_id,
    employer_id,
    max_earnings,
    period_number,
    pay_period_start_date,
    pay_period_end_date

from period_bounds
order by employee_id, period_number
  );
