import duckdb
import pandas as pd
import plotly.express as px
import streamlit as st

st.set_page_config(page_title="EWA Streaming Pipeline Dashboard", layout="wide")

@st.cache_resource
def get_connection():
    return duckdb.connect('md:ewa')

conn = get_connection()

st.title("EWA Streaming Pipeline — Live Dashboard")
st.caption("Synthetic Earned Wage Access simulation — Redpanda → DuckDB → dbt → MotherDuck")

balances = conn.execute("select * from mart_employee_balances").df()
utilization = conn.execute("select * from mart_employer_utilization").df()
anomalies = conn.execute("select * from mart_anomalies").df()

tab1, tab2, tab3 = st.tabs(["Employee Balances", "Employer Utilization", "Anomalies"])

with tab1:
    st.subheader("Current Pay-Period Earned Balance by Employee")
    col1, col2, col3 = st.columns(3)
    col1.metric("Total Employees", len(balances))
    col2.metric("Total Confirmed Earnings", f"${balances['total_confirmed_earnings'].sum():,.2f}")
    col3.metric("Employees with Negative Balance", int((balances['current_balance'] < 0).sum()))

    fig = px.bar(
        balances.sort_values('current_balance'),
        x='employee_id', y='current_balance',
        color=balances['current_balance'] < 0,
        color_discrete_map={True: '#d62728', False: '#2ca02c'},
        title='Current Balance by Employee',
        labels={'color': 'Negative Balance'}
    )
    st.plotly_chart(fig, use_container_width=True)
    st.dataframe(balances, use_container_width=True)

with tab2:
    st.subheader("Advance Utilization Rate by Employer (Current Month)")
    fig = px.bar(
        utilization.sort_values('utilization_rate_pct', ascending=False),
        x='employer_id', y='utilization_rate_pct',
        title='Utilization Rate (%) by Employer'
    )
    st.plotly_chart(fig, use_container_width=True)
    st.dataframe(utilization, use_container_width=True)

with tab3:
    st.subheader(f"Flagged Anomalies ({len(anomalies)} total)")
    counts = anomalies['anomaly_type'].value_counts().reset_index()
    counts.columns = ['anomaly_type', 'count']
    fig = px.bar(counts, x='anomaly_type', y='count', title='Anomalies by Type')
    st.plotly_chart(fig, use_container_width=True)
    st.dataframe(anomalies, use_container_width=True)