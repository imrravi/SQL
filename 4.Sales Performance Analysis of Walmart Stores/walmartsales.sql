 # Add a new date column in date format.
ALTER TABLE walmart
ADD COLUMN date_clean DATE;
SET SQL_SAFE_UPDATES = 0;
UPDATE walmart
SET date_clean = STR_TO_DATE(Date,'%d-%m-%Y');

/* Task 1: Identifying the Top Branch by Sales Growth Rate 
Walmart wants to identify which branch has exhibited the highest sales 
growth over time. Analyze the total sales for each branch and compare 
the growth rate across months to find the top performer.*/

WITH monthly_sales AS (
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
ROUND(((total_amount - `lag`)/ `lag`) * 100,2) AS growth_rate
FROM previous_sale
WHERE `lag` IS NOT NULL
)
SELECT * 
FROM growth_value
ORDER BY growth_rate DESC
LIMIT 1;

/* Task 2: Finding the Most Profitable Product Line for Each Branch 
Walmart needs to determine which product line contributes the highest profit to each branch.
The profit margin should be calculated based on the difference between the gross income
 and cost of goods sold.*/
 
 # gross income = profit (already given).
 WITH product_profit AS(
 SELECT
 Branch,
 `Product line` AS product_line,
 ROUND(SUM(`gross income`),2) AS profit
 FROM walmart
 GROUP BY Branch, product_line
 ),
 rank_profit AS(
 SELECT *,
 RANK() OVER(PARTITION BY Branch ORDER BY profit DESC) as 'rank'
 FROM product_profit
 )
 SELECT 
 Branch,
 product_line,
 profit
 FROM rank_profit
 WHERE `rank` = 1
 ORDER BY profit DESC;
 
 /* Task 3: Analyzing Customer Segmentation Based on Spending.
Walmart wants to segment customers based on their average spending behavior. 
Classify customers into three tiers: High, Medium, and Low spenders based on 
their total purchase amounts.*/

WITH average_spending AS (
SELECT 
`Customer ID` AS customer_id,
ROUND(AVG(Total),2) AS avg_amount 
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

/* Task 4: Detecting Anomalies in Sales Transactions.
Walmart suspects that some transactions have unusually high or low sales 
compared to the average for the product line. Identify these anomalies.*/

# To identify outliers using the Interquartile Range (IQR)

WITH product_sorted AS(
SELECT 
`Product line` AS product_line,
Total,
ROW_NUMBER() OVER(PARTITION BY `Product line` ORDER BY Total) AS `row_number`,
COUNT(*) OVER(PARTITION BY `Product line`) AS total_rows
FROM walmart
),
quartile AS(
SELECT 
product_line,
MAX(CASE WHEN `row_number` = FLOOR(0.25 * total_rows) THEN Total END) AS Q1,
MAX(CASE WHEN `row_number` = FLOOR(0.75 * total_rows) THEN Total END) AS Q3
FROM product_sorted
GROUP BY product_line
),
anomalies AS(
SELECT 
w.`Product line`,
w.Total,
q.Q1,
q.Q3,
(q.Q3 - q.Q1) as IQR,
CASE WHEN w.Total < (q.Q1 - 1.5 * (q.Q3 - q.Q1))
OR w.Total > (q.Q3 + 1.5 * (q.Q3 - q.Q1))
THEN 'Anomaly'
ELSE 'Normal'
END AS anomly_status
FROM walmart w
JOIN quartile q ON w.`Product line` = q.product_line
)
SELECT 
`Product line`,
Total
FROM anomalies
WHERE anomly_status = 'Anomaly';

/* Task 5: Most Popular Payment Method by City 
Walmart needs to determine the most popular payment method in each 
city to tailor marketing strategies.*/

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
Payment AS most_popular_payment 
FROM ranked_payment
WHERE `rank` = 1;

/* Task 6: Monthly Sales Distribution by Gender
Walmart wants to understand the sales distribution between male and 
female customers on a monthly basis.*/

SELECT 
    DATE_FORMAT(date_clean, '%m-%Y') AS month_year,
    ROUND(SUM(CASE
                WHEN Gender = 'Male' THEN Total
            END),
            2) AS male_sales,
    ROUND(SUM(CASE
                WHEN Gender = 'Female' THEN Total
            END),
            2) AS female_sales
FROM
    walmart
GROUP BY month_year
ORDER BY month_year;

/* Task7: Best Product Line by Customer Type
Walmart wants to know which product lines are preferred by different 
customer types(Member vs. Normal).*/

WITH product_sale AS(
SELECT
`Product line` AS product_line,
`Customer type` AS customer_type,
ROUND(SUM(Total),2) AS total_amount
FROM walmart
GROUP BY product_line,customer_type
),
rnk AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY customer_type ORDER BY total_amount DESC) AS `rank`
FROM product_sale
)
select 
product_line,
customer_type,
total_amount
from rnk
where `rank` = 1;

/* Task 8: Identifying Repeat Customers 
Walmart needs to identify customers who made repeat purchases within a 
specific time frame (e.g., within 30 days).*/

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

/* Task 9: Finding Top 5 Customers by Sales Volume 
Walmart wants to reward its top 5 customers who have generated the most sales Revenue.*/

SELECT 
    `Customer ID`, ROUND(SUM(Total), 2) AS total_amount
FROM
    walmart
GROUP BY `Customer ID`
ORDER BY total_amount DESC
LIMIT 5;

/* Task 10: Analyzing Sales Trends by Day of the Week
Walmart wants to analyze the sales patterns to determine which day of the week
brings the highest sales.*/

SELECT 
    DAYNAME(date_clean) AS `dayname`,
    ROUND(SUM(Total), 2) AS total_amount
FROM
    walmart
GROUP BY `dayname`
ORDER BY total_amount DESC;
