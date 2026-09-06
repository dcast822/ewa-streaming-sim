import json
import subprocess
import time

import duckdb
from confluent_kafka import Consumer, KafkaError
from dagster import op, Failure, get_dagster_logger

DB_PATH = "/Users/dcast822/ewa_streaming_pipeline/ewa-streaming-sim/ewa.duckdb"
DBT_PROJECT_DIR = "/Users/dcast822/ewa_streaming_pipeline/ewa-streaming-sim/dbt_project"
PROJECT_ROOT = "/Users/dcast822/ewa_streaming_pipeline/ewa-streaming-sim"


@op
def drain_kafka_to_duckdb() -> int:
    logger = get_dagster_logger()

    consumer = Consumer({
        "bootstrap.servers": "localhost:9092",
        "group.id": "ewa-consumer-group",
        "auto.offset.reset": "earliest",
    })
    consumer.subscribe(["payroll-transactions"])

    setup_conn = duckdb.connect(DB_PATH)
    setup_conn.execute("""
        CREATE TABLE IF NOT EXISTS raw_transactions (
            transaction_id  VARCHAR,
            employee_id     VARCHAR,
            employer_id     VARCHAR,
            amount          DOUBLE,
            status          VARCHAR,
            event_time      TIMESTAMP,
            loaded_at       TIMESTAMP DEFAULT current_timestamp
        )
    """)
    setup_conn.close()

    IDLE_TIMEOUT = 5.0
    MAX_DURATION = 45.0

    inserted = 0
    start = time.monotonic()
    last_message_time = start

    try:
        while True:
            now = time.monotonic()
            if now - start > MAX_DURATION:
                logger.info("Hit max duration, stopping drain.")
                break
            if now - last_message_time > IDLE_TIMEOUT:
                logger.info("No new messages for 5s, stopping drain.")
                break

            msg = consumer.poll(1.0)
            if msg is None:
                continue
            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    continue
                else:
                    raise Failure(f"Kafka error: {msg.error()}")

            event = json.loads(msg.value().decode("utf-8"))

            conn = duckdb.connect(DB_PATH)
            conn.execute(
                "INSERT INTO raw_transactions VALUES (?, ?, ?, ?, ?, ?, now())",
                [
                    event["transaction_id"],
                    event["employee_id"],
                    event["employer_id"],
                    event["amount"],
                    event["status"],
                    event["event_time"],
                ],
            )
            conn.close()

            inserted += 1
            last_message_time = time.monotonic()
    finally:
        consumer.close()

    logger.info(f"Drained {inserted} messages into raw_transactions.")
    return inserted


@op
def dbt_run(drain_count: int) -> int:
    logger = get_dagster_logger()
    result = subprocess.run(
        ["dbt", "run"],
        cwd=DBT_PROJECT_DIR,
        capture_output=True,
        text=True,
    )
    logger.info(result.stdout)
    if result.returncode != 0:
        raise Failure(f"dbt run failed:\n{result.stderr}")
    return drain_count


@op
def dbt_test(run_marker: int) -> int:
    logger = get_dagster_logger()
    result = subprocess.run(
        ["dbt", "test"],
        cwd=DBT_PROJECT_DIR,
        capture_output=True,
        text=True,
    )
    logger.info(result.stdout)
    if result.returncode != 0:
        raise Failure(f"dbt test failed:\n{result.stderr}")
    return run_marker


@op
def sync_to_motherduck(test_marker: int) -> None:
    logger = get_dagster_logger()
    result = subprocess.run(
        ["python3", "dashboard/sync_to_motherduck.py"],
        cwd=PROJECT_ROOT,
        capture_output=True,
        text=True,
    )
    logger.info(result.stdout)
    if result.returncode != 0:
        raise Failure(f"MotherDuck sync failed:\n{result.stderr}")