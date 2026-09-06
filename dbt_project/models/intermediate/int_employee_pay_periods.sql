with employees as (

    select * from {{ ref('stg_employees') }}

),

date_spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="(select min(pay_period_start) from " ~ ref('stg_employees') ~ ")",
        end_date="(cast(current_date as date) + interval '90 day')"
    ) }}

),

exploded as (

    select
        employees.employee_id,
        employees.employer_id,
        employees.max_earnings,
        date_spine.date_day,
        cast(
            floor(
                {{ dbt.datediff('employees.pay_period_start', 'date_spine.date_day', 'day') }} / 14
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