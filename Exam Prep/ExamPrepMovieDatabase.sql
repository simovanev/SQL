# 1
CREATE DATABASE softuni_imdb;
USE softuni_imdb;
CREATE TABLE countries
(
    id        INT PRIMARY KEY AUTO_INCREMENT,
    name      VARCHAR(30) NOT NULL UNIQUE,
    continent VARCHAR(30) NOT NULL,
    currency  VARCHAR(5)  NOT NULL

);
CREATE TABLE genres
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL

);
CREATE TABLE actors
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    birthdate  DATE        NOT NULL,
    height     INT,
    awards     INT,
    country_id INT         NOT NULL,
    CONSTRAINT fk_country_actor FOREIGN KEY (country_id)
        REFERENCES countries (id)
);
CREATE TABLE movies_additional_info
(
    id            INT AUTO_INCREMENT PRIMARY KEY,
    rating        DECIMAL(10, 2) NOT NULL,
    runtime       INT            NOT NULL,
    picture_url   VARCHAR(80)    NOT NULL,
    budget        DECIMAL(10, 2),
    release_date  DATE           NOT NULL,
    has_subtitles BOOLEAN,
    description   TEXT

);
CREATE TABLE movies
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    title         VARCHAR(70) UNIQUE NOT NULL,
    country_id    INT                NOT NULL,
    movie_info_id INT                NOT NULL UNIQUE,
    CONSTRAINT fk_movie_country FOREIGN KEY (country_id)
        REFERENCES countries (id),
    CONSTRAINT fk_movie_info FOREIGN KEY (movie_info_id)
        REFERENCES movies_additional_info (id)

);
CREATE TABLE movies_actors
(
    movie_id INT,
    actor_id INT,
    CONSTRAINT fk_movie_movies_actosrs FOREIGN KEY (movie_id)
        REFERENCES movies (id),
    CONSTRAINT fk_actors_movies_actors FOREIGN KEY (actor_id)
        REFERENCES actors (id)

);
CREATE TABLE genres_movies
(
    genre_id INT,
    movie_id INT,
    CONSTRAINT fk_geners_geners_movies FOREIGN KEY (genre_id)
        REFERENCES genres (id),
    CONSTRAINT fk_moovies_movie_id FOREIGN KEY (movie_id)
        REFERENCES movies (id)

);

# 2
INSERT INTO actors(first_name, last_name, birthdate, height, awards, country_id)
SELECT REVERSE(actors.first_name),
       REVERSE(actors.last_name),
       DATE(birthdate - 2),
       actors.height + 10,
       actors.country_id,
       (SELECT id
        FROM countries AS c
        WHERE c.name = 'Armenia')
FROM actors
WHERE id <= 10;

# 3
UPDATE movies_additional_info
SET runtime=runtime - 10
WHERE id BETWEEN 15 AND 25;

# 4
DELETE
FROM countries
WHERE id IN (51, 52, 53);

# 5
SELECT id, name, continent, currency
FROM countries
ORDER BY currency DESC, id;

# 6
SELECT m.id, title, runtime, budget, release_date
FROM movies AS m
         JOIN movies_additional_info mai ON mai.id = m.movie_info_id
WHERE YEAR(release_date) BETWEEN 1996 AND 1999
ORDER BY runtime, m.id
LIMIT 20;

# 7
SELECT CONCAT_WS(' ', first_name, last_name)                      AS full_name,
       CONCAT(REVERSE(last_name), LENGTH(last_name), '@cast.com') AS email,
       (2022 - YEAR(birthdate))                                   AS age,
       height
FROM actors AS a
         LEFT JOIN movies_actors ma ON a.id = ma.actor_id
WHERE movie_id IS NULL
ORDER BY height;

# 8
SELECT name, COUNT(m.id) AS movies_count
FROM countries AS c
         JOIN movies m ON c.id = m.country_id
GROUP BY country_id
HAVING movies_count >= 7
ORDER BY name DESC;

# 9
SELECT title,
       CASE
           WHEN rating <= 4 THEN 'poor'
           WHEN rating <= 7 THEN 'good'
           ELSE 'excellent' END AS rating,
       CASE
           WHEN has_subtitles = 1 THEN 'english'
           ELSE '-' END         AS subtitles,

       mai.budget
FROM movies AS m
         JOIN movies_additional_info mai ON m.movie_info_id = mai.id
ORDER BY budget DESC;

# 10

CREATE FUNCTION udf_actor_history_movies_count(full_name VARCHAR(50))
    RETURNS INT
    DETERMINISTIC
    RETURN (SELECT COUNT(m.id) AS history_movies
            FROM actors AS a
                     JOIN movies_actors ma ON a.id = ma.actor_id
                     JOIN movies m ON m.id = ma.movie_id
                     JOIN genres_movies gm ON m.id = gm.movie_id
                     JOIN genres g ON g.id = gm.genre_id
            WHERE full_name = CONCAT_WS(' ', a.first_name, a.last_name)
            GROUP BY g.name
            HAVING g.name = 'History');



CALL udf_actor_history_movies_count('Jared Di Batista');
DROP PROCEDURE udf_actor_history_movies_count;

# 11
DELIMITER $$
CREATE PROCEDURE udp_award_movie(movie_title VARCHAR(50))
BEGIN
    UPDATE actors as a1
        JOIN movies_actors ma ON a1.id = ma.actor_id
        JOIN movies AS m ON ma.movie_id = m.id
    SET awards = awards + 1
    WHERE m.title = movie_title;
END $$

DELIMITER ;
SELECT awards
FROM actors AS a
         JOIN movies_actors ma ON a.id = ma.actor_id
         JOIN movies AS m ON ma.movie_id = m.id
WHERE m.title = 'Tea For Two';
DROP PROCEDURE udp_award_movie;
CALL udp_award_movie('Tea For Two');