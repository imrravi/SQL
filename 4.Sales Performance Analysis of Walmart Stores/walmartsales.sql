/* Task 1: Identifying the Top Branch by Sales Growth Rate.
Walmart wants to identify which branch has exhibited the highest sales growth over time. 
Analyze the total sales for each branch and compare the growth rate across months to find the top performer.*/

# MonthlySales by CTE:
WITH monthly_sales AS (
    SELECT 
        Branch, 
        DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS sales_month, 
        ROUND(SUM(Total),2) AS total_sales  
    FROM walmartsales     
    GROUP BY Branch, sales_month
), 
# GrowthRate : current sales − previous sales / previous sales * 100
Growthrate AS (
    SELECT  
        Branch, 
        sales_month, 
        total_sales, 
        LAG(total_sales) OVER (PARTITION BY Branch ORDER BY sales_month) AS prev_sales, 
        ROUND(
            (total_sales - LAG(total_sales) OVER (PARTITION BY Branch ORDER BY sales_month)) 
            / NULLIF(LAG(total_sales) OVER (PARTITION BY Branch ORDER BY sales_month), 0) * 100, 2
        ) AS growth_rate
    FROM monthly_sales
)
SELECT 
Branch,
ROUND(AVG(growth_rate),2) AS avg_growth_rate
FROM Growthrate
GROUP BY Branch
ORDER BY avg_growth_rate DESC
LIMIT 1;

/* Task 2: Finding the Most Profitable Product Line for Each Branch 
Walmart needs to determine which product line contributes the highest profit to each branch.The profit margin
should be calculated based on the difference between the gross income and cost of goods sold.*/

WITH product_profit AS(
    SELECT
          Branch,
          `Product line`,
          ROUND(SUM(`gross income`),2) AS total_profit
	from walmartsales
    group by Branch,`Product line`
),
ranked_profit AS(
      SELECT
            Branch,
            `Product line`,
            total_profit,
            RANK() OVER (PARTITION BY Branch ORDER BY total_profit DESC) AS rnk
		FROM product_profit
)
SELECT
	Branch,
    `Product line`,
    total_profit
FROM ranked_profit
WHERE rnk = 1
ORDER BY total_profit DESC;

/* Task 3: Analyzing Customer Segmentation Based on Spending 
Walmart wants to segment customers based on their average spending behavior. Classify customers into three
tiers: High, Medium, and Low spenders based on their total purchase amounts.*/

# Calculated total spending per customer by summing up Total grouped by Customer ID.
WITH customer_avg_spending AS(
    SELECT
         `Customer ID`,
         ROUND(AVG(Total),2) AS avg_spent_per_trans
	FROM walmartsales
    GROUP BY `Customer ID`
),
spending_tiers AS (
      SELECT
           `Customer ID`,
           avg_spent_per_trans,
           NTILE(3) OVER (ORDER BY avg_spent_per_trans DESC) AS tier  #NTILE(3) to divide customers into three equal tiers 
	 FROM customer_avg_spending
)
SELECT
     `Customer ID`,
     avg_spent_per_trans,
     CASE
        WHEN tier = 1 THEN 'High Spender'
        WHEN tier = 2 THEN 'Medium Spender'
        ELSE 'Low Spender'
	END AS spending_category
FROM spending_tiers;

/* Task 4: Detecting Anomalies in Sales Transactions
Walmart suspects that some transactions have unusually high or low sales compared to the average for the
product line. Identify these anomalies.*/

# To identify outliers using the Interquartile Range (IQR)

WITH product_sorted as(
    SELECT
			`Product line`,
            Total,
            ROW_NUMBER() OVER (PARTITION BY `Product line` ORDER BY Total) AS row_num,
            COUNT(*) OVER (PARTITION BY `Product line`) as total_rows
	FROM walmartsales
),
quartile AS(
	SELECT
		ps.`Product line`,
        MAX(CASE WHEN row_num = FLOOR(0.25 * total_rows) THEN Total END) AS Q1,
        MAX(CASE WHEN row_num = FLOOR(0.75 * total_rows) THEN Total END) AS Q3
	FROM product_sorted ps
    GROUP BY ps.`Product line`
),
anomalies as(
	SELECT 
		w.`Invoice ID`,
        w.Branch,
        w.`Product line`,
        w.Total,
		q.Q1,
        q.Q3,
        (q.Q3 - q.Q1) AS IQR,
	CASE
		WHEN w.Total < (q.Q1 - 1.5 * (q.Q3 - q.Q1))
		OR  w.Total > (q.Q3 + 1.5 * (q.Q3 - q.Q1))
        THEN 'anomaly'
        ELSE 'Normal'
	END AS anomaly_status
    FROM walmartsales w
    JOIN quartile q ON w.`Product line` = q.`Product line`
    )
