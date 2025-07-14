-- 📁 Superstore Sales Analytics Project (SQL-Based, Advanced with CTEs & Window Functions)
-- ✅ Schema: 'superstore'

--STEP 1: Total Sales by Region Using CTE
WITH region_sales AS (
    SELECT Region, SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY Region
)
SELECT Region, total_sales,
       RANK() OVER (ORDER BY total_sales DESC) AS region_rank
FROM region_sales;

--STEP 2: Top Customers by Revenue Contribution (Window Function)
SELECT Customer_ID, Customer_Name,
       ROUND(SUM(Sales), 2) AS total_sales,
       RANK() OVER (ORDER BY SUM(Sales) DESC) AS revenue_rank
FROM superstore
GROUP BY Customer_ID, Customer_Name
ORDER BY revenue_rank
LIMIT 10;

--STEP 3: Monthly Sales Trend and Growth Rate (CTE + LAG)
WITH monthly_sales AS (
    SELECT DATE_FORMAT(Order_Date, '%Y-%m') AS month,
           SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY month
),
sales_growth AS (
    SELECT month, total_sales,
           LAG(total_sales) OVER (ORDER BY month) AS prev_month_sales
    FROM monthly_sales
)
SELECT month, total_sales,
       ROUND(((total_sales - prev_month_sales) / prev_month_sales) * 100, 2) AS growth_percentage
FROM sales_growth
WHERE prev_month_sales IS NOT NULL;

--STEP 4: Average Delay by Shipping Mode and Region (CTE + AVG)
WITH shipping_delay AS (
    SELECT Region, Ship_Mode,
           DATEDIFF(Ship_Date, Order_Date) AS delay_days
    FROM superstore
)
SELECT Region, Ship_Mode,
       ROUND(AVG(delay_days), 2) AS avg_shipping_delay
FROM shipping_delay
GROUP BY Region, Ship_Mode
ORDER BY avg_shipping_delay DESC;

--STEP 5: Repeat Customer Ratio (CTE + Window Function)
WITH customer_orders AS (
    SELECT Customer_ID, COUNT(DISTINCT Order_ID) AS order_count
    FROM superstore
    GROUP BY Customer_ID
),
repeaters AS (
    SELECT COUNT(*) AS repeat_customers
    FROM customer_orders
    WHERE order_count > 1
),
total AS (
    SELECT COUNT(*) AS total_customers FROM customer_orders
)
SELECT repeat_customers, total_customers,
       ROUND(100.0 * repeat_customers / total_customers, 2) AS repeat_ratio
FROM repeaters, total;

--STEP 6: Product Performance (Window Function)
SELECT Product_Name, Category, Sub_Category,
       SUM(Sales) AS total_sales,
       RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS category_rank
FROM superstore
GROUP BY Product_Name, Category, Sub_Category
ORDER BY category_rank;

--STEP 7: Most Frequently Ordered Sub-Categories (CTE)
WITH subcat_orders AS (
    SELECT Sub_Category, COUNT(*) AS frequency
    FROM superstore
    GROUP BY Sub_Category
)
SELECT *
FROM subcat_orders
ORDER BY frequency DESC
LIMIT 10;

--STEP 8: Revenue Contribution by Segment (CTE + Percentage)
WITH segment_sales AS (
    SELECT Segment, SUM(Sales) AS seg_sales
    FROM superstore
    GROUP BY Segment
),
total_sales AS (
    SELECT SUM(Sales) AS total FROM superstore
)
SELECT s.Segment, s.seg_sales,
       ROUND(100.0 * s.seg_sales / t.total, 2) AS contribution_percentage
FROM segment_sales s, total_sales t
ORDER BY contribution_percentage DESC;

--STEP 9: Detecting Outlier Orders (Top 1% by Sales)
SELECT *
FROM superstore
WHERE Sales > (
    SELECT PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY Sales)
);

--STEP 10: Best City-Category Combinations
SELECT City, Category,
       SUM(Sales) AS total_sales,
       RANK() OVER (PARTITION BY City ORDER BY SUM(Sales) DESC) AS category_rank
FROM superstore
GROUP BY City, Category
ORDER BY City, category_rank;

-- ✅ END OF THE PROJECT
