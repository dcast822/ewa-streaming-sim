with 
    source as (

        select * 
        from "ewa"."main"."raw_transactions"

    ),

    deduplicated as (

        select
            *,
            row_number() over (
                partition by transaction_id
                order by loaded_at desc
            ) as rn

        from source

    ),

    renamed as (

        select
            transaction_id,
            employee_id,
            employer_id,
            amount,
            status,
            event_time,
            loaded_at
        from deduplicated
        where rn = 1

    )

select * 
from renamed