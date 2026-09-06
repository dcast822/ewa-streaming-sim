with staged as (

    select * from {{ ref('stg_transactions') }}

),

numbered as (

    select
        *,
        row_number() over (
            partition by transaction_id
            order by loaded_at desc
        ) as rn,
        count(*) over (partition by transaction_id) as occurrence_count

    from staged

)

select
    transaction_id,
    employee_id,
    employer_id,
    amount,
    status,
    event_time,
    loaded_at,
    occurrence_count > 1 as duplicate_flag

from numbered
where rn = 1