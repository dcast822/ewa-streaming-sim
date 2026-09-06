
    
    

select
    employer_id as unique_field,
    count(*) as n_records

from "ewa"."main"."mart_employer_utilization"
where employer_id is not null
group by employer_id
having count(*) > 1


