-- ============================================================
-- BUSINESS QUESTION 1
-- Sales Performance Over Time
-- ============================================================

-- 1. Year-over-Year Sales and Profitability
-- ============================================================

SELECT
    d.year,
    SUM(f.revenue) AS total_revenue,
    SUM(f.profit) AS total_profit,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.revenue), 0) * 100,
        2
    ) AS profit_margin
FROM fact_order_items f
JOIN dim_date d
    ON f.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;


-- ============================================================
-- 2. Monthly Revenue and Profit Trend
-- ============================================================

SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.revenue) AS total_revenue,
    SUM(f.profit) AS total_profit
FROM fact_order_items f
JOIN dim_date d
    ON f.date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;


-- ============================================================
-- 3. Year-over-Year Monthly Revenue Comparison
-- ============================================================

SELECT
    month,
    month_name,
    ROUND(MAX(CASE WHEN year = 2024 THEN total_revenue END), 2) AS revenue_2024,
    ROUND(MAX(CASE WHEN year = 2025 THEN total_revenue END), 2) AS revenue_2025,
    ROUND(
        (
            MAX(CASE WHEN year = 2025 THEN total_revenue END)
            - MAX(CASE WHEN year = 2024 THEN total_revenue END)
        )
        / NULLIF(
            MAX(CASE WHEN year = 2024 THEN total_revenue END),
            0
        ) * 100,
        2
    ) AS revenue_growth_percent
FROM (
    SELECT
        d.year,
        d.month,
        TRIM(d.month_name) AS month_name,
        SUM(f.revenue) AS total_revenue
    FROM fact_order_items f
    JOIN dim_date d
        ON f.date_key = d.date_key
    GROUP BY
        d.year,
        d.month,
        d.month_name
) AS monthly_sales
GROUP BY
    month,
    month_name
ORDER BY month;



-- ============================================================
-- BUSINESS QUESTION 2
-- Product and Category Performance
-- ============================================================

-- 1. Category Revenue and Profitability
-- ============================================================

SELECT
    p.category,
    SUM(f.revenue) AS total_revenue,
    SUM(f.profit) AS total_profit,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.revenue), 0) * 100,
        2
    ) AS profit_margin
FROM fact_order_items f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- ============================================================
-- 2. Product Revenue and Profitability
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(f.revenue) AS total_revenue,
    SUM(f.profit) AS total_profit,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.revenue), 0) * 100,
        2
    ) AS profit_margin
FROM fact_order_items f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 3. Top 10 Products by Profit
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(f.revenue) AS total_revenue,
    SUM(f.profit) AS total_profit,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.revenue), 0) * 100,
        2
    ) AS profit_margin
FROM fact_order_items f
JOIN dim_product p
    ON f.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_profit DESC
LIMIT 10;



-- ============================================================
-- BUSINESS QUESTION 3
-- Returns and Cancellations
-- ============================================================

-- 1. Revenue and Profit by Order Status
-- ============================================================

SELECT
    o.status,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.revenue) AS total_revenue,
    SUM(f.profit) AS total_profit
FROM fact_order_items f
JOIN dim_order o
    ON f.order_id = o.order_id
GROUP BY o.status
ORDER BY total_revenue DESC;


-- ============================================================
-- 2. Return and Cancellation Rate by Category
-- ============================================================

WITH order_category AS (
    SELECT DISTINCT
        f.order_id,
        p.category,
        o.status
    FROM fact_order_items f
    JOIN dim_product p
        ON f.product_id = p.product_id
    JOIN dim_order o
        ON f.order_id = o.order_id
)
SELECT
    category,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE status = 'returned') AS returned_orders,
    COUNT(*) FILTER (WHERE status = 'canceled') AS canceled_orders,
    ROUND(
        COUNT(*) FILTER (WHERE status = 'returned')::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS return_rate,
    ROUND(
        COUNT(*) FILTER (WHERE status = 'canceled')::NUMERIC
        / COUNT(*) * 100,
        2
    ) AS cancellation_rate
FROM order_category
GROUP BY category
ORDER BY return_rate DESC;