
SELECT * FROM netflix;

--1. count the number of movies vs TV show

SELECT type,
COUNT (*) AS total_count
FROM netflix
GROUP BY type
ORDER BY total_count DESC;

---2. find the most common rating for movies and tv shows
WITH RatingCounts AS (
    SELECT type, rating, COUNT(*) AS t_count,
           ROW_NUMBER() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rn
    FROM netflix
    GROUP BY rating, type
)
SELECT type, rating, t_count
FROM RatingCounts
WHERE rn = 1;

SELECT
    type, rating
FROM 
(
    SELECT
        type, rating, COUNT(*) AS count_rating,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY type, rating
) AS t1
WHERE ranking = 1;

---3. list all movies released in a specific year (2020)

SELECT * FROM netflix
WHERE type IN('movie') AND  release_year IN ('2020');

--4. find the top 5 countries with the most content on netflix
SELECT TOP 5 
    TRIM(value) AS country, 
    COUNT(*) AS number_of_content
FROM netflix
CROSS APPLY STRING_SPLIT(country, ',')
GROUP BY TRIM(value)
ORDER BY number_of_content DESC;

--5. identify the longest movie
SELECT TOP 1 duration,type
FROM netflix
WHERE type in('movie')
ORDER BY duration DESC;

SELECT TOP 1
    title, duration
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(REPLACE(duration, ' min', '') AS INT) DESC;

--6. find content add in last 5 year
SELECT title, date_added
FROM netflix
WHERE date_added IS NOT NULL
AND CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE())
ORDER BY date_added DESC;

--7. find all the movie/tv shows by director 'rajiv chilaka'
SELECT * FROM 
netflix
WHERE director like '%Rajiv chilaka%';

--8. list all tv shows with more than 5 seasons

SELECT * FROM 
netflix
WHERE type = 'tv show' AND CAST(REPLACE(REPLACE(duration, ' Season', ''), 's', '') AS INT) > 5;

--9. count the number of content in each genere

SELECT 
    TRIM(value) AS listed_in, 
    COUNT(*) AS number_of_content
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY TRIM(value)
ORDER BY number_of_content DESC;

--10. List all the movies that are documentaries

SELECT count(*) as total_number_of_content
FROM netflix
WHERE type = 'Movie'
AND listed_in LIKE '%Documentaries%';

--11. Find all the content without a director

SELECT count(*) as total_number_of_content
FROM netflix
where director is null;

--12. Find how many movies actor 'salman khan' appeared in last 10 year

SELECT COUNT(*) AS total_number_of_content
FROM netflix
WHERE date_added IS NOT NULL 
AND type = 'Movie'
AND CAST(date_added AS DATE) >= DATEADD(YEAR, -10, GETDATE())
AND cast LIKE '%Salman Khan%';


