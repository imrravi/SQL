/* Q1. Write a query to find the name and age of the oldest passenger who survived.*/

SELECT first_name,
last_name, age, who
FROM titanic
WHERE survived = 1
AND age = (SELECT MAX(age) FROM titanic WHERE survived =1);

/* Q2. Create a view to display passenger survival status, class, age, and fare.*/

CREATE VIEW passenger_survival_info AS
SELECT 
survived,      -- survival status(1 = survived, 0 = did not survived)
class,
age,
fare
FROM titanic;
SELECT * FROM passenger_survival_info   -- for view.

/* Q3. Create a stored procedure to retrieve passengers based on a given age range.*/

DELIMITER //

CREATE PROCEDURE pas_by_age_range(IN min_age INT, IN max_age INT)
BEGIN 
    SELECT Passenger_No,first_name,last_name,survived,
    pclass,fare,who,embark_town,age
    FROM titanic
    WHERE age BETWEEN min_age AND max_age
    ORDER BY age;
END //

DELIMITER ;

CALL pas_by_age_range(50,60);

/* Q4. Write a query to categorize passengers based on the fare they paid: 
'Low', 'Medium', or 'High'.*/

SELECT
first_name,
last_name,
fare,
CASE
  WHEN fare < 30000 THEN 'Low'
  WHEN fare BETWEEN 30000 AND 50000 THEN 'Medium'
  ELSE 'High'
  END AS fare_category
FROM titanic;

/* Q5. Show each passenger's fare and the fare of the next passenger.*/

SELECT 
Passenger_No,
first_name,
last_name,
fare,
LEAD(fare) OVER(ORDER BY Passenger_No) AS next_fare
FROM titanic; 

/* Q6. Show the age of each passenger and the age of the previous passenger.*/

SELECT 
Passenger_No,
first_name,
last_name,
age,
LAG(age) OVER(ORDER BY Passenger_No) AS previous_age
FROM titanic; 

/* Q7. Write a query to rank passengers based on their fare, 
displaying rank for each passenger.*/

SELECT
first_name,
last_name,
pclass,
fare,
RANK() OVER(PARTITION BY pclass ORDER BY fare DESC) AS fare_rank
FROM titanic;

/* Q8. Write a query to rank passengers based on their fare, ensuring no gaps in rank.*/

SELECT
first_name,
last_name,
fare,
DENSE_RANK() OVER(ORDER BY fare DESC) AS dense_fare_rank
FROM titanic;

/* Q9. Assign row numbers to passengers based on the order of their fares.*/

SELECT
first_name,
last_name,
class,
fare,
ROW_NUMBER() OVER(PARTITION BY class) AS row_no
FROM titanic;

/* Q10. Use a CTE to calculate the average fare and find passengers who 
paid more than the average.*/

WITH avgfare_cte AS(
SELECT AVG(fare) AS avg_fare
FROM titanic
)
SELECT
Passenger_No,
first_name,
last_name,
fare
FROM titanic,avgfare_cte
WHERE titanic.fare>avgfare_cte.avg_fare;