-- =====================================================
-- NOVAMART ANALYTICS PROJECT
-- PROJECT 1: DATA EXPLORATION & DATABASE AUDIT
-- =====================================================

USE novamart_analytics;

-- =====================================================
-- TASK 1: ORDER STATUS DISTRIBUTION
-- =====================================================

SELECT
    status,
    COUNT(*) AS orders_count
FROM orders
GROUP BY status;


-- =====================================================
-- TASK 2: ORDERS BY SALES CHANNEL
-- Business Question:
-- How many orders came through each sales channel?
-- =====================================================

SELECT
    channel,                 -- Sales channel
    COUNT(*) AS orders_count -- Count the orders in each channel
FROM orders                 -- Get the data from the orders table
GROUP BY channel;            -- Create one group for each channel


-- =====================================================
-- TASK 3: ORDERS BY YEAR
-- Business Question:
-- How many orders were placed in each year?
-- =====================================================

SELECT
    YEAR(order_date) AS order_year, -- Extract the year from order_date
    COUNT(*) AS orders_count        -- Count orders for each year
FROM orders                         -- Use the orders table
GROUP BY YEAR(order_date)           -- Group orders by year
ORDER BY order_year;                -- Show years in ascending order

-- =====================================================
-- TASK 4: ORDERS BY MONTH
-- Business Question:
-- How many orders were placed in each month?
-- =====================================================

SELECT
    MONTH(order_date) AS order_month, -- Extract the month number
    COUNT(*) AS orders_count          -- Count orders in each month
FROM orders                           -- Use the orders table
GROUP BY MONTH(order_date)             -- Group orders by month
ORDER BY order_month;                  -- Display months from January to December

-- =====================================================
-- TASK 5: ORDERS BY CUSTOMER
-- Business Question:
-- How many orders has each customer placed?
-- =====================================================

SELECT
    customer_id,                 -- Identify the customer
    COUNT(*) AS orders_count    -- Count orders placed by that customer
FROM orders                      -- Use the orders table
GROUP BY customer_id             -- Create one group for each customer
ORDER BY orders_count DESC;      -- Show customers with most orders first

-- =====================================================
-- TASK 6: CUSTOMERS WITH MORE THAN 5 ORDERS
-- Business Question:
-- Which customers have placed more than 5 orders?
-- =====================================================

SELECT
    customer_id,                  -- Identify the customer
    COUNT(*) AS orders_count      -- Count orders placed by the customer
FROM orders                       -- Use the orders table
GROUP BY customer_id              -- Create one group for each customer
HAVING COUNT(*) > 5               -- Keep only customers with more than 5 orders
ORDER BY orders_count DESC;       -- Show highest-order customers first



-- =====================================================
-- TASK 7: ORDERS BY STORE
-- Business Question:
-- How many orders does each store handle?
-- =====================================================

SELECT
    store_id,                    -- Identify the store
    COUNT(*) AS orders_count     -- Count orders handled by the store
FROM orders                      -- Use the orders table
GROUP BY store_id                -- Create one group for each store
ORDER BY orders_count DESC;      -- Show busiest stores first


-- =====================================================
-- TASK 8: ORDERS BY REGION
-- Business Question:
-- How many orders were placed in each region?
-- =====================================================

SELECT
    s.region,                       -- Identify the region
    COUNT(*) AS orders_count        -- Count orders in that region
FROM orders AS o                    -- Start with the orders table
JOIN stores AS s                    -- Connect orders to stores
    ON o.store_id = s.store_id      -- Match each order to its store
GROUP BY s.region                   -- Create one group for each region
ORDER BY orders_count DESC;         -- Show regions with most orders first

-- =====================================================
-- TASK 9: PAYMENT METHOD DISTRIBUTION
-- Business Question:
-- Which payment methods are used most frequently?
-- =====================================================

SELECT
    payment_method,                  -- Identify the payment method
    COUNT(*) AS payment_count        -- Count payments using each method
