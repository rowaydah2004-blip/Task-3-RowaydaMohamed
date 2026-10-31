-- =====================================================
-- DecodeLabs Data Analytics Internship
-- Project 3: E-Commerce SQL Data Analysis
-- Master SQL Analysis Script
-- Database: DecodeLabs_Project3_SQL_Analysis.db
-- =====================================================




-- =====================================================
-- SECTION 01: DATA VALIDATION
-- Query 01: Verify Total Order Records
-- Purpose: Confirm the number of imported records
-- =====================================================

SELECT
    COUNT(*) AS Total_Orders
FROM Orders;




-- =====================================================
-- Query 02: Check Duplicate Order IDs
-- Purpose: Verify that each order has a unique identifier
-- =====================================================

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT OrderID) AS Unique_Order_IDs,
    COUNT(*) - COUNT(DISTINCT OrderID) AS Duplicate_Count
FROM Orders;





-- =====================================================
-- Query 03: Check Missing Values
-- Purpose: Identify missing or blank values in key fields
-- =====================================================

SELECT
    COUNT(*) AS Total_Orders,

    SUM(CASE WHEN OrderID IS NULL OR TRIM(OrderID) = ''
        THEN 1 ELSE 0 END) AS Missing_OrderID,

    SUM(CASE WHEN Date IS NULL OR TRIM(Date) = ''
        THEN 1 ELSE 0 END) AS Missing_Date,

    SUM(CASE WHEN CustomerID IS NULL OR TRIM(CustomerID) = ''
        THEN 1 ELSE 0 END) AS Missing_CustomerID,

    SUM(CASE WHEN Product IS NULL OR TRIM(Product) = ''
        THEN 1 ELSE 0 END) AS Missing_Product,

    SUM(CASE WHEN Quantity IS NULL
        THEN 1 ELSE 0 END) AS Missing_Quantity,

    SUM(CASE WHEN UnitPrice IS NULL
        THEN 1 ELSE 0 END) AS Missing_UnitPrice,

    SUM(CASE WHEN TotalPrice IS NULL
        THEN 1 ELSE 0 END) AS Missing_TotalPrice,

    SUM(CASE WHEN PaymentMethod IS NULL
        OR TRIM(PaymentMethod) = ''
        THEN 1 ELSE 0 END) AS Missing_PaymentMethod,

    SUM(CASE WHEN OrderStatus IS NULL
        OR TRIM(OrderStatus) = ''
        THEN 1 ELSE 0 END) AS Missing_OrderStatus

FROM Orders;




-- =====================================================
-- Query 04: Validate Prices and Quantities
-- Purpose: Detect invalid numerical values and inspect ranges
-- =====================================================

SELECT
    COUNT(*) AS Total_Orders,

    SUM(CASE WHEN Quantity <= 0
        THEN 1 ELSE 0 END) AS Invalid_Quantity,

    SUM(CASE WHEN UnitPrice <= 0
        THEN 1 ELSE 0 END) AS Invalid_UnitPrice,

    SUM(CASE WHEN TotalPrice <= 0
        THEN 1 ELSE 0 END) AS Invalid_TotalPrice,

    MIN(Quantity) AS Minimum_Quantity,
    MAX(Quantity) AS Maximum_Quantity,

    MIN(UnitPrice) AS Minimum_UnitPrice,
    MAX(UnitPrice) AS Maximum_UnitPrice,

    MIN(TotalPrice) AS Minimum_TotalPrice,
    MAX(TotalPrice) AS Maximum_TotalPrice

FROM Orders;





-- =====================================================
-- Query 05: Verify Order Total Calculations
-- Purpose: Check stored totals against calculated values
-- =====================================================

SELECT
    COUNT(*) AS Total_Orders,

    SUM(
        CASE
            WHEN ABS(TotalPrice - (Quantity * UnitPrice)) > 0.01
            THEN 1 ELSE 0
        END
    ) AS Mismatched_Orders,

    ROUND(
        MAX(ABS(TotalPrice - (Quantity * UnitPrice))),
        2
    ) AS Maximum_Price_Difference

FROM Orders;





-- =====================================================
-- SECTION 02: BUSINESS PERFORMANCE ANALYSIS
-- Query 06: Sales Performance by Product
-- Purpose: Identify top-performing products by order value
-- =====================================================

SELECT
    Product,
    COUNT(*) AS Total_Orders,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(TotalPrice), 2) AS Total_Order_Value,
    ROUND(AVG(TotalPrice), 2) AS Average_Order_Value
FROM Orders
GROUP BY Product
ORDER BY Total_Order_Value DESC;





