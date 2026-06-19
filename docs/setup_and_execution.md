# Setup and Execution

## Clone repository

```bash
git clone <repo-url>
cd book-analytics-platform
```

---

## Create Python virtual environment

```bash
python3 -m venv venv
```

Activate:

```bash
source venv/bin/activate
```

---

## Install dependencies

```bash
pip install -r requirements.txt
```

---

## Build database

```bash
python scripts/build_database.py
```

This will:

- Create SQLite database
- Import raw CSV data
- Execute SQL transformation scripts
- Populate normalized relational tables
- Build Tableau-ready SQL views
- Run validation summary

---

## Database output

Generated database:

```text
database/book_analytics.db
```

---

## Manual QA checks

Optional:

Run:

```text
sql/validation_checks.sql
```

to manually inspect data integrity.
