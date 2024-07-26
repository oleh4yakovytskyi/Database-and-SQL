SELECT
	m.id AS id,
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
		p.last_name,
		'photo',
		json_build_object(
			'id',
			pf.id,
			'file_name',
			pf.file_name,
			'mime_type',
			pf.mime_type,
			'key',
			pf.key,
			'url',
			pf.url
		)
	) AS director,
	(
		SELECT
			json_agg(
				json_build_object(
					'id',
					a.id,
					'first_name',
					a.first_name,
					'last_name',
					a.last_name,
					'photo',
					json_build_object(
						'id',
						af.id,
						'file_name',
						af.file_name,
						'mime_type',
						af.mime_type,
						'key',
						af.key,
						'url',
						af.url
					)
				)
			)
		FROM
			Character c
			LEFT JOIN Person a ON c.actor_id = a.id
			LEFT JOIN File af ON a.main_photo_id = af.id
		WHERE
			c.movie_id = m.id
	) AS actors,
	(
		SELECT
			json_agg(
				json_build_object(
					'id',
					g.id,
					'name',
					g.genre_name
				)
			)
		FROM
			MovieGenre mg
			LEFT JOIN Genre g ON mg.genre_id = g.id
		WHERE
			mg.movie_id = m.id
	) AS genres
FROM
	Movie m
	LEFT JOIN File f ON m.poster_id = f.id
	LEFT JOIN Person p ON m.director_id = p.id
	LEFT JOIN File pf ON p.main_photo_id = pf.id
WHERE
	m.id = 1;