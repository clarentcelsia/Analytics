select * from payment_detail;

-- COD is the most favored payment method
WITH PAYMENT AS (
    SELECT DISTINCT(od.ID), EXTRACT(YEAR FROM od.ORDER_DATE) AS "YEAR", pd.PAYMENT_METHOD
    FROM order_detail od
    INNER JOIN payment_detail pd ON pd.ID = od.PAYMENT_ID
    WHERE od.IS_VALID = 1 AND EXTRACT(YEAR FROM od.ORDER_DATE) IN (2021, 2022)
    ORDER BY 2
)
SELECT pd.PAYMENT_METHOD, 
    COUNT(CASE WHEN pd."YEAR"=2021 THEN pd.PAYMENT_METHOD END) AS PAYMENT_2021,
    COUNT(CASE WHEN pd."YEAR"=2022 THEN pd.PAYMENT_METHOD END) AS PAYMENT_2022
FROM PAYMENT pd
GROUP BY 1
ORDER BY 2 DESC, 3 DESC

/**
  payment_method   | payment_2021 | payment_2022
-------------------+--------------+--------------
 cod               |         1574 |         1809
 Payaxis           |           73 |          181
 customercredit    |           37 |           75
 ublcreditcard     |           26 |            0
 internetbanking   |           14 |            0
 mcblite           |           13 |            0
 jazzwallet        |           10 |           26
 cashatdoorstep    |           10 |            6
 jazzvoucher       |            9 |            9
 productcredit     |            6 |            0
 mygateway         |            2 |            0
 financesettlement |            1 |            2
 marketingexpense  |            1 |            0
 Easypay           |            0 |           69
 easypay_voucher   |            0 |            2
**/

