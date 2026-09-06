import duckdb

conn = duckdb.connect('ewa.duckdb')  # adjust path if run from elsewhere
conn.execute("ATTACH 'md:ewa' AS md_ewa")

tables_to_sync = [
    'mart_employee_balances',
    'mart_employer_utilization',
    'mart_anomalies',
]

for table in tables_to_sync:
    conn.execute(f"CREATE OR REPLACE TABLE md_ewa.{table} AS SELECT * FROM {table}")
    print(f"Synced {table}")

conn.execute("DETACH md_ewa")
conn.close()
print("Sync complete.")