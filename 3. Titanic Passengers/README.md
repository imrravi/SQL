## Title: Analyzing the Titanic Passengers Dataset Using Advanced MySQL Queries
![titanic](https://github.com/user-attachments/assets/b8c507f4-9e19-447b-80b2-9bfb8488e65a)

**Problem Statement:**

The dataset contains information about passengers on the Titanic, including personal details
such as name, age, class, fare, survival status, and other related data. The goal is to analyze
this data using advanced MySQL features to answer specific business questions and provide
insights on passenger demographics, survival rates, and relationships between various
attributes.

**Datasets Used: [Titanic Dataset](https://docs.google.com/spreadsheets/d/1AQZGkOgs69O63V4wer2lij4vbwHIhtHYgtfbcxsqFxM/edit?gid=265941730#gid=265941730)**

Passengers Dataset: Contains columns such as Passenger_No, first_name, last_name,
survived, pclass, sex, age, parch, fare, embarked, deck, embark_town, and alive.

**Objective:**

The objective is to perform advanced data analysis and reporting on the Titanic passengers
dataset using key MySQL concepts, such as subqueries, views, stored procedures, CTE
(Common Table Expressions), and window functions like LEAD, LAG, RANK, and
DENSE_RANK.

---

## Question and Solution
**1. Write a query to find the name and age of the oldest passenger who survived.**
```sql
SELECT 
    CONCAT(first_name, ' ', last_name) AS name, age, who
FROM
    titanic
WHERE
    survived = 1
ORDER BY age DESC
LIMIT 5;
```
<img width="165" height="96" alt="1" src="https://github.com/user-attachments/assets/3ed8d1f2-d5b3-46e7-a28e-5ec1a0374b50" />

---

**2. Create a view to display passenger survival status, class, age, and fare.**
```sql
CREATE VIEW passenger_summary AS
    SELECT 
        survived, class, age, fare
    FROM
        titanic;
SELECT  * FROM passenger_summary;
```
<img width="154" height="333" alt="2" src="https://github.com/user-attachments/assets/0e53f22b-4823-4228-a2f4-0a340ceb0140" />

- The data in the preview has been truncated due to size limits.

---

**3. Create a stored procedure to retrieve passengers based on a given age range.**
```sql
DELIMITER //
CREATE PROCEDURE pass_by_age(
IN min_age INT,
IN max_age INT
)
BEGIN
SELECT *
FROM titanic
WHERE age BETWEEN min_age AND max_age
ORDER BY age;
END //
DELIMITER ;
CALL pass_by_age(20,40);
```
<img width="608" height="225" alt="3" src="https://github.com/user-attachments/assets/c2c417c9-7e35-44db-b7c1-271f24e28bcf" />

- The data in the preview has been truncated due to size limits.

---

**4. Write a query to categorize passengers based on the fare they paid: 'Low', 'Medium', or 'High'.**
```sql
SELECT
fare,
CASE NTILE(3) OVER(ORDER BY fare DESC)
WHEN 1 THEN 'High'
WHEN 2 THEN 'Medium'
WHEN 3 THEN 'Low'
END AS fare_tier
FROM titanic;
```
<img width="86" height="332" alt="4" src="https://github.com/user-attachments/assets/6357091f-ac0b-4b58-9ea1-60f8a8cc2398" />

---

**5.Show each passenger's fare and the fare of the next passenger.**
```sql
SELECT
Passenger_No,
fare,
LEAD(fare) OVER(ORDER BY Passenger_No) AS 'lead'
FROM titanic;
```
<img width="146" height="335" alt="5" src="https://github.com/user-attachments/assets/b178a649-ba63-4617-97b5-a4755be9580c" />

---

**6. Show the age of each passenger and the age of the previous passenger.**
```sql
SELECT
Passenger_No,
age,
LAG(age) OVER(ORDER BY Passenger_No) AS 'lag'
FROM titanic;
```
<img width="137" height="336" alt="6" src="https://github.com/user-attachments/assets/f3da0d96-4e09-4067-b121-f1e2efaeb550" />

---

**7. Write a query to rank passengers based on their fare, displaying rank for each passenger.**
```sql
SELECT
Passenger_No,
fare,
RANK() OVER(ORDER BY fare DESC) AS 'rank'
FROM titanic;
```
<img width="142" height="334" alt="7" src="https://github.com/user-attachments/assets/3148f71e-4cd9-457b-a428-495588472f7c" />

---

**8. Write a query to rank passengers based on their fare, ensuring no gaps in rank**
```sql
SELECT
Passenger_No,
fare,
DENSE_RANK() OVER(ORDER BY fare DESC) AS 'dense_rank'
FROM titanic;
```
<img width="169" height="334" alt="8" src="https://github.com/user-attachments/assets/b2f19e50-68ad-4d8e-819f-a677a1c1876d" />

---

**9. Assign row numbers to passengers based on the order of their fares.**
```sql
SELECT
Passenger_No,
fare,
ROW_NUMBER() OVER(ORDER BY fare DESC) AS 'row_number'
FROM titanic;
```
<img width="173" height="332" alt="9" src="https://github.com/user-attachments/assets/7e4abb8f-f5e4-40b2-b24e-ec427fc94516" />

---

**10. Use a CTE to calculate the average fare and find passengers who paid more than the average.**
```sql
WITH avgfare AS(
SELECT
AVG(fare) AS 'avg'
FROM titanic
)
SELECT 
t.Passenger_No,
CONCAT(t.first_name,' ',t.last_name) AS 'name',
t.fare,
a.avg
FROM titanic t, avgfare a
WHERE t.fare > a.avg;
```
<img width="230" height="190" alt="10" src="https://github.com/user-attachments/assets/2a8862e6-06e2-48b4-95e6-93098bfc02c7" />

---








