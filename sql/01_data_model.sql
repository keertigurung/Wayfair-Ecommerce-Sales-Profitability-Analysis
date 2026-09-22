-- ============================================================
-- 01_data_model.sql
-- Wayfair E-commerce Sales & Profitability Analysis
-- ============================================================



-- ============================================================
-- 1. Create Dimension Tables
-- ============================================================
CREATE TABLE dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    signup_date DATE,
    state VARCHAR(50),
    acquisition_channel VARCHAR(50)
);


CREATE TABLE dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL,
    product_name VARCHAR(255),
    category VARCHAR(100),
    list_price NUMERIC(10,2),
    unit_cost NUMERIC(10,2)
);


CREATE TABLE dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL,
    year INTEGER,
    month INTEGER,
    month_name VARCHAR(20),
    quarter INTEGER
);


INSERT INTO dim_date (
    date_key,
    full_date,
    year,
    month,
    month_name,
    quarter
)
SELECT
    TO_CHAR(date_value, 'YYYYMMDD')::INTEGER AS date_key,
    date_value::DATE AS full_date,
    EXTRACT(YEAR FROM date_value)::INTEGER AS year,
    EXTRACT(MONTH FROM date_value)::INTEGER AS month,
    TO_CHAR(date_value, 'Month') AS month_name,
    EXTRACT(QUARTER FROM date_value)::INTEGER AS quarter
FROM generate_series(
    '2024-01-01'::DATE,
    '2025-12-31'::DATE,
    '1 day'::INTERVAL
) AS date_value;


CREATE TABLE dim_order (
    order_key SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(30),
    payment_method VARCHAR(50),
    discount_code VARCHAR(50),
    shipping_fee NUMERIC(10,2)
);



-- ============================================================
-- 2. Create Fact and Staging Tables
-- ============================================================
CREATE TABLE fact_order_items (
    order_item_key SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    date_key INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    discount_amount NUMERIC(10,2) NOT NULL,
    revenue NUMERIC(12,2),
    cost NUMERIC(12,2),
    profit NUMERIC(12,2)
);


CREATE TABLE stg_order_items (
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price NUMERIC(10,2),
    discount_amount NUMERIC(10,2)
);



-- ============================================================
-- 3. Load Fact Table
-- ============================================================
INSERT INTO fact_order_items (
    order_id,
    product_id,
    date_key,
    quantity,
    unit_price,
    discount_amount,
    revenue,
    cost,
    profit
)
SELECT
    s.order_id,
    s.product_id,
    TO_CHAR(o.order_date, 'YYYYMMDD')::INTEGER AS date_key,
    s.quantity,
    s.unit_price,
    s.discount_amount,

    (s.quantity * s.unit_price) - s.discount_amount AS revenue,

    s.quantity * p.unit_cost AS cost,

    ((s.quantity * s.unit_price) - s.discount_amount)
        - (s.quantity * p.unit_cost) AS profit

FROM stg_order_items s
JOIN dim_order o
    ON s.order_id = o.order_id
JOIN dim_product p
    ON s.product_id = p.product_id;


-- ============================================================
-- 4. Fact Table Validation
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(*) FILTER (WHERE revenue IS NULL) AS missing_revenue,
    COUNT(*) FILTER (WHERE cost IS NULL) AS missing_cost,
    COUNT(*) FILTER (WHERE profit IS NULL) AS missing_profit,
    COUNT(*) FILTER (WHERE profit < 0) AS negative_profit
FROM fact_order_items;


-- ============================================================
-- 5. Orders Without Fact Records
-- ============================================================

SELECT COUNT(*) AS orders_without_items
FROM dim_order o
LEFT JOIN fact_order_items f
    ON o.order_id = f.order_id
WHERE f.order_id IS NULL;


-- ============================================================
-- 6. Financial Calculation Validation
-- ============================================================

SELECT
    SUM(revenue) AS total_revenue,
    SUM(cost) AS total_cost,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(revenue), 0) * 100,
        2
    ) AS profit_margin
FROM fact_order_items;


-- ============================================================
-- 7. Date Validation
-- ============================================================

SELECT COUNT(*) AS invalid_dates
FROM fact_order_items f
LEFT JOIN dim_date d
    ON f.date_key = d.date_key
WHERE d.date_key IS NULL;