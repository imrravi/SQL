/* 1. Insert a new game with the title "Future Racing", genre "Racing", release date
"2024-10-01", and developer "Speed Studios".*/

INSERT INTO games(GameTitle,Genre,ReleaseDate,Developer)
VALUES('Future Racing', 'Racing', '2024-10-01', 'Speed Studios');

/* 2. Update the price of the game with GameID 2 on the PlayStation platform to 60.*/

UPDATE game_sales 
SET 
    Price = 60
WHERE
    GameID = 2 AND Platform = 'PlayStation';
    
/* 3. Delete the record of the game with GameID 5 from the Game Sales table.*/

DELETE FROM game_sales 
WHERE
    GameID = 5;
    
/* 4. Calculate the total number of units sold for each game across all platforms and
regions.*/

SELECT 
    Platform, SalesRegion, SUM(UnitsSold) AS total_units
FROM
    game_sales
GROUP BY Platform , SalesRegion
ORDER BY total_units DESC;

/* 5. Identify the game with the highest number of units sold in North America.*/

SELECT 
    Platform, SalesRegion, SUM(UnitsSold) AS total_units
FROM
    game_sales
WHERE
    SalesRegion = 'North America'
GROUP BY SalesRegion , Platform
ORDER BY total_units DESC;

/* 6. Get the game titles, platforms, and sales regions along with the units sold for each
game.*/

SELECT 
    g.GameTitle, gs.Platform, gs.SalesRegion, gs.UnitsSold
FROM
    game_sales gs
        LEFT JOIN
    games g ON gs.GameID = g.GameID;

/* 7. Find all games, including those that have no sales data in the Game Sales table.*/

SELECT 
    g.GameTitle, gs.Platform, gs.SalesRegion, gs.UnitsSold
FROM
    games g
        LEFT JOIN
    game_sales gs ON g.GameID = gs.GameID;
    
/* 8. Retrieve sales records where the game details are missing in the Games table.*/

SELECT 
    gs.*
FROM
    games g
        RIGHT JOIN
    game_sales gs ON g.GameID = gs.GameID
WHERE
    g.GameID IS NULL;

/* 9. Retrieve game sales data for North America and Europe removing duplicate
records.*/

SELECT DISTINCT
    *
FROM
    game_sales
WHERE
    SalesRegion IN ('North America' , 'Europe');

/* 10. Retrieve all game sales data from North America and Europe without removing
duplicate records.*/

SELECT 
    *
FROM
    game_sales
WHERE
    SalesRegion IN ('North America' , 'Europe');

