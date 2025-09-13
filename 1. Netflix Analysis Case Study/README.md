## Title: Netflix Originals Data Exploration and Analysis

<img width="2560" height="641" alt="Netflix_LinkdinHeader_N_Texture_5" src="https://github.com/user-attachments/assets/e9d014d2-20a8-46f8-8afd-15859d8883a2" />

**Problem Statement:**

The task involves analyzing the Netflix Originals dataset to derive insights about movie genres, runtime, IMDb
scores, and premiere dates. The dataset holds valuable information regarding the content Netflix produces, and
understanding these attributes can help identify trends and patterns. By using SQL queries, the aim
is to perform complex filtering, aggregation, and sorting operations, providing meaningful insights for business
decisions.

**Dataset Used: [Netflix_Originals](https://docs.google.com/spreadsheets/d/1-8mBEVJgYg89WQp2eXlaQP7ATMCItwRJQS24MvXLHhA/edit?gid=275629490#gid=275629490)**

- Title: The title of the Netflix Original
- GenreID: Genre ID of the movie/show
- Runtime: Duration of the movie/show in minutes
- IMDBScore: IMDb score of the movie/show
- Language: Language in which the movie/show is available
- Premiere_Date: The date the movie/show premiered

**Objective:**

The objective is to use MySQL queries to perform advanced filtering, grouping, and
sorting on the Netflix Originals dataset.

---
## Question and Solution

**1. Retrieve all Netflix Originals with an IMDb score greater than 7, runtime greater than 100 minutes, and the
language is either English or Spanish.**
```sql
SELECT 
    *
FROM
    netflix_originals
WHERE
    IMDBScore > 7 AND Runtime > 100
        AND Language IN ('English' , 'Spanish');
```
<img width="592" height="328" alt="1" src="https://github.com/user-attachments/assets/ac5f1305-012d-42ed-a5f4-aff36b5b92e5" />

---

**2. Find the total number of Netflix Originals in each language, but only show those languages that have more
than 5 titles.**
```sql
SELECT 
    Language, COUNT(*) AS Titles
FROM
    netflix_originals
GROUP BY Language
HAVING Titles > 5
ORDER BY Titles DESC;
```
<img width="111" height="153" alt="2" src="https://github.com/user-attachments/assets/cba1f456-d967-41c8-9b79-914ae4d3af25" />

---

**3. Get the top 3 longest-running movies in Hindi language sorted by IMDb score in descending order.**
```sql
SELECT 
    Title
FROM
    netflix_originals
WHERE
    Language = 'Hindi'
ORDER BY Runtime DESC
LIMIT 3;
```
<img width="84" height="68" alt="3" src="https://github.com/user-attachments/assets/0946f828-ef5d-4141-9c2c-549db9877a5d" />

---
**4. Retrieve all titles that contain the word "House" in their name and have an IMDb score greater than 6.**
```sql
SELECT 
    Title, IMDBScore
FROM
    netflix_originals
WHERE
    Title LIKE '%House%' AND IMDBScore > 6;
```
<img width="167" height="50" alt="4" src="https://github.com/user-attachments/assets/a8a0ca2d-3860-4ea5-869e-0d2117a90e0f" />

---

**5. Find all Netflix Originals released between the years 2018 and 2020 that are in either English, Spanish, or Hindi.**
```sql
SELECT 
    *
FROM
    netflix_originals
WHERE
    YEAR(STR_TO_DATE(Premiere_Date, '%d-%m-%Y')) BETWEEN 2018 AND 2020
        AND Language IN ('English' , 'Spanish', 'Hindi');
```
<img width="782" height="194" alt="query2" src="https://github.com/user-attachments/assets/59ba0b84-1153-4d67-9b69-1b7b23276ea3" />

---

**6. Find all movies that either have a runtime less than 60 minutes or an IMDb score less than 5, sorted by
Premiere Date.**
```sql
SELECT 
    Title, Runtime, IMDBScore, Premiere_Date
FROM
    netflix_originals
WHERE
    Runtime < 60 OR IMDBScore < 5
ORDER BY Premiere_Date;
```
<img width="492" height="322" alt="Screenshot 2025-09-13 225108" src="https://github.com/user-attachments/assets/2cbfe599-335a-475f-8836-21d564cd29a9" />

---

**7. Get the average IMDb score for each genre where the genre has at least 10 movies.**
```sql
SELECT 
    GenreID, ROUND(AVG(IMDBScore), 2) AS avg_imdb_score
FROM
    netflix_originals
GROUP BY GenreID
HAVING COUNT(*) >= 10
ORDER BY avg_imdb_score DESC;
```
<img width="131" height="193" alt="7" src="https://github.com/user-attachments/assets/bd68e237-4454-471c-9149-85632098a910" />

---

**8. Retrieve the top 5 most common runtimes for Netflix Originals.**
```sql
SELECT 
    Runtime, COUNT(*) AS count_runtime
FROM
    netflix_originals
GROUP BY Runtime
ORDER BY count_runtime DESC
LIMIT 5;
```
<img width="131" height="101" alt="8" src="https://github.com/user-attachments/assets/5040eb64-31e8-4430-9072-c694d6b8403f" />

---

**9. List all Netflix Originals that were released in 2020, grouped by language, and show the total count of titles for
each language.**
```sql
SELECT 
    Language, COUNT(*) total_title
FROM
    netflix_originals
WHERE
    YEAR(STR_TO_DATE(Premiere_Date, '%d-%m-%Y')) = 2020
GROUP BY Language
ORDER BY total_title DESC;
```
<img width="113" height="304" alt="9" src="https://github.com/user-attachments/assets/7e8ec249-e4c4-4d6f-9441-e50884d7becc" />

---

**10. Create a new table that enforces a constraint on the IMDb score to be between 0 and 10 and the runtime to
be greater than 30 minutes.**
```sql
CREATE TABLE netflix_movie (
    title VARCHAR(255) NOT NULL,
    genere_id VARCHAR(255) NOT NULL,
    Runtime INT CHECK (Runtime > 30),
    IMDB_Score DECIMAL(3 , 1 ) CHECK (IMDB_Score BETWEEN 0 AND 10),
    Language VARCHAR(100),
    Premiere_Date DATE
```
---


