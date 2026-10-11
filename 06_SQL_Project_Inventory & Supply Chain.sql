-- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 1: INVENTORY OVERVIEW & STOCK POSITION
-- Business Question:
-- What does NovaMart's current inventory position
-- look like across its stores?
-- =====================================================

SELECT

    -- Total inventory records
    COUNT(*) AS inventory_records,

    -- Total units currently in stock
    SUM(stock_quantity) AS total_stock_units,

    -- Average stock held per inventory record
    AVG(stock_quantity) AS average_stock_per_record,

    -- Count inventory records below reorder level
    SUM(
        CASE
            WHEN stock_quantity < reorder_level
                THEN 1
            ELSE 0
        END
    ) AS below_reorder_level,

    -- Count inventory records with zero stock
    SUM(
        CASE
            WHEN stock_quantity = 0
                THEN 1
            ELSE 0
        END
    ) AS out_of_stock_records

FROM inventory;


-- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 2: LOW-STOCK PRODUCTS
-- Business Question:
-- Which products have inventory below their
-- reorder level, and where are they located?
-- =====================================================

SELECT
    i.inventory_id,
    p.product_id,
    p.product_name,
    s.store_code,
    s.city,
    s.region,
    i.stock_quantity,
    i.reorder_level,
    
    -- Units below the reorder threshold
    (i.reorder_level - i.stock_quantity) AS reorder_gap

FROM inventory AS i

JOIN products AS p
    ON i.product_id = p.product_id

JOIN stores AS s
    ON i.store_id = s.store_id

WHERE i.stock_quantity < i.reorder_level

ORDER BY
    reorder_gap DESC;
    
    
    
    -- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 3: OUT-OF-STOCK INVENTORY
-- Business Question:
-- Which products are completely out of stock,
-- and which stores are affected?
-- =====================================================

SELECT
    i.inventory_id,
    p.product_id,
    p.product_name,
    s.store_code,
    s.city,
    s.region,
    i.stock_quantity,
    i.reorder_level,

    -- Full quantity required to reach reorder level
    i.reorder_level AS units_needed

FROM inventory AS i

JOIN products AS p
    ON i.product_id = p.product_id

JOIN stores AS s
    ON i.store_id = s.store_id

WHERE i.stock_quantity = 0

ORDER BY
    units_needed DESC;
    
    
    -- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 4: OVERSTOCKED INVENTORY
-- Business Question:
-- Which products have unusually high inventory
-- compared with their reorder level?
-- =====================================================

SELECT
    i.inventory_id,
    p.product_id,
    p.product_name,
    s.store_code,
    s.city,
    s.region,
    i.stock_quantity,
    i.reorder_level,
    (i.stock_quantity - i.reorder_level) AS excess_stock
FROM inventory AS i
JOIN products AS p
    ON i.product_id = p.product_id
JOIN stores AS s
    ON i.store_id = s.store_id
WHERE i.stock_quantity > (i.reorder_level * 2)
ORDER BY excess_stock DESC;


-- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 5: INVENTORY VALUE BY STORE
-- Business Question:
-- How much inventory value is currently held
-- by each store?
-- =====================================================

SELECT
    s.store_code,
    s.city,
    s.region,
    SUM(i.stock_quantity) AS total_stock_units,
    SUM(i.stock_quantity * p.cost_price) AS inventory_cost_value
FROM inventory AS i
JOIN stores AS s
    ON i.store_id = s.store_id
JOIN products AS p
    ON i.product_id = p.product_id
GROUP BY
    s.store_code,
    s.city,
    s.region
ORDER BY inventory_cost_value DESC;



-- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 6: INVENTORY VALUE BY CATEGORY
-- Business Question:
-- Which product categories have the most capital
-- tied up in inventory?
-- =====================================================

SELECT
    c.category_name,
    SUM(i.stock_quantity) AS total_stock_units,
    SUM(i.stock_quantity * p.cost_price) AS inventory_cost_value
FROM inventory AS i
JOIN products AS p
    ON i.product_id = p.product_id
JOIN categories AS c
    ON p.category_id = c.category_id
GROUP BY
    c.category_name
ORDER BY inventory_cost_value DESC;


-- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 7: STOCK COVERAGE ANALYSIS
-- Business Question:
-- How much inventory does each product-store
-- combination hold relative to its reorder level?
-- =====================================================