FROM payments                        -- Use the payments table
GROUP BY payment_method              -- Create one group for each method
ORDER BY payment_count DESC;         -- Show most-used methods first

-- =====================================================
-- TASK 10: PRODUCT STATUS DISTRIBUTION
-- Business Question:
-- How many products are in each product status?
-- =====================================================

SELECT
    status,                       -- Product status
    COUNT(*) AS product_count     -- Count products in each status
FROM products                    -- Use the products table
GROUP BY status                  -- Create one group for each status
ORDER BY product_count DESC;     -- Show the largest group first


-- =====================================================
-- TASK 11: DATA QUALITY CHECK — NULL VALUES
-- Business Question:
-- Are there missing values in important order columns?
-- =====================================================

SELECT
    COUNT(*) AS total_orders,                         -- Total number of orders

    SUM(customer_id IS NULL) AS missing_customer,    -- Orders without a customer
    SUM(store_id IS NULL) AS missing_store,          -- Orders without a store
    SUM(employee_id IS NULL) AS missing_employee,    -- Orders without an employee
    SUM(order_date IS NULL) AS missing_order_date    -- Orders without an order date

FROM orders;                                         -- Check the orders table


-- =====================================================
-- TASK 12: DATA QUALITY CHECK — DUPLICATE ORDER IDs
-- Business Question:
-- Are there any duplicate order IDs?
-- =====================================================

SELECT
    order_id,                         -- Identify the order
    COUNT(*) AS duplicate_count       -- Count how many times it appears
FROM orders                           -- Check the orders table
GROUP BY order_id                     -- Group identical order IDs together
HAVING COUNT(*) > 1;                  -- Show only IDs appearing more than once


-- =====================================================
-- TASK 13: DATA QUALITY CHECK — INVALID CUSTOMER IDs
-- Business Question:
-- Do all orders reference a valid customer?
-- =====================================================

SELECT
    o.customer_id,                    -- Customer referenced by the order
    COUNT(*) AS affected_orders       -- Number of orders using this customer ID
FROM orders AS o                      -- Start with orders
LEFT JOIN customers AS c              -- Look for the matching customer
    ON o.customer_id = c.customer_id  -- Match customer IDs
WHERE c.customer_id IS NULL           -- Keep only orders with no matching customer
GROUP BY o.customer_id                -- Group invalid customer IDs
ORDER BY affected_orders DESC;        -- Show most affected IDs first


-- =====================================================
-- TASK 14: DATA QUALITY CHECK — INVALID PRODUCT IDs
-- Business Question:
-- Do all order items reference a valid product?
-- =====================================================

SELECT
    oi.product_id,                       -- Product referenced by the order item
    COUNT(*) AS affected_items            -- Number of order items using this product ID
FROM order_items AS oi                    -- Start with order items
LEFT JOIN products AS p                   -- Look for the matching product
    ON oi.product_id = p.product_id       -- Match product IDs
WHERE p.product_id IS NULL                -- Keep only items with no matching product
GROUP BY oi.product_id                    -- Group invalid product IDs
ORDER BY affected_items DESC;             -- Show most affected IDs first

-- =====================================================
-- TASK 15: DATA QUALITY CHECK — INVALID STORE IDs
-- Business Question:
-- Do all orders reference a valid store?
-- =====================================================

SELECT
    o.store_id,                         -- Store referenced by the order
    COUNT(*) AS affected_orders         -- Number of orders using this store ID
FROM orders AS o                        -- Start with orders
LEFT JOIN stores AS s                   -- Look for the matching store
    ON o.store_id = s.store_id           -- Match store IDs
WHERE s.store_id IS NULL                -- Keep only orders with no matching store
GROUP BY o.store_id                     -- Group invalid store IDs
ORDER BY affected_orders DESC;           -- Show most affected IDs first


-- =====================================================
-- TASK 16: DATA QUALITY CHECK — INVALID ORDER IDs
-- Business Question:
-- Do all order items reference a valid order?
-- =====================================================

