select * from sku_detail;

-- TOP SELLING CATEGORY
-- 2021: Soghaat is the top-selling product category with 119x trxs, whereas Mobile & Tablet is the least-selling prod cat with 24x trxs.
-- 2022: Superstore is the top-selling prod cat with 135x trxs, whereas Mobile & Tablet is the least-selling prod cat with 27x trxs.
SELECT EXTRACT(YEAR FROM od.ORDER_DATE), sk.CATEGORY, COUNT(sk.CATEGORY)
FROM order_detail od
INNER JOIN sku_detail sk ON sk.ID = od.SKU_ID
WHERE od.IS_NET=1 AND od.IS_VALID=1 
    AND (EXTRACT(YEAR FROM od.ORDER_DATE)=2021 OR EXTRACT(YEAR FROM od.ORDER_DATE)=2022)
GROUP BY EXTRACT(YEAR FROM od.ORDER_DATE), sk.CATEGORY
ORDER BY EXTRACT(YEAR FROM od.ORDER_DATE), COUNT(sk.CATEGORY) DESC;

-- THE MOST SELLING CATEGORY
-- 2021: 686 items with Soghaat category has been sold, 33 items for Entertainment category.
-- 2022: 1093 items with Mobile & Tablets category has been sold, 52 items for Appliances.
-- next. customer_detail
SELECT EXTRACT(YEAR FROM od.ORDER_DATE), sk.CATEGORY, SUM(od.QTY)
FROM order_detail od
INNER JOIN sku_detail sk ON sk.ID = od.SKU_ID
WHERE od.IS_NET=1 AND od.IS_VALID=1 
    AND (EXTRACT(YEAR FROM od.ORDER_DATE)=2021 OR EXTRACT(YEAR FROM od.ORDER_DATE)=2022)
GROUP BY EXTRACT(YEAR FROM od.ORDER_DATE), sk.CATEGORY
ORDER BY EXTRACT(YEAR FROM od.ORDER_DATE), SUM(od.QTY) DESC;

-- COMPARE THE TRANSACTION MADE BY CATEGORIES BETWEEN YEAR 21 AND YEAR 22
SELECT 
    sk.CATEGORY,
    SUM(CASE WHEN EXTRACT(YEAR FROM od.ORDER_DATE)=2021 THEN od.DISCOUNT_AFTER END) AS "2021",
    SUM(CASE WHEN EXTRACT(YEAR FROM od.ORDER_DATE)=2022 THEN od.DISCOUNT_AFTER END) AS "2022"
FROM order_detail od
INNER JOIN sku_detail sk ON sk.ID = od.SKU_ID
WHERE od.IS_NET=1 AND od.IS_VALID=1
    AND (EXTRACT(YEAR FROM od.ORDER_DATE)=2021 OR EXTRACT(YEAR FROM od.ORDER_DATE)=2022)
GROUP BY sk.CATEGORY
ORDER BY SUM(od.DISCOUNT_AFTER) DESC;

/**
 category      |        2021        |       2022
--------------------+--------------------+-------------------
 Mobiles & Tablets  |          106859026 |         667686372
 Entertainment      |         57068537.4 |         140705100
 Appliances         |        110569958.8 |          60116188
 Computing          |           40631262 |          50134968
 Women Fashion      |           31704076 |          47779820
 Beauty & Grooming  |           29738050 |          33477832
 Home & Living      |           28429715 |        26403966.4
 Men Fashion        |           24234894 |        28898804.5
 Health & Sports    |         24295167.6 |        28811047.6
 Superstore         |           17072416 |       22564902.32
 Others             | 21126617.740000002 |       12027245.98
 Soghaat            |         12865542.6 |          12638577
 Kids & Baby        |         11020669.9 |          12595396
 School & Education |  9615129.799999999 | 5165586.720000001
 Books              |            6919400 |         4521607.5
**/

-- https://www.postgresql.org/docs/current/tablefunc.html
CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT CATEGORY,
    COALESCE("2021", 0) AS "2021",
    COALESCE("2022", 0) AS "2022"
FROM crosstab('
    select 
        sk.CATEGORY, --piv point
        EXTRACT(YEAR FROM od.ORDER_DATE),
        SUM(od.DISCOUNT_AFTER)
    from order_detail od
    inner join sku_detail sk on sk.ID = od.SKU_ID
    where od.IS_NET=1 and od.IS_VALID=1 
        and (EXTRACT(YEAR FROM od.ORDER_DATE)=2021 or EXTRACT(YEAR FROM ORDER_DATE)=2022)
    group by sk.CATEGORY, EXTRACT(YEAR FROM od.ORDER_DATE)',  
    
    -- cross category by its year   
    'select distinct EXTRACT(YEAR FROM ORDER_DATE) 
    from order_detail 
    where EXTRACT(YEAR FROM ORDER_DATE) IN (2021, 2022)'
) AS PIVOT(
    CATEGORY VARCHAR,
    "2021" FLOAT,
    "2022" FLOAT
)
ORDER BY "2021" DESC;

