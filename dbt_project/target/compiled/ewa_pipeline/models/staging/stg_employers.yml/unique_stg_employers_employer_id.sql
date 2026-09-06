
    
    

select
    employer_id as unique_field,
    count(*) as n_records

from "ewa"."main"."stg_employers"
where employer_id is not null
group by employer_id
having count(*) > 1


