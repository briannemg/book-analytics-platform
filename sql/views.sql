/*
==========================================================
TABLEAU-READY VIEWS
Purpose:
Reusable SQL views for Tableau dashboard development.
==========================================================
*/

-- ========================================================
-- 1. Yearly Reading Summary
-- ========================================================

DROP VIEW IF EXISTS yearly_reading_summary;

CREATE VIEW yearly_reading_summary AS
SELECT
    year_read,
    COUNT(*) AS books_read,
    SUM(pages) AS pages_read,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(days_read), 1) AS avg_days_read,
    ROUND(AVG(pages_per_day), 1) AS avg_pages_per_day
FROM books
WHERE year_read IS NOT NULL
GROUP BY year_read;

-- ========================================================
-- 2. Source Summary
-- ========================================================

DROP VIEW IF EXISTS source_summary;

CREATE VIEW source_summary AS
SELECT
    s.source_name,
    COUNT(*) AS books,
    ROUND(AVG(b.rating), 2) AS avg_rating
FROM books b
JOIN sources s
    ON b.source_id = s.source_id
WHERE b.rating IS NOT NULL
GROUP BY s.source_name;

-- ========================================================
-- 3. Format Summary
-- ========================================================

DROP VIEW IF EXISTS format_summary;

CREATE VIEW format_summary AS
SELECT
    f.format_name,
    COUNT(*) AS books,
    ROUND(AVG(b.rating), 2) AS avg_rating
FROM books b
JOIN formats f
    ON b.format_id = f.format_id
WHERE b.rating IS NOT NULL
GROUP BY f.format_name;

-- ========================================================
-- 4. Genre Summary
-- ========================================================

DROP VIEW IF EXISTS genre_summary;

CREATE VIEW genre_summary AS
SELECT
    g.genre_name,
    COUNT(*) AS books,
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
GROUP BY g.genre_name;

-- ========================================================
-- 5. Mood Summary
-- ========================================================

DROP VIEW IF EXISTS mood_summary;

CREATE VIEW mood_summary AS
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
GROUP BY m.mood_name;

-- ========================================================
-- 6. Author Summary
-- ========================================================

DROP VIEW IF EXISTS author_summary;

CREATE VIEW author_summary AS
SELECT
    a.author_name,
    COUNT(*) AS books,
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
GROUP BY a.author_name;

-- ========================================================
-- 7. Rating Distribution
-- ========================================================

DROP VIEW IF EXISTS rating_distribution;

CREATE VIEW rating_distribution AS
SELECT
    rating,
    COUNT(*) AS books
FROM books
WHERE rating IS NOT NULL
GROUP BY rating;

-- ========================================================
-- 8. Reading Behavior Summary
-- ========================================================

DROP VIEW IF EXISTS reading_behavior_summary;

CREATE VIEW reading_behavior_summary AS
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
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(pages), 0) AS avg_pages,
    ROUND(AVG(pages_per_day), 1) AS avg_pages_per_day
FROM books
WHERE pages IS NOT NULL
  AND pages_per_day IS NOT NULL
  AND rating IS NOT NULL
GROUP BY length_bucket, speed_bucket;

-- ========================================================
-- 9. Monthly Reading Summary
-- ========================================================

DROP VIEW IF EXISTS monthly_reading_summary;

CREATE VIEW monthly_reading_summary AS
SELECT
    STRFTIME('%m', finish_date) AS finish_month,
    COUNT(*) AS books,
    SUM(pages) AS pages_read,
    ROUND(AVG(rating), 2) AS avg_rating
FROM books
WHERE finish_date IS NOT NULL
GROUP BY finish_month;

-- ========================================================
-- 10. Book Detail View
-- ========================================================

DROP VIEW IF EXISTS book_detail;

CREATE VIEW book_detail AS
SELECT
    b.book_id,
    b.title,
    b.pages,
    b.publication_year,
    b.rating,
    b.start_date,
    b.finish_date,
    b.year_read,
    b.days_read,
    b.pages_per_day,
    b.reread,
    s.source_name,
    f.format_name,
    st.status_name,
    se.series_name,
    b.book_number
FROM books b
LEFT JOIN sources s
    ON b.source_id = s.source_id
LEFT JOIN formats f
    ON b.format_id = f.format_id
LEFT JOIN statuses st
    ON b.status_id = st.status_id
LEFT JOIN series se
    ON b.series_id = se.series_id;