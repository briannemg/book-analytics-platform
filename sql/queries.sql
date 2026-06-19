/*
==========================================================
READING ANALYTICS QUERIES
Purpose:
Exploratory SQL queries used to analyze reading history
and support Tableau dashboard development.
==========================================================
*/

-- ========================================================
-- 1. Reading Volume Trends
-- ========================================================

-- Books read by year

SELECT
    year_read,
    COUNT(*) AS books_read
FROM books
WHERE year_read IS NOT NULL
GROUP BY year_read
ORDER BY year_read;

-- Pages read by year

SELECT
    year_read,
    SUM(pages) AS pages_read
FROM books
WHERE year_read IS NOT NULL
GROUP BY year_read
ORDER BY year_read;

-- Average rating by year

SELECT
    year_read,
    ROUND(AVG(rating), 2) AS avg_rating
FROM books
WHERE year_read IS NOT NULL
  AND rating IS NOT NULL
GROUP BY year_read
ORDER BY year_read;

-- Average reading speed by year

SELECT
    year_read,
    ROUND(AVG(pages_per_day), 1) AS avg_pages_per_day
FROM books
WHERE year_read IS NOT NULL
  AND pages_per_day IS NOT NULL
GROUP BY year_read
ORDER BY year_read;


-- ========================================================
-- 2. Source and Format Analysis
-- ========================================================

-- Books by source
SELECT
    s.source_name,
    COUNT(*) AS books
FROM books b
JOIN sources s
    ON b.source_id = s.source_id
GROUP BY s.source_name
ORDER BY books DESC;

-- Books by format

SELECT
    f.format_name,
    COUNT(*) AS books
FROM books b
JOIN formats f
    ON b.format_id = f.format_id
GROUP BY f.format_name
ORDER BY books DESC;

-- Average rating by source

SELECT
    s.source_name,
    COUNT(*) AS books,
    ROUND(AVG(b.rating), 2) AS avg_rating
FROM books b
JOIN sources s
    ON b.source_id = s.source_id
WHERE b.rating IS NOT NULL
GROUP BY s.source_name
ORDER BY avg_rating DESC, books DESC;


-- ========================================================
-- 3. Author Analysis
-- ========================================================

-- Most-read authors

SELECT
    a.author_name,
    COUNT(*) AS books_read
FROM books b
JOIN book_authors ba
    ON b.book_id = ba.book_id
JOIN authors a
    ON ba.author_id = a.author_id
GROUP BY a.author_name
ORDER BY books_read DESC, a.author_name;

-- Highest-rated authors, minimum 2 books

SELECT
    a.author_name,
    COUNT(*) AS books_read,
    ROUND(AVG(b.rating), 2) AS avg_rating
FROM books b
JOIN book_authors ba
    ON b.book_id = ba.book_id
JOIN authors a
    ON ba.author_id = a.author_id
WHERE b.rating IS NOT NULL
GROUP BY a.author_name
HAVING COUNT(*) >= 2
ORDER BY avg_rating DESC, books_read DESC;

-- ========================================================
-- 4. Genre Analysis
-- ========================================================

-- Most-read genres

SELECT
    g.genre_name,
    COUNT(*) AS books_read
FROM books b
JOIN book_genres bg
    ON b.book_id = bg.book_id
JOIN genres g
    ON bg.genre_id = g.genre_id
GROUP BY g.genre_name
ORDER BY books_read DESC, g.genre_name;

-- Highest-rated genres, minimum 3 books

SELECT
    g.genre_name,
    COUNT(*) AS books_read,
    ROUND(AVG(b.rating), 2) AS avg_rating
FROM books b
JOIN book_genres bg
    ON b.book_id = bg.book_id
JOIN genres g
    ON bg.genre_id = g.genre_id
WHERE b.rating IS NOT NULL
GROUP BY g.genre_name
HAVING COUNT(*) >= 3
ORDER BY avg_rating DESC, books_read DESC;


-- ========================================================
-- 5. Mood Analysis
-- ========================================================

-- Most common moods

SELECT
    m.mood_name,
    COUNT(*) AS books
FROM books b
JOIN book_moods bm
    ON b.book_id = bm.book_id
JOIN moods m
    ON bm.mood_id = m.mood_id
GROUP BY m.mood_name
ORDER BY books DESC, m.mood_name;

-- Highest-rated moods, minimum 3 books

SELECT
    m.mood_name,
    COUNT(*) AS books,
    ROUND(AVG(b.rating), 2) AS avg_rating
FROM books b
JOIN book_moods bm
    ON b.book_id = bm.book_id
JOIN moods m
    ON bm.mood_id = m.mood_id
WHERE b.rating IS NOT NULL
GROUP BY m.mood_name
HAVING COUNT(*) >= 3
ORDER BY avg_rating DESC, books DESC;


-- ========================================================
-- 6. Reading Behavior
-- ========================================================

-- Fastest reads

SELECT
    title,
    pages,
    days_read,
    pages_per_day,
    rating
FROM books
WHERE pages_per_day IS NOT NULL
ORDER BY pages_per_day DESC
LIMIT 10;

-- Longest books

SELECT
    title,
    pages,
    rating,
    year_read
FROM books
WHERE pages IS NOT NULL
ORDER BY pages DESC
LIMIT 10;

-- Reading speed bucket vs rating

SELECT
    CASE
        WHEN pages_per_day < 20 THEN 'Slow'
        WHEN pages_per_day < 50 THEN 'Moderate'
        ELSE 'Fast'
    END AS reading_speed,
    COUNT(*) AS books,
    ROUND(AVG(rating), 2) AS avg_rating
FROM books
WHERE pages_per_day IS NOT NULL
  AND rating IS NOT NULL
GROUP BY reading_speed
ORDER BY avg_rating DESC;