SELECT
    oi.order_id,                         -- Order referenced by the order item
    COUNT(*) AS affected_items           -- Number of items using this order ID
FROM order_items AS oi                   -- Start with order items
LEFT JOIN orders AS o                    -- Look for the matching order
    ON oi.order_id = o.order_id          -- Match order IDs
WHERE o.order_id IS NULL                 -- Keep only items with no matching order
GROUP BY oi.order_id                     -- Group invalid order IDs
ORDER BY affected_items DESC;            -- Show most affected IDs first


-- =====================================================
-- TASK 17: DATA QUALITY CHECK — INVALID CATEGORY IDs
-- Business Question:
-- Do all products reference a valid category?
-- =====================================================

SELECT
    p.category_id,                         -- Category referenced by the product
    COUNT(*) AS affected_products          -- Number of products using this category ID
FROM products AS p                         -- Start with products
LEFT JOIN categories AS c                  -- Look for the matching category
    ON p.category_id = c.category_id       -- Match category IDs
WHERE c.category_id IS NULL                -- Keep only products with no matching category
GROUP BY p.category_id                     -- Group invalid category IDs
ORDER BY affected_products DESC;           -- Show most affected IDs first


-- =====================================================
-- TASK 18: DATA QUALITY CHECK — INVALID SUPPLIER IDs
-- Business Question:
-- Do all products reference a valid supplier?
-- =====================================================

SELECT
    p.supplier_id,                         -- Supplier referenced by the product
    COUNT(*) AS affected_products          -- Number of products using this supplier ID
FROM products AS p                         -- Start with products
LEFT JOIN suppliers AS s                   -- Look for the matching supplier
    ON p.supplier_id = s.supplier_id       -- Match supplier IDs
WHERE s.supplier_id IS NULL                -- Keep only products with no matching supplier
GROUP BY p.supplier_id                     -- Group invalid supplier IDs
ORDER BY affected_products DESC;           -- Show most affected IDs first


-- =====================================================
-- TASK 19: DATA QUALITY CHECK — INVALID EMPLOYEE IDs
-- Business Question:
-- Do all non-NULL employee IDs reference a valid employee?
-- =====================================================

SELECT
    o.employee_id,                         -- Employee referenced by the order
    COUNT(*) AS affected_orders            -- Number of orders using this employee ID
FROM orders AS o                           -- Start with orders
LEFT JOIN employees AS e                   -- Look for the matching employee
    ON o.employee_id = e.employee_id       -- Match employee IDs
WHERE o.employee_id IS NOT NULL            -- Ignore legitimate NULL employee IDs
  AND e.employee_id IS NULL                -- Keep only invalid employee IDs
GROUP BY o.employee_id                     -- Group invalid employee IDs
ORDER BY affected_orders DESC;              -- Show most affected IDs first


-- =====================================================
-- TASK 20: DATA QUALITY CHECK — DUPLICATE EMAILS
-- Business Question:
-- Are there duplicate customer email addresses?
-- =====================================================

SELECT
    email,                            -- Customer email address
    COUNT(*) AS customer_count        -- Count customers using this email
FROM customers                        -- Check the customers table
WHERE email IS NOT NULL               -- Ignore missing email values
GROUP BY email                        -- Group identical email addresses
HAVING COUNT(*) > 1                   -- Show only duplicated emails
ORDER BY customer_count DESC;         -- Show most duplicated first

-- 🎯 Project 1 Complete
-- NovaMart — Data Exploration & Database Audit ✅
-- You’ve now covered:
-- Order status distribution
-- Sales-channel distribution
-- Orders by year/month
-- Customer order activity
-- Store activity
-- Regional activity
-- Payment methods
-- Product status
-- NULL-value checks
-- Duplicate IDs
-- Invalid customer references
-- Invalid product references
-- Invalid store references
-- Invalid order references
-- Invalid category references
-- Invalid supplier references
-- Invalid employee references
-- Duplicate customer emails








