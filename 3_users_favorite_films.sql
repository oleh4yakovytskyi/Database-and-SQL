SELECT
	u.id AS user_id,
	u.username,
	ARRAY_AGG(fm.movie_id) AS favorite_movies
FROM
	Users u
	LEFT JOIN FavoriteMovie fm ON u.id = fm.user_id
GROUP BY
	u.id,
	u.username;