CREATE TABLE File (
	id SERIAL PRIMARY KEY,
	file_name VARCHAR(255) NOT NULL,
	mime_type VARCHAR(255) NOT NULL,
	key VARCHAR(255) NOT NULL,
	url VARCHAR(255) NOT NULL,
	createdAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
	updatedAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Users (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	username VARCHAR(255) UNIQUE NOT NULL,
	email VARCHAR(255) UNIQUE NOT NULL,
	password VARCHAR(50) NOT NULL,
	avatar_id INT,
	createdAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
	updatedAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (avatar_id) REFERENCES File(id)
);

CREATE TABLE Country (
	id SERIAL PRIMARY KEY,
	country_name VARCHAR(255) NOT NULL
);

CREATE TABLE Person (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	biography TEXT,
	date_of_birth DATE,
	gender VARCHAR(50) CHECK (gender IN ('male', 'female', 'other')),
	country_id INT NOT NULL,
	main_photo_id INT,
	createdAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
	updatedAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (country_id) REFERENCES Country(id),
	FOREIGN KEY (main_photo_id) REFERENCES File(id)
);

CREATE TABLE Movie (
	id SERIAL PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	description TEXT,
	budget DECIMAL(18, 2),
	release_date DATE,
	duration INT,
	country_id INT NOT NULL,
	director_id INT NOT NULL,
	poster_id INT,
	createdAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
	updatedAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (country_id) REFERENCES Country(id),
	FOREIGN KEY (director_id) REFERENCES Person(id),
	FOREIGN KEY (poster_id) REFERENCES File(id)
);

CREATE TYPE character_role AS ENUM ('leading', 'supporting', 'background');

CREATE TABLE Character (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	description TEXT,
	role character_role,
	movie_id INT NOT NULL,
	actor_id INT NOT NULL,
	createdAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
	updatedAt TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (movie_id) REFERENCES Movie(id),
	FOREIGN KEY (actor_id) REFERENCES Person(id)
);

CREATE TABLE SideCharacter (
	id SERIAL PRIMARY KEY,
	movie_id INT NOT NULL,
	actor_id INT NOT NULL,
	FOREIGN KEY (movie_id) REFERENCES Movie(id),
	FOREIGN KEY (actor_id) REFERENCES Person(id)
);

CREATE TABLE PersonPhoto (
	id SERIAL PRIMARY KEY,
	person_id INT NOT NULL,
	file_id INT NOT NULL,
	FOREIGN KEY (person_id) REFERENCES Person(id),
	FOREIGN KEY (file_id) REFERENCES File(id)
);

CREATE TABLE FavoriteMovie (
	id SERIAL PRIMARY KEY,
	user_id INT,
	movie_id INT,
	FOREIGN KEY (user_id) REFERENCES Users(id),
	FOREIGN KEY (movie_id) REFERENCES Movie(id)
);

CREATE TABLE Genre (
	id SERIAL PRIMARY KEY,
	genre_name VARCHAR(255) NOT NULL
);

CREATE TABLE MovieGenre (
	id SERIAL PRIMARY KEY,
	movie_id INT NOT NULL,
	genre_id INT NOT NULL,
	FOREIGN KEY (movie_id) REFERENCES Movie(id),
	FOREIGN KEY (genre_id) REFERENCES Genre(id)
);

CREATE
OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS $ $ BEGIN NEW.updatedAt = NOW();

RETURN NEW;

END;

$ $ LANGUAGE plpgsql;

CREATE TRIGGER update_file_before_update BEFORE
UPDATE
	ON File FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_user_before_update BEFORE
UPDATE
	ON Users FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_person_before_update BEFORE
UPDATE
	ON Person FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_movie_before_update BEFORE
UPDATE
	ON Movie FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_character_before_update BEFORE
UPDATE
	ON Character FOR EACH ROW EXECUTE FUNCTION update_timestamp();