-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 1: PROMOTION OVERVIEW
-- Business Question:
-- What does NovaMart's overall promotion portfolio
-- look like?
-- =====================================================

SELECT
    COUNT(*) AS total_promotions,

    ROUND(
        AVG(discount_percent),
        2
    ) AS average_discount_percent,

    MIN(discount_percent) AS minimum_discount_percent,

    MAX(discount_percent) AS maximum_discount_percent,

    ROUND(
        AVG(
            DATEDIFF(end_date, start_date) + 1
        ),
        2
    ) AS average_promotion_duration_days

FROM promotions;


-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 2: PROMOTION DISCOUNT ANALYSIS
-- Business Question:
-- How are NovaMart's promotions distributed
-- across different discount levels?
-- =====================================================

SELECT
    discount_percent,
    COUNT(*) AS promotion_count
FROM promotions
GROUP BY
    discount_percent
ORDER BY
    discount_percent;


-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 3: PROMOTIONS BY YEAR
-- Business Question:
-- How many promotions did NovaMart run in each year?
-- =====================================================

SELECT
    YEAR(start_date) AS promotion_year,

    COUNT(*) AS promotion_count,

    ROUND(
        AVG(discount_percent),
        2
    ) AS average_discount_percent

FROM promotions

GROUP BY
    YEAR(start_date)

ORDER BY
    promotion_year;


-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 4: PROMOTION DURATION ANALYSIS
-- Business Question:
-- How long do NovaMart promotions typically run?
-- =====================================================

SELECT
    promotion_id,
    promotion_name,
    start_date,
    end_date,

    DATEDIFF(
        end_date,
        start_date
    ) + 1 AS duration_days,

    CASE
        WHEN DATEDIFF(end_date, start_date) + 1 <= 7
            THEN 'Short'

        WHEN DATEDIFF(end_date, start_date) + 1 <= 14
            THEN 'Medium'

        ELSE 'Long'
    END AS duration_category

FROM promotions

ORDER BY
    duration_days DESC;


-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 5: PROMOTION DURATION DISTRIBUTION
-- Business Question:
-- How many promotions fall into each duration category?
-- =====================================================

SELECT
    duration_category,
    COUNT(*) AS promotion_count,

    ROUND(
        COUNT(*) /
        (SELECT COUNT(*) FROM promotions) * 100,
        2
    ) AS percentage_of_promotions

FROM (
    SELECT
        CASE
            WHEN DATEDIFF(end_date, start_date) + 1 <= 7
                THEN 'Short'

            WHEN DATEDIFF(end_date, start_date) + 1 <= 14
                THEN 'Medium'

            ELSE 'Long'
        END AS duration_category

    FROM promotions
) AS promotion_duration

GROUP BY
    duration_category

ORDER BY
    CASE duration_category
        WHEN 'Short' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Long' THEN 3
    END;



-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 6: DISCOUNT LEVEL CLASSIFICATION
-- Business Question:
-- How aggressive is NovaMart's discount strategy?
-- =====================================================

SELECT
    discount_category,
    COUNT(*) AS promotion_count,

    ROUND(
        COUNT(*) /
        (SELECT COUNT(*) FROM promotions) * 100,
        2
    ) AS percentage_of_promotions

FROM (
    SELECT
        CASE
            WHEN discount_percent < 15
                THEN 'Low Discount'

            WHEN discount_percent <= 25
                THEN 'Medium Discount'

            ELSE 'High Discount'
        END AS discount_category

    FROM promotions
) AS promotion_discounts

GROUP BY
    discount_category

ORDER BY
    CASE discount_category
        WHEN 'Low Discount' THEN 1
        WHEN 'Medium Discount' THEN 2
        WHEN 'High Discount' THEN 3
    END;



-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 7: HIGHEST DISCOUNT PROMOTIONS
-- Business Question:
-- Which promotions offered the highest discounts?
-- =====================================================

SELECT
    promotion_id,
    promotion_name,
    start_date,
    end_date,
    discount_percent,

    DATEDIFF(
        end_date,
        start_date
    ) + 1 AS duration_days

FROM promotions

ORDER BY
    discount_percent DESC,
    duration_days DESC;



-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 8: LOWEST DISCOUNT PROMOTIONS
-- Business Question:
-- Which promotions used the smallest discounts,
-- and how long did they run?
-- =====================================================

SELECT
    promotion_id,
    promotion_name,
    start_date,
    end_date,
    discount_percent,

    DATEDIFF(
        end_date,
        start_date
    ) + 1 AS duration_days

FROM promotions

ORDER BY
    discount_percent ASC,
    duration_days DESC;


-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 9: DISCOUNT & DURATION RELATIONSHIP
-- Business Question:
-- How do discount intensity and promotion duration
-- combine across NovaMart campaigns?
-- =====================================================

SELECT
    discount_category,
    duration_category,
    COUNT(*) AS promotion_count

FROM (
    SELECT

        CASE
            WHEN discount_percent < 15
                THEN 'Low Discount'

            WHEN discount_percent <= 25
                THEN 'Medium Discount'

            ELSE 'High Discount'
        END AS discount_category,

        CASE
            WHEN DATEDIFF(end_date, start_date) + 1 <= 7
                THEN 'Short'

            WHEN DATEDIFF(end_date, start_date) + 1 <= 14
                THEN 'Medium'

            ELSE 'Long'
        END AS duration_category

    FROM promotions
) AS promotion_profile

GROUP BY
    discount_category,
    duration_category

