## Anomaly Analysis

### Insert Anomaly

**Definition:** An insert anomaly occurs when certain data cannot be inserted without the presence of other unrelated data.

**Example from `orders_flat.csv`:**
Suppose the company hires a new sales representative SR04 Meena Pillai (meena@corp.com). In the flat table, it is impossible to record her details until she handles at least one order — there is no row for SR04 without a corresponding `order_id`, `customer_id`, and `product_id`. The columns `sales_rep_id`, `sales_rep_name`, `sales_rep_email`, and `office_address` are entirely tied to an order existing. Organisational data is lost simply because no order has been placed yet.

---

### Update Anomaly

**Definition:** An update anomaly occurs when a single logical fact must be changed in multiple rows, risking inconsistency if any row is missed.

**Example from `orders_flat.csv`:**
Sales rep SR01 Deepak Joshi appears in rows 1, 2, 8, 9, 14, 18, 22, 24, 29, 31 and many more. His `office_address` is stored as `Mumbai HQ, Nariman Point, Mumbai - 400021` in most rows but as `Mumbai HQ, Nariman Pt, Mumbai - 400021` (shortened) in rows 37, 56, 89, 92, 96, 110, 122, 125, 129, 152. This inconsistency already exists in the raw data. If his address changes, every row must be updated individually — missing even one leaves two different addresses for the same person.

---

### Delete Anomaly

**Definition:** A delete anomaly occurs when deleting one piece of information accidentally destroys other unrelated information.

**Example from `orders_flat.csv`:**
Customer C007 Arjun Nair (arjun@gmail.com, Bangalore) has orders ORD1093, ORD1098, ORD1103, ORD1113 and others. If all his orders are cancelled and deleted, every trace of Arjun Nair as a customer disappears from the database — his name, email, and city are permanently lost, even though the business may still want to retain customer records for marketing or compliance purposes.

---

## Normalization Justification

I would strongly refute my manager's position. The evidence is already in `orders_flat.csv` itself — just 186 rows and it already has all three anomaly types.

Take the update anomaly as a direct example. SR01 Deepak Joshi's `office_address` appears in over 60 rows. In some rows it says "Nariman Point" and in others "Nariman Pt" — this inconsistency exists right now in the raw data. If Deepak's office moves, someone must update 60+ rows and hope they miss none. In a normalized `sales_reps` table, that is one row, one UPDATE, zero risk.

Similarly, product P001 "Laptop" at price 55000 is repeated across dozens of rows. A price change means hunting down every single row. With a `products` table it is one UPDATE statement.

The "simpler" argument also breaks down when querying. Writing "total revenue per sales rep" on a flat file means working around duplicated, potentially inconsistent string values. On a normalized schema with foreign keys it is a clean JOIN and GROUP BY.

The manager is only thinking about data entry speed. That convenience disappears the moment data needs to be updated, deleted, or reported on. At scale, the cost of managing anomalies in a flat table grows with every new row added. Normalization is a one-time investment that pays off permanently — the anomalies already visible in this dataset prove that the flat approach has already started failing at just 186 rows.
