/* 1. Retrieve all Netflix Originals with an IMDb score greater than 7, runtime greater 
than 100 minutes, and the language is either English or Spanish.*/

SELECT 
    *
FROM
    netflix_originals
WHERE
    IMDBScore > 7 AND Runtime > 100
        AND Language IN ('English' , 'Spanish');
        
/* 2. Find the total number of Netflix Originals in each language, but only show 
those languages that have more than 5 titles.*/

SELECT 
    Language, COUNT(*) AS total_titles
FROM
    netflix_originals
GROUP BY Language
HAVING total_titles > 5
ORDER BY total_titles DESC;

/* 3. Get the top 3 longest-running movies in Hindi language sorted by IMDb score in descending order.*/

SELECT 
    *
FROM
    netflix_originals
WHERE
    Language = 'Hindi'
ORDER BY Runtime DESC , IMDBScore DESC
LIMIT 3;

/* 4. Retrieve all titles that contain the word "House" in their name 
and have an IMDb score greater than 6.*/

SELECT 
    *
FROM
    netflix_originals
WHERE
    Title LIKE '%House%' AND IMDBScore > 6;
    
/* 5. Find all Netflix Originals released between the years 2018 and 2020 that are in
either English, Spanish, or Hindi.*/

SELECT 
    *
FROM
    netflix_originals
WHERE
    YEAR(STR_TO_DATE(Premiere_Date, '%d-%m-%Y')) BETWEEN 2018 AND 2020
        AND Language IN ('English' , 'Spanish', 'Hindi');
        
/* 6. Find all movies that either have a runtime less than 60 minutes or an 
IMDb score less than 5, sorted by Premiere Date.*/

SELECT 
    *
FROM
    netflix_originals
WHERE
    Runtime <= 60 AND IMDBScore <= 5
ORDER BY Premiere_Date;

/* 7. Get the average IMDb score for each genre where the genre has at least 10 movies.*/

SELECT 
    GenreID,
    ROUND(AVG(IMDBScore),2) AS avg_imdb,
    COUNT(*) AS total_genere_id
FROM
    netflix_originals
GROUP BY GenreID
HAVING total_genere_id >= 10
ORDER BY total_genere_id DESC;

/* 8. Retrieve the top 5 most common runtimes for Netflix Originals.*/

SELECT 
    Runtime, COUNT(*) AS total_runtime
FROM
    netflix_originals
GROUP BY Runtime
ORDER BY total_runtime DESC
LIMIT 5;

/* 9. List all Netflix Originals that were released in 2020, grouped by language, 
and show the total count of titles for each language*/

SELECT 
    Language, COUNT(*) AS total_titles
FROM
    netflix_originals
WHERE
    YEAR(STR_TO_DATE(Premiere_Date, '%d-%m-%Y')) = 2020
GROUP BY Language
ORDER BY total_titles DESC;

/* 10. Create a new table that enforces a constraint on the IMDb score to be between 0 and 10
 and the runtime to be greater than 30 minutes.*/
 
 CREATE TABLE netflix_movie (
    title VARCHAR(255) NOT NULL,
    genere_id VARCHAR(255) NOT NULL,
    Runtime INT CHECK (Runtime > 30),
    IMDB_Score DECIMAL(3 , 1 ) CHECK (IMDB_Score BETWEEN 0 AND 10),
    Language VARCHAR(100),
    Premiere_Date DATE
);