-- TOP 5 SELLING CATEGORY WITH THE HIGHEST GROSS MARGIN
-- SUPERSTORE, MOBILE & TABLETS, APPLIANCES, ENTERTAINMENT, WOMEN FASHION exhibit substantial revenue growth, surpassing 35% above.
WITH GROSS_TABLE AS(
    SELECT 
        sk.CATEGORY, 
        SUM(CASE WHEN EXTRACT(YEAR FROM ORDER_DATE)=2021 THEN od.DISCOUNT_AFTER END) AS "GROSS REVENUE 2021",
        SUM(CASE WHEN EXTRACT(YEAR FROM ORDER_DATE)=2021 THEN sk.COGS END) AS "TOTAL COGS 2021",
        SUM(CASE WHEN EXTRACT(YEAR FROM ORDER_DATE)=2022 THEN od.DISCOUNT_AFTER END) AS "GROSS REVENUE 2022",
        SUM(CASE WHEN EXTRACT(YEAR FROM ORDER_DATE)=2022 THEN sk.COGS END) AS "TOTAL COGS 2022"
    FROM order_detail od
    INNER JOIN sku_detail sk ON sk.ID = od.SKU_ID
    WHERE od.IS_NET=1 AND od.IS_VALID=1 
        AND EXTRACT(YEAR FROM od.ORDER_DATE) IN (2021, 2022)
    GROUP BY 1
), GROSS_MARGIN_TABLE AS (
    SELECT T.CATEGORY, 
        ROUND(CAST(100*(T."GROSS REVENUE 2021"- T."TOTAL COGS 2021")/T."GROSS REVENUE 2021" AS NUMERIC), 2) AS "GROSS_MARGIN_2021(%)",
        ROUND(CAST(100*(T."GROSS REVENUE 2022"- T."TOTAL COGS 2022")/T."GROSS REVENUE 2022" AS NUMERIC), 2) AS "GROSS_MARGIN_2022(%)"
    FROM GROSS_TABLE T
)
SELECT T.CATEGORY, T."GROSS_MARGIN_2021(%)", T."GROSS_MARGIN_2022(%)", 
    ROUND(CAST(100*(T."GROSS_MARGIN_2022(%)" - T."GROSS_MARGIN_2021(%)")/T."GROSS_MARGIN_2021(%)" AS NUMERIC),2) AS "GROSS_REVENUE_MARGIN_GROWTH_RATE (%)"
FROM GROSS_MARGIN_TABLE T
ORDER BY 4 DESC
LIMIT 5;

/**
   category      | GROSS_MARGIN_2021(%) | GROSS_MARGIN_2022(%) | GROSS_REVENUE_MARGIN_GROWTH_RATE (%)
-------------------+----------------------+----------------------+--------------------------------------
 Superstore        |                29.23 |                69.18 |                               136.67
 Mobiles & Tablets |                40.01 |                88.65 |                               121.57
 Appliances        |                23.99 |                37.76 |                                57.40
 Entertainment     |                37.33 |                53.29 |                                42.75
 Women Fashion     |                34.86 |                47.15 |                                35.26
**/


-- https://www.postgresql.org/docs/current/functions-matching.html#FUNCTIONS-POSIX-REGEXP
SELECT 
    (CASE WHEN sk.SKU_NAME ~* 'SAMSUNG' THEN 'SAMSUNG'
        WHEN sk.SKU_NAME ~* 'IPHONE' THEN 'IPHONE'
        WHEN sk.SKU_NAME ~* 'HUAWEI' THEN 'HUAWEI'
        WHEN sk.SKU_NAME ~* 'LENOVO' THEN 'LENOVO'
        WHEN sk.SKU_NAME ~* 'SONY' THEN 'SONY'
        ELSE sk.SKU_NAME
        END
    ) AS "SKU_NAME",
    SUM(CASE WHEN EXTRACT(YEAR FROM od.ORDER_DATE)=2021 THEN od.DISCOUNT_AFTER END) AS "2021",
    SUM(CASE WHEN EXTRACT(YEAR FROM od.ORDER_DATE)=2022 THEN od.DISCOUNT_AFTER END) AS "2022"
FROM order_detail od
INNER JOIN sku_detail sk ON sk.ID = od.SKU_ID
WHERE 
    od.IS_VALID=1 AND EXTRACT(YEAR FROM od.ORDER_DATE) IN (2021, 2022)
    AND (sk.SKU_NAME ILIKE '%SAMSUNG%' 
        or sk.SKU_NAME ILIKE '%IPHONE%' 
        or sk.SKU_NAME ILIKE '%HUAWEI%' 
        or sk.SKU_NAME ILIKE '%SONY%' 
        or sk.SKU_NAME ILIKE '%LENOVO%' 
    )
GROUP BY (
    (CASE WHEN sk.SKU_NAME ~* 'SAMSUNG' THEN 'SAMSUNG'
        WHEN sk.SKU_NAME ~* 'IPHONE' THEN 'IPHONE'
        WHEN sk.SKU_NAME ~* 'HUAWEI' THEN 'HUAWEI'
        WHEN sk.SKU_NAME ~* 'LENOVO' THEN 'LENOVO'
        WHEN sk.SKU_NAME ~* 'SONY' THEN 'SONY'
        ELSE sk.SKU_NAME
        END
    ))
ORDER BY 2 DESC, 3 DESC;

/**
 SKU_NAME |   2021    |    2022
----------+-----------+------------
 IPHONE   | 208306826 |  145488592
 SAMSUNG  | 176406304 |  412357844
 LENOVO   |  38758210 | 23621590.4
 HUAWEI   |  32217434 |   30942826
 SONY     |  31617540 |   32343178
 **/