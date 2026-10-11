-- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 1: EXECUTIVE KPI OVERVIEW
-- Business Question:
-- What are NovaMart's core business KPIs in one
-- executive-level view?
-- =====================================================

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT o.customer_id) AS total_customers,

    COUNT(DISTINCT oi.product_id) AS products_sold,

    SUM(oi.quantity) AS total_units_sold,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ),
        2
    ) AS total_revenue,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        ),
        2
    ) AS total_profit,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        )
        /
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        * 100,
        2
    ) AS profit_margin_percent,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value

FROM orders AS o

JOIN order_items AS oi
    ON o.order_id = oi.order_id

JOIN products AS p
    ON oi.product_id = p.product_id;
    
    
    
    -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 2: REVENUE & PROFIT BY YEAR
-- Business Question:
-- How are NovaMart's revenue and profitability
-- changing from year to year?
-- =====================================================

SELECT
    YEAR(o.order_date) AS order_year,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ),
        2
    ) AS total_revenue,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        ),
        2
    ) AS total_profit,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        )
        /
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        * 100,
        2
    ) AS profit_margin_percent

FROM orders AS o

JOIN order_items AS oi
    ON o.order_id = oi.order_id

JOIN products AS p
    ON oi.product_id = p.product_id

GROUP BY
    YEAR(o.order_date)

ORDER BY
    order_year;
    
    
    
    -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 3: REVENUE & PROFIT BY CHANNEL
-- Business Question:
-- Which sales channels generate the most revenue
-- and profit?
-- =====================================================

SELECT
    o.channel,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ),
        2
    ) AS total_revenue,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        ),
        2
    ) AS total_profit,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        )
        /
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        * 100,
        2
    ) AS profit_margin_percent,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value

FROM orders AS o

JOIN order_items AS oi
    ON o.order_id = oi.order_id

JOIN products AS p
    ON oi.product_id = p.product_id

GROUP BY
    o.channel

ORDER BY
    total_revenue DESC;
    
    
    
    -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 4: REGIONAL PERFORMANCE
-- Business Question:
-- Which regions generate the most revenue and profit,
-- and how efficient are they?
-- =====================================================

SELECT
    s.region,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ),
        2
    ) AS total_revenue,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        ),
        2
    ) AS total_profit,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        )
        /
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        * 100,
        2
    ) AS profit_margin_percent,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value

FROM orders AS o

JOIN stores AS s
    ON o.store_id = s.store_id

JOIN order_items AS oi
    ON o.order_id = oi.order_id

JOIN products AS p
    ON oi.product_id = p.product_id

GROUP BY
    s.region

ORDER BY
    total_revenue DESC;
    
    
    
    -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 5: CUSTOMER VALUE OVERVIEW
-- Business Question:
-- Which customer segments generate the most revenue
-- and purchase most frequently?
-- =====================================================

SELECT
    CASE
        WHEN lifetime_revenue >= 1500000
             AND order_count >= 8
            THEN 'VIP'

        WHEN lifetime_revenue >= 1000000
             AND order_count >= 5
            THEN 'Loyal'

        WHEN lifetime_revenue >= 500000
             AND order_count >= 3
            THEN 'Regular'

        ELSE 'One-Time / Low Value'
    END AS customer_segment,

    COUNT(*) AS customer_count,

    ROUND(
        SUM(lifetime_revenue),
        2
    ) AS total_revenue,

    ROUND(
        AVG(lifetime_revenue),
        2
    ) AS average_customer_revenue,

    ROUND(
        AVG(order_count),
        2
    ) AS average_order_count

FROM (
    SELECT
        c.customer_id,

        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ) AS lifetime_revenue,

        COUNT(DISTINCT o.order_id) AS order_count

    FROM customers AS c

    JOIN orders AS o
        ON c.customer_id = o.customer_id

    JOIN order_items AS oi
        ON o.order_id = oi.order_id

    GROUP BY
        c.customer_id
) AS customer_metrics

GROUP BY
    customer_segment

