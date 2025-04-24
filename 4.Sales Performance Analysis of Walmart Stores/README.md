# 🛒 Walmart Sales SQL Project

This project involves analyzing Walmart sales data using SQL. The goal is to explore trends, performance across branches, and customer insights through SQL queries and visual presentation.

---

## 📁 Project Structure

| File Name                  | Description                                         |
|---------------------------|-----------------------------------------------------|
| `walmartsales.csv`        | Main dataset containing Walmart transaction records |
| `walmartsale.sql`         | SQL queries used for data exploration and analysis  |
| `sql_walmart_Project.pdf` | PDF version of the SQL assignment or project report |
| `Walmartsales.pptx`       | PowerPoint presentation summarizing the analysis    |
| `~$Walmartsales.pptx`     | *(Temporary backup file — can be deleted)*          |

---

## 🔍 Key SQL Insights

- Total sales by branch and product line
- Customer type and gender analysis
- Payment method trends
- Tax and gross income per transaction
- Sales distribution over time

---

## 💡 Sample SQL Query

```sql
SELECT Branch, AVG(Total) AS Average_Sales
FROM walmartsales
GROUP BY Branch
ORDER BY Average_Sales DESC;

🛠️ Tools Used
SQL (MySQL)

PowerPoint (for presentation)

GitHub (for version control and sharing

📦 How to Use
Download or clone the repository.

Load the walmartsales.csv file into your SQL database.

Run queries from walmartsale.sql.

Check the presentation and report for summarized results.

👤 Author
Ravi