SELECT
	`Invoice ID`,
    Branch,
    `Product line`,
    Total,
    Q1,Q3,IQR,anomaly_status
FROM anomalies
  WHERE anomaly_status = 'anomaly'
ORDER BY Total DESC;

    
/* Task 5: Most Popular Payment Method by City 
Walmart needs to determine the most popular payment method in each city to tailor marketing strategies.*/

WITH payment_counts AS(
 SELECT
     City,Payment,COUNT(*) AS payment_count,
     RANK() OVER (PARTITION BY City ORDER BY COUNT(*)DESC) AS rnk
FROM walmartsales
GROUP BY City,Payment
 )
 SELECT
     City,
     Payment AS most_popular_payment_method,
     payment_count
FROM payment_counts
WHERE rnk = 1;

/* Task 6: Monthly Sales Distribution by Gender
Walmart wants to understand the sales distribution between male and female customers on a monthly basis.*/

SELECT 
DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS sales_month,
Gender,
ROUND(SUM(Total),2) AS total_sale
FROM walmartsales
GROUP BY sales_month,Gender
ORDER BY sales_month,Gender;

/* Task 7: Best Product Line by Customer Type
Walmart wants to know which product lines are preferred by different customer types(Member vs. Normal).*/

WITH product_sales AS(
	SELECT
		`Customer type`,
        `Product line`,
        ROUND(SUM(Total),2) AS total_sales
        FROM walmartsales
        GROUP BY `Customer type`,`Product line`
),
ranked_product AS(
	SELECT
		`Customer type`,
        `Product line`,
        total_sales,
        RANK() OVER (PARTITION BY `Customer type` ORDER BY total_sales DESC) AS rnk
        FROM product_sales
)
SELECT  
	`Customer type`,
    `Product line`,
    total_sales
    FROM ranked_product
    WHERE rnk = 1;

/* Task 8: Identifying Repeat Customers 
Walmart needs to identify customers who made repeat purchases within a specific time frame (e.g., within 30
days).*/

WITH customer_purchase AS(
    SELECT
    `Customer ID`,
   STR_TO_DATE(Date, '%d-%m-%Y') AS purchase_date,
   LEAD(STR_TO_DATE(Date, '%d-%m-%Y')) OVER (PARTITION BY `Customer ID` ORDER BY STR_TO_DATE(Date, '%d-%m-%Y')) AS next_purchase_date
FROM walmartsales
)
SELECT
     `Customer ID`,
     COUNT(*) AS repeat_purchase
FROM customer_purchase
WHERE next_purchase_date IS NOT NULL
AND DATEDIFF(next_purchase_date,purchase_date) <=30
GROUP BY `Customer ID`
ORDER BY repeat_purchase DESC;

/* Task 9: Finding Top 5 Customers by Sales Volume (6 Marks)
Walmart wants to reward its top 5 customers who have generated the most sales Revenue.*/

SELECT 
   `Customer ID`,
   ROUND(SUM(Total),2) AS total_sales
FROM walmartsales
GROUP BY `Customer ID`
ORDER BY total_sales DESC
LIMIT 5;

/* Task 10: Analyzing Sales Trends by Day of the Week
Walmart wants to analyze the sales patterns to determine which day of the week
brings the highest sales.*/

SELECT
   DAYNAME(STR_TO_DATE(Date, '%d-%m-%Y'))  AS day_of_week,
   ROUND(SUM(Total),2) AS total_sales
FROM walmartsales
GROUP BY day_of_week
ORDER BY total_sales DESC;