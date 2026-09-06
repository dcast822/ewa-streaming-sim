from dagster import ScheduleDefinition
from .jobs import ewa_pipeline_job

ewa_pipeline_schedule = ScheduleDefinition(
    job=ewa_pipeline_job,
    cron_schedule="* * * * *",  # every minute
)