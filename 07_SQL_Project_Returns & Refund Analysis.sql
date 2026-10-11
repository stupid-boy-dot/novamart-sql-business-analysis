-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 1: RETURN OVERVIEW
-- Business Question:
-- What does NovaMart's overall returns situation
-- look like?
-- =====================================================

SELECT
    COUNT(*) AS total_return_records,
    SUM(quantity_returned) AS total_units_returned,
    SUM(refund_amount) AS total_refund_value,
    AVG(refund_amount) AS average_refund_value,
    AVG(quantity_returned) AS average_units_per_return
FROM returns;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 2: RETURN RATE
-- Business Question:
-- What percentage of sold units are being returned?
-- =====================================================

SELECT
    (
        SELECT SUM(quantity_returned)
        FROM returns
    ) AS total_units_returned,

    (
        SELECT SUM(quantity)
        FROM order_items
    ) AS total_units_sold,

    ROUND(
        (
            SELECT SUM(quantity_returned)
            FROM returns
        )
        /
        (
            SELECT SUM(quantity)
            FROM order_items
        )
        * 100,
        2
    ) AS return_rate_percent;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 3: REFUND VALUE ANALYSIS
-- Business Question:
-- Which return records represent the largest
-- refund amounts?
-- =====================================================

SELECT
    r.return_id,
    r.order_item_id,
    r.return_reason,
    r.quantity_returned,
    r.refund_amount,
    r.return_date
FROM returns AS r
ORDER BY
    r.refund_amount DESC;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 4: RETURN REASONS
-- Business Question:
-- Why are customers returning products, and which
-- reasons generate the most refund exposure?
-- =====================================================

SELECT
    r.return_reason,
    COUNT(*) AS return_count,
    SUM(r.quantity_returned) AS units_returned,
    SUM(r.refund_amount) AS total_refund_value,
    AVG(r.refund_amount) AS average_refund_value
FROM returns AS r
GROUP BY
    r.return_reason
ORDER BY
    total_refund_value DESC;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 5: RETURNS BY PRODUCT
-- Business Question:
-- Which products generate the most returned units
-- and refund exposure?
-- =====================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(DISTINCT r.return_id) AS return_count,
    SUM(r.quantity_returned) AS units_returned,
    SUM(r.refund_amount) AS total_refund_value
FROM returns AS r
JOIN order_items AS oi
    ON r.order_item_id = oi.order_item_id
JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    total_refund_value DESC;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 6: RETURNS BY CATEGORY
-- Business Question:
-- Which product categories generate the greatest
-- return and refund exposure?
-- =====================================================

SELECT
    c.category_name,
    COUNT(DISTINCT r.return_id) AS return_count,
    SUM(r.quantity_returned) AS units_returned,
    SUM(r.refund_amount) AS total_refund_value
FROM returns AS r
JOIN order_items AS oi
    ON r.order_item_id = oi.order_item_id
JOIN products AS p
    ON oi.product_id = p.product_id
JOIN categories AS c
    ON p.category_id = c.category_id
GROUP BY
    c.category_name
ORDER BY
    total_refund_value DESC;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 7: RETURNS BY STORE
-- Business Question:
-- Which stores have the greatest return and
-- refund exposure?
-- =====================================================

SELECT
    s.store_code,
    s.city,
    s.region,
    COUNT(DISTINCT r.return_id) AS return_count,
    SUM(r.quantity_returned) AS units_returned,
    SUM(r.refund_amount) AS total_refund_value
FROM returns AS r
JOIN order_items AS oi
    ON r.order_item_id = oi.order_item_id
JOIN orders AS o
    ON oi.order_id = o.order_id
JOIN stores AS s
    ON o.store_id = s.store_id
GROUP BY
    s.store_code,
    s.city,
    s.region
ORDER BY
    total_refund_value DESC;



-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 8: RETURNS BY REGION
-- Business Question:
-- Which regions have the greatest return volume
-- and refund exposure?
-- =====================================================

SELECT
    s.region,
    COUNT(DISTINCT r.return_id) AS return_count,
    SUM(r.quantity_returned) AS units_returned,
    SUM(r.refund_amount) AS total_refund_value,
    AVG(r.refund_amount) AS average_refund_value
