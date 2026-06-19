/*
==========================================================
validation_checks.sql

Purpose:
Manual validation and QA checks for database integrity.

This script is NOT run automatically by build_database.py.

Run manually after schema changes, ETL changes,
or when debugging data quality issues.

Expected:
- No missing foreign keys
- No orphaned relationships
- No duplicate raw imports
==========================================================
*/

-- Row counts

SELECT COUNT(*) AS books_count
FROM books;

SELECT COUNT(*) AS authors_count
FROM authors;

SELECT COUNT(*) AS book_author_links
FROM book_authors;

SELECT COUNT(*) AS genres_count
FROM genres;

SELECT COUNT(*) AS book_genre_links
FROM book_genres;

SELECT COUNT(*) AS moods_count
FROM moods;

SELECT COUNT(*) AS book_mood_links
FROM book_moods;

SELECT COUNT(*) AS series_count
FROM series;

-- Check books missing relationships

SELECT COUNT(*) AS books_missing_authors
FROM books b
LEFT JOIN book_authors ba
    ON b.book_id = ba.book_id
WHERE ba.author_id IS NULL;

SELECT COUNT(*) AS books_missing_genres
FROM books b
LEFT JOIN book_genres bg
    ON b.book_id = bg.book_id
WHERE bg.genre_id IS NULL;

SELECT COUNT(*) AS books_missing_moods
FROM books b
LEFT JOIN book_moods bm
    ON b.book_id = bm.book_id
WHERE bm.mood_id IS NULL;

-- Rating distribution

SELECT
    rating,
    COUNT(*) AS count
FROM books
GROUP BY rating
ORDER BY rating;

-- Source distribution

SELECT
    s.source_name,
    COUNT(*) AS books
FROM books b
JOIN sources s
    ON b.source_id = s.source_id
GROUP BY s.source_name
ORDER BY books DESC;

-- Check for duplicate raw row imports
SELECT
    raw_row_id,
    COUNT(*) AS count
FROM books
GROUP BY raw_row_id
HAVING COUNT(*) > 1;

-- Check for duplicate title/year/read combinations

SELECT
    title,
    year_read,
    start_date,
    finish_date,
    COUNT(*) AS count
FROM books
GROUP BY title, year_read, start_date, finish_date
HAVING COUNT(*) > 1;

-- Check for books with missing lookup values

SELECT COUNT(*) AS books_missing_source
FROM books
WHERE source_id is NULL;

SELECT COUNT(*) AS books_missing_format
FROM books
WHERE format_id IS NULL;

SELECT COUNT(*) AS books_missing_status
FROM books
WHERE status_id IS NULL;