/* Task 1: Identifying the Top Branch by Sales Growth Rate 
Walmart wants to identify which branch has exhibited the highest sales 
growth over time. Analyze the total sales for each branch and compare 
the growth rate across months to find the top performer.*/

with monthly_sales AS(
select
Branch,
DATE_FORMAT(STR_TO_DATE(Date,'%d-%m-%Y'), '%m-%Y') AS month_year,
ROUND(SUM(Total)) AS total_amount
FROM walmartsales
GROUP BY Branch, month_year
),
previous_sale AS(
SELECT *,
LAG(total_amount) OVER(PARTITION BY Branch ORDER BY month_year) AS previous_value
FROM monthly_sales
),
growth_value AS(
SELECT *,
((total_amount - previous_value)/ previous_value) * 100 AS growth_rate
FROM previous_sale
WHERE previous_value IS NOT NULL
)
SELECT
Branch,
month_year,
total_amount,
growth_rate
FROM growth_value
ORDER BY growth_rate DESC
LIMIT 1;

/* Task 2: Finding the Most Profitable Product Line for Each Branch 
Walmart needs to determine which product line contributes the highest profit to each branch.
The profit margin should be calculated based on the difference between the gross income
 and cost of goods sold.*/
 
 WITH highest_profit AS(
 SELECT
 Branch,
 `Product line` AS product_line,
 ROUND(SUM(`gross income`)) AS profit_margin
 FROM walmartsales
 GROUP BY Branch, product_line
 ),
 ranked_profit AS(
 SELECT *,
 ROW_NUMBER() OVER(PARTITION BY Branch ORDER BY profit_margin DESC) AS rnk
 FROM highest_profit
 )
 SELECT * 
 FROM ranked_profit
 WHERE rnk = 1
 ORDER BY profit_margin DESC;
 
 /* Task 3: Analyzing Customer Segmentation Based on Spending.
Walmart wants to segment customers based on their average spending behavior. 
Classify customers into three tiers: High, Medium, and Low spenders based on 
their total purchase amounts.*/

WITH customer_average_spending AS (
SELECT 
`Customer ID` AS customer_id,
ROUND(AVG(Total)) AS average_amount
FROM walmartsales
GROUP BY customer_id
),
tier_customer AS(
SELECT *,
CASE NTILE(3) OVER(ORDER BY average_amount)
WHEN 1 THEN 'Low Spendors'
WHEN 2 THEN 'Medium Spendors'
ELSE 'High Spendors'
END AS  spending_category
FROM customer_average_spending
)
SELECT * FROM  tier_customer;

/* Task 4: Detecting Anomalies in Sales Transactions.
Walmart suspects that some transactions have unusually high or low sales 
compared to the average for the product line. Identify these anomalies.*/

# To identify outliers using the Interquartile Range (IQR)

WITH product_sorted AS(
SELECT
`Product line` AS product_line,
Total,
ROW_NUMBER() OVER(PARTITION BY `Product line` ORDER BY Total) AS row_num,
COUNT(*) OVER(PARTITION BY `Product line`) AS total_rows
FROM walmartsales
),
quartile AS(
SELECT
product_line,
MAX(CASE WHEN row_num = FLOOR(0.25 * total_rows) THEN Total END) AS Q1,
MAX(CASE WHEN row_num = FLOOR(0.75 * total_rows) THEN Total END) AS Q3
FROM product_sorted
GROUP BY product_line
),
anomalies AS (
SELECT
w.Branch,
w.`Product line`,
w.Total,
q.Q1,
q.Q3,
(q.Q3 - q.Q1) AS IQR,
CASE WHEN w.Total < (q.Q1 - 1.5*(q.Q3 - q.Q1))
OR Total > (Q3 + 1.5* (q.Q3 - q.Q1)) 
THEN 'Anomaly'
ELSE 'Normal' 
END AS anomaly_status
FROM walmartsales w
JOIN quartile q on w.`Product line` = q.product_line
)
SELECT * 
FROM anomalies
WHERE anomaly_status = 'Anomaly';

/* Task 5: Most Popular Payment Method by City 
Walmart needs to determine the most popular payment method in each 
city to tailor marketing strategies.*/

WITH payment_counts AS(
SELECT 
City,
Payment,
COUNT(*) AS payment_count,
ROW_NUMBER() OVER(PARTITION BY City ORDER BY COUNT(*) DESC) AS rnk
FROM walmartsales
GROUP BY City,Payment
)
SELECT * 
FROM payment_counts
WHERE rnk = 1;

/* Task 6: Monthly Sales Distribution by Gender
Walmart wants to understand the sales distribution between male and 
female customers on a monthly basis.*/

SELECT 
    Gender,
    DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%m-%Y') AS sales_month,
    ROUND(SUM(Total)) AS total_amount
FROM
    walmartsales
GROUP BY Gender , sales_month
ORDER BY sales_month , total_amount;

/* Task7: Best Product Line by Customer Type
Walmart wants to know which product lines are preferred by different 
customer types(Member vs. Normal).*/

WITH product_sale AS(
SELECT 
`Customer type` AS customer_type,
`Product line` AS product_line,
ROUND(SUM(Total)) AS total_sales
FROM walmartsales
GROUP BY customer_type, product_line
),
ranked AS(
SELECT *,
RANK() OVER(PARTITION BY customer_type ORDER BY total_sales DESC) AS rnk
FROM product_sale
)
SELECT * 
FROM ranked
WHERE rnk = 1;

/* Task 8: Identifying Repeat Customers 
Walmart needs to identify customers who made repeat purchases within a 
specific time frame (e.g., within 30 days).*/

WITH customer_purchase AS(
SELECT
`Customer ID` AS customer_id,
STR_TO_DATE(Date,'%d-%m-%Y') AS purchase_date,
LEAD(STR_TO_DATE(Date,'%d-%m-%Y')) OVER(PARTITION BY `Customer ID` ORDER BY STR_TO_DATE(Date,'%d-%m-%Y')) AS next_purchase_date
FROM walmartsales
)
SELECT 
customer_id,
COUNT(*) AS repeat_purchase
FROM customer_purchase
WHERE next_purchase_date IS NOT NULL
AND DATEDIFF(next_purchase_date, purchase_date) <= 30
GROUP BY customer_id
ORDER BY repeat_purchase DESC;

/* Task 9: Finding Top 5 Customers by Sales Volume 
Walmart wants to reward its top 5 customers who have generated the most sales Revenue.*/

SELECT 
    `Customer ID`, ROUND(SUM(Total)) AS amount
FROM
    walmartsales
GROUP BY `Customer Id`
ORDER BY amount DESC
LIMIT 5;

/* Task 10: Analyzing Sales Trends by Day of the Week
Walmart wants to analyze the sales patterns to determine which day of the week
brings the highest sales.*/

SELECT 
    DAYNAME(STR_TO_DATE(Date, '%d-%m-%Y')) AS Day,
    ROUND(SUM(Total)) AS amount
FROM
    walmartsales
GROUP BY Day
ORDER BY amount DESC;