SELECT
    i.inventory_id,
    p.product_id,
    p.product_name,
    s.store_code,
    s.city,
    i.stock_quantity,
    i.reorder_level,
    ROUND(
        i.stock_quantity / NULLIF(i.reorder_level, 0),
        2
    ) AS stock_coverage_ratio
FROM inventory AS i
JOIN products AS p
    ON i.product_id = p.product_id
JOIN stores AS s
    ON i.store_id = s.store_id
ORDER BY stock_coverage_ratio DESC;


-- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 8: REORDER RISK ANALYSIS
-- Business Question:
-- Which inventory records represent the highest
-- replenishment risk?
-- =====================================================

SELECT
    i.inventory_id,
    p.product_id,
    p.product_name,
    s.store_code,
    s.city,
    s.region,
    i.stock_quantity,
    i.reorder_level,
    (i.reorder_level - i.stock_quantity) AS reorder_gap,
    CASE
        WHEN i.stock_quantity = 0
            THEN 'Critical'
        WHEN i.stock_quantity < i.reorder_level * 0.25
            THEN 'High Risk'
        WHEN i.stock_quantity < i.reorder_level
            THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS reorder_risk
FROM inventory AS i
JOIN products AS p
    ON i.product_id = p.product_id
JOIN stores AS s
    ON i.store_id = s.store_id
WHERE i.stock_quantity < i.reorder_level
ORDER BY
    CASE reorder_risk
        WHEN 'Critical' THEN 1
        WHEN 'High Risk' THEN 2
        WHEN 'Medium Risk' THEN 3
        ELSE 4
    END,
    reorder_gap DESC;
    
    
    -- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 9: SUPPLIER PERFORMANCE
-- Business Question:
-- Which suppliers have the largest inventory
-- exposure across NovaMart?
-- =====================================================

SELECT
    sp.supplier_id,
    sp.supplier_name,
    sp.country,
    COUNT(DISTINCT p.product_id) AS product_count,
    SUM(i.stock_quantity) AS total_stock_units,
    SUM(
        i.stock_quantity * p.cost_price
    ) AS inventory_cost_value
FROM suppliers AS sp
JOIN products AS p
    ON sp.supplier_id = p.supplier_id
JOIN inventory AS i
    ON p.product_id = i.product_id
GROUP BY
    sp.supplier_id,
    sp.supplier_name,
    sp.country
ORDER BY inventory_cost_value DESC;



-- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 10: SUPPLIER CONCENTRATION
-- Business Question:
-- How much of NovaMart's total inventory value
-- is concentrated among individual suppliers?
-- =====================================================

WITH supplier_inventory AS (
    SELECT
        sp.supplier_id,
        sp.supplier_name,
        sp.country,
        SUM(
            i.stock_quantity * p.cost_price
        ) AS inventory_cost_value
    FROM suppliers AS sp
    JOIN products AS p
        ON sp.supplier_id = p.supplier_id
    JOIN inventory AS i
        ON p.product_id = i.product_id
    GROUP BY
        sp.supplier_id,
        sp.supplier_name,
        sp.country
)

SELECT
    supplier_id,
    supplier_name,
    country,
    inventory_cost_value,
    ROUND(
        inventory_cost_value
        / SUM(inventory_cost_value) OVER ()
        * 100,
        2
    ) AS inventory_value_share_percent,
    RANK() OVER (
        ORDER BY inventory_cost_value DESC
    ) AS supplier_rank
FROM supplier_inventory
ORDER BY supplier_rank;



-- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 11: PRODUCT AVAILABILITY BY STORE
-- CORRECTED VERSION
-- =====================================================

SELECT
    p.product_id,
    p.product_name,

    -- Number of distinct stores where the product exists
    COUNT(DISTINCT i.store_id) AS stores_with_inventory,

    -- Number of distinct stores where the product actually
    -- has stock available
    COUNT(
        DISTINCT CASE
            WHEN i.stock_quantity > 0
                THEN i.store_id
        END
    ) AS stores_with_stock,

    -- Total physical stock across inventory records
    SUM(i.stock_quantity) AS total_stock_units

FROM products AS p
JOIN inventory AS i
    ON p.product_id = i.product_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY
    stores_with_stock DESC,
    total_stock_units DESC;
    
    
    
    -- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 12: INVENTORY EFFICIENCY RANKING
