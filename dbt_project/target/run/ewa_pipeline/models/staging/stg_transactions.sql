

    MERGE INTO "ewa"."main"."stg_transactions" AS DBT_INTERNAL_DEST
        USING "stg_transactions__dbt_tmp20260905211653601899" AS DBT_INTERNAL_SOURCE
        
            
                
            
        
        ON (DBT_INTERNAL_SOURCE.transaction_id = DBT_INTERNAL_DEST.transaction_id)
    
    WHEN MATCHED
    THEN
        UPDATE BY NAME
    WHEN NOT MATCHED
        
    THEN
        INSERT BY NAME

  