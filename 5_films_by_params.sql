SELECT
	m.id AS movie_id,
	m.title,
	m.release_date,
	m.duration,
	m.description,
	json_build_object(
		'id',
		f.id,
		'file_name',
		f.file_name,
		'mime_type',
		f.mime_type,
		'key',
		f.key,
		'url',
		f.url
	) AS poster,
	json_build_object(
		'id',
		p.id,
		'first_name',
		p.first_name,
		'last_name',
		p.last_name
	) AS director
FROM
	Movie m
	JOIN File f ON m.poster_id = f.id
	JOIN Person p ON m.director_id = p.id
	JOIN MovieGenre mg ON m.id = mg.movie_id
	JOIN Genre g ON mg.genre_id = g.id
WHERE
	m.country_id = 1
	AND m.release_date >= '2022-01-01'
	AND m.duration > 135
	AND (
		g.genre_name = 'Action'
		OR g.genre_name = 'Drama'
	)
GROUP BY
	m.id,
	f.id,
	p.id;