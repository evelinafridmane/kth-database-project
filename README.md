# IV1351 – Data Storage Paradigms

A full-stack database project built as part of the KTH course **IV1351 – Data Storage Paradigms**. The project covers relational database design, query optimization, and a Java application layer following the MVC pattern.

---

## Overview

This project implements a normalized relational database for managing structured data with versioned course layouts. It demonstrates end-to-end data engineering skills — from schema design and population to query optimization and a connected Java application.

**Tech stack:** PostgreSQL · PL/pgSQL · Java · JDBC · MVC Architecture

---

## Project Structure

```
data_project/
├── application/            # Java MVC application (JDBC-connected)
├── execution_plans/        # EXPLAIN ANALYZE output for optimized queries
├── higher_grade_queries/   # Advanced OLAP queries for higher-grade criteria
├── logphy_models/          # Logical and physical data models (crow's foot notation)
├── buildDB.sql             # DDL – creates all tables, constraints, and indices
├── populateDB.sql          # DML – seeds the database with sample data
├── query1.sql              # Query
├── query2.sql              # Query
├── query3.sql              # Query
└── query4.sql              # Query
```

---

## Features

- **Normalized schema** designed using crow's foot notation, satisfying 3NF
- **Temporal data structures** to support versioned and historical course layouts
- **Optimized OLAP queries** with strategic use of indices and materialized views
- **EXPLAIN ANALYZE** used to profile and tune query performance
- **Java MVC application** with clean separation between model, view, and controller layers
- **JDBC integration** for seamless communication between the application and the database

---

## Getting Started

### Prerequisites

- PostgreSQL 14+
- Java 17+
- A PostgreSQL client (e.g. `psql` or pgAdmin)

### Setup

**1. Create the database**

```bash
psql -U postgres -c "CREATE DATABASE iv1351;"
```

**2. Build the schema**

```bash
psql -U postgres -d iv1351 -f buildDB.sql
```

**3. Populate with sample data**

```bash
psql -U postgres -d iv1351 -f populateDB.sql
```

**4. Run a query**

```bash
psql -U postgres -d iv1351 -f query1.sql
```

**5. Run the Java application**

Navigate to the `application/` folder and compile/run according to your build setup (Maven/Gradle or plain `javac`).

---

## Database Design

The schema was designed from a set of requirements and modelled using logical and physical ER diagrams (see `logphy_models/`). Key design decisions include:

- Fully normalized tables to eliminate redundancy
- Foreign key constraints to enforce referential integrity
- Temporal columns to track historical states of entities
- Indices placed on high-cardinality columns used in frequent joins and filters

---

## Query Optimization

Execution plans for all major queries can be found in `execution_plans/`. Each query was profiled using `EXPLAIN ANALYZE` and iteratively improved. Optimization techniques applied include:

- B-tree indices on foreign keys and filter columns
- Materialized views for expensive aggregation queries
- Query restructuring to avoid sequential scans on large tables

---

## Higher Grade Queries

The `higher_grade_queries/` folder contains more advanced analytical queries, including window functions and multi-level aggregations, written to meet the higher-grade criteria of the course assignment.

---


## Authors

**Evelina Fridmane**  
[github.com/evelinafridmane](https://github.com/evelinafridmane)

**Sam Serbouti**
