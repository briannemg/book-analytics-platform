-- Add any source values found in raw data that are misisng from sources
INSERT OR IGNORE INTO sources (source_name)
SELECT DISTINCT TRIM("SOURCE")
FROM books_raw
WHERE "SOURCE" IS NOT NULL
    AND TRIM("SOURCE") <> '';

-- Add any format values found in raw data that are missing from formats
INSERT OR IGNORE INTO formats (format_name)
SELECT DISTINCT TRIM("FORMAT")
FROM books_raw
WHERE "FORMAT" IS NOT NULL
    AND TRIM("FORMAT") <> '';

-- Add any status values found in raw data that are missing from statuses
INSERT OR IGNORE INTO statuses (status_name)
SELECT DISTINCT TRIM("STATUS")
FROM books_raw
WHERE "STATUS" IS NOT NULL
    AND TRIM("STATUS") <> '';

-- Add any series values found in raw data that are missing from series
INSERT OR IGNORE INTO series (series_name)
SELECT DISTINCT TRIM("SERIES")
FROM books_raw
WHERE "SERIES" IS NOT NULL
    AND TRIM("SERIES") <> '';