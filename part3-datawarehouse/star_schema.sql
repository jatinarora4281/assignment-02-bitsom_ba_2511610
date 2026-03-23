-- =============================================================
-- Part 3 — Data Warehouse Star Schema
-- Source: retail_transactions.csv
-- Fact table: fact_sales
-- Dimension tables: dim_date, dim_store, dim_product, dim_customer
-- Compatible with MySQL 8.0+
-- =============================================================

-- Use the warehouse database
CREATE DATABASE IF NOT EXISTS warehouse;
USE warehouse;

-- -------------------------------------------------------------
-- Dimension: dim_date
-- -------------------------------------------------------------
CREATE TABLE dim_date (
    date_key     INT          PRIMARY KEY,
    full_date    DATE         NOT NULL,
    day          INT          NOT NULL,
    month        INT          NOT NULL,
    month_name   VARCHAR(20)  NOT NULL,
    quarter      INT          NOT NULL,
    year         INT          NOT NULL,
    day_of_week  VARCHAR(10)  NOT NULL,
    is_weekend   BOOLEAN      NOT NULL
);

INSERT INTO dim_date (date_key, full_date, day, month, month_name, quarter, year, day_of_week, is_weekend) VALUES
(20230101, '2023-01-01', 1,  1,  'January',   1, 2023, 'Sunday',    TRUE),
(20230115, '2023-01-15', 15, 1,  'January',   1, 2023, 'Sunday',    TRUE),
(20230205, '2023-02-05', 5,  2,  'February',  1, 2023, 'Sunday',    TRUE),
(20230220, '2023-02-20', 20, 2,  'February',  1, 2023, 'Monday',    FALSE),
(20230331, '2023-03-31', 31, 3,  'March',     1, 2023, 'Friday',    FALSE),
(20230418, '2023-04-18', 18, 4,  'April',     2, 2023, 'Tuesday',   FALSE),
(20230516, '2023-05-16', 16, 5,  'May',       2, 2023, 'Tuesday',   FALSE),
(20230809, '2023-08-09', 9,  8,  'August',    3, 2023, 'Wednesday', FALSE),
(20230829, '2023-08-29', 29, 8,  'August',    3, 2023, 'Tuesday',   FALSE),
(20231026, '2023-10-26', 26, 10, 'October',   4, 2023, 'Thursday',  FALSE),
(20231208, '2023-12-08', 8,  12, 'December',  4, 2023, 'Friday',    FALSE),
(20231212, '2023-12-12', 12, 12, 'December',  4, 2023, 'Tuesday',   FALSE);


-- -------------------------------------------------------------
-- Dimension: dim_store
-- -------------------------------------------------------------
CREATE TABLE dim_store (
    store_key  INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    store_id   VARCHAR(20)  NOT NULL UNIQUE,
    store_name VARCHAR(100) NOT NULL,
    city       VARCHAR(100) NOT NULL,
    region     VARCHAR(50)  NOT NULL
);

INSERT INTO dim_store (store_id, store_name, city, region) VALUES
('STR001', 'Chennai Anna',   'Chennai',   'South'),
('STR002', 'Delhi South',    'Delhi',     'North'),
('STR003', 'Bangalore MG',   'Bangalore', 'South'),
('STR004', 'Pune FC Road',   'Pune',      'West'),
('STR005', 'Mumbai Central', 'Mumbai',    'West');


-- -------------------------------------------------------------
-- Dimension: dim_product
-- -------------------------------------------------------------
CREATE TABLE dim_product (
    product_key  INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100)  NOT NULL,
    category     VARCHAR(50)   NOT NULL,
    unit_price   DECIMAL(12,2) NOT NULL CHECK (unit_price > 0)
);

INSERT INTO dim_product (product_name, category, unit_price) VALUES
('Speaker',    'Electronics', 49262.78),
('Tablet',     'Electronics', 23226.12),
('Phone',      'Electronics', 48703.39),
('Smartwatch', 'Electronics', 58851.01),
('Laptop',     'Electronics', 75000.00),
('Headphones', 'Electronics',  3200.00),
('Atta 10kg',  'Grocery',     52464.00),
('Biscuits',   'Grocery',     27469.99),
('Jeans',      'Clothing',     2317.47),
('T-Shirt',    'Clothing',     1299.00);


-- -------------------------------------------------------------
-- Dimension: dim_customer
-- -------------------------------------------------------------
CREATE TABLE dim_customer (
    customer_key INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_id  VARCHAR(20)  NOT NULL UNIQUE,
    city         VARCHAR(100),
    segment      VARCHAR(50)  DEFAULT 'Retail'
);

INSERT INTO dim_customer (customer_id, city, segment) VALUES
('CUST004', 'Chennai',   'Retail'),
('CUST007', 'Delhi',     'Retail'),
('CUST019', 'Mumbai',    'Retail'),
('CUST020', 'Bangalore', 'Retail'),
('CUST021', 'Chennai',   'Retail'),
('CUST025', 'Pune',      'Retail'),
('CUST027', 'Bangalore', 'Retail'),
('CUST030', 'Bangalore', 'Retail'),
('CUST041', 'Pune',      'Retail'),
('CUST045', 'Chennai',   'Retail');


-- -------------------------------------------------------------
-- Fact Table: fact_sales
-- -------------------------------------------------------------
CREATE TABLE fact_sales (
    sales_key      INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(20)   NOT NULL,
    date_key       INT           NOT NULL,
    store_key      INT           NOT NULL,
    product_key    INT           NOT NULL,
    customer_key   INT           NOT NULL,
    units_sold     INT           NOT NULL CHECK (units_sold > 0),
    unit_price     DECIMAL(12,2) NOT NULL,
    total_amount   DECIMAL(14,2) NOT NULL,
    CONSTRAINT fk_fs_date     FOREIGN KEY (date_key)     REFERENCES dim_date(date_key),
    CONSTRAINT fk_fs_store    FOREIGN KEY (store_key)    REFERENCES dim_store(store_key),
    CONSTRAINT fk_fs_product  FOREIGN KEY (product_key)  REFERENCES dim_product(product_key),
    CONSTRAINT fk_fs_customer FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key)
);

INSERT INTO fact_sales (transaction_id, date_key, store_key, product_key, customer_key, units_sold, unit_price, total_amount) VALUES
('TXN5000', 20230829, 1, 1,  10, 3,  49262.78, 147788.34),
('TXN5001', 20231212, 1, 2,  5,  11, 23226.12, 255487.32),
('TXN5002', 20230205, 1, 3,  3,  20, 48703.39, 974067.80),
('TXN5003', 20230220, 2, 2,  2,  14, 23226.12, 325165.68),
('TXN5004', 20230115, 1, 4,  1,  10, 58851.01, 588510.10),
('TXN5005', 20230809, 3, 7,  7,  12, 52464.00, 629568.00),
('TXN5006', 20230331, 4, 4,  6,  6,  58851.01, 353106.06),
('TXN5007', 20231026, 4, 9,  9,  16,  2317.47,  37079.52),
('TXN5008', 20231208, 3, 8,  8,  9,  27469.99, 247229.91),
('TXN5009', 20230829, 3, 4,  4,  3,  58851.01, 176553.03);