FROM returns AS r
JOIN order_items AS oi
    ON r.order_item_id = oi.order_item_id
JOIN orders AS o
    ON oi.order_id = o.order_id
JOIN stores AS s
    ON o.store_id = s.store_id
GROUP BY
    s.region
ORDER BY
    total_refund_value DESC;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 9: RETURN RATE BY CATEGORY
-- Business Question:
-- Which product categories have the highest
-- return rates relative to units sold?
-- =====================================================

SELECT
    c.category_name,

    SUM(oi.quantity) AS units_sold,

    COALESCE(
        SUM(r.quantity_returned),
        0
    ) AS units_returned,

    ROUND(
        COALESCE(SUM(r.quantity_returned), 0)
        / SUM(oi.quantity)
        * 100,
        2
    ) AS return_rate_percent

FROM order_items AS oi

JOIN products AS p
    ON oi.product_id = p.product_id

JOIN categories AS c
    ON p.category_id = c.category_id

LEFT JOIN returns AS r
    ON oi.order_item_id = r.order_item_id

GROUP BY
    c.category_name

ORDER BY
    return_rate_percent DESC;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 10: REFUND EXPOSURE
-- Business Question:
-- What percentage of sales value is being returned
-- as refunds for each category?
-- =====================================================

SELECT
    c.category_name,

    SUM(
        oi.quantity
        * oi.unit_price
        * (1 - oi.discount_percent / 100)
    ) AS sales_value,

    COALESCE(
        SUM(r.refund_amount),
        0
    ) AS refund_value,

    ROUND(
        COALESCE(SUM(r.refund_amount), 0)
        /
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        * 100,
        2
    ) AS refund_exposure_percent

FROM order_items AS oi

JOIN products AS p
    ON oi.product_id = p.product_id

JOIN categories AS c
    ON p.category_id = c.category_id

LEFT JOIN returns AS r
    ON oi.order_item_id = r.order_item_id

GROUP BY
    c.category_name

ORDER BY
    refund_exposure_percent DESC;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 11: HIGH-RETURN PRODUCTS
-- Business Question:
-- Which products have meaningful sales volume
-- and unusually high return rates?
-- =====================================================

SELECT
    p.product_id,
    p.product_name,

    SUM(oi.quantity) AS units_sold,

    COALESCE(
        SUM(r.quantity_returned),
        0
    ) AS units_returned,

    ROUND(
        COALESCE(SUM(r.quantity_returned), 0)
        / SUM(oi.quantity)
        * 100,
        2
    ) AS return_rate_percent,

    COALESCE(
        SUM(r.refund_amount),
        0
    ) AS refund_value

FROM products AS p

JOIN order_items AS oi
    ON p.product_id = oi.product_id

LEFT JOIN returns AS r
    ON oi.order_item_id = r.order_item_id

GROUP BY
    p.product_id,
    p.product_name

HAVING
    SUM(oi.quantity) >= 200
    AND
    (
        COALESCE(SUM(r.quantity_returned), 0)
        / SUM(oi.quantity)
        * 100
    ) > 1.5

ORDER BY
    return_rate_percent DESC,
    refund_value DESC;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 12: RETURN PATTERN ANALYSIS
-- Business Question:
-- How do return volumes and refund values
-- change over time?
-- =====================================================

SELECT
    YEAR(return_date) AS return_year,
    MONTH(return_date) AS return_month,

    COUNT(*) AS return_count,

    SUM(quantity_returned) AS units_returned,

    SUM(refund_amount) AS refund_value,

    ROUND(
        AVG(refund_amount),
        2
    ) AS average_refund_value

FROM returns

GROUP BY
    YEAR(return_date),
    MONTH(return_date)

ORDER BY
    return_year,
    return_month;



-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 13: RETURN RISK CLASSIFICATION
-- Business Question:
-- Which products should be classified as
-- low, medium, or high return risk?
-- =====================================================

SELECT
    product_id,
    product_name,
    units_sold,
    units_returned,
    return_rate_percent,
    refund_value,

    CASE
        WHEN return_rate_percent > 3
            THEN 'High Risk'

        WHEN return_rate_percent >= 1.5
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS return_risk

