use hemz

select count(*) from genre
SELECT year, count(id) as number_of_movies from movies 
Group by 1
select * from movies

SELECT year, country, count(id) as count_movies from movies
WHERE country IN ("USA","India") 
GROUP BY 1,2


SELECT distinct(genre) from genre 
select count(*) from movies

select * from ratings

select month(STR_TO_DATE(date_published, '%m/%d/%Y')) as mnth, count(id) as cnt_mov

from movies

group by mnth

order by mnth 

select genre, count(movie_id) from genre
Group by 1
Order by 2 desc 
limit 1 

select count(movie_id) from (select movie_id, count(*) as count_movies from genre 
group by 1 
having count_movies = 1) as sc 

select g.genre, AVG(m.duration) as Average_Duration from genre g 
JOIN 
movies m 
ON g.movie_id = m.id 
GROUP BY 1 

select * from (select genre, count(movie_id), RANK() over (order by count(movie_id) desc) as rnk from genre 
Group by 1) as tbl 
WHERE genre = "thriller"  

select min(avg_rating) as min_avg_rating, max(avg_rating) as max_avg_rating, min(total_votes) as min_total_votes,
 max(total_votes) as max_total_votes,
min(median_rating) as min_median_rating, max(median_rating) as max_median_rating from ratings 

select m.title as movie_name, r.avg_rating as average_rating from movies m join ratings r
ON m.id = r.movie_id 
order by 2 desc 
limit 10 

select count(m.id), r.median_rating from movies m JOIN ratings r ON m.id = r.movie_id 
GROUP BY 2 
ORDER BY 2 

select m.production_company,count(m.id) from movies m JOIN ratings r ON m.id = r.movie_id
Where r.avg_rating > 8 AND m.production_company IS NOT NULL
GROUP BY 1 
ORDER BY 2 desc 
LIMIT 1
OFFSET 1 



select g.genre,count(m.id) as total_movies

from movies m 
JOIN ratings r 
ON m.id = r.movie_id 
JOIN genre g 
ON g.movie_id = m.id 
where month(STR_TO_DATE(m.date_published, '%m/%d/%Y')) = 3 AND m.year = 2017 AND r.total_votes > 1000 AND m.country = 'USA'

group by 1
ORDER BY 2 DESC 

select g.genre,count(m.id) as total_movies
from movies m 
JOIN ratings r 
ON m.id = r.movie_id 
JOIN genre g 
ON g.movie_id = m.id 
WHERE m.title LIKE 'The%' AND avg_rating > 8
group by 1
ORDER BY 2 DESC 
select * from director_mapping
SELECT g.genre,n.name as director_name,r.avg_rating
from movies m 
JOIN ratings r 
ON m.id = r.movie_id 
JOIN genre g 
ON g.movie_id = m.id  
JOIN director_mapping dm 
ON dm.movie_id = m.id 
JOIN names n 
ON dm.name_id = n.id 
WHERE r.avg_rating > 8  
ORDER BY g.genre DESC, r.avg_rating DESC 
LIMIT 3

Select n.name as actor_name, ROUND(AVG(r.median_rating),2) as avg_median_rating from names n 
JOIN role_mapping rm 
ON n.id = rm.name_id 
JOIN ratings r 
ON rm.movie_id = r.movie_id 
GROUP BY 1 
HAVING  AVG(r.median_rating) >=8
ORDER BY 2 DESC 
LIMIT 2

SELECT m.production_company as prod_company, SUM(r.total_votes) as total_votes from movies m 
JOIN ratings r 
ON m.id =r.movie_id
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 3  


Select n.name as actor_name, ROUND(AVG(r.avg_rating),2) as avg_rating, DENSE_RANK() over (ORDER BY AVG(r.avg_rating) DESC) as Actor_Rank from names n 
JOIN role_mapping rm 
ON n.id = rm.name_id 
JOIN ratings r 
ON rm.movie_id = r.movie_id 
JOIN movies m 
ON m.id= r.movie_id
WHERE m.country = 'India' AND rm.category = 'actor'
GROUP BY 1 
ORDER BY 2 DESC 
 
SELECT actress_name, avg_rating from (Select n.name as actress_name, ROUND(AVG(r.avg_rating),2) as avg_rating, DENSE_RANK() over (ORDER BY AVG(r.avg_rating) DESC) as Actor_Rank from names n 
JOIN role_mapping rm 
ON n.id = rm.name_id 
JOIN ratings r 
ON rm.movie_id = r.movie_id 
JOIN movies m 
ON m.id= r.movie_id
WHERE m.country = 'India' AND rm.category = 'actress' AND m.languages LIKE '%Hindi%'
GROUP BY 1 
ORDER BY 2 DESC) as Temp 
WHERE Actor_Rank <= 5

select * from genre 

SELECT m.title, r.avg_rating, CASE WHEN r.avg_rating > 8 THEN "EXCELLENT"
WHEN r.avg_rating BETWEEN 6 AND 8 THEN "GOOD" ELSE "AVERAGE AND BELOW" END as Classification 
from genre g 
JOIN movies m 
ON g.movie_id = m.id 
JOIN ratings r 
ON r.movie_id = m.id 
WHERE g.genre = "Thriller"

SELECT genre, AVG(m.duration) from genre g 
JOIN movies m 
On g.movie_id = m.id 

SELECT m.title,m.worlwide_gross_income from genre g 
join movies m 
ON g.movie_id = m.id  


WITH top_three_genres AS (

SELECT genre, COUNT(*) AS movie_count

FROM genre

GROUP BY genre

ORDER BY movie_count DESC

LIMIT 3

),

highest_grossing_movies AS (

SELECT m.year, m.title, m.worlwide_gross_income, g.genre,

ROW_NUMBER() OVER (PARTITION BY m.year, g.genre ORDER BY m.worlwide_gross_income DESC) AS `rank`

FROM movie m

INNER JOIN genre g ON m.id = g.movie_id

INNER JOIN top_three_genres t ON g.genre = t.genre

)

SELECT year, genre, title, worlwide_gross_income

FROM highest_grossing_movies

WHERE `rank` <= 5

ORDER BY year, genre, `rank`;

select production_company, count(*) as movie_count
from movies m
JOIN ratings r
ON 
m.id = r.movie_id
WHERE r.avg_rating > 8 and m.production_company IS NOT NULL
Group by 1 
ORDER BY movie_count DESC 
LIMIT 2 
offset 1 

select dm.name_id as director_id, count(m.id) as movie_count, ROUND(AVG(r.avg_rating),1) as avg_rating, SUM(r.total_votes) as total_votes
from movies m
JOIN ratings r
ON 
m.id = r.movie_id 
JOIN genre g 
ON 
m.id = g.movie_id 
JOIN director_mapping dm  
ON 
m.id = dm.movie_id 
JOIN names n
ON 
dm.name_id = n.id 
GROUP BY 1 
ORDER BY 2 DESC, 3 DESC, 4 DESC 
LIMIT 9
