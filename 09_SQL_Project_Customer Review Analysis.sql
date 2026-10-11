-- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 1: REVIEW OVERVIEW
-- Business Question:
-- What does NovaMart's overall customer-review
-- dataset look like?
-- =====================================================

SELECT
    COUNT(*) AS total_reviews,

    ROUND(
        AVG(rating),
        2
    ) AS average_rating,

    MIN(rating) AS minimum_rating,

    MAX(rating) AS maximum_rating,

    ROUND(
        AVG(CHAR_LENGTH(review_text)),
        2
    ) AS average_review_text_length

FROM reviews;


-- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 2: RATING DISTRIBUTION
-- Business Question:
-- How are customer ratings distributed from 1 to 5?
-- =====================================================

SELECT
    rating,

    COUNT(*) AS review_count,

    ROUND(
        COUNT(*)
        /
        (SELECT COUNT(*) FROM reviews)
        * 100,
        2
    ) AS percentage_of_reviews

FROM reviews

GROUP BY
    rating

ORDER BY
    rating;



-- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 3: AVERAGE RATING BY CATEGORY
-- Business Question:
-- Which product categories have the highest
-- and lowest average customer ratings?
-- =====================================================

SELECT
    c.category_name,

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
    c.category_name

ORDER BY
    average_rating DESC;


-- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 4: REVIEWS BY PRODUCT
-- Business Question:
-- Which products receive the most customer reviews?
-- =====================================================

SELECT
    p.product_id,
    p.product_name,

    COUNT(r.review_id) AS review_count

FROM reviews AS r

JOIN products AS p
    ON r.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY
    review_count DESC;


-- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 5: AVERAGE RATING BY PRODUCT
-- Business Question:
-- Which products have the highest and lowest
-- average customer ratings?
-- =====================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating), 2) AS average_rating

FROM reviews AS r

JOIN products AS p
    ON r.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY
    average_rating DESC;
    
    
    -- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 6: REVIEWS BY CATEGORY
-- Business Question:
-- Which product categories receive the most
-- customer reviews?
-- =====================================================

SELECT
    c.category_name,
    COUNT(r.review_id) AS review_count

FROM reviews AS r

JOIN products AS p
    ON r.product_id = p.product_id

JOIN categories AS c
    ON p.category_id = c.category_id

GROUP BY
    c.category_name

ORDER BY
    review_count DESC;
    
    
    -- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 7: AVERAGE RATING BY CATEGORY
-- Business Question:
-- Which product categories have the highest
-- and lowest average customer ratings?
-- =====================================================

SELECT
    c.category_name,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating), 2) AS average_rating

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
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 8: REVIEWS BY REGION
-- Business Question:
-- Which customer regions generate the most reviews?
-- =====================================================

SELECT
    c.region,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating), 2) AS average_rating

FROM reviews AS r

JOIN orders AS o
    ON r.order_id = o.order_id

JOIN customers AS c
    ON o.customer_id = c.customer_id

GROUP BY
    c.region

ORDER BY
    review_count DESC;
    
    
    
    -- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 9: RATING TREND OVER TIME
-- Business Question:
-- How has customer satisfaction changed over time?
-- =====================================================

SELECT
    YEAR(review_date) AS review_year,
    MONTH(review_date) AS review_month,
    COUNT(review_id) AS review_count,
    ROUND(AVG(rating), 2) AS average_rating

FROM reviews

GROUP BY
    YEAR(review_date),
    MONTH(review_date)

ORDER BY
    review_year,
    review_month;


-- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 10: LOW-RATED PRODUCTS
-- Business Question:
-- Which products have the lowest average customer ratings?
-- =====================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating), 2) AS average_rating

FROM reviews AS r

JOIN products AS p
    ON r.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name

HAVING
    COUNT(r.review_id) >= 5

ORDER BY
    average_rating ASC,
    review_count DESC;
    
    
    -- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 11: HIGH-RATED PRODUCTS