ORDER BY
    total_revenue DESC;
    
    
    
    
    
    -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 6: PRODUCT PERFORMANCE OVERVIEW
-- Business Question:
-- Which products generate the most revenue and profit,
-- and what are their profit margins?
-- =====================================================

SELECT
    p.product_id,
    p.product_name,

    SUM(oi.quantity) AS units_sold,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ),
        2
    ) AS total_revenue,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        ),
        2
    ) AS total_profit,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        )
        /
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        * 100,
        2
    ) AS profit_margin_percent

FROM products AS p

JOIN order_items AS oi
    ON p.product_id = oi.product_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY
    total_profit DESC;
    
    
    -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 7: STORE PERFORMANCE OVERVIEW
-- Business Question:
-- Which stores generate the most revenue and profit,
-- and how efficient are their operations?
-- =====================================================

SELECT
    s.store_id,
    s.store_code,
    s.city,
    s.region,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ),
        2
    ) AS total_revenue,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        ),
        2
    ) AS total_profit,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        )
        /
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        * 100,
        2
    ) AS profit_margin_percent,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value

FROM stores AS s

JOIN orders AS o
    ON s.store_id = o.store_id

JOIN order_items AS oi
    ON o.order_id = oi.order_id

JOIN products AS p
    ON oi.product_id = p.product_id

GROUP BY
    s.store_id,
    s.store_code,
    s.city,
    s.region

ORDER BY
    total_profit DESC;
    
    
    
    
    -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 8: INVENTORY RISK OVERVIEW
-- Business Question:
-- Which regions have the highest inventory value
-- and the greatest stock risk?
-- =====================================================

SELECT
    s.region,

    SUM(i.stock_quantity) AS total_stock_units,

    ROUND(
        SUM(
            i.stock_quantity * p.cost_price
        ),
        2
    ) AS inventory_value,

    SUM(
        CASE
            WHEN i.stock_quantity < i.reorder_level
                THEN 1
            ELSE 0
        END
    ) AS low_stock_records,

    SUM(
        CASE
            WHEN i.stock_quantity = 0
                THEN 1
            ELSE 0
        END
    ) AS out_of_stock_records,

    ROUND(
        SUM(
            CASE
                WHEN i.stock_quantity < i.reorder_level
                    THEN 1
                ELSE 0
            END
        )
        /
        COUNT(*)
        * 100,
        2
    ) AS low_stock_percentage

FROM inventory AS i

JOIN products AS p
    ON i.product_id = p.product_id

JOIN stores AS s
    ON i.store_id = s.store_id

GROUP BY
    s.region

ORDER BY
    low_stock_percentage DESC;
    
    
    
    -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 9: RETURNS & REFUND OVERVIEW
-- Business Question:
-- Which product categories have the greatest
-- return volume and refund exposure?
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
        /
        SUM(oi.quantity)
        * 100,
        2
    ) AS return_rate_percent,

    ROUND(
        COALESCE(SUM(r.refund_amount), 0),
        2
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
    refund_exposure_percent DESC,
    refund_value DESC;
    
    
    
    -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 10: CUSTOMER SATISFACTION OVERVIEW
-- Business Question:
-- Which product categories have the strongest
-- and weakest customer satisfaction?
-- =====================================================

SELECT
    c.category_name,

    COUNT(r.review_id) AS review_count,

    ROUND(
        AVG(r.rating),
        2
    ) AS average_rating,

    SUM(
        CASE
            WHEN r.rating <= 2 THEN 1
            ELSE 0
        END
    ) AS low_rating_count,

    ROUND(
        SUM(
            CASE
                WHEN r.rating <= 2 THEN 1
                ELSE 0
            END
        )
        /
        COUNT(r.review_id)
        * 100,
        2
    ) AS low_rating_percentage,

    SUM(
        CASE
            WHEN r.rating >= 4 THEN 1
            ELSE 0
        END
    ) AS high_rating_count,

    ROUND(
        SUM(
            CASE
                WHEN r.rating >= 4 THEN 1
                ELSE 0
            END
        )
        /
        COUNT(r.review_id)
        * 100,
        2
    ) AS high_rating_percentage

FROM reviews AS r

JOIN products AS p
    ON r.product_id = p.product_id

JOIN categories AS c
    ON p.category_id = c.category_id

GROUP BY
    c.category_name

ORDER BY
    average_rating DESC;
    
    
    
    
    -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 11: REVENUE GROWTH ANALYSIS
-- Business Question:
-- How is NovaMart's revenue changing from one year
-- to the next?
-- =====================================================

WITH yearly_revenue AS (
    SELECT
        YEAR(o.order_date) AS order_year,

        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ) AS total_revenue

    FROM orders AS o

    JOIN order_items AS oi
        ON o.order_id = oi.order_id

    GROUP BY
        YEAR(o.order_date)
)