-- =====================================================
-- Query 07: Order Status Analysis
-- Purpose: Analyze order distribution and value by status
-- =====================================================

SELECT
    OrderStatus,
    COUNT(*) AS Total_Orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Orders),
        2
    ) AS Percentage_of_Orders,
    ROUND(SUM(TotalPrice), 2) AS Total_Order_Value
FROM Orders
GROUP BY OrderStatus
ORDER BY Total_Orders DESC;




-- =====================================================
-- Query 08: Payment Method Analysis
-- Purpose: Compare order frequency, total value, and
-- average order value across payment methods
-- =====================================================

SELECT
    PaymentMethod,
    COUNT(*) AS Total_Orders,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Orders),
        2
    ) AS Percentage_of_Orders,
    ROUND(SUM(TotalPrice), 2) AS Total_Order_Value,
    ROUND(AVG(TotalPrice), 2) AS Average_Order_Value
FROM Orders
GROUP BY PaymentMethod
ORDER BY Total_Orders DESC;




-- =====================================================
-- Query 09: Cancellation and Return Rates by Payment
-- Purpose: Identify payment methods associated with
-- higher cancellation and return rates
-- =====================================================

SELECT
    PaymentMethod,
    COUNT(*) AS Total_Orders,

    SUM(CASE
        WHEN OrderStatus = 'Cancelled'
        THEN 1 ELSE 0
    END) AS Cancelled_Orders,

    SUM(CASE
        WHEN OrderStatus = 'Returned'
        THEN 1 ELSE 0
    END) AS Returned_Orders,

    ROUND(
        100.0 * SUM(CASE
            WHEN OrderStatus IN ('Cancelled', 'Returned')
            THEN 1 ELSE 0
        END) / COUNT(*),
        2
    ) AS Cancellation_Return_Rate

FROM Orders
GROUP BY PaymentMethod
ORDER BY Cancellation_Return_Rate DESC;





-- =====================================================
-- SECTION 03: TIME-BASED ANALYSIS
-- Query 10: Monthly Order Value Trends
-- Purpose: Examine monthly order volume and value
-- =====================================================

SELECT
    strftime('%Y', Date) AS Order_Year,
    strftime('%m', Date) AS Order_Month,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(TotalPrice), 2) AS Total_Order_Value,
    ROUND(AVG(TotalPrice), 2) AS Average_Order_Value
FROM Orders
GROUP BY
    strftime('%Y', Date),
    strftime('%m', Date)
ORDER BY
    Order_Year,
    Order_Month;




-- =====================================================
-- Query 11: Month-over-Month Order Value Changes
-- Purpose: Compare monthly order values and calculate
-- absolute and percentage changes using LAG()
-- =====================================================

WITH Monthly_Sales AS (
    SELECT
        strftime('%Y-%m', Date) AS Order_Month,
        COUNT(*) AS Total_Orders,
        ROUND(SUM(TotalPrice), 2) AS Total_Order_Value
    FROM Orders
    GROUP BY strftime('%Y-%m', Date)
),
Monthly_Comparison AS (
    SELECT
        Order_Month,
        Total_Orders,
        Total_Order_Value,
        LAG(Total_Order_Value) OVER (
            ORDER BY Order_Month
        ) AS Previous_Month_Value
    FROM Monthly_Sales
)
SELECT
    Order_Month,
    Total_Orders,
    Total_Order_Value,
    Previous_Month_Value,

    ROUND(
        Total_Order_Value - Previous_Month_Value,
        2
    ) AS Monthly_Change,

    ROUND(
        (Total_Order_Value - Previous_Month_Value)
        * 100.0 / NULLIF(Previous_Month_Value, 0),
        2
    ) AS Monthly_Change_Percentage

FROM Monthly_Comparison
ORDER BY Order_Month;





-- =====================================================
-- Query 12: Ranking Monthly Performance
-- Purpose: Rank months by total recorded order value
-- using the RANK() window function
-- =====================================================

WITH Monthly_Performance AS (
    SELECT
        strftime('%Y-%m', Date) AS Order_Month,
        COUNT(*) AS Total_Orders,
        ROUND(SUM(TotalPrice), 2) AS Total_Order_Value
    FROM Orders
    GROUP BY strftime('%Y-%m', Date)
)
SELECT
    Order_Month,
    Total_Orders,
    Total_Order_Value,

    RANK() OVER (
        ORDER BY Total_Order_Value DESC
    ) AS Monthly_Rank

FROM Monthly_Performance
ORDER BY Monthly_Rank;




