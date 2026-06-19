WITH RECURSIVE split_genres(title, genre_piece, remaining_genres) AS (
    SELECT
        "TITLE",
        TRIM(
            CASE
                WHEN INSTR("GENRE", ',') > 0 THEN SUBSTR("GENRE", 1, INSTR("GENRE", ',') - 1)
                ELSE "GENRE"
            END
        ),
        TRIM(
            CASE
                WHEN INSTR("GENRE", ',') > 0 THEN SUBSTR("GENRE", INSTR("GENRE", ',') + 1)
                ELSE ''
            END
        )
    FROM books_raw
    WHERE "TITLE" IS NOT NULL
      AND TRIM("TITLE") <> ''
      AND "STATUS" = 'Completed'
      AND "GENRE" IS NOT NULL
      AND TRIM("GENRE") <> ''

    UNION ALL

    SELECT
        title,
        TRIM(
            CASE
                WHEN INSTR(remaining_genres, ',') > 0 THEN SUBSTR(remaining_genres, 1, INSTR(remaining_genres, ',') - 1)
                ELSE remaining_genres
            END
        ),
        TRIM(
            CASE
                WHEN INSTR(remaining_genres, ',') > 0 THEN SUBSTR(remaining_genres, INSTR(remaining_genres, ',') + 1)
                ELSE ''
            END
        )
    FROM split_genres
    WHERE remaining_genres <> ''
),

new_genres AS (
    SELECT DISTINCT genre_piece
    FROM split_genres
    WHERE genre_piece <> ''
)

INSERT OR IGNORE INTO genres (genre_name)
SELECT genre_piece
FROM new_genres;