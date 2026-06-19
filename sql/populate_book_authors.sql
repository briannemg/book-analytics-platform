WITH RECURSIVE split_authors(raw_row_id, author_piece, remaining_authors, author_order) AS (
    SELECT
        rowid,
        TRIM(CASE WHEN INSTR("AUTHOR", ',') > 0 THEN SUBSTR("AUTHOR", 1, INSTR("AUTHOR", ',') - 1) ELSE "AUTHOR" END),
        TRIM(CASE WHEN INSTR("AUTHOR", ',') > 0 THEN SUBSTR("AUTHOR", INSTR("AUTHOR", ',') + 1) ELSE '' END),
        1
    FROM books_raw
    WHERE "TITLE" IS NOT NULL
      AND TRIM("TITLE") <> ''
      AND "STATUS" = 'Completed'
      AND "AUTHOR" IS NOT NULL
      AND TRIM("AUTHOR") <> ''

    UNION ALL

    SELECT
        raw_row_id,
        TRIM(CASE WHEN INSTR(remaining_authors, ',') > 0 THEN SUBSTR(remaining_authors, 1, INSTR(remaining_authors, ',') - 1) ELSE remaining_authors END),
        TRIM(CASE WHEN INSTR(remaining_authors, ',') > 0 THEN SUBSTR(remaining_authors, INSTR(remaining_authors, ',') + 1) ELSE '' END),
        author_order + 1
    FROM split_authors
    WHERE remaining_authors <> ''
)

INSERT OR IGNORE INTO book_authors (book_id, author_id, author_order)
SELECT
    b.book_id,
    a.author_id,
    sa.author_order
FROM split_authors sa
JOIN books b
    ON b.raw_row_id = sa.raw_row_id
JOIN authors a
    ON a.author_name = sa.author_piece
WHERE sa.author_piece <> '';