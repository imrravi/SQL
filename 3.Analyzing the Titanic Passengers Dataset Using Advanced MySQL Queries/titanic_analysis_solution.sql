/* 1. Write a query to find the name and age of the oldest passenger who survived.*/
select * from titanic;
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, age, who
FROM
    titanic
WHERE
    survived = 1
ORDER BY age DESC
LIMIT 5;

/* 2. Create a view to display passenger survival status, class, age, and fare.*/

CREATE VIEW passenger_sur_info AS
    SELECT 
        CONCAT(first_name, ' ', last_name) AS full_name,
        survived,
        class,
        age,
        fare
    FROM
        titanic;
SELECT *
FROM
    passenger_sur_info;

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
ORDER BY age ;
end //
DELIMITER ;
CALL pass_by_age(20,40);

/* 4. Write a query to categorize passengers based on the fare they paid: 'Low', 'Medium', or
'High'.*/

SELECT
Passenger_No,
CONCAT(first_name,' ', last_name) AS full_name,
age, who,fare,
CASE NTILE(3) OVER (ORDER BY fare)
WHEN 1 THEN 'Low'
WHEN 2 THEN 'Medium'
WHEN 3 THEN 'HIGH'
END AS fare_category
FROM titanic;

/* 5. Show each passenger's fare and the fare of the next passenger.*/

SELECT 
Passenger_No,
fare,
LEAD(fare) OVER(ORDER BY Passenger_No) AS next_fare
FROM titanic;

/* 6. Show the age of each passenger and the age of the previous passenger.*/

SELECT
Passenger_No,
CONCAT(first_name, ' ', last_name) AS full_name,
age,
LAG(age) OVER(ORDER BY Passenger_No) AS pre_age
FROM titanic;

/* 7. Write a query to rank passengers based on their fare, displaying rank for each passenger.*/

SELECT
Passenger_No,
CONCAT(first_name, ' ', last_name) AS full_name,
age, fare,
RANK() OVER (ORDER BY fare DESC) AS rnk
FROM titanic;

/* 8. Write a query to rank passengers based on their fare, ensuring no gaps in rank*/

SELECT
Passenger_No,
CONCAT(first_name, ' ', last_name) AS full_name,
age, fare,
DENSE_RANK() OVER (ORDER BY fare DESC) AS d_rnk
FROM titanic;

/* 9. Assign row numbers to passengers based on the order of their fares.*/

SELECT
Passenger_No,
CONCAT(first_name, ' ', last_name) AS full_name,
age, fare,
ROW_NUMBER() OVER (ORDER BY fare DESC) AS row_num
FROM titanic;

/* 10. Use a CTE to calculate the average fare and find passengers who paid more than the
average.*/

WITH avg_cte AS(
SELECT
AVG(fare) AS avg_fare
FROM titanic
)
SELECT
t.Passenger_No,
CONCAT(first_name,' ',last_name) AS name,
t.fare, a.avg_fare
FROM titanic t, avg_cte a
WHERE t.fare > a.avg_fare;
