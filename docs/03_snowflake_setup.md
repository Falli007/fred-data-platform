# Snowflake Setup

## Purpose

This document explains how Snowflake was configured for the Road Safety Analytics project.

The objective was not simply to create a database.

The objective was to build a scalable cloud data warehouse that could support a modern analytics engineering workflow using dbt.

This document explains every design decision, why it was made, and how the environment was validated.

---

# What is Snowflake?

Snowflake is a cloud-native data warehouse.

Unlike traditional databases, Snowflake separates three major components.

- Storage
- Compute
- Cloud Services

Separating these responsibilities allows each component to scale independently.

```
                Snowflake

         +--------------------+

         Cloud Services Layer

+----------------+----------------+

Storage                    Compute

```

This architecture is one of the reasons Snowflake performs well for analytical workloads.

---

# Why Snowflake?

Several cloud data warehouses exist including:

- Snowflake
- Amazon Redshift
- Google BigQuery
- Azure Synapse

Snowflake was chosen because it provides:

- automatic scaling
- separation of storage and compute
- excellent SQL support
- strong integration with dbt
- support for structured and semi-structured data
- simple administration
- time travel
- zero copy cloning

These features make Snowflake one of the most popular cloud data warehouses for analytics engineering.

---

# Snowflake Architecture

The project follows this architecture.

```

AWS S3

↓

Snowflake Stage

↓

Raw Tables

↓

dbt

↓

Views

↓

Tables

↓

Business Users

```

Snowflake stores both the raw data and the transformed analytical datasets.

dbt executes SQL directly inside Snowflake.

No data leaves the warehouse during transformation.

---

# Snowflake Objects

Several different object types exist within Snowflake.

Understanding the purpose of each object is important.

```

Account

↓

Warehouse

↓

Database

↓

Schema

↓

Table

↓

View

```

Each object serves a different purpose.

---

# Snowflake Account

The Snowflake account represents the top level environment.

Everything inside Snowflake belongs to an account.

The account contains:

- warehouses
- databases
- users
- roles
- stages
- file formats
- schemas

---

# Warehouse

The warehouse provides compute.

A warehouse is responsible for executing SQL.

It does not permanently store data.

One of the biggest lessons learned during this project was understanding that storage and compute are completely separate.

This means:

Stopping a warehouse does not delete data.

Deleting a warehouse does not delete data.

Data continues to exist inside Snowflake storage.

---

# Database

The project database was created as:

```

FRED_DATA_PLATFORM

```

The database acts as the logical container for the project.

Inside the database are multiple schemas.

Keeping everything inside a dedicated project database improves organisation and simplifies security.

---

# Schemas

Schemas provide another level of organisation.

Initially the project used:

```

STAGING

```

Later during development the project was restructured.

Separate schemas were introduced for each transformation layer.

Final structure

```

STAGING_STAGING

↓

STAGING_INTERMEDIATE

↓

STAGING_MARTS

```

This follows analytics engineering best practice.

---

# Why Separate Schemas?

Each layer has a different responsibility.

Keeping them together would work technically.

However separating them provides several advantages.

Benefits

- easier navigation
- cleaner lineage
- simpler permissions
- easier debugging
- easier maintenance

Future subject areas can follow exactly the same pattern.

Example

```

CUSTOMERS_STAGING

CUSTOMERS_INTERMEDIATE

CUSTOMERS_MARTS

```

The project therefore becomes much easier to scale.

---

# Loading Raw Data

Raw road safety data was loaded into Snowflake before dbt development began.

The three datasets included:

- collisions
- casualties
- vehicles

These raw datasets were intentionally left unchanged.

No business logic was applied.

No columns were renamed.

No joins were performed.

Raw data should always remain as close as possible to the original source.

---

# Why Keep Raw Data?

A common beginner mistake is modifying raw data.

Instead this project follows the principle that raw data should remain immutable.

Reasons include:

- easier auditing
- easier debugging
- simpler reloads
- reproducibility
- source preservation

If business rules change later, transformations can simply be rerun without needing to reload source files.

---

# Data Warehouse Layers

The completed warehouse now contains three logical layers.

```

Raw

↓

Staging

↓

Intermediate

↓

Mart

```

Each layer exists for a specific purpose.

---

# Staging Layer

Purpose

Prepare raw data.

Typical activities

- rename columns
- cast data types
- standardise names
- remove unnecessary fields

No business logic should exist here.

---

# Intermediate Layer

Purpose

Create reusable business logic.

Typical activities

- joins
- reusable calculations
- standard business rules

This prevents duplication across multiple reporting models.

---

# Mart Layer

Purpose

Produce analytics-ready datasets.

Typical outputs include:

- fact tables
- dimension tables
- aggregate tables

Business users should primarily consume data from this layer.

---

# Materialisations

During development two different materialisations were used.

Views

Used for:

- staging
- intermediate

Reason

Views avoid storing duplicate data and always return the latest information.

Tables

Used for:

- marts

Reason

Fact tables and aggregates benefit from improved query performance.

Although tables consume storage, they reduce computation during reporting.

---

# Validation

One of the most important stages of development involved validating that dbt had created the expected objects.

Instead of assuming success, INFORMATION_SCHEMA was queried.

Validation included:

- schema names
- object names
- object types
- row counts
- timestamps

This became one of the most useful debugging techniques used throughout the project.

---

# Unexpected Behaviour

During validation duplicate objects appeared.

Examples

```

STAGING

STAGING_STAGING

STAGING_INTERMEDIATE

STAGING_MARTS

```

Initially this appeared to be a dbt error.

Further investigation revealed the real cause.

The project configuration had changed.

dbt correctly created the models inside the new schemas.

However previously created relations inside STAGING remained.

dbt does not automatically remove obsolete relations after schema changes.

---

# Resolution

Legacy objects were manually removed.

Views

```

DROP VIEW IF EXISTS ...

```

Tables

```

DROP TABLE IF EXISTS ...

```

After cleanup the validation query confirmed the correct warehouse structure.

---

# Final Warehouse Layout

```

FRED_DATA_PLATFORM

│

├── STAGING_STAGING

│

│ ├── STG_ROAD_SAFETY__COLLISIONS

│ ├── STG_ROAD_SAFETY__CASUALTIES

│ └── STG_ROAD_SAFETY__VEHICLES

│

├── STAGING_INTERMEDIATE

│

│ └── INT_ROAD_SAFETY__COLLISION_SUMMARY

│

└── STAGING_MARTS

├── FCT_ROAD_SAFETY__COLLISIONS

└── AGG_ROAD_SAFETY__DAILY_SUMMARY

```

This confirmed that the warehouse structure matched the intended analytics architecture.

---

# Lessons Learned

Several important lessons were learned during Snowflake development.

Storage and compute are independent.

Schemas should represent logical transformation layers.

Raw data should remain untouched.

Validation queries are essential.

Warehouse organisation becomes increasingly important as projects grow.

Understanding Snowflake architecture is just as important as writing SQL.

---

# Best Practices

Throughout future projects the following principles should continue to be followed.

- Never modify raw data.
- Keep one responsibility per schema.
- Validate every deployment.
- Separate staging, intermediate and marts.
- Document design decisions.
- Keep warehouse organisation consistent.

---

# Next Document

Continue with:

04_data_loading.md

This document explains how raw datasets entered the warehouse and how they were validated before transformation.