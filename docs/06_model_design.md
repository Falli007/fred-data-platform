# Model Design

## Purpose

This document explains the design of every dbt model used in the Road Safety Analytics project.

Rather than treating models as individual SQL files, this document explains how they work together to form a complete transformation pipeline.

It covers:

- The purpose of each model
- The transformation layer it belongs to
- Input datasets
- Output datasets
- Dependencies
- Design decisions
- Materialisations
- Naming conventions
- Best practices

Understanding the model architecture is essential because analytics engineering is about building maintainable data products rather than writing isolated SQL queries.

---

# Overview

The project follows a layered modelling approach.

```

Raw Data

↓

Sources

↓

Staging

↓

Intermediate

↓

Mart

↓

Business Consumption

```

Each layer has one responsibility.

Keeping responsibilities separate makes the platform easier to maintain, test and extend.

---

# Why Layer Models?

One large SQL query might produce the same final result, but it quickly becomes difficult to maintain.

Layering transformations provides several advantages.

- Easier debugging
- Smaller SQL files
- Reusable logic
- Clear dependencies
- Better testing
- Better documentation
- Improved scalability

These principles are widely adopted across modern analytics engineering teams.

---

# Complete Model Lineage

The complete lineage for this project is shown below.

```

RAW_COLLISIONS

│

├───────────────┐

│

RAW_CASUALTIES

│

├──────► STG_COLLISIONS

│

├──────► STG_CASUALTIES

│

RAW_VEHICLES

│

└──────► STG_VEHICLES

↓

INT_COLLISION_SUMMARY

↓

FCT_COLLISIONS

↓

AGG_DAILY_SUMMARY

```

Every downstream model depends on the quality of upstream models.

---

# Staging Layer

Purpose

Prepare source data for transformation.

Typical responsibilities include:

- Renaming columns
- Standardising naming conventions
- Selecting required fields
- Casting data types
- Removing unnecessary columns

Staging models intentionally avoid business logic.

---

## STG_ROAD_SAFETY__COLLISIONS

Materialisation

```
View
```

Purpose

Provides a clean representation of the raw collisions dataset.

Input

```
Raw Snowflake collisions table
```

Output

A standardised collision dataset ready for downstream modelling.

Responsibilities

- Select required columns
- Rename fields where appropriate
- Apply consistent naming conventions
- Preserve row-level granularity

Dependencies

```
Source
```

Used By

```
INT_ROAD_SAFETY__COLLISION_SUMMARY
```

---

## STG_ROAD_SAFETY__CASUALTIES

Materialisation

```
View
```

Purpose

Standardises casualty information while preserving the original source records.

Input

```
Raw casualties table
```

Responsibilities

- Standardise columns
- Preserve original records
- Prepare joins for downstream models

Dependencies

```
Source
```

Used By

```
INT_ROAD_SAFETY__COLLISION_SUMMARY
```

---

## STG_ROAD_SAFETY__VEHICLES

Materialisation

```
View
```

Purpose

Provides a clean vehicle dataset suitable for downstream joins.

Input

```
Raw vehicles table
```

Responsibilities

- Rename columns
- Preserve source integrity
- Standardise naming

Dependencies

```
Source
```

Used By

```
INT_ROAD_SAFETY__COLLISION_SUMMARY
```

---

# Why Use Views in Staging?

Views were deliberately chosen because:

- No duplicate storage
- Always reflect the latest raw data
- Faster development
- Easier debugging
- Lightweight transformations

Since staging models contain minimal logic, materialising them as tables would provide little benefit.

---

# Intermediate Layer

Purpose

Create reusable business logic.

This layer combines multiple staging models into a reusable analytical dataset.

Rather than repeating joins across several downstream models, the logic is implemented once.

---

## INT_ROAD_SAFETY__COLLISION_SUMMARY

Materialisation

```
View
```

Purpose

Produces a unified collision dataset by combining the staging models.

Inputs

- STG_ROAD_SAFETY__COLLISIONS
- STG_ROAD_SAFETY__CASUALTIES
- STG_ROAD_SAFETY__VEHICLES

Responsibilities

