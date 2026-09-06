import json
import time
import random
import uuid
from datetime import datetime, timedelta
from faker import Faker
from confluent_kafka import Producer

fake = Faker()
random.seed(42)

# ── Synthetic data setup ───────────────────────────────────────────────────
EMPLOYERS = [f"EMP_{i:03d}" for i in range(1, 6)]  # 5 employers

EMPLOYEES = [
    {
        'employee_id':      f"EE_{i:04d}",
        'employer_id':      random.choice(EMPLOYERS),
        'max_earnings':     round(random.uniform(800, 4000), 2),
        'pay_period_start': datetime.now().replace(day=1).date(),
    }
    for i in range(1, 51)  # 50 employees
]

STATUSES = ['confirmed', 'confirmed', 'confirmed', 'pending', 'reversed']

# ── Kafka producer config ──────────────────────────────────────────────────
producer = Producer({'bootstrap.servers': 'localhost:9092'})

def delivery_report(err, msg):
    if err:
        print(f"❌ Delivery failed: {err}")
    else:
        print(f"  ↑ Sent: {msg.key().decode()} to {msg.topic()}")

def generate_transaction(duplicate_of=None, late=False):
    if duplicate_of:
        return duplicate_of  # resend the exact same event — true duplicate delivery

    employee = random.choice(EMPLOYEES)

    if late:
        event_time = datetime.now() - timedelta(hours=random.uniform(1, 3))
    else:
        event_time = datetime.now()

    return {
        'transaction_id': str(uuid.uuid4()),
        'employee_id':    employee['employee_id'],
        'employer_id':    employee['employer_id'],
        'amount':         round(random.uniform(10, employee['max_earnings'] * 0.3), 2),
        'status':         random.choice(STATUSES),
        'event_time':     event_time.isoformat(),
    }

# ── Producer loop ──────────────────────────────────────────────────────────
print("🚀 Producer started — sending payroll transactions...")
sent_ids = []  # track IDs for duplicate generation

RUN_SECONDS = 30 * 60  # 30 minutes
start_time = time.monotonic()

try:
    while time.monotonic() - start_time < RUN_SECONDS:
        roll = random.random()

        if roll < 0.10 and sent_ids:
            # 10% chance: send a duplicate of a previous transaction
            event = generate_transaction(duplicate_of=random.choice(sent_ids))
            print(f"  ⚠️  Duplicate: {event['transaction_id']}")
        elif roll < 0.12:
            # 2% chance: late-arriving event
            event = generate_transaction(late=True)
            print(f"  🕐 Late-arriving: {event['transaction_id']}")
        else:
            event = generate_transaction()

        sent_ids.append(event)
        if len(sent_ids) > 100:
            sent_ids.pop(0)  # keep buffer manageable

        producer.produce(
            topic='payroll-transactions',
            key=event['transaction_id'],
            value=json.dumps(event),
            callback=delivery_report
        )
        producer.poll(0)

        sleep_time = random.uniform(.5, 2)
        print(f"  💤 Next event in {sleep_time:.1f}s")
        time.sleep(sleep_time)

    print("\n⏱ 30 minutes elapsed — producer stopping.")

except KeyboardInterrupt:
    print("\n⏹ Producer stopped manually.")
finally:
    producer.flush()