-- Length bucket vs rating

SELECT
    CASE
        WHEN pages < 300 THEN 'Short'
        WHEN pages < 450 THEN 'Medium'
        ELSE 'Long'
    END AS length_bucket,
    COUNT(*) AS books,
    ROUND(AVG(rating), 2) AS avg_rating
FROM books
WHERE pages IS NOT NULL
  AND rating IS NOT NULL
GROUP BY length_bucket
ORDER BY avg_rating DESC;


-- ========================================================
-- 7. Rating Distribution
-- ========================================================

-- Rating counts

SELECT
    rating,
    COUNT(*) AS books
FROM books
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY rating;


-- ========================================================
-- 8. Reread Analysis
-- ========================================================

-- Rereads by year

SELECT
    year_read,
    COUNT(*) AS rereads
FROM books
WHERE reread = 1
GROUP BY year_read
ORDER BY year_read;

-- Reread ratings vs first-read ratings

SELECT
    CASE
        WHEN reread = 1 THEN 'Reread'
        ELSE 'First read'
    END AS read_type,
    COUNT(*) AS books,
    ROUND(AVG(rating), 2) AS avg_rating
FROM books
WHERE rating IS NOT NULL
GROUP BY read_type;


-- ========================================================
-- 9. Confidence-Weighted Rankings
-- ========================================================

-- Confidence-weighted author ranking, minimum 2 books

SELECT
    a.author_name,
    COUNT(*) AS books_read,
    ROUND(AVG(b.rating), 2) AS avg_rating,
    ROUND(
        (AVG(b.rating) * COUNT(*)) / (COUNT(*) + 2),
        2
    ) AS weighted_score
FROM books b
JOIN book_authors ba
    ON b.book_id = ba.book_id
JOIN authors a
    ON ba.author_id = a.author_id
WHERE b.rating IS NOT NULL
GROUP BY a.author_name
HAVING COUNT(*) >= 2
ORDER BY weighted_score DESC, books_read DESC;

-- Confidence-weighted genre rankings, minimum 3 books

SELECT
    g.genre_name,
    COUNT(*) AS books_read,
    ROUND(AVG(b.rating), 2) AS avg_rating,
    ROUND(
        (AVG(b.rating) * COUNT(*)) / (COUNT(*) + 2),
        2
    ) AS weighted_score
FROM books b
JOIN book_genres bg
    ON b.book_id = bg.book_id
JOIN genres g
    ON bg.genre_id = g.genre_id
WHERE b.rating IS NOT NULL
GROUP BY g.genre_name
HAVING COUNT(*) >= 3
ORDER BY weighted_score DESC, books_read DESC;

-- Confidence-weighted mood rankings, minimum 3 books

SELECT
    m.mood_name,
    COUNT(*) AS books,
    ROUND(AVG(b.rating), 2) AS avg_rating,
    ROUND(
        (AVG(b.rating) * COUNT(*)) / (COUNT(*) + 2),
        2
    ) AS weighted_score
FROM books b
JOIN book_moods bm
    ON b.book_id = bm.book_id
JOIN moods m
    ON bm.mood_id = m.mood_id
WHERE b.rating IS NOT NULL
GROUP BY m.mood_name
HAVING COUNT(*) >= 3
ORDER BY weighted_score DESC, books DESC;

-- ========================================================
-- 10. Length and Pace Analysis
-- ========================================================

-- Average book length by rating

SELECT
    rating,
    COUNT(*) AS books,
    ROUND(AVG(pages), 0) AS avg_pages
FROM books
WHERE rating IS NOT NULL
  AND pages IS NOT NULL
GROUP BY rating
ORDER BY rating DESC;

-- Average reading speed by rating

SELECT
    rating,
    COUNT(*) AS books,
    ROUND(AVG(pages_per_day), 1) AS avg_pages_per_day
FROM books
WHERE rating IS NOT NULL
  AND pages_per_day IS NOT NULL
GROUP BY rating
ORDER BY rating DESC;

-- Length and speed pattern analysis

SELECT
    CASE
        WHEN pages < 300 THEN 'Short'
        WHEN pages < 450 THEN 'Medium'
        ELSE 'Long'
    END AS length_bucket,
    CASE
        WHEN pages_per_day < 20 THEN 'Slow'
        WHEN pages_per_day < 50 THEN 'Moderate'
        ELSE 'Fast'
    END AS speed_bucket,
    COUNT(*) AS books,
    ROUND(AVG(rating), 2) AS avg_rating
FROM books
WHERE pages IS NOT NULL
  AND pages_per_day IS NOT NULL
  AND rating IS NOT NULL
GROUP BY length_bucket, speed_bucket
ORDER BY avg_rating DESC, books DESC;

-- ========================================================
-- 11. Seasonal Reading Trends
-- ========================================================

-- Books completed by month

SELECT
    STRFTIME('%m', finish_date) AS month,
    COUNT(*) AS books_read
FROM books
WHERE finish_date IS NOT NULL
GROUP BY month
ORDER BY month;

-- Average rating by finish month

SELECT
    STRFTIME('%m', finish_date) AS month,
    COUNT(*) AS books,
    ROUND(AVG(rating), 2) AS avg_rating
FROM books
WHERE finish_date IS NOT NULL
  AND rating IS NOT NULL
GROUP BY month
ORDER BY month;

-- ========================================================
-- 12. Series Analysis
-- ========================================================

-- Series statistics

SELECT
    se.series_name,
    COUNT(*) AS books_read,
    ROUND(AVG(b.rating), 2) AS avg_rating
FROM books b
JOIN series se
    ON b.series_id = se.series_id
WHERE b.series_id IS NOT NULL
GROUP BY se.series_name
ORDER BY books_read DESC, avg_rating DESC;