ORDER BY
    CASE discount_category
        WHEN 'Low Discount' THEN 1
        WHEN 'Medium Discount' THEN 2
        WHEN 'High Discount' THEN 3
    END,
    CASE duration_category
        WHEN 'Short' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Long' THEN 3
    END;


-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 10: PROMOTION CALENDAR ANALYSIS
-- Business Question:
-- Which months contain the most promotion launches?
-- =====================================================

SELECT
    MONTH(start_date) AS promotion_month,

    MONTHNAME(start_date) AS month_name,

    COUNT(*) AS promotion_count,

    ROUND(
        AVG(discount_percent),
        2
    ) AS average_discount_percent

FROM promotions

GROUP BY
    MONTH(start_date),
    MONTHNAME(start_date)

ORDER BY
    promotion_count DESC;


-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 11: PROMOTION COVERAGE
-- Business Question:
-- How many promotion-days were scheduled in each year?
-- =====================================================

SELECT
    YEAR(start_date) AS promotion_year,

    COUNT(*) AS promotion_count,

    SUM(
        DATEDIFF(end_date, start_date) + 1
    ) AS total_promotion_days,

    ROUND(
        AVG(
            DATEDIFF(end_date, start_date) + 1
        ),
        2
    ) AS average_duration_days

FROM promotions

GROUP BY
    YEAR(start_date)

ORDER BY
    promotion_year;



-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 12: PROMOTION PORTFOLIO
-- Business Question:
-- What types of promotional campaigns does NovaMart
-- use most often?
-- =====================================================

SELECT
    discount_category,
    duration_category,
    COUNT(*) AS promotion_count,

    ROUND(
        COUNT(*) /
        (SELECT COUNT(*) FROM promotions) * 100,
        2
    ) AS percentage_of_promotions

FROM (
    SELECT

        CASE
            WHEN discount_percent < 15
                THEN 'Low Discount'

            WHEN discount_percent <= 25
                THEN 'Medium Discount'

            ELSE 'High Discount'
        END AS discount_category,

        CASE
            WHEN DATEDIFF(end_date, start_date) + 1 <= 7
                THEN 'Short'

            WHEN DATEDIFF(end_date, start_date) + 1 <= 14
                THEN 'Medium'

            ELSE 'Long'
        END AS duration_category

    FROM promotions
) AS promotion_portfolio

GROUP BY
    discount_category,
    duration_category

ORDER BY
    promotion_count DESC;


-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 13: DISCOUNT RISK ANALYSIS
-- Business Question:
-- Which promotions combine aggressive discounts
-- with long durations?
-- =====================================================

SELECT
    promotion_id,
    promotion_name,
    start_date,
    end_date,
    discount_percent,

    DATEDIFF(
        end_date,
        start_date
    ) + 1 AS duration_days,

    ROUND(
        discount_percent
        *
        (DATEDIFF(end_date, start_date) + 1),
        2
    ) AS discount_exposure_score

FROM promotions

ORDER BY
    discount_exposure_score DESC;


-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 14: PROMOTION STRATEGY CLASSIFICATION
-- Business Question:
-- Which promotions are aggressive, moderate,
-- or conservative based on discount and duration?
-- =====================================================

SELECT
    promotion_id,
    promotion_name,
    start_date,
    end_date,
    discount_percent,

    DATEDIFF(
        end_date,
        start_date
    ) + 1 AS duration_days,

    ROUND(
        discount_percent
        *
        (DATEDIFF(end_date, start_date) + 1),
        2
    ) AS discount_exposure_score,

    CASE
        WHEN discount_percent
             *
             (DATEDIFF(end_date, start_date) + 1) >= 600
            THEN 'Aggressive'

        WHEN discount_percent
             *
             (DATEDIFF(end_date, start_date) + 1) >= 300
            THEN 'Moderate'

        ELSE 'Conservative'
    END AS strategy_class

FROM promotions

ORDER BY
    discount_exposure_score DESC;



-- =====================================================
-- PROJECT 8: MARKETING & PROMOTION ANALYSIS
-- TASK 15: MARKETING & PROMOTION EXECUTIVE ANALYSIS
-- Business Question:
-- What does NovaMart's overall promotional strategy
-- look like when discount intensity and duration
-- are considered together?
-- =====================================================

SELECT
    strategy_class,

    COUNT(*) AS promotion_count,

    ROUND(
        COUNT(*)
        /
        (SELECT COUNT(*) FROM promotions)
        * 100,
        2
    ) AS percentage_of_promotions,

    ROUND(
        AVG(discount_percent),
        2
    ) AS average_discount_percent,

    ROUND(
        AVG(
            DATEDIFF(end_date, start_date) + 1
        ),
        2
    ) AS average_duration_days,

    ROUND(
        AVG(
            discount_percent
            *
            (DATEDIFF(end_date, start_date) + 1)
        ),
        2
    ) AS average_exposure_score

FROM (
    SELECT
        discount_percent,
        start_date,
        end_date,

        CASE
            WHEN discount_percent
                 *
                 (DATEDIFF(end_date, start_date) + 1) >= 600
                THEN 'Aggressive'

            WHEN discount_percent
                 *
                 (DATEDIFF(end_date, start_date) + 1) >= 300
                THEN 'Moderate'

            ELSE 'Conservative'
        END AS strategy_class

    FROM promotions
) AS promotion_strategy

GROUP BY
    strategy_class

ORDER BY
    CASE strategy_class
        WHEN 'Aggressive' THEN 1
        WHEN 'Moderate' THEN 2
        WHEN 'Conservative' THEN 3
    END;


































































































































































































































































































































































































































































































































































































