-- Business Question:
-- Which stores carry the highest-value inventory,
-- and how do they rank against other stores?
-- =====================================================

SELECT
    s.store_code,
    s.city,
    s.region,
    SUM(i.stock_quantity) AS total_stock_units,
    SUM(
        i.stock_quantity * p.cost_price
    ) AS inventory_cost_value,

    RANK() OVER (
        ORDER BY
            SUM(i.stock_quantity * p.cost_price) DESC
    ) AS inventory_value_rank

FROM inventory AS i
JOIN stores AS s
    ON i.store_id = s.store_id
JOIN products AS p
    ON i.product_id = p.product_id

GROUP BY
    s.store_code,
    s.city,
    s.region

ORDER BY inventory_value_rank;


-- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 13: REGIONAL INVENTORY RISK
-- Business Question:
-- Which regions have the greatest inventory exposure
-- and the greatest number of low-stock records?
-- =====================================================

SELECT
    s.region,

    SUM(i.stock_quantity) AS total_stock_units,

    SUM(
        i.stock_quantity * p.cost_price
    ) AS inventory_cost_value,

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
    ) AS out_of_stock_records

FROM inventory AS i
JOIN stores AS s
    ON i.store_id = s.store_id
JOIN products AS p
    ON i.product_id = p.product_id

GROUP BY
    s.region

ORDER BY
    low_stock_records DESC;
    
    
    
    -- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 14: CRITICAL INVENTORY IDENTIFICATION
-- Business Question:
-- Which inventory records require the most immediate
-- replenishment attention?
-- =====================================================

SELECT
    i.inventory_id,
    p.product_id,
    p.product_name,
    s.store_code,
    s.city,
    s.region,
    i.stock_quantity,
    i.reorder_level,
    (i.reorder_level - i.stock_quantity) AS replenishment_gap,

    CASE
        WHEN i.stock_quantity = 0
            THEN 'Critical'
        WHEN i.stock_quantity < i.reorder_level * 0.25
            THEN 'High Risk'
        ELSE 'Medium Risk'
    END AS risk_level

FROM inventory AS i
JOIN products AS p
    ON i.product_id = p.product_id
JOIN stores AS s
    ON i.store_id = s.store_id

WHERE
    i.stock_quantity = 0
    OR i.stock_quantity < i.reorder_level * 0.25

ORDER BY
    CASE risk_level
        WHEN 'Critical' THEN 1
        WHEN 'High Risk' THEN 2
        ELSE 3
    END,
    replenishment_gap DESC;



-- =====================================================
-- PROJECT 6: INVENTORY & SUPPLY CHAIN
-- TASK 15: INVENTORY & SUPPLY CHAIN PORTFOLIO
-- Business Question:
-- Which stores have high inventory investment
-- and high inventory risk?
-- =====================================================

SELECT
    store_code,
    city,
    region,
    inventory_cost_value,
    low_stock_records,
    out_of_stock_records,

    CASE
        WHEN inventory_cost_value >= 3300000000
             AND low_stock_records >= 500
            THEN 'High Investment / High Risk'

        WHEN inventory_cost_value >= 3300000000
             AND low_stock_records < 500
            THEN 'High Investment / Low Risk'

        WHEN inventory_cost_value < 3300000000
             AND low_stock_records >= 500
            THEN 'Low Investment / High Risk'

        ELSE 'Low Investment / Low Risk'
    END AS portfolio_segment

FROM (
    SELECT
        s.store_code,
        s.city,
        s.region,

        SUM(
            i.stock_quantity * p.cost_price
        ) AS inventory_cost_value,

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
        ) AS out_of_stock_records

    FROM inventory AS i
    JOIN stores AS s
        ON i.store_id = s.store_id
    JOIN products AS p
        ON i.product_id = p.product_id

    GROUP BY
        s.store_code,
        s.city,
        s.region
) AS store_inventory
ORDER BY
    CASE portfolio_segment
        WHEN 'High Investment / High Risk' THEN 1
        WHEN 'High Investment / Low Risk' THEN 2
        WHEN 'Low Investment / High Risk' THEN 3
        ELSE 4
    END,
    inventory_cost_value DESC;















