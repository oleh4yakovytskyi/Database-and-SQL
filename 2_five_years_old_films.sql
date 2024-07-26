SELECT
	m.title as movie_title,
	m.release_date as release_date,
	COUNT(DISTINCT c.actor_id) as actor_count
FROM
	Movie m
	LEFT JOIN Character c ON m.id = c.movie_id
WHERE
	m.release_date >= CURRENT_DATE - INTERVAL '5 years'
GROUP BY
	m.id,
	m.title,
	m.release_date;