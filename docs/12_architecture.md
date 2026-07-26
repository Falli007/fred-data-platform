# Platform Architecture

## Purpose

This document describes the complete architecture of the Road Safety Analytics platform.

Rather than focusing on individual technologies, it explains how every component interacts to produce trusted analytical datasets.

---

# High-Level Architecture

```

Road Safety CSV Files

↓

Amazon S3

↓

Snowflake

↓

Raw Tables

↓

dbt Sources

↓

Staging Models

↓

Intermediate Models

↓

Fact Tables

↓

Aggregate Tables

↓

Dashboards

↓

Business Users

```

Every component has a single responsibility.

---

# Responsibilities

## AWS S3

Purpose

Raw storage.

Responsibilities

- receive files
- retain originals
- archive source data

---

## Snowflake

Purpose

Cloud data warehouse.

Responsibilities

- store structured data
- execute SQL
- host transformed datasets

---

## dbt

Purpose

Transformation framework.

Responsibilities

- SQL execution
- dependency management
- testing
- documentation
- lineage

---

# Transformation Layers

## Raw

Stores original datasets.

Never modified.

---

## Sources

Provides controlled access to raw data.

Acts as the interface between Snowflake and dbt.

---

## Staging

Purpose

Standardisation.

Activities

- rename columns
- cast types
- remove unnecessary fields

---

## Intermediate

Purpose

Reusable business logic.

Activities

- joins
- calculations
- reusable transformations

---

## Mart

Purpose

Analytics-ready datasets.

Contains

- fact tables
- aggregate tables

---

# Data Flow

```

CSV

↓

S3

↓

Snowflake Stage

↓

Raw Tables

↓

Sources

↓

Staging

↓

Intermediate

↓

Fact

↓

Aggregate

↓

Reporting

```

---

# Deployment Flow

```

Developer

↓

dbt Parse

↓

dbt Build

↓

dbt Test

↓

Snowflake

↓

Validation

↓

Git Commit

↓

GitHub

↓

Pull Request

↓

Merge

```

---

# Technologies Used

| Technology | Purpose |
|------------|----------|
| AWS S3 | Raw storage |
| Snowflake | Data warehouse |
| dbt | Transformations |
| SQL | Data modelling |
| Git | Version control |
| GitHub | Collaboration |

---

# Design Principles

The architecture follows several engineering principles.

- Single responsibility
- Separation of concerns
- Modular design
- Immutable raw data
- Layered transformations
- Automated testing
- Documentation-first
- Version control

---

# Scalability

The platform was designed to grow.

Future subject areas can reuse exactly the same structure.

Example

```

customers/

weather/

insurance/

finance/

```

Each subject area can have:

- staging
- intermediate
- marts

without changing the overall architecture.

---

# Security

Although security was not the primary focus of this project, the architecture naturally supports:

- role-based access
- schema permissions
- warehouse permissions
- environment separation

These can be expanded in future iterations.

---

# Future Enhancements

Potential improvements include:

- Incremental models
- Snapshots
- dbt exposures
- CI/CD pipelines
- Snowpipe
- Automated quality monitoring
- Data contracts
- Semantic layer

---

# Knowledge Check

Can you explain the purpose of every box in the architecture diagram?

If you can describe the complete journey from a CSV file to a dashboard without referring to this document, you understand the architecture of the platform.

---

# Next Document

Continue with:

13_glossary.md

This document defines every important term used throughout the project so that future readers can quickly understand the terminology.