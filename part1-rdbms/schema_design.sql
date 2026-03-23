-- =============================================================
-- Part 1 — Schema Design (3NF Normalization of orders_flat.csv)
-- =============================================================
-- Tables: sales_reps, customers, products, orders, order_items
-- All tables are in Third Normal Form (3NF):
--   1NF: atomic values, no repeating groups
--   2NF: no partial dependencies (all non-key cols depend on full PK)
--   3NF: no transitive dependencies
-- =============================================================


-- -------------------------------------------------------------
-- Table: sales_reps
-- Eliminates transitive dependency: sales_rep_name, sales_rep_email,
-- office_address all depend on sales_rep_id, not on order_id.
-- -------------------------------------------------------------
CREATE TABLE sales_reps (
    sales_rep_id   VARCHAR(10)  PRIMARY KEY,
    rep_name       VARCHAR(100) NOT NULL,
    rep_email      VARCHAR(100) NOT NULL UNIQUE,
    office_address VARCHAR(255) NOT NULL
);

INSERT INTO sales_reps (sales_rep_id, rep_name, rep_email, office_address) VALUES
('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
('SR02', 'Anita Desai',  'anita@corp.com',  'Delhi Office, Connaught Place, New Delhi - 110001'),
('SR03', 'Ravi Kumar',   'ravi@corp.com',   'South Zone, MG Road, Bangalore - 560001'),
('SR04', 'Meena Pillai', 'meena@corp.com',  'West Zone, FC Road, Pune - 411004'),
('SR05', 'Suresh Nair',  'suresh@corp.com', 'East Zone, Park Street, Kolkata - 700016');


-- -------------------------------------------------------------
-- Table: customers
-- Eliminates transitive dependency: customer_name, customer_email,
-- customer_city all depend on customer_id, not on order_id.
-- -------------------------------------------------------------
CREATE TABLE customers (
    customer_id    VARCHAR(10)  PRIMARY KEY,
    customer_name  VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL UNIQUE,
    customer_city  VARCHAR(100) NOT NULL
);

INSERT INTO customers (customer_id, customer_name, customer_email, customer_city) VALUES
('C001', 'Rohan Mehta',  'rohan@gmail.com',  'Mumbai'),
('C002', 'Priya Sharma', 'priya@gmail.com',  'Delhi'),
('C003', 'Amit Verma',   'amit@gmail.com',   'Bangalore'),
('C004', 'Sneha Iyer',   'sneha@gmail.com',  'Chennai'),
('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
('C006', 'Neha Gupta',   'neha@gmail.com',   'Delhi'),
('C007', 'Arjun Nair',   'arjun@gmail.com',  'Bangalore'),
('C008', 'Kavya Rao',    'kavya@gmail.com',  'Hyderabad');


-- -------------------------------------------------------------
-- Table: products
-- Eliminates transitive dependency: product_name, category,
-- unit_price all depend on product_id, not on order_id.
-- -------------------------------------------------------------
CREATE TABLE products (
    product_id   VARCHAR(10)    PRIMARY KEY,
    product_name VARCHAR(100)   NOT NULL,
    category     VARCHAR(50)    NOT NULL,
    unit_price   DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0)
);

INSERT INTO products (product_id, product_name, category, unit_price) VALUES
('P001', 'Laptop',        'Electronics', 55000.00),
('P002', 'Mouse',         'Electronics',   800.00),
('P003', 'Desk Chair',    'Furniture',    8500.00),
('P004', 'Notebook',      'Stationery',    120.00),
('P005', 'Headphones',    'Electronics',  3200.00),
('P006', 'Standing Desk', 'Furniture',   22000.00),
('P007', 'Pen Set',       'Stationery',    250.00),
('P008', 'Webcam',        'Electronics',  2100.00);


-- -------------------------------------------------------------
-- Table: orders
-- Stores one row per order. Links customer and sales rep via FKs.
-- -------------------------------------------------------------
CREATE TABLE orders (
    order_id     VARCHAR(10) PRIMARY KEY,
    customer_id  VARCHAR(10) NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL,
    order_date   DATE        NOT NULL,
    CONSTRAINT fk_order_customer  FOREIGN KEY (customer_id)  REFERENCES customers(customer_id),
    CONSTRAINT fk_order_sales_rep FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);

INSERT INTO orders (order_id, customer_id, sales_rep_id, order_date) VALUES
('ORD1000', 'C002', 'SR03', '2023-05-21'),
('ORD1001', 'C004', 'SR03', '2023-02-22'),
('ORD1002', 'C002', 'SR02', '2023-01-17'),
('ORD1003', 'C002', 'SR01', '2023-09-16'),
('ORD1004', 'C001', 'SR01', '2023-11-29'),
('ORD1005', 'C007', 'SR02', '2023-10-29'),
('ORD1006', 'C001', 'SR01', '2023-12-24'),
('ORD1007', 'C006', 'SR01', '2023-04-21'),
('ORD1008', 'C002', 'SR02', '2023-02-19'),
('ORD1009', 'C006', 'SR02', '2023-01-23'),
('ORD1010', 'C002', 'SR01', '2023-10-10'),
('ORD1011', 'C006', 'SR01', '2023-12-27'),
('ORD1012', 'C001', 'SR01', '2023-05-29'),
('ORD1013', 'C004', 'SR01', '2023-07-14'),
('ORD1014', 'C008', 'SR02', '2023-03-25'),
('ORD1015', 'C006', 'SR03', '2023-05-17'),
('ORD1016', 'C003', 'SR03', '2023-05-06'),
('ORD1017', 'C008', 'SR02', '2023-11-24'),
('ORD1018', 'C004', 'SR02', '2023-01-29'),
('ORD1019', 'C001', 'SR02', '2023-07-25'),
('ORD1020', 'C002', 'SR03', '2023-06-11'),
('ORD1021', 'C008', 'SR03', '2023-08-23'),
('ORD1022', 'C005', 'SR01', '2023-10-15'),
('ORD1023', 'C005', 'SR03', '2023-08-08'),
('ORD1024', 'C007', 'SR01', '2023-03-12'),
('ORD1025', 'C008', 'SR01', '2023-02-26'),
('ORD1026', 'C003', 'SR03', '2023-08-05'),
('ORD1027', 'C002', 'SR02', '2023-11-02'),
('ORD1028', 'C005', 'SR01', '2023-12-15'),
('ORD1029', 'C005', 'SR03', '2023-06-24'),
('ORD1030', 'C005', 'SR01', '2023-08-21'),
('ORD1031', 'C005', 'SR01', '2023-09-17'),
('ORD1032', 'C005', 'SR03', '2023-09-17'),
('ORD1033', 'C004', 'SR02', '2023-03-24'),
('ORD1034', 'C001', 'SR02', '2023-09-08'),
('ORD1035', 'C002', 'SR02', '2023-05-03'),
('ORD1036', 'C004', 'SR01', '2023-02-13'),
('ORD1037', 'C002', 'SR03', '2023-03-06'),
('ORD1038', 'C008', 'SR01', '2023-05-16'),
('ORD1039', 'C007', 'SR03', '2023-12-20'),
('ORD1040', 'C005', 'SR03', '2023-11-29'),
('ORD1041', 'C008', 'SR02', '2023-03-03'),
('ORD1042', 'C004', 'SR02', '2023-01-11'),
('ORD1043', 'C004', 'SR01', '2023-01-04'),
('ORD1044', 'C001', 'SR01', '2023-01-17'),
('ORD1045', 'C002', 'SR01', '2023-05-23'),
('ORD1046', 'C004', 'SR01', '2023-10-20'),
('ORD1047', 'C008', 'SR02', '2023-07-28'),
('ORD1048', 'C002', 'SR03', '2023-08-09'),
('ORD1049', 'C007', 'SR02', '2023-01-28'),
('ORD1050', 'C001', 'SR03', '2023-06-23');


-- -------------------------------------------------------------
-- Table: order_items
-- Each row is one line item in an order (product + quantity).
-- Resolves the many-to-many relationship between orders and products.
-- unit_price is stored here to capture the price at time of order.
-- -------------------------------------------------------------
CREATE TABLE order_items (
    item_id    SERIAL         PRIMARY KEY,
    order_id   VARCHAR(10)    NOT NULL,
    product_id VARCHAR(10)    NOT NULL,
    quantity   INT            NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0),
    CONSTRAINT fk_item_order   FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    CONSTRAINT fk_item_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
('ORD1000', 'P001', 2,  55000.00),
('ORD1001', 'P002', 5,    800.00),
('ORD1002', 'P005', 1,   3200.00),
('ORD1003', 'P002', 5,    800.00),
('ORD1004', 'P005', 5,   3200.00),
('ORD1005', 'P002', 3,    800.00),
('ORD1006', 'P007', 4,    250.00),
('ORD1007', 'P003', 3,   8500.00),
('ORD1008', 'P001', 3,  55000.00),
('ORD1009', 'P005', 4,   3200.00),
('ORD1010', 'P004', 3,    120.00),
('ORD1011', 'P005', 1,   3200.00),
('ORD1012', 'P006', 1,  22000.00),
('ORD1013', 'P007', 3,    250.00),
('ORD1014', 'P006', 3,  22000.00),
('ORD1015', 'P002', 1,    800.00),
('ORD1016', 'P005', 2,   3200.00),
('ORD1017', 'P004', 5,    120.00),
('ORD1018', 'P006', 2,  22000.00),
('ORD1019', 'P007', 3,    250.00),
('ORD1020', 'P002', 2,    800.00),
('ORD1021', 'P004', 2,    120.00),
('ORD1022', 'P002', 5,    800.00),
('ORD1023', 'P006', 5,  22000.00),
('ORD1024', 'P003', 5,   8500.00),
('ORD1025', 'P001', 2,  55000.00),
('ORD1026', 'P007', 5,    250.00),
('ORD1027', 'P004', 4,    120.00),
('ORD1028', 'P005', 1,   3200.00),
('ORD1029', 'P007', 1,    250.00),
('ORD1030', 'P004', 1,    120.00),
('ORD1031', 'P005', 1,   3200.00),
('ORD1032', 'P007', 5,    250.00),
('ORD1033', 'P002', 5,    800.00),
('ORD1034', 'P005', 1,   3200.00),
('ORD1035', 'P003', 1,   8500.00),
('ORD1036', 'P005', 4,   3200.00),
('ORD1037', 'P007', 2,    250.00),
('ORD1038', 'P005', 5,   3200.00),
('ORD1039', 'P002', 2,    800.00),
('ORD1040', 'P004', 3,    120.00),
('ORD1041', 'P005', 2,   3200.00),
('ORD1042', 'P001', 5,  55000.00),
('ORD1043', 'P005', 1,   3200.00),
('ORD1044', 'P002', 3,    800.00),
('ORD1045', 'P005', 4,   3200.00),
('ORD1046', 'P005', 5,   3200.00),
('ORD1047', 'P002', 2,    800.00),
('ORD1048', 'P001', 3,  55000.00),
('ORD1049', 'P004', 1,    120.00),
('ORD1050', 'P004', 1,    120.00);
