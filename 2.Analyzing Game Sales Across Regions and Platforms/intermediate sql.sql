/* Q1. Insert a new game with the title "Future Racing", genre 
"Racing", release date "2024-10-01", and developer "Speed Studios".*/

select * from games;

insert into games(GameTitle,Genre,ReleaseDate,Developer)
values('Future Racing','Racing','2024-10-01','Speed Studios');

/* Q2. Update the price of the game with GameID 2 on the PlayStation platform to 60.*/

select * from game_sales;

update game_sales
set Price = 60
where GameID = 2 and Platform = 'PlayStation';

/* Q3. Delete the record of the game with GameID 5 from the Game Sales table.*/

select * from game_sales;

delete from game_sales where GameID = 5;

/* Q4. Calculate the total number of units sold for each 
game across all platforms and regions. */

select Platform, SalesRegion, sum(UnitsSold) as total_units_sold
from game_sales
group by Platform,SalesRegion
order by total_units_sold desc;

/* Q5. Identify the game with the highest number of units sold in North America.*/

select *
from game_sales
where SalesRegion='North America'
and UnitsSold = (select max(UnitsSold) from game_sales where SalesRegion='North America');

/* Q6. Get the game titles, platforms, and sales regions along
 with the units sold for each game.*/
 
SELECT g.GameTitle,
gs.Platform,gs.SalesRegion,gs.UnitsSold
FROM game_sales gs
INNER JOIN games g ON gs.GameID = g.GameID
ORDER BY g.GameTitle,gs.Platform,gs.SalesRegion,gs.UnitsSold;

/* Q7. Find all games, including those that have no sales data 
in the Game Sales table. */

SELECT g.GameTitle,
gs.Platform,gs.SalesRegion,gs.UnitsSold
FROM games g
LEFT JOIN game_sales gs ON g.GameID = gs.GameID

/* Q8. Retrieve sales records where the game details are missing in the Games table.*/

SELECT gs.GameID,gs.Platform,gs.SalesRegion,gs.UnitsSold
FROM game_sales gs
LEFT JOIN games g ON gs.GameID = g.GameID
WHERE g.GameID IS NULL;

/* Q9. Retrieve game sales data for North America and Europe removing duplicate
records.*/
-- METHOD - 1
SELECT SalesRegion,
       SUM(UnitsSold) AS TotalUnitsSold, 
       ROUND(AVG(Price),2) AS AvgPrice
FROM game_sales
WHERE SalesRegion IN ('North America', 'Europe')
GROUP BY SalesRegion;

-- METHOD - 2 
SELECT DISTINCT SalesRegion
FROM game_sales
WHERE SalesRegion IN ('North America', 'Europe');

/* Q 10. Retrieve all game sales data from North America and Europe 
without removing duplicate records.*/

SELECT GameID, Platform, SalesRegion, UnitsSold, Price
FROM game_sales
WHERE SalesRegion IN ('North America', 'Europe');



