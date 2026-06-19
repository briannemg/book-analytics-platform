WITH RECURSIVE split_moods(raw_row_id, mood_piece, remaining_moods) AS (
    SELECT
        rowid,
        TRIM(CASE WHEN INSTR("MOOD / VIBE", ',') > 0 THEN SUBSTR("MOOD / VIBE", 1, INSTR("MOOD / VIBE", ',') - 1) ELSE "MOOD / VIBE" END),
        TRIM(CASE WHEN INSTR("MOOD / VIBE", ',') > 0 THEN SUBSTR("MOOD / VIBE", INSTR("MOOD / VIBE", ',') + 1) ELSE '' END)
    FROM books_raw
    WHERE "TITLE" IS NOT NULL
      AND TRIM("TITLE") <> ''
      AND "STATUS" = 'Completed'
      AND "MOOD / VIBE" IS NOT NULL
      AND TRIM("MOOD / VIBE") <> ''

    UNION ALL

    SELECT
        raw_row_id,
        TRIM(CASE WHEN INSTR(remaining_moods, ',') > 0 THEN SUBSTR(remaining_moods, 1, INSTR(remaining_moods, ',') - 1) ELSE remaining_moods END),
        TRIM(CASE WHEN INSTR(remaining_moods, ',') > 0 THEN SUBSTR(remaining_moods, INSTR(remaining_moods, ',') + 1) ELSE '' END)
    FROM split_moods
    WHERE remaining_moods <> ''
)

INSERT OR IGNORE INTO book_moods (book_id, mood_id)
SELECT
    b.book_id,
    m.mood_id
FROM split_moods sm
JOIN books b
    ON b.raw_row_id = sm.raw_row_id
JOIN moods m
    ON m.mood_name = sm.mood_piece
WHERE sm.mood_piece <> '';