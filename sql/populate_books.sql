INSERT OR IGNORE INTO books (
    raw_row_id,
    title,
    source_id,
    format_id,
    status_id,
    series_id,
    book_number,
    pages,
    publication_year,
    rating,
    start_date,
    finish_date,
    year_read,
    days_read,
    pages_per_day,
    reread,
    notes
)

SELECT
    br.rowid,
    br."TITLE",
    s.source_id,
    f.format_id,
    st.status_id,
    se.series_id,

    CASE
        WHEN br."BOOK #" IS NULL OR TRIM(br."BOOK #") = '' THEN NULL
        ELSE CAST(br."BOOK #" AS REAL)
    END,

    br."PAGES",
    br."PUB YEAR",

    CASE
        WHEN br."RATING" = '' THEN NULL
        WHEN br."RATING" = '★☆☆☆☆' THEN 1
        WHEN br."RATING" = '★★☆☆☆' THEN 2
        WHEN br."RATING" = '★★★☆☆' THEN 3
        WHEN br."RATING" = '★★★★☆' THEN 4
        WHEN br."RATING" = '★★★★★' THEN 5
    END,

    NULLIF(br."START DATE",''),
    NULLIF(br."FINISH DATE",''),
    br."YEAR READ",
    br."DAYS READ",
    br."PAGES/DAY",

    CASE
        WHEN br."REREAD" = 1 THEN 1
        WHEN br."REREAD" = 'TRUE' THEN 1
        ELSE 0
    END,

    NULLIF(br."NOTES",'')

FROM books_raw br
LEFT JOIN sources s ON br."SOURCE" = s.source_name
LEFT JOIN formats f ON br."FORMAT" = f.format_name
LEFT JOIN statuses st ON br."STATUS" = st.status_name
LEFT JOIN series se ON br."SERIES" = se.series_name

WHERE br."TITLE" IS NOT NULL
    AND TRIM(br."TITLE") <> ''
    AND br."STATUS" = 'Completed';