-- =====================================================
-- SECTION 04: MARKETING AND CUSTOMER ANALYSIS
-- Query 13: Referral Source Performance
-- Purpose: Compare order volume and recorded order
-- value across customer acquisition channels
-- =====================================================

SELECT
    ReferralSource,
    COUNT(*) AS Total_Orders,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Orders),
        2
    ) AS Percentage_of_Orders,

    ROUND(SUM(TotalPrice), 2) AS Total_Order_Value,

    ROUND(AVG(TotalPrice), 2) AS Average_Order_Value

FROM Orders
GROUP BY ReferralSource
ORDER BY Total_Orders DESC;




-- =====================================================
-- Query 14: Coupon Usage Analysis
-- Purpose: Compare coupon usage frequency and recorded
-- order values across coupon categories
-- =====================================================

SELECT
    COALESCE(NULLIF(TRIM(CouponCode), ''), 'No Coupon')
        AS Coupon_Category,

    COUNT(*) AS Total_Orders,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Orders),
        2
    ) AS Percentage_of_Orders,

    ROUND(SUM(TotalPrice), 2) AS Total_Order_Value,

    ROUND(AVG(TotalPrice), 2) AS Average_Order_Value

FROM Orders
GROUP BY COALESCE(NULLIF(TRIM(CouponCode), ''), 'No Coupon')
ORDER BY Total_Orders DESC;




-- =====================================================
-- Query 15: Customer Purchase Frequency
-- Purpose: Measure one-time and repeat customer behavior
-- =====================================================

WITH Customer_Orders AS (
    SELECT
        CustomerID,
        COUNT(*) AS Order_Count
    FROM Orders
    GROUP BY CustomerID
)
SELECT
    COUNT(*) AS Total_Customers,

    SUM(CASE
        WHEN Order_Count = 1 THEN 1 ELSE 0
    END) AS One_Time_Customers,

    SUM(CASE
        WHEN Order_Count > 1 THEN 1 ELSE 0
    END) AS Repeat_Customers,

    ROUND(
        100.0 * SUM(CASE
            WHEN Order_Count > 1 THEN 1 ELSE 0
        END) / COUNT(*),
        2
    ) AS Repeat_Customer_Rate

FROM Customer_Orders;





-- =====================================================
-- Query 16: Customer Spending Analysis
-- Purpose: Compare spending patterns between one-time
-- and repeat customers
-- =====================================================

WITH Customer_Spending AS (
    SELECT
        CustomerID,
        COUNT(*) AS Total_Orders,
        SUM(TotalPrice) AS Customer_Order_Value
    FROM Orders
    GROUP BY CustomerID
)
SELECT
    CASE
        WHEN Total_Orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS Customer_Type,

    COUNT(*) AS Total_Customers,

    SUM(Total_Orders) AS Total_Orders,

    ROUND(
        SUM(Customer_Order_Value), 2
    ) AS Total_Order_Value,

    ROUND(
        AVG(Customer_Order_Value), 2
    ) AS Average_Value_Per_Customer,

    ROUND(
        SUM(Customer_Order_Value) * 100.0 /
        (SELECT SUM(TotalPrice) FROM Orders),
        2
    ) AS Percentage_of_Total_Value

FROM Customer_Spending
GROUP BY Customer_Type
ORDER BY Total_Order_Value DESC;




-- =====================================================
-- Query 17: Customer Spending Segmentation
-- Purpose: Segment customers based on their total
-- recorded order value
-- =====================================================

WITH Customer_Spending AS (
    SELECT
        CustomerID,
        COUNT(*) AS Total_Orders,
        SUM(TotalPrice) AS Customer_Order_Value
    FROM Orders
    GROUP BY CustomerID
),
Customer_Segments AS (
    SELECT
        CustomerID,
        Total_Orders,
        Customer_Order_Value,

        CASE
            WHEN Customer_Order_Value >= 3000
                THEN 'Premium Spend'
            WHEN Customer_Order_Value >= 1500
                THEN 'High Spend'
            WHEN Customer_Order_Value >= 500
                THEN 'Medium Spend'
            ELSE 'Low Spend'
        END AS Spending_Segment

    FROM Customer_Spending
)
SELECT
    Spending_Segment,
    COUNT(*) AS Total_Customers,
    SUM(Total_Orders) AS Total_Orders,

    ROUND(
        SUM(Customer_Order_Value), 2
    ) AS Total_Order_Value,

    ROUND(
        AVG(Customer_Order_Value), 2
    ) AS Average_Value_Per_Customer,

    ROUND(
        SUM(Customer_Order_Value) * 100.0 /
        (SELECT SUM(TotalPrice) FROM Orders),
        2
    ) AS Percentage_of_Total_Value

