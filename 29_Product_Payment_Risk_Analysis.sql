
SELECT
    Product,
    PaymentMethod,
    COUNT(*) AS Total_Orders,

    SUM(CASE
        WHEN OrderStatus IN ('Cancelled', 'Returned')
        THEN 1 ELSE 0
    END) AS Affected_Orders,

    ROUND(
        100.0 * SUM(CASE
            WHEN OrderStatus IN ('Cancelled', 'Returned')
            THEN 1 ELSE 0
        END) / COUNT(*),
        2
    ) AS Affected_Order_Rate,

    ROUND(SUM(CASE
        WHEN OrderStatus IN ('Cancelled', 'Returned')
        THEN TotalPrice ELSE 0
    END), 2) AS Affected_Order_Value

FROM Orders
GROUP BY Product, PaymentMethod
HAVING COUNT(*) >= 10
ORDER BY Affected_Order_Rate DESC,
         Affected_Order_Value DESC;

