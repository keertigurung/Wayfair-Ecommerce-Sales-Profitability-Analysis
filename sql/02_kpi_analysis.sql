-- ============================================================
-- Wayfair E-commerce Sales & Profitability Analysis
-- KPI Analysis
-- ============================================================


-- ============================================================
-- 1. Overall Sales and Profitability KPIs
-- ============================================================
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(revenue) AS total_revenue,
    SUM(cost) AS total_cost,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(revenue), 0) * 100,
        2
    ) AS profit_margin,
    ROUND(
        SUM(revenue) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM fact_order_items;


-- ============================================================
-- 2. Order Status KPIs
-- ============================================================

SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE status = 'completed') AS completed_orders,
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
FROM dim_order;


-- ============================================================
-- 3. Yearly Sales and Profitability KPIs
-- ============================================================

SELECT
    d.year,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.revenue) AS total_revenue,
    SUM(f.cost) AS total_cost,
    SUM(f.profit) AS total_profit,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.revenue), 0) * 100,
        2
    ) AS profit_margin,
    ROUND(
        SUM(f.revenue) / NULLIF(COUNT(DISTINCT f.order_id), 0),
        2
    ) AS average_order_value
FROM fact_order_items f
JOIN dim_date d
    ON f.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;


-- ============================================================
-- 4. Monthly Sales KPIs
-- ============================================================

SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.revenue) AS total_revenue
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
-- 5. Monthly Profitability KPIs
-- ============================================================

SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.revenue) AS total_revenue,
    SUM(f.cost) AS total_cost,
    SUM(f.profit) AS total_profit,
    ROUND(
        SUM(f.profit) / NULLIF(SUM(f.revenue), 0) * 100,
        2
    ) AS profit_margin
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