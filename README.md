# Book Analytics Platform

A full-stack personal data analytics project designed to transform denormalized reading history data into a normalized relational database, automated ETL pipeline, and business intelligence reporting layer.

The goal of this project was to develop practical experience in SQL, database design, Python automation, and data analytics workflows while building a real-world analytics platform around multi-year reading history data.

---

## Tech Stack

- Python
- SQLite
- SQL
- Pandas
- Git / GitHub
- Tableau (coming soon)

---

## Project Architecture

```text
CSV Source Data
      ↓
Python ETL Pipeline
      ↓
SQLite Relational Database
      ↓
SQL Transformation Scripts
      ↓
SQL Analytical Queries
      ↓
Tableau Reporting Views
      ↓
Interactive Dashboard (coming soon)
```

---

## Features

### Automated ETL Pipeline

Python script automatically:

- Builds SQLite database
- Imports CSV data
- Executes SQL transformation pipeline
- Creates normalized tables
- Builds SQL views for reporting
- Performs validation checks

---

### Relational Database Design

Normalized schema includes:

- Books
- Authors
- Genres
- Moods / Vibes
- Series
- Sources
- Formats

Includes:

- Many-to-many junction tables
- Foreign key relationships
- Lookup tables
- Data validation

---

### SQL Analytics Layer

Analytical SQL queries include:

- Reading trends by year
- Rating analysis
- Author rankings
- Genre rankings
- Mood analysis
- Confidence-weighted scoring
- Reading speed and length analysis
- Seasonal reading trends
- Reread analysis

---

### Reporting Layer

SQL views built specifically for Tableau dashboard development.

Includes:

- Yearly reading summary
- Genre summary
- Mood summary
- Author summary
- Source summary
- Monthly reading summary
- Reading behavior summary

---

## Running the Project

See:

```text
docs/setup_and_execution.md
```

---

## Future Improvements

- Interactive Tableau dashboard
- Recommendation engine
- Book trend forecasting
- Expanded reading behavior analytics

---

## Why I Built This

This project was designed to strengthen skills in:

- SQL database design
- Data modeling
- ETL pipeline automation
- Analytical SQL querying
- Buisness intelligence workflows

while demonstrating end-to-end analytics engineering practices on a real-world dataset.