SELECT
    order_year,

    ROUND(
        total_revenue,
        2
    ) AS total_revenue,

    ROUND(
        total_revenue
        -
        LAG(total_revenue) OVER (
            ORDER BY order_year
        ),
        2
    ) AS revenue_change,

    ROUND(
        (
            total_revenue
            -
            LAG(total_revenue) OVER (
                ORDER BY order_year
            )
        )
        /
        NULLIF(
            LAG(total_revenue) OVER (
                ORDER BY order_year
            ),
            0
        )
        * 100,
        2
    ) AS revenue_growth_percent

FROM yearly_revenue

ORDER BY
    order_year;
    
    
    
   -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 12: PROFITABILITY ANALYSIS
-- Business Question:
-- Which categories generate the most profit and
-- maintain the strongest profit margins?
-- =====================================================

SELECT
    c.category_name,

    SUM(oi.quantity) AS units_sold,

    ROUND(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ),
        2
    ) AS total_revenue,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        ),
        2
    ) AS total_profit,

    ROUND(
        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        )
        /
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        )
        * 100,
        2
    ) AS profit_margin_percent

FROM order_items AS oi

JOIN products AS p
    ON oi.product_id = p.product_id

JOIN categories AS c
    ON p.category_id = c.category_id

GROUP BY
    c.category_name

ORDER BY
    total_profit DESC; 
    
    
    
  -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 13: BUSINESS PERFORMANCE RANKING
-- Business Question:
-- How do NovaMart's categories rank by revenue,
-- profit, and profit margin?
-- =====================================================

WITH category_performance AS (
    SELECT
        c.category_name,

        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ) AS total_revenue,

        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        ) AS total_profit

    FROM order_items AS oi

    JOIN products AS p
        ON oi.product_id = p.product_id

    JOIN categories AS c
        ON p.category_id = c.category_id

    GROUP BY
        c.category_name
)

SELECT
    category_name,

    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(total_profit, 2) AS total_profit,

    ROUND(
        total_profit
        / total_revenue
        * 100,
        2
    ) AS profit_margin_percent,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,

    RANK() OVER (
        ORDER BY total_profit DESC
    ) AS profit_rank,

    RANK() OVER (
        ORDER BY
            total_profit / total_revenue DESC
    ) AS margin_rank

FROM category_performance

ORDER BY
    profit_rank;  
    
    
    
    
   -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 14: BUSINESS RISK CLASSIFICATION
-- Business Question:
-- Which product categories require management
-- attention based on profitability?
-- =====================================================

WITH category_performance AS (
    SELECT
        c.category_name,

        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount_percent / 100)
        ) AS total_revenue,

        SUM(
            (
                oi.unit_price
                * (1 - oi.discount_percent / 100)
                - p.cost_price
            )
            * oi.quantity
        ) AS total_profit

    FROM order_items AS oi

    JOIN products AS p
        ON oi.product_id = p.product_id

    JOIN categories AS c
        ON p.category_id = c.category_id

    GROUP BY
        c.category_name
)

