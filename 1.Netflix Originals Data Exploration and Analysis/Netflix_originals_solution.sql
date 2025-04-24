/*Q1. Retrieve all Netflix Originals with an IMDb score greater than 7, runtime g
reater than 100 minutes, and the language is either English or Spanish.*/

select * from netflix_originals
where IMDBScore > 7
and Runtime > 100
and Language in ('English','Spanish');

/* Q2. Find the total number of Netflix Originals in each language, 
but only show those languages that have more than 5 titles.*/


select Language, count(*) as total_titles
from netflix_originals
group by Language
having count(*) > 5
order by total_titles;

/* Q3. Get the top 3 longest-running movies in Hindi language 
sorted by IMDb score in descending order.*/

select * from netflix_originals
where Language = 'Hindi'
order by Runtime desc, IMDBScore desc
limit 3;

/* Q4. Retrieve all titles that contain the word "House" in 
their name and have an IMDb score greater than 6.*/

select Title,IMDBScore
from netflix_originals
where Title like '%House%'
and IMDBScore > 6;

/* Q5. Find all Netflix Originals released between the years 2018 and 
2020 that are in either English, Spanish, or Hindi. */

select * 
from netflix_originals
where year(str_to_date(Premiere_Date, '%d-%m-%Y')) between 2018 and 2020
and Language in ('English','Spanish','Hindi');

/* Q6. Find all movies that either have a runtime less than 
60 minutes or an IMDb score less than 5, sorted by Premiere Date. */

select * 
from netflix_originals
where Runtime < 60 
or IMDBScore < 5
order by str_to_date(Premiere_Date, '%d-%m-%Y');

/* Q7 Get the average IMDb score for each genre 
where the genre has at least 10 movies. */

select avg(IMDBScore) as avg_imdb_score, GenreID, count(*) as total_movies
from netflix_originals
group by GenreID
having count(*) >= 10
order by avg_imdb_score desc;

/* Q8. Retrieve the top 5 most common runtimes for Netflix Originals.*/

select Runtime, count(*) as total_movies
from netflix_originals
group by Runtime
order by total_movies desc
limit 5;

/* Q9. List all Netflix Originals that were released in 2020, grouped by 
language, and show the total count of titles for each language.*/

select Language,
year(str_to_date(Premiere_Date, '%d-%m-%Y')) as premiere_year,
count(Title) as total_titles
from netflix_originals
where year(str_to_date(Premiere_Date, '%d-%m-%Y')) = 2020
group by Language, premiere_year
order by total_titles desc;

/* Q10. Create a new table that enforces a constraint on the IMDb score
 to be between 0 and 10 and the runtime to be greater than 30 minutes.*/
 
 create table netflix_movies(
   Title varchar(255) not null,
   GenreID varchar(10) not null,
   Runtime int check (Runtime > 30), -- runtime is greater than 30.
   IMDB_Score decimal(3,1) check (IMDB_Score between 0 and 10),
   Language varchar(100),
   Premiere_Date date
   );


