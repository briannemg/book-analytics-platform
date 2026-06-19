import sqlite3
import pandas as pd
from pathlib import Path
import os

# ============================================================
# File Paths
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

DB_DIR = BASE_DIR / "database"
DB_PATH = DB_DIR / "book_analytics.db"

CSV_PATH = BASE_DIR / "data" / "raw" / "books_raw.csv"
SQL_DIR = BASE_DIR / "sql"

# ============================================================
# SQL Execution Order
# ============================================================

# Initial database creation

SETUP_FILES = [
    "schema.sql",
    "seed_lookup_tables.sql"
]

# Transformation pipeline

TRANSFORMATION_FILES = [
    "update_lookup_tables_from_raw.sql",
    "populate_authors.sql",
    "populate_genres.sql",
    "populate_moods.sql",
    "populate_books.sql",
    "populate_book_authors.sql",
    "populate_book_genres.sql",
    "populate_book_moods.sql",
    "views.sql"
]

# ============================================================
# SQL Runner
# ============================================================

def run_sql_file(conn, filename):
    """
    Reads and executes a SQL script.
    """
    
    file_path = SQL_DIR / filename
    
    if not file_path.exists():
        raise FileNotFoundError(f"Missing SQL file: {file_path}")
    
    with open(file_path, "r", encoding="utf-8") as file:
        sql_script = file.read()
        
    conn.executescript(sql_script)
    conn.commit()
    
    print(f"✓ Executed: {filename}")
    
# ============================================================
# Build Summary / Validation
# ============================================================

def get_count(conn, query):
    """
    Run a COUNT query and return result.
    """
    cursor = conn.execute(query)
    return cursor.fetchone()[0]

def print_build_summary(conn):
    """
    Print final database summary after build.
    """
    books = get_count(conn, "SELECT COUNT(*) FROM books;")
    authors = get_count(conn, "SELECT COUNT(*) FROM authors;")
    series = get_count(conn, "SELECT COUNT(*) FROM series;")
    genres = get_count(conn, "SELECT COUNT(*) FROM genres;")
    moods = get_count(conn, "SELECT COUNT(*) FROM moods;")
    
    book_authors = get_count(conn, "SELECT COUNT(*) FROM book_authors;")
    book_genres = get_count(conn, "SELECT COUNT(*) FROM book_genres;")
    book_moods = get_count(conn, "SELECT COUNT(*) FROM book_moods;")
    
    missing_source = get_count(
        conn,
        "SELECT COUNT(*) FROM books WHERE source_id IS NULL;"
    )

    missing_format = get_count(
        conn,
        "SELECT COUNT(*) FROM books WHERE format_id IS NULL;"
    )

    missing_status = get_count(
        conn,
        "SELECT COUNT(*) FROM books WHERE status_id IS NULL;"
    )

    print("\n================================================")
    print("BUILD SUMMARY")
    print("================================================\n")
    
    print(f"Books imported:               {books}")
    print(f"Authors created:              {authors}")
    print(f"Series created:               {series}")
    print(f"Genres created:               {genres}")
    print(f"Moods created:                {moods}")
    print()
    print(f"Book-author relationships:    {book_authors}")
    print(f"Book-genre relationships:     {book_genres}")
    print(f"Book-mood relationships:      {book_moods}")
    print()

    if missing_source == 0 and missing_format == 0 and missing_status == 0:
        print("Validation checks passed ✓")
    else:
        print("Validation issues detected ⚠")
        print(f"Missing sources:  {missing_source}")
        print(f"Missing formats:  {missing_format}")
        print(f"Missing statuses: {missing_status}")
    
# ============================================================
# Main Build Process
# ============================================================

def main():
    
    # --------------------------------------------------------
    # Create database folder if it does not exist
    # --------------------------------------------------------
    
    DB_DIR.mkdir(exist_ok=True)
    
    # --------------------------------------------------------
    # Delete existing database
    # --------------------------------------------------------
    
    if DB_PATH.exists():
        os.remove(DB_PATH)
        print("✓ Deleted old database")
        
    # --------------------------------------------------------
    # Check CSV exists
    # --------------------------------------------------------
    
    if not CSV_PATH.exists():
        raise FileNotFoundError(
            f"CSV file not found: {CSV_PATH}"
        )
        
    # --------------------------------------------------------
    # Create database connection
    # --------------------------------------------------------
    
    conn = sqlite3.connect(DB_PATH)
    
    try:
        
        # Enable foreign key enforcement
        conn.execute("PRAGMA foreign_keys = ON;")
        
        # ----------------------------------------------------
        # Run setup scripts
        # ----------------------------------------------------
        
        print("\nRunning setup scripts...\n")
        
        for filename in SETUP_FILES:
            run_sql_file(conn, filename)
            
        # ----------------------------------------------------
        # Import raw CSV
        # ----------------------------------------------------
        
        print("\nImporting raw CSV...\n")
        
        books_raw = pd.read_csv(CSV_PATH)
        
        books_raw.to_sql(
            "books_raw",
            conn,
            if_exists="replace",
            index=False
        )
        
        print("✓ Imported books_raw.csv")
        
        # ----------------------------------------------------
        # Run transformation scripts
        # ----------------------------------------------------
        
        print("\nRuning transformation pipeline...\n")
        
        for filename in TRANSFORMATION_FILES:
            run_sql_file(conn, filename)
            
        # ----------------------------------------------------
        # Success
        # ----------------------------------------------------
        
        print_build_summary(conn)

        print("\nDatabase saved to:")
        print(DB_PATH)
        
    finally:
        conn.close()
        
        
# ============================================================
# Run Script
# ============================================================

if __name__ == "__main__":
    main()