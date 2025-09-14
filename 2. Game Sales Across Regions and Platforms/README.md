## Title: Analyzing Game Sales Across Regions and Platforms
![dataset-cover](https://github.com/user-attachments/assets/ecc9d65e-c4c7-452f-acea-b2a79e06cbbe)

**Problem Statement:**

The gaming industry is highly competitive, and understanding sales patterns across
different regions and platforms is crucial for developers and publishers to optimize
their strategies. In this case, we aim to analyze a set of game sales data to provide
insights into sales performance across various platforms and regions. This analysis
will include aggregate metrics, joins, and manipulation of sales records.

**Datasets Used: [Games](https://docs.google.com/spreadsheets/d/1GwhwUOgpOZgNWc0xijvt3WMsdwiIJplR9WGwSgbk0i0/edit?gid=2102834210#gid=2102834210), [game sales](https://docs.google.com/spreadsheets/d/180QoAZn0h7xmr3gc5NR091zTKHpR-BmEzctKLq5_NSA/edit?gid=1294232080#gid=1294232080)**

1. **Games.csv:** This dataset contains information about games, including GameID,
GameTitle, Genre, ReleaseDate, and Developer.
2. **Game Sales.csv:** This dataset contains game sales data, including GameID,
Platform, SalesRegion, UnitsSold, and Price.

**Objective:**

The objective of this project is to analyze the game sales data and extract
meaningful insights using various SQL operations. The tasks will involve inserting
new data, updating records, deleting records, and using aggregate functions and
joins to explore game sales performance.

---

## Question and Solution
**1.Insert a new game with the title "Future Racing", genre "Racing", release date
"2024-10-01", and developer "Speed Studios".**
```sql
INSERT INTO games(GameTitle,Genre,ReleaseDate,Developer)
VALUES('Future Racing','Racing','2024-10-01','Speed Studios');
```
---

**2. Update the price of the game with GameID 2 on the PlayStation platform to 60.**
```sql
UPDATE game_sales 
SET 
    Price = 60
WHERE
    GameID = 2 AND Platform = 'PlayStation' LIMIT 1;
SELECT 
    *
FROM
    game_sales;
```
<img width="277" height="44" alt="2" src="https://github.com/user-attachments/assets/e68da485-4c02-4518-9e77-b8d239d89c31" />

---

**3. Delete the record of the game with GameID 5 from the Game Sales table.**
```sql
SET SQL_SAFE_UPDATES=0;
START TRANSACTION;
DELETE FROM game_sales WHERE GameID = 5;
SELECT * FROM game_sales WHERE GameID = 5;
COMMIT;
SET SQL_SAFE_UPDATES=1;
```
<img width="275" height="105" alt="3" src="https://github.com/user-attachments/assets/cf72ff4a-3e3f-454b-9071-722df2afd1df" />

---

**4. Calculate the total number of units sold for each game across all platforms and regions.**
```sql
SELECT 
    Platform, SalesRegion, SUM(UnitsSold) AS total_units
FROM
    game_sales
GROUP BY Platform , SalesRegion
ORDER BY total_units DESC;
```
<img width="565" height="194" alt="4" src="https://github.com/user-attachments/assets/7e2c885b-ba4b-4a4e-a1f3-51c502b7c09d" />

---

**5. Identify the game with the highest number of units sold in North America.**
```sql
SELECT 
    Platform, SalesRegion, SUM(UnitsSold) AS total_units
FROM
    game_sales
WHERE
    SalesRegion = 'North America'
GROUP BY SalesRegion , Platform
ORDER BY total_units DESC;
```
<img width="206" height="77" alt="5" src="https://github.com/user-attachments/assets/e3a95862-57d7-455a-9104-fe19af848028" />

---

**6. Get the game titles, platforms, and sales regions along with the units sold for each game.**
```sql
SELECT 
    g.GameTitle, gs.Platform, gs.SalesRegion, gs.UnitsSold
FROM
    games g
        JOIN
    game_sales gs ON g.GameID = gs.GameID;
```
<img width="344" height="356" alt="6" src="https://github.com/user-attachments/assets/24223709-ba4e-4f00-8c9f-718ff29f5430" />

---

**7. Find all games, including those that have no sales data in the Game Sales table.**
```sql
SELECT 
    g.GameTitle, gs.Platform, gs.Salesregion, gs.UnitsSold
FROM
    games g
        LEFT JOIN
    game_sales gs ON g.GameID = gs.GameID;
```
<img width="341" height="370" alt="7" src="https://github.com/user-attachments/assets/8bc78ef6-04e0-4a4f-9aa0-fafbc96e1890" />

---

**8. Retrieve sales records where the game details are missing in the Games table.**
```sql
SELECT 
    gs.*
FROM
    games g
        RIGHT JOIN
    game_sales gs ON g.GameID = gs.GameID
WHERE
    g.GameID IS NULL;
```
<img width="256" height="19" alt="8" src="https://github.com/user-attachments/assets/fdf4a90e-8cee-4982-aff4-4058418e97d7" />

---

**9. Retrieve game sales data for North America and Europe removing duplicate records.**
```sql
SELECT DISTINCT
    *
FROM
    game_sales
WHERE
    SalesRegion IN ('North America' , 'Europe');
```
<img width="273" height="334" alt="9" src="https://github.com/user-attachments/assets/dc8129f0-84fb-45be-9b01-5c6769b15bda" />

- The data in the preview has been truncated due to size limits.
- DISTINCT * removes only identical row.
- If two rows have all columns exactly the same → one copy will remain.
- If even one column is different → both rows will stay.
- So if duplicates in our table happen because of small differences (e.g., different UnitsSold), DISTINCT * will not remove them.

---

**10. Retrieve all game sales data from North America and Europe without removing duplicate records.**
```sql
SELECT 
    *
FROM
    game_sales
WHERE
    SalesRegion IN ('North America' , 'Europe');
```
<img width="273" height="334" alt="9" src="https://github.com/user-attachments/assets/587dbb38-8a8a-47d3-85b0-d87f3f31b116" />

- The data in the preview has been truncated due to size limits.

---