-- Business Question:
-- Which products have the highest average customer ratings?
-- =====================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating), 2) AS average_rating

FROM reviews AS r

JOIN products AS p
    ON r.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name

HAVING
    COUNT(r.review_id) >= 5

ORDER BY
    average_rating DESC,
    review_count DESC;
    
    
    -- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 12: REVIEW VOLUME VS RATING
-- Business Question:
-- Which products combine strong review volume
-- with strong customer ratings?
-- =====================================================

SELECT
    p.product_id,
    p.product_name,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating), 2) AS average_rating

FROM reviews AS r

JOIN products AS p
    ON r.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name

HAVING
    COUNT(r.review_id) >= 10

ORDER BY
    average_rating DESC,
    review_count DESC;
    
    
    
    -- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 13: PRODUCT REVIEW RISK CLASSIFICATION
-- Business Question:
-- Which products show potential customer-satisfaction risk?
-- =====================================================

SELECT
    product_id,
    product_name,
    review_count,
    average_rating,

    CASE
        WHEN average_rating < 2.5
            THEN 'High Risk'

        WHEN average_rating < 3.5
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS review_risk

FROM (
    SELECT
        p.product_id,
        p.product_name,
        COUNT(r.review_id) AS review_count,
        ROUND(AVG(r.rating), 2) AS average_rating

    FROM reviews AS r

    JOIN products AS p
        ON r.product_id = p.product_id

    GROUP BY
        p.product_id,
        p.product_name

    HAVING
        COUNT(r.review_id) >= 5
) AS product_reviews

ORDER BY
    CASE
        WHEN average_rating < 2.5 THEN 1
        WHEN average_rating < 3.5 THEN 2
        ELSE 3
    END,
    average_rating ASC;
    
    
    -- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 14: REVIEW PERFORMANCE CLASSIFICATION
-- Business Question:
-- How can products be classified based on
-- customer rating and review volume?
-- =====================================================

SELECT
    product_id,
    product_name,
    review_count,
    average_rating,

    CASE
        WHEN average_rating >= 4
             AND review_count >= 10
            THEN 'Excellent Performer'

        WHEN average_rating >= 3
             AND review_count >= 10
            THEN 'Stable Performer'

        WHEN average_rating < 3
             AND review_count >= 10
            THEN 'Needs Improvement'

        ELSE 'Limited Feedback'
    END AS performance_class

FROM (
    SELECT
        p.product_id,
        p.product_name,
        COUNT(r.review_id) AS review_count,
        ROUND(AVG(r.rating), 2) AS average_rating

    FROM reviews AS r

    JOIN products AS p
        ON r.product_id = p.product_id

    GROUP BY
        p.product_id,
        p.product_name
) AS product_review_metrics

ORDER BY
    CASE
        WHEN average_rating >= 4
             AND review_count >= 10
            THEN 1

        WHEN average_rating >= 3
             AND review_count >= 10
            THEN 2

        WHEN average_rating < 3
             AND review_count >= 10
            THEN 3

        ELSE 4
    END,
    average_rating DESC,
    review_count DESC;
    
    
    
    -- =====================================================
-- PROJECT 9: CUSTOMER REVIEW ANALYSIS
-- TASK 15: CUSTOMER REVIEW EXECUTIVE ANALYSIS
-- Business Question:
-- What does NovaMart's overall customer satisfaction
-- landscape look like across product categories?
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
    ) AS high_rating_percentage,

    CASE
        WHEN AVG(r.rating) >= 3.5
            THEN 'Strong Satisfaction'

        WHEN AVG(r.rating) >= 3
            THEN 'Moderate Satisfaction'

        ELSE 'Low Satisfaction'
    END AS satisfaction_class

FROM reviews AS r

JOIN products AS p
    ON r.product_id = p.product_id

JOIN categories AS c
    ON p.category_id = c.category_id

GROUP BY
    c.category_name

ORDER BY
    average_rating DESC,
    review_count DESC;





















































































































































































































































































































































































































































































































































































































