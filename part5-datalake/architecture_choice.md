## Architecture Recommendation

### Scenario

A fast-growing food delivery startup collects GPS location logs, customer text reviews, payment transactions, and restaurant menu images. The question is: which storage architecture — Data Warehouse, Data Lake, or Data Lakehouse — is the right choice?

---

### Recommendation: Data Lakehouse

I recommend a **Data Lakehouse** architecture for this startup. Here are three specific reasons.

---

**Reason 1: The data is heterogeneous — no single architecture handles all four data types alone.**

The startup has four fundamentally different data types:
- **GPS logs** — high-velocity, semi-structured time-series data (latitude, longitude, timestamps)
- **Customer text reviews** — unstructured free text, unsuitable for warehouse tables
- **Payment transactions** — highly structured, relational, ACID-sensitive
- **Restaurant menu images** — binary unstructured data (JPEG/PNG)

A traditional **Data Warehouse** (e.g., Snowflake, BigQuery) handles structured payment data excellently but cannot natively store raw images or unstructured text. A pure **Data Lake** (e.g., S3 + Parquet) stores everything cheaply but lacks the query performance and governance needed for financial reporting on payment data. A **Data Lakehouse** (e.g., Delta Lake on Databricks, or Apache Iceberg on S3) combines both: raw files (images, logs, text) are stored in an object store, while structured and semi-structured data gets ACID-compliant table layers on top, enabling SQL analytics without a separate warehouse.

---

**Reason 2: The startup needs both real-time and batch analytics.**

GPS logs from delivery drivers require near-real-time processing (e.g., ETA predictions, live order tracking). Payment transactions need immediate ACID consistency. Customer reviews can be batch-processed nightly for sentiment analysis. A Data Lakehouse supports **streaming ingestion** (via Apache Kafka → Delta tables) alongside batch ETL pipelines in the same storage layer. A Data Warehouse would require separate streaming infrastructure; a Data Lake lacks built-in streaming table semantics.

---

**Reason 3: Scalability and cost efficiency for a fast-growing startup.**

A Data Lakehouse separates **compute from storage**. The startup pays cheaply for raw object storage (S3/GCS) and scales compute independently for analytics workloads. As the startup grows from thousands to millions of daily orders, new data types (e.g., audio reviews, video delivery proofs) can be added to the lake layer without schema migrations. A managed Data Warehouse would lock the team into a rigid schema and become prohibitively expensive at petabyte scale.

---

### Summary

| Architecture   | Handles all 4 data types | Real-time + batch | Cost at scale | Recommendation |
|----------------|--------------------------|-------------------|---------------|----------------|
| Data Warehouse | No (structured only)     | Batch only        | Expensive     | ✗              |
| Data Lake      | Yes                      | With extra tools  | Cheap         | Partial        |
| Data Lakehouse | Yes                      | Native support    | Optimal       | ✓ Best fit     |

The Data Lakehouse is the most pragmatic and scalable choice for a startup with diverse, fast-growing data of mixed structure.
