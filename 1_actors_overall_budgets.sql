SELECT
	p.id as id,
	p.first_name AS actor_first_name,
	p.last_name AS actor_last_name,
	COALESCE(SUM(m.budget), 0) AS total_budget
FROM
	Person p
	LEFT JOIN Character c ON p.id = c.actor_id
	LEFT JOIN Movie m ON c.movie_id = m.id
GROUP BY
	p.id,
	p.first_name,
	p.last_name
ORDER BY
	id;