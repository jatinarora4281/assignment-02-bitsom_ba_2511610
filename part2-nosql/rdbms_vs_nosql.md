## Database Recommendation

### Scenario

A healthcare startup is building a patient management system. One engineer recommends MySQL; another recommends MongoDB. The decision must account for ACID guarantees, the CAP theorem, and the potential addition of a fraud detection module.

---

### Core System: MySQL (RDBMS) is the Right Choice

For the core patient management system, I would recommend **MySQL** (or PostgreSQL) over MongoDB, for the following reasons.

**ACID compliance is non-negotiable in healthcare.** Patient records involve life-critical transactions: prescriptions being written, lab results being associated with the correct patient, billing records being linked to insurance. If a transaction fails halfway — say, a prescription is saved but the corresponding dosage record is not — the resulting inconsistency could endanger a patient's life. ACID transactions in MySQL guarantee that either all parts of a transaction commit or none do. MongoDB supports multi-document ACID since version 4.0, but it is an afterthought layered onto a system designed for eventual consistency, whereas MySQL's transactional model is foundational.

**Structured, relational data fits the tabular model perfectly.** Patient data is highly structured: patients have appointments, appointments link to doctors, doctors belong to departments, bills tie to procedures. These are clean one-to-many and many-to-many relationships that normalised SQL tables represent naturally and query efficiently with JOINs.

**CAP theorem perspective:** MySQL prioritises Consistency and Partition tolerance (CP). In healthcare, you want strong consistency — reading a patient's blood type must return the correct value, not a stale replica. MongoDB's default read preference can return slightly stale data from secondaries, which is unacceptable for medical decisions.

**Regulatory compliance** (HIPAA, DPDP Act) is easier to enforce with RDBMS audit logs, row-level security, and mature access control frameworks.

---

### Fraud Detection Module: MongoDB (or a Hybrid)

If the startup adds a **fraud detection module**, the recommendation shifts toward a hybrid architecture.

Fraud detection requires analysing large volumes of semi-structured, high-velocity events: login patterns, billing claim sequences, IP addresses, device fingerprints. This data has variable structure — not every event has the same fields — and it arrives in real time. MongoDB's flexible document model and horizontal sharding make it well-suited to storing and querying these heterogeneous event streams efficiently.

A practical architecture would keep the **core patient management system in MySQL** (the system of record) while feeding a **MongoDB collection** with anonymised event logs for the fraud detection pipeline. The fraud engine reads from MongoDB, detects anomalies, and writes alerts back, which are then acted upon by the RDBMS-backed application.

**In summary:** MySQL for the core system where ACID integrity and structured relational data are paramount; MongoDB as a complementary store for the high-velocity, semi-structured fraud event pipeline. These two systems work better together than either does alone for this use case.
