
    
    

select
    request_id as unique_field,
    count(*) as n_records

from "ewa"."main"."stg_advance_requests"
where request_id is not null
group by request_id
having count(*) > 1


