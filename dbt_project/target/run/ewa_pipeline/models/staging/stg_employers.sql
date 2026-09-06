
  
  create view "ewa"."main"."stg_employers__dbt_tmp" as (
    select
    employer_id

from "ewa"."main"."employers"
  );
