from dagster import Definitions
from .jobs import ewa_pipeline_job
from .schedules import ewa_pipeline_schedule

defs = Definitions(
    jobs=[ewa_pipeline_job],
    schedules=[ewa_pipeline_schedule],
)