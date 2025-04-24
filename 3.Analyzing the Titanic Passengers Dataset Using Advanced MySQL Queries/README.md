# 🚢 Titanic SQL Assignment

This project involves SQL-based data exploration of the Titanic passenger dataset. The goal is to analyze survival patterns, passenger demographics, and other key insights using structured SQL queries.

## 📂 Project Structure

📁 Repository Root
├── SQL_Assignment_titanic.pdf   # PDF file with questions/instructions
├── titanic.csv                  # Titanic dataset
├── titanic_analysis.sql         # Your SQL queries/answers

## 🧠 Key Objectives

- Understand survival rates by class, gender, and age
- Explore passenger demographics
- Identify trends and insights from structured queries

## 🛠️ Tools Used

- **SQL** (via MySQL / PostgreSQL / SQLite etc.)
- **Text editor** or **DB tools** for running queries
- **Git & GitHub** for version control

## 📊 Sample Queries

```sql
-- 1. Count total passengers
SELECT COUNT(*) FROM titanic;

-- 2. Survival count by gender
SELECT sex, survived, COUNT(*) 
FROM titanic
GROUP BY sex, survived;

-- 3. Average age of passengers
SELECT AVG(age) AS average_age FROM titanic;

📁 Dataset Info
The dataset contains the following columns:

PassengerId, Name, Sex, Age, SibSp, Parch, Ticket, Fare, Cabin, Embarked, Survived, Pclass

📬 Contact
Feel free to reach out if you’d like to collaborate or provide feedback:
📧 ravi.18teen@gmail.com
