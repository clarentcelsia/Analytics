select * from customer_detail;

-- CHECK TOTAL REGISTERED CUSTOMER PER YEAR
SELECT EXTRACT(YEAR FROM REGISTERED_DATE),
    COUNT(ID)
FROM customer_detail
GROUP BY 1
/*
 extract | count
---------+-------
    2022 |  1731
    2021 |  2267
*/

-- CUSTOMER WITH HIGHEST NUMBER OF TRANSACTION 
WITH CUSTOMER_TRX AS (
    SELECT od.CUSTOMER_ID,
        COUNT(od.CUSTOMER_ID) OVER(PARTITION BY od.CUSTOMER_ID) AS NUM_TRX
    FROM order_detail od
    INNER JOIN sku_detail sk ON sk.ID = od.SKU_ID
    INNER JOIN customer_detail c ON c.ID = od.CUSTOMER_ID
    INNER JOIN payment_detail pd ON pd.ID = od.PAYMENT_ID
    WHERE od.IS_VALID = 1
) 
SELECT CUSTOMER_ID, NUM_TRX 
FROM CUSTOMER_TRX
GROUP BY 1,2
ORDER BY 2 DESC
LIMIT 5;

/*
customer_id | num_trx
-------------+---------
 C374672L    |      46
 C741634L    |      32
 C525405L    |      31
 C972737L    |      30
 C869172L    |      28
*/

--
  

