## ETL Decisions

### Decision 1 — Standardising inconsistent date formats

**Problem:** The `date` column in `retail_transactions.csv` contained three different formats across rows: `YYYY-MM-DD` (e.g., `2023-01-15`), `DD-MM-YYYY` (e.g., `12-12-2023`), and `DD/MM/YYYY` (e.g., `29/08/2023`). Directly loading this column into a `DATE` field in the warehouse would either fail or silently misparse dates — for example, `12-12-2023` could be interpreted as December 12 or as the 12th day of the 12th month depending on the parser's locale setting.

**Resolution:** Before loading, all date strings were parsed using Python's `dateutil.parser.parse()` with a custom pre-processing step that normalises separators (`/` → `-`) and detects the format based on the position of the year component (4-digit groups). All dates were converted to the ISO 8601 standard `YYYY-MM-DD` format before being written to the `dim_date` dimension table. The `date_key` integer (`YYYYMMDD`) was then derived from this standardised value.

---

### Decision 2 — Normalising inconsistent category casing

**Problem:** The `category` column contained inconsistent casing and spelling variations: `Electronics` and `electronics` (same category, different capitalisation), and `Grocery` and `Groceries` (same category, two different names). This meant that a GROUP BY on `category` would produce separate rows for what should be a single category, inflating the number of groups and producing incorrect revenue totals per category.

**Resolution:** A canonical category mapping dictionary was applied during the Transform phase before loading into `dim_product`:
- `electronics` → `Electronics`
- `Groceries` → `Grocery`

All values were title-cased as a general rule, and a whitelist of accepted category values was enforced. Any row with a category not in the whitelist was logged as a data quality warning and excluded from the load until manually reviewed. This ensures the `dim_product` table has exactly the categories the business recognises.

---

### Decision 3 — Imputing missing store city values

**Problem:** Several rows in `retail_transactions.csv` had `NULL` or empty values in the `store_city` column. Since `store_city` is a key attribute in `dim_store` — used in GROUP BY queries for city-level revenue analysis — loading NULL values would cause those rows to group into a `NULL` city bucket, distorting location-based reports.

**Resolution:** A reference lookup table was created mapping each `store_name` to its known canonical city:
- `Chennai Anna` → `Chennai`
- `Delhi South` → `Delhi`
- `Bangalore MG` → `Bangalore`
- `Pune FC Road` → `Pune`
- `Mumbai Central` → `Mumbai`

During the Transform phase, any row with a missing `store_city` had its city imputed from this mapping using `store_name` as the join key. This mapping is deterministic (each store has exactly one city), so imputation introduces no ambiguity. The fix was validated by confirming zero NULL values in `store_city` after transformation.
