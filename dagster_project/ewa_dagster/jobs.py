from dagster import job
from .ops import drain_kafka_to_duckdb, dbt_run, dbt_test, sync_to_motherduck


@job
def ewa_pipeline_job():
    sync_to_motherduck(dbt_test(dbt_run(drain_kafka_to_duckdb())))