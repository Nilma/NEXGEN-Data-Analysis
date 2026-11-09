# NEXGEN — MySQL + Python Data Analysis

A beginner-friendly project for practising Python data analysis in VS Code/Jupyter with the **original NEXGEN sample MySQL dataset**. It includes 5 student notebooks and 5 separate teacher solution notebooks.

## 1. Open in VS Code (macOS)

Install Python 3 and VS Code extensions **Python** and **Jupyter**. In the VS Code terminal from this project folder:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

Open `notebooks/01_Python_Basics.ipynb`, select the `.venv` Python kernel, and run cells using Shift+Enter. Work through lessons 1–3 and 5 **without MySQL**. The CSV files are derived from the supplied SQL INSERT script. Lesson 3 has a deliberately messy practice CSV; the other CSVs reproduce the original sample records.

## 2. Set up MySQL for lesson 4

Start your local MySQL server (for example through MySQL Workbench or your normal MySQL installation). In MySQL Workbench run, in order:

1. `database/SQLCreateNexgen.sql`
2. `database/SQLInsertNexgen.sql`

**CAUTION: `SQLCreateNexgen.sql` starts with `DROP DATABASE IF EXISTS nexgen;`. It will permanently replace an existing database named `nexgen`. Back up existing data or change the script/database name before running it.**

Verify:

```sql
USE nexgen;
SELECT * FROM Consultant;
SELECT * FROM v_ProjectBilling;
```

Open `notebooks/04_SQL_and_Python.ipynb`. When prompted, provide your local MySQL username, password and port (default 3306). Passwords are not saved to notebooks or source files. The Python process connects to the separately running MySQL server; no second project folder is required.

## Structure

- `database/`: unchanged user-provided SQL CREATE and INSERT scripts.
- `data/`: CSV exports corresponding to those INSERT rows, plus a clearly marked synthetic cleaning exercise.
- `notebooks/`: guided practice notebooks, with unfinished student exercises.
- `solutions/`: worked teacher solutions (lesson 4 solution uses the `engine` created in its student notebook).
- `requirements.txt`: Python dependencies.


