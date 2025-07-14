## 📊 Superstore Sales Analytics (SQL Project)

This project uses **advanced SQL techniques** such as **Common Table Expressions (CTEs)** and **Window Functions** to analyze the [Superstore sales dataset](https://www.kaggle.com/datasets/rohitsahoo/sales-forecasting) — a fictional but realistic dataset of sales orders.

---

### 📁 Dataset Used

Single CSV with 9K+ rows including columns like:
`Order ID`, `Order Date`, `Ship Date`, `Ship Mode`, `Customer ID`, `Segment`, `City`, `Region`, `Product Name`, `Sales`, etc.

---

### 🧠 Key Business Questions Solved

1. **Which regions generate the most revenue?**
2. **Who are our top 10 high-value customers?**
3. **What is the monthly revenue growth trend?**
4. **Which shipping modes cause the most delay in each region?**
5. **What is the repeat customer ratio?**
6. **What are the top-performing products by category?**
7. **Which sub-categories are most frequently ordered?**
8. **How much revenue does each segment contribute?**
9. **Which orders are outliers (top 1% by value)?**
10. **What city-category combinations drive maximum revenue?**

---

### ⚙️ SQL Features Used

* ✅ **Common Table Expressions (CTEs)**
* ✅ **Window Functions (RANK, LAG)**
* ✅ **Aggregations (SUM, COUNT, AVG)**
* ✅ **Date formatting**
* ✅ **Subqueries & joins**

---

### 🧾 Sample Query: Monthly Growth Rate

```sql
WITH monthly_sales AS (
  SELECT DATE_FORMAT(Order_Date, '%Y-%m') AS month, SUM(Sales) AS total_sales
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
```

---

### 📌 How to Run

1. Load the dataset into MySQL using `LOAD DATA INFILE` or import via Workbench.
2. Use the SQL queries from `superstore_project.sql` (provided).
3. Adjust table name if needed (assumes `superstore` as table name in default schema).

---

### 📈 Insights Generated

* 📍 West region drives the highest revenue
* 👥 Top 10 customers contribute \~18% of revenue
* 📈 Revenue grew 20% MoM during peak months
* 🕒 Standard Class has longer delays in Southern region
* 🔁 54% customers placed more than one order

## 🤝 Let's Connect

👤 Yash Agarwal  
📧 ag.yash1920@gmail.com 
🔗 [LinkedIn](https://www.linkedin.com/in/yash-agarwal-305029256/)
