# Glossary

## Purpose

This glossary defines the key terms used throughout the Road Safety Analytics project.

Rather than searching through multiple documents, future readers can use this glossary as a quick reference when unfamiliar terminology appears.

---

# A

## Aggregate Table

A table containing summarised information rather than individual records.

Example

```
AGG_ROAD_SAFETY__DAILY_SUMMARY
```

This model stores daily collision totals rather than every collision.

---

# B

## Business Logic

Rules that transform raw operational data into meaningful analytical information.

Examples include:

- joining datasets
- calculating totals
- grouping records
- creating reporting metrics

Business logic should not exist inside staging models.

---

# C

## Cloud Data Warehouse

A cloud platform designed for analytical workloads.

In this project the cloud data warehouse is Snowflake.

---

# D

## dbt

Data Build Tool.

A transformation framework that executes SQL inside the data warehouse.

dbt was responsible for:

- transformations
- testing
- documentation
- dependency management
- lineage

---

## Dependency

A model that must exist before another model can be built.

Example

```
FCT_COLLISIONS

depends on

INT_COLLISION_SUMMARY
```

dbt automatically determines build order using dependencies.

---

# F

## Fact Table

A table that stores measurable business events.

Example

```
FCT_ROAD_SAFETY__COLLISIONS
```

Each record represents a collision.

---

# G

## Git

Distributed version control software used to track every project change.

---

## GitHub

Cloud platform used to store the repository, collaborate and manage Pull Requests.

---

# I

## Intermediate Model

A reusable transformation layer that contains shared business logic.

Purpose

Reduce duplicated SQL across downstream models.

---

# J

## Jinja

The templating language used by dbt.

Example

```sql
{{ ref('stg_road_safety__collisions') }}
```

Jinja allows SQL to become modular and reusable.

---

# M

## Materialisation

How dbt creates a model inside Snowflake.

Common types

- View
- Table
- Incremental
- Ephemeral

This project used Views and Tables.

---

## Mart

The final analytics layer.

Contains business-ready datasets.

Examples

```
Fact Tables

Aggregate Tables
```

---

# R

## Raw Data

The original source datasets before transformation.

Raw data should remain unchanged.

---

## ref()

dbt function used to reference another model.

Example

```sql
{{ ref('int_road_safety__collision_summary') }}
```

This automatically creates dependencies.

---

# S

## Schema

A logical container inside a Snowflake database.

Project schemas

```
STAGING_STAGING

STAGING_INTERMEDIATE

STAGING_MARTS
```

---

## Source

A dbt object representing a raw table inside Snowflake.

Every staging model begins from a Source.

---

## Staging Model

The first transformation layer.

Responsibilities

- rename columns
- standardise names
- cast data types
- remove unnecessary fields

No business logic should be added.

---

# T

## Table

A physical object that stores data inside Snowflake.

Unlike a View, tables consume storage.

---

# V

## View

A stored SQL query.

Views do not duplicate data and always return the latest underlying results.

---

# W

## Warehouse

Snowflake's compute engine.

Responsible for executing SQL.

It does not permanently store data.

---

# Knowledge Check

Can you explain each of the following without referring to the documentation?

- dbt
- Warehouse
- Schema
- Source
- Staging
- Intermediate
- Mart
- Fact Table
- Aggregate Table
- Materialisation

If yes, you understand the terminology used throughout this project.