- Join related datasets
- Apply reusable business logic
- Create a single analytical foundation

Outputs

A reusable summary dataset used by mart models.

Dependencies

```
STG_COLLISIONS

STG_CASUALTIES

STG_VEHICLES
```

Used By

```
FCT_ROAD_SAFETY__COLLISIONS
```

---

# Why Separate the Intermediate Layer?

Without an intermediate layer, every mart model would repeat the same joins.

This introduces:

- duplicated SQL
- inconsistent business logic
- higher maintenance effort

By centralising reusable logic, downstream models remain smaller and easier to understand.

---

# Mart Layer

Purpose

Produce analytics-ready datasets.

The mart layer is designed for reporting and business consumption.

Unlike staging and intermediate models, these models are materialised as tables to improve query performance.

---

## FCT_ROAD_SAFETY__COLLISIONS

Materialisation

```
Table
```

Purpose

Acts as the primary fact table for collision analysis.

Input

```
INT_ROAD_SAFETY__COLLISION_SUMMARY
```

Responsibilities

- Store collision-level analytical records
- Support reporting
- Provide a stable foundation for aggregations

Outputs

One analytical record per collision.

Used By

```
AGG_ROAD_SAFETY__DAILY_SUMMARY
```

---

## Why Use a Fact Table?

Fact tables represent measurable business events.

In this project:

Business Event

```
Road Collision
```

The fact table allows business users to answer questions such as:

- How many collisions occurred?
- When did they occur?
- Where did they occur?
- What factors were associated with them?

---

## AGG_ROAD_SAFETY__DAILY_SUMMARY

Materialisation

```
Table
```

Purpose

Produces daily aggregated collision statistics.

Input

```
FCT_ROAD_SAFETY__COLLISIONS
```

Responsibilities

- Aggregate collision data by day
- Reduce query complexity for dashboards
- Improve reporting performance

Outputs

One record per reporting day.

---

# Why Materialise Aggregations as Tables?

Daily summaries are queried frequently.

Storing them as tables:

- reduces repeated computation
- improves dashboard performance
- simplifies reporting
- provides predictable query times

---

# Dependency Graph

```

Sources

↓

STG_COLLISIONS

↓

STG_CASUALTIES

↓

STG_VEHICLES

↓

INT_COLLISION_SUMMARY

↓

FCT_COLLISIONS

↓

AGG_DAILY_SUMMARY

```

dbt automatically builds models in dependency order using `ref()` and `source()` relationships.

---

# Naming Convention

Consistent naming was used throughout the project.

| Prefix | Meaning |
|---------|---------|
| `stg_` | Staging model |
| `int_` | Intermediate model |
| `fct_` | Fact table |
| `agg_` | Aggregate table |

This makes the purpose of every model immediately obvious.

---

# Design Decisions

Several design decisions shaped the final architecture.

- Raw data remains immutable.
- Staging models contain no business logic.
- Reusable logic belongs in the intermediate layer.
- Reporting models belong in the mart layer.
- Views are used where storage is unnecessary.
- Tables are used where performance matters.
- Every model has a single responsibility.

These principles reduce technical debt and make future enhancements easier.

---

# Lessons Learned

Developing the models reinforced several key analytics engineering concepts.

Small, focused models are easier to maintain than large SQL scripts.

Clear model naming improves collaboration.

Separating transformation layers improves readability and scalability.

Materialisation should be chosen based on the purpose of the model rather than applied uniformly.

Well-designed model dependencies reduce duplication and make the pipeline easier to evolve over time.

---

# Knowledge Check

Before moving on, make sure you can answer the following:

- Why are staging models kept lightweight?
- Why does the intermediate layer exist?
- What makes a fact table different from an aggregate table?
- Why were views chosen for staging and intermediate models?
- Why were tables chosen for mart models?
- What would happen if every join were performed directly inside the fact table?
- How does dbt determine the order in which models are built?

If you can confidently answer these questions, you have a solid understanding of the model architecture.

---

# Next Document

Continue with:

**07_testing_and_validation.md**

This document explains how the project was tested, validated, and verified to ensure that the models built successfully and produced the expected results.