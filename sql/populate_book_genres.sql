WITH RECURSIVE split_genres(raw_row_id, genre_piece, remaining_genres) AS (
    SELECT
        rowid,
        TRIM(CASE WHEN INSTR("GENRE", ',') > 0 THEN SUBSTR("GENRE", 1, INSTR("GENRE", ',') - 1) ELSE "GENRE" END),
        TRIM(CASE WHEN INSTR("GENRE", ',') > 0 THEN SUBSTR("GENRE", INSTR("GENRE", ',') + 1) ELSE '' END)
    FROM books_raw
    WHERE "TITLE" IS NOT NULL
      AND TRIM("TITLE") <> ''
      AND "STATUS" = 'Completed'
      AND "GENRE" IS NOT NULL
      AND TRIM("GENRE") <> ''

    UNION ALL

    SELECT
        raw_row_id,
        TRIM(CASE WHEN INSTR(remaining_genres, ',') > 0 THEN SUBSTR(remaining_genres, 1, INSTR(remaining_genres, ',') - 1) ELSE remaining_genres END),
        TRIM(CASE WHEN INSTR(remaining_genres, ',') > 0 THEN SUBSTR(remaining_genres, INSTR(remaining_genres, ',') + 1) ELSE '' END)
    FROM split_genres
    WHERE remaining_genres <> ''
)

INSERT OR IGNORE INTO book_genres (book_id, genre_id)
SELECT
    b.book_id,
    g.genre_id
FROM split_genres sg
JOIN books b
    ON b.raw_row_id = sg.raw_row_id
JOIN genres g
    ON g.genre_name = sg.genre_piece
WHERE sg.genre_piece <> '';