FROM (
    SELECT
        p.product_id,
        p.product_name,

        SUM(oi.quantity) AS units_sold,

        COALESCE(
            SUM(r.quantity_returned),
            0
        ) AS units_returned,

        ROUND(
            COALESCE(SUM(r.quantity_returned), 0)
            / SUM(oi.quantity)
            * 100,
            2
        ) AS return_rate_percent,

        COALESCE(
            SUM(r.refund_amount),
            0
        ) AS refund_value

    FROM products AS p

    JOIN order_items AS oi
        ON p.product_id = oi.product_id

    LEFT JOIN returns AS r
        ON oi.order_item_id = r.order_item_id

    GROUP BY
        p.product_id,
        p.product_name

    HAVING
        SUM(oi.quantity) >= 200
) AS product_returns

ORDER BY
    CASE
        WHEN return_rate_percent > 3 THEN 1
        WHEN return_rate_percent >= 1.5 THEN 2
        ELSE 3
    END,
    return_rate_percent DESC;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 14: PRODUCT RETURN PORTFOLIO
-- Business Question:
-- Which products have high/low return rates
-- and high/low refund exposure?
-- =====================================================

SELECT
    product_id,
    product_name,
    units_sold,
    units_returned,
    return_rate_percent,
    refund_value,

    CASE
        WHEN return_rate_percent >= 2
             AND refund_value >= 75000
            THEN 'High Return / High Refund'

        WHEN return_rate_percent >= 2
             AND refund_value < 75000
            THEN 'High Return / Low Refund'

        WHEN return_rate_percent < 2
             AND refund_value >= 75000
            THEN 'Low Return / High Refund'

        ELSE 'Low Return / Low Refund'
    END AS return_portfolio

FROM (
    SELECT
        p.product_id,
        p.product_name,

        SUM(oi.quantity) AS units_sold,

        COALESCE(
            SUM(r.quantity_returned),
            0
        ) AS units_returned,

        ROUND(
            COALESCE(SUM(r.quantity_returned), 0)
            / SUM(oi.quantity)
            * 100,
            2
        ) AS return_rate_percent,

        COALESCE(
            SUM(r.refund_amount),
            0
        ) AS refund_value

    FROM products AS p

    JOIN order_items AS oi
        ON p.product_id = oi.product_id

    LEFT JOIN returns AS r
        ON oi.order_item_id = r.order_item_id

    GROUP BY
        p.product_id,
        p.product_name

    HAVING
        SUM(oi.quantity) >= 200
) AS product_returns

ORDER BY
    CASE return_portfolio
        WHEN 'High Return / High Refund' THEN 1
        WHEN 'High Return / Low Refund' THEN 2
        WHEN 'Low Return / High Refund' THEN 3
        ELSE 4
    END,
    refund_value DESC;


-- =====================================================
-- PROJECT 7: RETURNS & REFUND ANALYSIS
-- TASK 15: RETURNS & REFUND EXECUTIVE ANALYSIS
-- Business Question:
-- Which categories require the most attention
-- based on return and refund performance?
-- =====================================================

SELECT
    c.category_name,

    SUM(oi.quantity) AS units_sold,

    COALESCE(
        SUM(r.quantity_returned),
        0
    ) AS units_returned,

    ROUND(
        COALESCE(SUM(r.quantity_returned), 0)
        / SUM(oi.quantity)
        * 100,
        2
    ) AS return_rate_percent,

    COALESCE(
        SUM(r.refund_amount),
        0
    ) AS refund_value,

    ROUND(
        COALESCE(AVG(r.refund_amount), 0),
        2
    ) AS average_refund_value,

    ROUND(
        COALESCE(SUM(r.refund_amount), 0)
        /
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        * 100,
        2
    ) AS refund_exposure_percent

FROM order_items AS oi

JOIN products AS p
    ON oi.product_id = p.product_id

JOIN categories AS c
    ON p.category_id = c.category_id

LEFT JOIN returns AS r
    ON oi.order_item_id = r.order_item_id

GROUP BY
    c.category_name

ORDER BY
    refund_exposure_percent DESC,
    refund_value DESC;






































































































































































































































































































































































































































