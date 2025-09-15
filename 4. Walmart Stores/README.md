## Project Title: Sales Performance Analysis of Walmart Stores Using Advanced MySQL Techniques
![walmart](https://github.com/user-attachments/assets/6e8669bb-220c-4eac-a9ba-18bfc9f41210)

**Introduction:**  
Walmart, a major retail chain, operates across several cities, offering a wide range of products. The dataset
provided contains detailed transaction data, including customer demographics, product lines, sales figures, and
payment methods. This project will use advanced SQL techniques to uncover actionable insights into sales
performance, customer behavior, and operational efficiencies.

**Business Problem:**  
Walmart wants to optimize its sales strategies by analyzing historical transaction data across branches,
customer types, payment methods, and product lines. To achieve this, advanced MySQL queries will be
employed to answer challenging business questions related to sales performance, customer segmentation, and
product trends.

**Dataset Link: [Walmartsales Dataset](https://docs.google.com/spreadsheets/d/1O-j6vD_uMm37pzYwvhVToTqZxw_01OTB0x2q0z00Yrc/edit?gid=1250133431#gid=1250133431)**

---
## Question and Solution
```sql
# Add a new date column in date format.
ALTER TABLE walmart
ADD COLUMN date_clean DATE;
SET SQL_SAFE_UPDATES = 0;
UPDATE walmart
SET date_clean = STR_TO_DATE(Date,'%d-%m-%Y');
```
**Task 1: Identifying the Top Branch by Sales Growth Rate**  
Walmart wants to identify which branch has exhibited the highest sales growth over time. Analyze the total sales
for each branch and compare the growth rate across months to find the top performer.
```sql
WITH monthly_sales AS(
SELECT
Branch,
DATE_FORMAT(date_clean,'%m-%Y') AS month_year,
ROUND(SUM(Total)) AS total_amount
FROM walmart
GROUP BY Branch, month_year
),
previous_sale AS(
SELECT *,
LAG(total_amount) OVER(PARTITION BY Branch ORDER BY month_year) AS `lag`
FROM monthly_sales
),
growth_value AS(
SELECT *,
ROUND(((total_amount - `lag`)/`lag`)*100) AS growth_rate 
FROM previous_sale
WHERE `lag` IS NOT NULL
)
SELECT * 
FROM growth_value
ORDER BY growth_rate DESC;
```
<img width="276" height="113" alt="1" src="https://github.com/user-attachments/assets/f8d0ee16-1fad-48ed-9bcc-3954db96fb4f" />

- Branch A is the top branch by sales growth.
- Growth Rate : current sales − previous sales / previous sales * 100
---
**Task 2: Finding the Most Profitable Product Line for Each Branch**  
Walmart needs to determine which product line contributes the highest profit to each branch.The profit margin
should be calculated based on the difference between the gross income and cost of goods sold.   
```sql
# gross income = Total – cogs
# So, profit = gross income (because it’s already Total – cogs).
# So we can directly use gross income.
WITH product_profit AS(
SELECT 
Branch,
`Product line` AS product_line,
ROUND(SUM(`gross income`)) AS total_profit
FROM walmart
GROUP BY Branch, product_line
),
rank_profit AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Branch ORDER BY total_profit DESC) AS `rank`
FROM product_profit
)
SELECT 
Branch,
product_line,
total_profit
FROM rank_profit
WHERE `rank` = 1
ORDER BY total_profit DESC;
```
<img width="188" height="65" alt="2" src="https://github.com/user-attachments/assets/b1a5cae9-4ac2-4462-b8c6-dae4605f9d75" />

---
**Task 3: Analyzing Customer Segmentation Based on Spending**  
Walmart wants to segment customers based on their average spending behavior. Classify customers into three
tiers: High, Medium, and Low spenders based on their total purchase amounts.
```sql
WITH average_spending AS(
SELECT 
`Customer ID` AS customer_id,
ROUND(AVG(Total)) AS avg_amount
FROM walmart
GROUP BY customer_id
),
tier_customer AS(
SELECT *,
CASE NTILE(3) OVER(ORDER BY avg_amount)
WHEN 1 THEN 'Low Spendors'
WHEN 2 THEN 'Medium Spendors'
ELSE 'High Spendors'
END AS spending_tier
FROM average_spending
)
SELECT * FROM tier_customer;
```
<img width="206" height="253" alt="3" src="https://github.com/user-attachments/assets/61cf391f-3191-4854-8a92-44ec6f8e91fc" />

---
**Task 4: Detecting Anomalies in Sales Transactions**  
Walmart suspects that some transactions have unusually high or low sales compared to the average for the
product line. Identify these anomalies.
```sql
WITH product_sorted AS(
SELECT 
`Product line` AS product_line,
Total,
ROW_NUMBER() OVER(PARTITION BY `Product line` ORDER BY Total) AS `row number`,
COUNT(*) OVER(PARTITION BY `Product line`) AS total_rows
FROM walmart
),
quartile AS(
SELECT
product_line,
MAX(CASE WHEN `row number` = FLOOR(0.25 * total_rows) THEN Total END) AS Q1,
MAX(CASE WHEN `row number` = FLOOR(0.75 * total_rows) THEN Total END) AS Q3
FROM product_sorted
GROUP BY product_line
),
anomalies AS(
SELECT 
w.`Product line`,
w.Total,
q.Q1,
q.Q3,
(q.Q3 - q.Q1) AS IQR,
CASE WHEN w.Total < (q.Q1 - 1.5 * (q.Q3 - q.Q1))
OR w.Total > (q.Q3 + 1.5 *(q.Q3 - q.Q1))
THEN 'Anomaly'
ELSE 'Normal'
END AS anomaly_status
FROM walmart w
JOIN quartile q ON w.`Product line` = q.product_line
)
SELECT 
`Product line`,
Total 
FROM anomalies
WHERE anomaly_status = 'Anomaly';
```
<img width="171" height="191" alt="4" src="https://github.com/user-attachments/assets/2afbfebf-37bc-4530-adb4-85c821efa128" />

---
**Task 5: Most Popular Payment Method by City**  
Walmart needs to determine the most popular payment method in each city to tailor marketing strategies.
```sql
WITH payment_counts AS(
SELECT 
City,
Payment,
COUNT(*) AS payment_count 
FROM walmart
GROUP BY City, Payment
),
ranked_payment AS(
SELECT 
City,
Payment,
payment_count,
ROW_NUMBER() OVER(PARTITION BY City ORDER BY payment_count DESC) AS `rank`
FROM payment_counts
)
SELECT 
City,
Payment,
payment_count
FROM ranked_payment
WHERE `rank` = 1
ORDER BY payment_count DESC;
```
<img width="367" height="126" alt="image" src="https://github.com/user-attachments/assets/6a2f0839-7fd8-47f5-91ca-3dc5974f2e16" />

---
**Task 6: Monthly Sales Distribution by Gender**  
Walmart wants to understand the sales distribution between male and female customers on a monthly basis.
```sql
SELECT
DATE_FORMAT(date_clean,'%m-%Y') AS month_year,
ROUND(SUM(CASE WHEN Gender = 'Male' THEN Total END)) AS male_sales,
ROUND(SUM(CASE WHEN Gender = 'Female' THEN Total End)) AS female_sales
FROM walmart
GROUP BY month_year
ORDER BY month_year;
```
<img width="253" height="88" alt="6" src="https://github.com/user-attachments/assets/af3f1d9e-053c-4dab-adc6-d0cd6449cf7e" />

---
**Task 7: Best Product Line by Customer Type**
Walmart wants to know which product lines are preferred by different customer types(Member vs. Normal).
```sql
WITH product_sale AS(
SELECT
`Product line` AS product_line,
`Customer type` AS customer_type,
ROUND(SUM(Total)) AS total_amount
FROM walmart
GROUP BY product_line, customer_type
),
rnk AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY customer_type ORDER BY total_amount DESC) AS `rank`
FROM product_sale
)
SELECT 
product_line,
customer_type,
total_amount
FROM rnk
WHERE `rank` = 1;
```
<img width="251" height="68" alt="7" src="https://github.com/user-attachments/assets/f4fed1cf-ae68-4cd2-b442-bf5792420ac0" />

---
**Task 8: Identifying Repeat Customers**    
Walmart needs to identify customers who made repeat purchases within a specific time frame (e.g., within 30 days).
```sql
WITH customer_orders AS(
SELECT
`Customer ID` AS customer_id,
date_clean as order_date,
LAG(date_clean) OVER(PARTITION BY `Customer ID` ORDER BY date_clean) AS prev_date
FROM walmart
)
SELECT 
customer_id,
COUNT(*) AS repeat_purchase
FROM customer_orders
WHERE prev_date IS NOT NULL
AND DATEDIFF(order_date,prev_date) <=30
GROUP BY customer_id
ORDER BY repeat_purchase DESC;
```
<img width="152" height="269" alt="8" src="https://github.com/user-attachments/assets/8fbc4e49-0fa3-4389-9fc1-4316e8bc107d" />

---
**Task 9: Finding Top 5 Customers by Sales Volume**  
Walmart wants to reward its top 5 customers who have generated the most sales Revenue.
```sql
SELECT 
    `Customer ID`, ROUND(SUM(Total), 2) AS total_amount
FROM
    walmart
GROUP BY `Customer ID`
ORDER BY total_amount DESC
LIMIT 5;
```
<img width="140" height="107" alt="9" src="https://github.com/user-attachments/assets/dad42fa6-5b35-4289-bbc6-25ca9f78a340" />

---
**Task 10: Analyzing Sales Trends by Day of the Week**  
Walmart wants to analyze the sales patterns to determine which day of the week brings the highest sales.
```sql
SELECT 
    DAYNAME(date_clean) AS `dayname`,
    ROUND(SUM(Total), 2) AS total_amount
FROM
    walmart
GROUP BY `dayname`
ORDER BY total_amount DESC;
```
<img width="575" height="159" alt="11" src="https://github.com/user-attachments/assets/b7da5c66-12b6-471e-a84b-00f1e4eb52c1" />

---
