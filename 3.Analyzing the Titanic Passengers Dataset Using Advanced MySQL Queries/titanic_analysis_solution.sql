/* 1. Write a query to find the name and age of the oldest passenger who survived.*/

SELECT 
    CONCAT(first_name, ' ', last_name) AS 'name', age, who
FROM
    titanic
WHERE
    survived = 1
ORDER BY age DESC
LIMIT 5;

/* 2. Create a view to display passenger survival status, class, age, and fare.*/

CREATE VIEW passenger_summary AS
    SELECT 
        survived, class, age, fare
    FROM
        titanic;
SELECT  * FROM passenger_summary;

/* 3. Create a stored procedure to retrieve passengers based on a given age range.*/

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

/* 4. Write a query to categorize passengers based on the fare they paid: 
'Low', 'Medium', or 'High'. */

SELECT
fare,
CASE NTILE(3) OVER(ORDER BY fare DESC)
WHEN 1 THEN 'High'
WHEN 2 THEN 'Medium'
WHEN 3 THEN 'Low'
END AS fare_tier
FROM titanic;

/* 5. Show each passenger's fare and the fare of the next passenger.*/

SELECT
Passenger_No,
fare,
LEAD(fare) OVER(ORDER BY Passenger_No) AS 'lead'
FROM titanic;

/* 6. Show the age of each passenger and the age of the previous passenger.*/

SELECT
Passenger_No,
age,
LAG(age) OVER(ORDER BY Passenger_No) AS 'lag'
FROM titanic;

/* 7. Write a query to rank passengers based on their fare, 
displaying rank for each passenger.*/ 

SELECT
Passenger_No,
fare,
RANK() OVER(ORDER BY fare DESC) AS 'rank'
FROM titanic;

/* 8. Write a query to rank passengers based on their fare, ensuring no gaps in rank*/

SELECT
Passenger_No,
fare,
DENSE_RANK() OVER(ORDER BY fare DESC) AS 'dense_rank'
FROM titanic;

/* 9. Assign row numbers to passengers based on the order of their fares.*/

SELECT
Passenger_No,
fare,
ROW_NUMBER() OVER(ORDER BY fare DESC) AS 'row_number'
FROM titanic;

/* 10. Use a CTE to calculate the average fare and find passengers 
who paid more than the average.*/

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
