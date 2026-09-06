{{ config(materialized='incremental', unique_key='transaction_id', incremental_strategy='merge') }}

select
    transaction_id,
    employee_id,
    employer_id,
    cast(amount as decimal(10, 2)) as amount,
    status,
    cast(event_time as timestamp) as event_time,
    loaded_at

from {{ source('raw', 'raw_transactions') }}

{% if is_incremental() %}
where loaded_at > (select max(loaded_at) from {{ this }})
{% endif %}