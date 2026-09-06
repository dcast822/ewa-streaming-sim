import random
import uuid
from datetime import datetime, timedelta

import duckdb

random.seed(43)  # different seed from producer.py so this is an independent draw

DB_PATH = 'ewa.duckdb'  # adjust if running from a different working directory

# Pull the same 50 employees dbt seeded, so employee_id foreign keys line up
conn = duckdb.connect(DB_PATH, read_only=True)
employees = conn.execute("select employee_id, employer_id, max_earnings, pay_period_start from employees").fetchall()
conn.close()

STATUSES = ['approved', 'approved', 'approved', 'pending', 'denied']

def generate_requests_for_employee(employee_id, employer_id, max_earnings, pay_period_start):
    num_requests = random.randint(1, 4)
    requests = []
    for _ in range(num_requests):
        # requested_amount is usually a portion of max_earnings, occasionally over it (to exercise validation)
        if random.random() < 0.08:
            requested_amount = round(max_earnings * random.uniform(1.05, 1.3), 2)  # intentionally over cap
        else:
            requested_amount = round(random.uniform(20, max_earnings * 0.5), 2)

        # request_time sometime within the current pay period window
        days_offset = random.uniform(0, 16)
        request_time = datetime.combine(pay_period_start, datetime.min.time()) + timedelta(days=days_offset)

        requests.append({
            'request_id':       str(uuid.uuid4()),
            'employee_id':      employee_id,
            'employer_id':      employer_id,
            'requested_amount': requested_amount,
            'status':           random.choice(STATUSES),
            'request_time':     request_time,
        })
    return requests

all_requests = []
for emp in employees:
    all_requests.extend(generate_requests_for_employee(*emp))

conn = duckdb.connect(DB_PATH, read_only=False)
conn.execute("""
    CREATE TABLE IF NOT EXISTS raw_advance_requests (
        request_id       VARCHAR,
        employee_id      VARCHAR,
        employer_id      VARCHAR,
        requested_amount DOUBLE,
        status           VARCHAR,
        request_time     TIMESTAMP,
        loaded_at        TIMESTAMP DEFAULT current_timestamp
    )
""")

for r in all_requests:
    conn.execute(
        "INSERT INTO raw_advance_requests VALUES (?, ?, ?, ?, ?, ?, now())",
        [r['request_id'], r['employee_id'], r['employer_id'], r['requested_amount'], r['status'], r['request_time']]
    )

conn.close()
print(f"Inserted {len(all_requests)} synthetic advance requests into raw_advance_requests.")