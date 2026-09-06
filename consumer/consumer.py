import json
import time
import duckdb
from confluent_kafka import Consumer, KafkaError

# ── Kafka consumer config ──────────────────────────────────────────────────
consumer = Consumer({
    'bootstrap.servers': 'localhost:9092',
    'group.id':          'ewa-consumer-group',
    'auto.offset.reset': 'earliest',
})
consumer.subscribe(['payroll-transactions'])

# ── DuckDB setup ────────────────────────────────────────────────────────────
DB_PATH = '/Users/dcast822/ewa_streaming_pipeline/ewa-streaming-sim/ewa.duckdb'

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
print("✅ Connected to DuckDB — raw_transactions table ready")


def insert_with_retry(event, max_retries=10, base_delay=0.2):
    """Insert a row, retrying briefly if another process (e.g. dbt) holds
    the DuckDB write lock. DuckDB is single-writer, so short contention
    between the consumer and scheduled dbt runs is expected — not an error
    worth crashing the consumer over."""
    for attempt in range(1, max_retries + 1):
        try:
            conn = duckdb.connect(DB_PATH)
            conn.execute(
                "INSERT INTO raw_transactions VALUES (?, ?, ?, ?, ?, ?, now())",
                [
                    event['transaction_id'],
                    event['employee_id'],
                    event['employer_id'],
                    event['amount'],
                    event['status'],
                    event['event_time'],
                ]
            )
            conn.close()
            return True
        except duckdb.IOException:
            if attempt == max_retries:
                print(f"  ⚠️  Gave up inserting {event['transaction_id']} after {max_retries} attempts (DB locked)")
                return False
            time.sleep(base_delay * attempt)  # linear backoff: 0.2s, 0.4s, 0.6s...
    return False


# ── Consumer loop ──────────────────────────────────────────────────────────
print("🎧 Listening for messages on payroll-transactions...")

RUN_SECONDS = 30 * 60  # 30 minutes
start_time = time.monotonic()

try:
    while time.monotonic() - start_time < RUN_SECONDS:
        msg = consumer.poll(1.0)

        if msg is None:
            continue
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                continue
            else:
                print(f"❌ Kafka error: {msg.error()}")
                break

        event = json.loads(msg.value().decode('utf-8'))

        if insert_with_retry(event):
            print(f"  ↓ Inserted: {event['transaction_id']} | {event['employee_id']} | ${event['amount']}")

    print("\n⏱ 30 minutes elapsed — consumer stopping.")

except KeyboardInterrupt:
    print("\n⏹ Consumer stopped manually.")
finally:
    consumer.close()