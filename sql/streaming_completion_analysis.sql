CREATE DATABASE streaming_platform;

CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	country TEXT,
	signup_date DATE
);

SELECT * FROM users;

INSERT INTO users (country, signup_date) VALUES
('UK', '2025-01-10'),
('UK', '2025-02-03'),
('US', '2025-01-22'),
('CA', '2025-03-05');

SELECT * FROM users;

SELECT country, COUNT(*) AS users_per_country
FROM users
GROUP BY country;

CREATE TABLE shows (
	show_id SERIAL PRIMARY KEY,
	title TEXT,
	genre TEXT,
	release_year INT
);

INSERT INTO shows (title, genre, release_year) VALUES
('The Crown', 'Drama', 2016),
('Stranger Things', 'Sci-Fi', 2016),
('Breaking Bad', 'Crime', 2008),
('The Witcher', 'Fantasy', 2019);

SELECT * FROM shows;

CREATE TABLE episodes (
	epsiode_id SERIAL PRIMARY KEY,
	show_id INT REFERENCES shows(show_id),
	episode_number INT,
	title TEXT,
	duration_minutes INT
);

INSERT INTO episodes (show_id, episode_number, title, duration_minutes) VALUES
(1, 1, 'Wolferton Splash', 60),
(1, 2, 'Hyde Park Corner', 58),
(2, 1, 'The Vanishing of Will Byers', 50),
(2, 2, 'The Weirdo on Maple Street', 52),
(3, 1, 'Pilot', 58),
(3, 2, 'Cat’s in the Bag...', 48),
(4, 1, 'The End’s Beginning', 60),
(4, 2, 'Four Marks', 59);

SELECT * FROM episodes;

CREATE TABLE views (
	view_id SERIAL PRIMARY KEY,
	user_id INT REFERENCES users(user_id),
	epsiode_id INT REFERENCES episodes(epsiode_id),
	watched_minutes INT,
	view_date DATE
);	

INSERT INTO views (user_id, epsiode_id, watched_minutes, view_date) VALUES
(1, 1, 60, '2025-12-01'),
(1, 2, 58, '2025-12-02'),
(2, 3, 50, '2025-12-01'),
(2, 4, 30, '2025-12-02'),
(3, 5, 58, '2025-12-01'),
(3, 6, 20, '2025-12-02'),
(4, 7, 60, '2025-12-01'),
(4, 8, 59, '2025-12-02');

SELECT * FROM views;

SELECT s.title, SUM(v.watched_minutes) AS total_minutes_watched
FROM views v
JOIN episodes e ON v.epsiode_id = e.epsiode_id
JOIN shows s ON e.show_id = s.show_id
GROUP BY s.title
ORDER BY total_minutes_watched DESC;

SELECT show_id, COUNT(*) AS total_episodes
FROM episodes
GROUP BY show_id;

SELECT v.user_id, e.show_id, COUNT(DISTINCT e.epsiode_id) AS episodes_watched
FROM views v
JOIN episodes e ON v.epsiode_id = e.epsiode_id
GROUP BY v.user_id, e.show_id;

WITH episode_counts AS (
	SELECT show_id, COUNT(*) AS total_episodes
	FROM episodes
	GROUP BY show_id
),
user_progress AS (
	SELECT v.user_id, e.show_id, COUNT(DISTINCT e.epsiode_id) AS episodes_watched
	FROM views v
	JOIN episodes e ON v.epsiode_id = e.epsiode_id
	GROUP BY v.user_id, e.show_id
)
SELECT u.user_id, s.title
FROM user_progress u
JOIN episode_counts ec ON u.show_id = ec.show_id
JOIN shows s ON u.show_id = s.show_id
WHERE u.episodes_watched = ec.total_episodes;

SELECT e.title AS episodes_title,
	s.title AS show_title,
	AVG(v.watched_minutes) AS avg_watched
FROM views v
JOIN episodes e ON v.epsiode_id = e.epsiode_id
JOIN shows s ON e.show_id = s.show_id
GROUP BY e.epsiode_id, e.title, s.title
HAVING AVG(v.watched_minutes) < 50
ORDER BY avg_watched ASC;

SELECT s.genre,
	SUM(v.watched_minutes) AS total_watch_time
FROM views v
JOIN episodes e ON v.epsiode_id = e.epsiode_id
JOIN shows s ON e.show_id = s.show_id
GROUP BY s.genre
ORDER BY total_watch_time DESC;

SELECT u.user_id, u.signup_date
FROM users u
LEFT JOIN views v ON u.user_id = v.user_id
WHERE v.view_id IS NULL;

SELECT user_id, COUNT (*) AS total_views
FROM views
GROUP BY user_id
HAVING COUNT (*) > 1;

SELECT show_id, COUNT (*) AS total_episodes
FROM episodes
GROUP BY show_id;

SELECT user_id, show_id, COUNT (DISTINCT e.epsiode_id) AS episodes_watched
FROM views v
JOIN episodes e ON v.epsiode_id = e.epsiode_id
GROUP BY v.user_id, e.show_id;

WITH total_episodes AS (
    SELECT show_id, COUNT(*) AS total
    FROM episodes
    GROUP BY show_id
),
user_progress AS (
    SELECT v.user_id,
           e.show_id,
           COUNT(DISTINCT e.epsiode_id) AS watched
    FROM views v
    JOIN episodes e ON v.epsiode_id = e.epsiode_id
    GROUP BY v.user_id, e.show_id
)
SELECT s.title,
       COUNT(DISTINCT up.user_id) AS users_not_finished
FROM user_progress up
JOIN total_episodes te ON up.show_id = te.show_id
JOIN shows s ON up.show_id = s.show_id
WHERE up.watched < te.total
GROUP BY s.title
ORDER BY users_not_finished DESC;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'episodes';

ALTER TABLE episodes
RENAME COLUMN epsiode_id TO episode_id;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'views';

ALTER TABLE views
RENAME COLUMN epsiode_id TO episode_id;