FROM Customer_Segments
GROUP BY Spending_Segment
ORDER BY Total_Order_Value DESC;





-- =====================================================
-- SECTION 05: ORDER RISK ANALYSIS
-- Query 18: Cancellation and Return Rates by Product
-- Purpose: Identify products associated with higher
-- cancellation and return rates
-- =====================================================

SELECT
    Product,
    COUNT(*) AS Total_Orders,

    SUM(CASE
        WHEN OrderStatus = 'Cancelled'
        THEN 1 ELSE 0
    END) AS Cancelled_Orders,

    SUM(CASE
        WHEN OrderStatus = 'Returned'
        THEN 1 ELSE 0
    END) AS Returned_Orders,

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
    ) AS Cancellation_Return_Rate,

    ROUND(
        SUM(CASE
            WHEN OrderStatus IN ('Cancelled', 'Returned')
            THEN TotalPrice ELSE 0
        END),
        2
    ) AS Affected_Order_Value

FROM Orders
GROUP BY Product
ORDER BY Cancellation_Return_Rate DESC;




-- =====================================================
-- Query 19: Overall Order Risk Summary
-- Purpose: Quantify cancelled and returned orders
-- and their share of total recorded order value
-- =====================================================

SELECT
    COUNT(*) AS Total_Orders,

    ROUND(SUM(TotalPrice), 2) AS Total_Order_Value,

    SUM(CASE
        WHEN OrderStatus = 'Cancelled'
        THEN 1 ELSE 0
    END) AS Cancelled_Orders,

    SUM(CASE
        WHEN OrderStatus = 'Returned'
        THEN 1 ELSE 0
    END) AS Returned_Orders,

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

    ROUND(
        SUM(CASE
            WHEN OrderStatus IN ('Cancelled', 'Returned')
            THEN TotalPrice ELSE 0
        END),
        2
    ) AS Affected_Order_Value,

    ROUND(
        100.0 * SUM(CASE
            WHEN OrderStatus IN ('Cancelled', 'Returned')
            THEN TotalPrice ELSE 0
        END) / NULLIF(SUM(TotalPrice), 0),
        2
    ) AS Affected_Value_Percentage

FROM Orders;




-- =====================================================
-- Query 20: Highest-Value Cancelled and Returned Orders
-- Purpose: Identify high-value individual orders
-- associated with cancellations and returns
-- =====================================================

SELECT
    OrderID,
    Date AS Order_Date,
    CustomerID,
    Product,
    Quantity,
    PaymentMethod,
    OrderStatus,
    ROUND(TotalPrice, 2) AS Order_Value

FROM Orders

WHERE OrderStatus IN ('Cancelled', 'Returned')

ORDER BY TotalPrice DESC

LIMIT 10;





-- =====================================================
-- Query 21: Cancellation and Return Rates by Quantity
-- Purpose: Examine how cancellation and return rates
-- vary across different order quantities
-- =====================================================

SELECT
    Quantity,
    COUNT(*) AS Total_Orders,

    SUM(CASE
        WHEN OrderStatus = 'Cancelled'
        THEN 1 ELSE 0
    END) AS Cancelled_Orders,

    SUM(CASE
        WHEN OrderStatus = 'Returned'
        THEN 1 ELSE 0
    END) AS Returned_Orders,

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
    ) AS Cancellation_Return_Rate,

    ROUND(
        SUM(CASE
            WHEN OrderStatus IN ('Cancelled', 'Returned')
            THEN TotalPrice ELSE 0
        END),
        2
    ) AS Affected_Order_Value

FROM Orders
GROUP BY Quantity
ORDER BY Quantity ASC;





-- =====================================================
-- Query 22: Product and Payment Method Risk Analysis
-- Purpose: Identify product-payment combinations
-- associated with higher cancellation and return rates
-- =====================================================

SELECT
    Product,
    PaymentMethod,

    COUNT(*) AS Total_Orders,

    SUM(CASE
        WHEN OrderStatus = 'Cancelled'
        THEN 1 ELSE 0
    END) AS Cancelled_Orders,

    SUM(CASE
        WHEN OrderStatus = 'Returned'
        THEN 1 ELSE 0
    END) AS Returned_Orders,

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
    ) AS Cancellation_Return_Rate,

    ROUND(
        SUM(CASE
            WHEN OrderStatus IN ('Cancelled', 'Returned')
            THEN TotalPrice ELSE 0
        END),
        2
    ) AS Affected_Order_Value

FROM Orders

GROUP BY
    Product,
    PaymentMethod

ORDER BY
    Cancellation_Return_Rate DESC,
    Affected_Order_Value DESC;
