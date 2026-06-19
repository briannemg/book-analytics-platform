WITH RECURSIVE split_authors(title, author_piece, remaining_authors) AS (
    SELECT
        title,
        TRIM(
            CASE
                WHEN INSTR(author, ',') > 0 THEN SUBSTR(author, 1, INSTR(author, ',') - 1)
                ELSE author
            END
        ) AS author_piece,
        TRIM(
            CASE
                WHEN INSTR(author, ',') > 0 THEN SUBSTR(author, INSTR(author, ',') + 1)
                ELSE ''
            END
        ) AS remaining_authors
    FROM books_raw
    WHERE title IS NOT NULL
      AND TRIM(title) <> ''
      AND "STATUS" = 'Completed'
      AND author IS NOT NULL
      AND TRIM(author) <> ''

    UNION ALL

    SELECT
        title,
        TRIM(
            CASE
                WHEN INSTR(remaining_authors, ',') > 0 THEN SUBSTR(remaining_authors, 1, INSTR(remaining_authors, ',') -1)
                ELSE remaining_authors
            END
        ) AS author_piece,
        TRIM(
            CASE
                WHEN INSTR(remaining_authors, ',') > 0 THEN SUBSTR(remaining_authors, INSTR(remaining_authors, ',') + 1)
                ELSE ''
            END
        ) AS remaining_authors
    FROM split_authors
    WHERE remaining_authors <> ''
)

INSERT OR IGNORE INTO authors (author_name)
SELECT DISTINCT author_piece
FROM split_authors
WHERE author_piece <> '';