SELECT
    category_name,

    ROUND(
        total_revenue,
        2
    ) AS total_revenue,

    ROUND(
        total_profit,
        2
    ) AS total_profit,

    ROUND(
        total_profit
        / total_revenue
        * 100,
        2
    ) AS profit_margin_percent,

    CASE
        WHEN total_profit / total_revenue * 100 < 30
            THEN 'High Risk'

        WHEN total_profit / total_revenue * 100 < 35
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS business_risk

FROM category_performance

ORDER BY
    CASE
        WHEN total_profit / total_revenue * 100 < 30
            THEN 1

        WHEN total_profit / total_revenue * 100 < 35
            THEN 2

        ELSE 3
    END,
    profit_margin_percent ASC; 
    
    
    
    
 -- =====================================================
-- PROJECT 10: EXECUTIVE BUSINESS ANALYTICS
-- TASK 15: EXECUTIVE BUSINESS DASHBOARD DATASET
-- Business Question:
-- Can we create one executive-level dataset that
-- summarizes NovaMart's major business KPIs?
-- =====================================================

WITH sales_metrics AS (

    -- Calculate sales and profit metrics by category
    SELECT
        c.category_id,
        c.category_name,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.quantity) AS units_sold,

        ROUND(
            SUM(
                oi.quantity
                * oi.unit_price
                * (1 - oi.discount_percent / 100)
            ),
            2
        ) AS total_revenue,

        ROUND(
            SUM(
                (
                    oi.unit_price
                    * (1 - oi.discount_percent / 100)
                    - p.cost_price
                )
                * oi.quantity
            ),
            2
        ) AS total_profit

    FROM order_items AS oi

    JOIN orders AS o
        ON oi.order_id = o.order_id

    JOIN products AS p
        ON oi.product_id = p.product_id

    JOIN categories AS c
        ON p.category_id = c.category_id

    GROUP BY
        c.category_id,
        c.category_name
),

return_metrics AS (

    -- Calculate return metrics separately
    SELECT
        c.category_id,

        COALESCE(
            SUM(r.quantity_returned),
            0
        ) AS units_returned,

        ROUND(
            COALESCE(
                SUM(r.refund_amount),
                0
            ),
            2
        ) AS refund_value

    FROM returns AS r

    JOIN order_items AS oi
        ON r.order_item_id = oi.order_item_id

    JOIN products AS p
        ON oi.product_id = p.product_id

    JOIN categories AS c
        ON p.category_id = c.category_id

    GROUP BY
        c.category_id
),

review_metrics AS (

    -- Calculate customer satisfaction metrics separately
    SELECT
        c.category_id,

        COUNT(r.review_id) AS review_count,

        ROUND(
            AVG(r.rating),
            2
        ) AS average_rating

    FROM reviews AS r

    JOIN products AS p
        ON r.product_id = p.product_id

    JOIN categories AS c
        ON p.category_id = c.category_id

    GROUP BY
        c.category_id
)

SELECT
    s.category_name,

    -- Sales KPIs
    s.total_orders,
    s.units_sold,
    s.total_revenue,

    -- Profit KPIs
    s.total_profit,

    ROUND(
        s.total_profit
        / NULLIF(s.total_revenue, 0)
        * 100,
        2
    ) AS profit_margin_percent,

    -- Return KPIs
    COALESCE(
        r.units_returned,
        0
    ) AS units_returned,

    ROUND(
        COALESCE(r.units_returned, 0)
        / NULLIF(s.units_sold, 0)
        * 100,
        2
    ) AS return_rate_percent,

    COALESCE(
        r.refund_value,
        0
    ) AS refund_value,

    -- Customer Satisfaction KPIs
    COALESCE(
        rv.review_count,
        0
    ) AS review_count,

    COALESCE(
        rv.average_rating,
        0
    ) AS average_rating

FROM sales_metrics AS s

LEFT JOIN return_metrics AS r
    ON s.category_id = r.category_id

LEFT JOIN review_metrics AS rv
    ON s.category_id = rv.category_id

ORDER BY
    s.total_revenue DESC;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    