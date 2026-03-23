## Storage Systems

The hospital's four goals require four different storage systems, each chosen for the specific workload it handles best.

**Goal 1 — Predict patient readmission risk** uses a **Data Lake (Amazon S3 + Apache Parquet)**. Historical treatment data — diagnosis codes, lab results, medications, prior admissions — is semi-structured and large. A data lake stores raw records in Parquet format cheaply and efficiently. The readmission prediction model (XGBoost or LSTM) reads training data directly from Parquet files via Apache Spark, which supports distributed feature engineering at scale without requiring the data to be loaded into a warehouse first.

**Goal 2 — Doctors query patient history in plain English** uses a **Vector Database (Pinecone / Chroma)**. Clinical notes, discharge summaries, and doctor observations are unstructured free text. These documents are chunked, embedded using a clinical language model (e.g., Bio-ClinicalBERT), and stored as vectors. When a doctor asks "Has this patient had a cardiac event before?", the query is embedded and the vector DB retrieves the most semantically similar clinical note chunks, which are then passed to an LLM (RAG pipeline) to generate a grounded answer.

**Goal 3 — Monthly management reports** uses a **Data Warehouse (Snowflake / BigQuery) with a Star Schema**. Bed occupancy, department-wise costs, staff allocation, and procedure counts are structured, aggregated metrics that are queried repeatedly by managers using BI tools (Tableau, Metabase). The star schema (fact tables for admissions/costs, dimension tables for departments, time, and doctors) provides fast GROUP BY query performance that a data lake alone cannot match.

**Goal 4 — Stream and store real-time ICU vitals** uses a **Time-Series Database (InfluxDB / TimescaleDB)**. ICU monitoring devices emit heart rate, blood pressure, SpO₂, and temperature readings every few seconds. Time-series databases are optimised for high-frequency write throughput, efficient time-range queries ("show me heart rate for the last 6 hours"), and downsampling/rollup operations. A relational database would degrade at millions of time-stamped rows per patient per day.

---

## OLTP vs OLAP Boundary

The **OLTP (Online Transactional Processing)** boundary covers all systems that handle real-time, row-level transactions: the RDBMS (PostgreSQL) where patient registrations, prescriptions, and billing records are created and updated; the Kafka streaming pipeline that ingests live ICU vitals; and the application APIs used by clinicians to update patient records. These systems prioritise low-latency writes, ACID consistency, and concurrency — a nurse updating a patient's medication must not see stale data, and two systems must not simultaneously overwrite the same record.

The **OLAP (Online Analytical Processing)** boundary begins where data is copied or transformed for analysis. This includes the Data Warehouse (Star Schema), which is populated nightly via an ETL job from the RDBMS and Data Lake, and the ML training pipeline, which reads historical Parquet files from S3. OLAP systems prioritise read throughput, aggregation performance, and historical query depth over write speed. Clinicians do not query the warehouse directly — they use the RDBMS for real-time lookups. Managers and data scientists query the warehouse for aggregated insights.

The separation is enforced by the ETL pipeline (Apache Airflow), which extracts from OLTP sources, transforms (cleans, aggregates, anonymises where required), and loads into the OLAP layer. This ensures that analytical workloads never degrade the performance of clinical transactional systems.

---

## Trade-offs

**The most significant trade-off** in this architecture is **data consistency and synchronisation lag between the OLTP and OLAP layers**. Because the Data Warehouse is populated via nightly ETL, the monthly management reports in Goal 3 are always at least 24 hours stale. A manager viewing bed occupancy on a dashboard is seeing yesterday's data, not a live count.

**Mitigation strategies:**

1. **Move to incremental micro-batch ETL** (every 15 minutes using Spark Structured Streaming or dbt + Airflow) to reduce lag from 24 hours to under an hour for most metrics.

2. **Materialised views with refresh policies** in the Data Warehouse can serve frequently-used aggregations (e.g., current bed count) at near-real-time if the source tables are refreshed more frequently.

3. **For truly live operational metrics** (current bed occupancy, active ICU patients), a separate **live operational dashboard** can read directly from the RDBMS or the time-series database rather than the warehouse, bypassing the ETL lag entirely. This creates a two-tier reporting system: live operational views from OLTP, and historical analytical reports from OLAP.

This trade-off is inherent to any system that separates transactional and analytical workloads, and it is a deliberate design decision — the alternative of running analytical queries directly against the RDBMS would degrade clinical system performance and is not acceptable in a hospital environment.
