-- =============================================================
-- Part 3 — Data Warehouse Analytical Queries
-- Star schema: fact_sales + dim_date, dim_store, dim_product
-- =============================================================

-- Q1: Total sales revenue by product category for each month
SELECT
    dd.year,
    dd.month,
    dd.month_name,
    dp.category,
    SUM(fs.total_amount)  AS total_revenue,
    SUM(fs.units_sold)    AS total_units_sold
FROM fact_sales fs
JOIN dim_date    dd ON fs.date_key    = dd.date_key
JOIN dim_product dp ON fs.product_key = dp.product_key
GROUP BY dd.year, dd.month, dd.month_name, dp.category
ORDER BY dd.year, dd.month, total_revenue DESC;

-- Q2: Top 2 performing stores by total revenue
SELECT
    ds.store_name,
    ds.city,
    ds.region,
    SUM(fs.total_amount)              AS total_revenue,
    SUM(fs.units_sold)                AS total_units_sold,
    COUNT(DISTINCT fs.transaction_id) AS total_transactions
FROM fact_sales fs
JOIN dim_store ds ON fs.store_key = ds.store_key
GROUP BY ds.store_key, ds.store_name, ds.city, ds.region
ORDER BY total_revenue DESC
LIMIT 2;

-- Q3: Month-over-month sales trend across all stores
SELECT
    dd.year,
    dd.month,
    dd.month_name,
    SUM(fs.total_amount)  AS monthly_revenue,
    LAG(SUM(fs.total_amount)) OVER (ORDER BY dd.year, dd.month) AS prev_month_revenue,
    ROUND(
        100.0 * (SUM(fs.total_amount) - LAG(SUM(fs.total_amount)) OVER (ORDER BY dd.year, dd.month))
        / NULLIF(LAG(SUM(fs.total_amount)) OVER (ORDER BY dd.year, dd.month), 0),
        2
    ) AS mom_growth_pct
FROM fact_sales fs
JOIN dim_date dd ON fs.date_key = dd.date_key
GROUP BY dd.year, dd.month, dd.month_name
ORDER BY dd.year, dd.month;
