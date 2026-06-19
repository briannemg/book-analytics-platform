PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS book_moods;
DROP TABLE IF EXISTS book_genres;
DROP TABLE IF EXISTS book_authors;
DROP TABLE IF EXISTS tbr_master;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS moods;
DROP TABLE IF EXISTS series;
DROP TABLE IF EXISTS sources;
DROP TABLE IF EXISTS formats;
DROP TABLE IF EXISTS statuses;

CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY AUTOINCREMENT,
    author_name TEXT NOT NULL UNIQUE
);

CREATE TABLE genres (
    genre_id INTEGER PRIMARY KEY AUTOINCREMENT,
    genre_name TEXT NOT NULL UNIQUE
);

CREATE TABLE moods (
    mood_id INTEGER PRIMARY KEY AUTOINCREMENT,
    mood_name TEXT NOT NULL UNIQUE
);

CREATE TABLE series (
    series_id INTEGER PRIMARY KEY AUTOINCREMENT,
    series_name TEXT NOT NULL UNIQUE
);

CREATE TABLE sources (
    source_id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_name TEXT NOT NULL UNIQUE
);

CREATE TABLE formats (
    format_id INTEGER PRIMARY KEY AUTOINCREMENT,
    format_name TEXT NOT NULL UNIQUE
);

CREATE TABLE statuses (
    status_id INTEGER PRIMARY KEY AUTOINCREMENT,
    status_name TEXT NOT NULL UNIQUE
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    raw_row_id INTEGER UNIQUE,
    title TEXT NOT NULL,
    source_id INTEGER,
    format_id INTEGER,
    status_id INTEGER,
    series_id INTEGER,
    book_number REAL,
    pages INTEGER,
    publication_year INTEGER,
    rating INTEGER,
    start_date TEXT,
    finish_date TEXT,
    year_read INTEGER,
    days_read INTEGER,
    pages_per_day REAL,
    reread INTEGER DEFAULT 0,
    notes TEXT,

    FOREIGN KEY (source_id) REFERENCES sources(source_id),
    FOREIGN KEY (format_id) REFERENCES formats(format_id),
    FOREIGN KEY (status_id) REFERENCES statuses(status_id),
    FOREIGN KEY (series_id) REFERENCES series(series_id)
);

CREATE TABLE book_authors (
    book_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    author_order INTEGER DEFAULT 1,

    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE book_genres (
    book_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,

    PRIMARY KEY (book_id, genre_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE book_moods (
    book_id INTEGER NOT NULL,
    mood_id INTEGER NOT NULL,

    PRIMARY KEY (book_id, mood_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (mood_id) REFERENCES moods(mood_id)
);

CREATE TABLE tbr_master (
    tbr_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author_text TEXT,
    priority TEXT,
    status TEXT,
    date_added TEXT,
    notes TEXT
);