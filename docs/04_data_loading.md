# Data Loading

## Purpose

This document explains how the Road Safety datasets entered the analytics platform.

The objective of this stage was to move raw source files into Snowflake while preserving data quality and ensuring that the datasets could later be transformed using dbt.

Unlike the transformation layer, this stage focuses entirely on ingestion.

No business logic should be introduced during loading.

---

# Overview

Every analytics platform follows a similar pattern.

```

External Source

↓

Cloud Storage

↓

Data Warehouse

↓

Transformation

↓

Analytics

```

For this project the flow became:

```

Road Safety Files

↓

Amazon S3

↓

Snowflake

↓

Raw Tables

↓

dbt

```

At the end of this stage the raw data should exist inside Snowflake exactly as received from the source.

---

# Source Datasets

Three datasets formed the foundation of the project.

## Collisions

Contains information describing every recorded collision.

Examples include:

- collision identifier
- date
- location
- weather
- road conditions

This became the primary dataset used throughout the project.

---

## Casualties

Contains information relating to casualties involved in collisions.

Examples include:

- casualty identifier
- severity
- age
- sex
- casualty class

This dataset links back to collisions.

---

## Vehicles

Contains information describing vehicles involved in collisions.

Examples include:

- vehicle type
- engine size
- age of vehicle
- manoeuvre
- direction

Each vehicle record is associated with a collision.

---

# Why Keep Separate Tables?

A common beginner approach is joining every dataset immediately after loading.

Instead, each dataset remained separate.

Reasons include:

- preserves source integrity
- easier validation
- simpler troubleshooting
- reusable datasets
- easier reloads

Joining occurs later inside dbt.

---

# Loading Strategy

The loading process followed these principles.

## Principle 1

Load data without modification.

---

## Principle 2

Validate every dataset after loading.

---

## Principle 3

Transform later.

---

## Principle 4

Never overwrite source data.

---

# Expected Workflow

The overall loading process can be summarised below.

```

CSV Files

↓

Upload to S3

↓

Snowflake Stage

↓

Raw Tables

↓

Validation

↓

dbt Sources

```

Each stage must complete successfully before progressing.

---

# Data Validation

Loading data successfully is not enough.

Every dataset should be validated.

Validation questions include:

- Did every file load?

- Were all expected columns created?

- Do row counts match expectations?

- Are any rows missing?

- Are duplicate records present?

Only after these checks should transformation begin.

---

# Row Count Validation

One of the simplest validation techniques is comparing expected row counts.

Unexpected differences usually indicate one of the following.

- incomplete load
- duplicate load
- incorrect filtering
- incorrect file

Although row counts cannot guarantee correctness, they provide an excellent first validation.

---

# Column Validation

Every dataset should be reviewed.

Questions include:

- Are column names correct?

- Are data types correct?

- Are dates recognised correctly?

- Are numeric fields numeric?

- Are identifiers complete?

These checks reduce downstream issues during transformation.

---

# Data Quality

The loading layer intentionally performs minimal processing.

However several quality checks should still be performed.

Examples include:

- missing files
- corrupt files
- incorrect delimiters
- unexpected null values
- invalid encoding

Problems discovered during loading should be resolved before dbt development begins.

---

# Why We Did Not Transform Data Here

One of the biggest lessons during this project was separating ingestion from transformation.

Loading should only move data.

Transformation belongs inside dbt.

Keeping these responsibilities separate provides:

- simpler pipelines
- reusable raw data
- easier debugging
- clearer ownership

---

# Validation Checklist

Before beginning dbt development the following should be confirmed.

□ All source datasets loaded

□ Expected tables created

□ Correct row counts

□ Correct column names

□ Correct data types

□ No corrupt files

□ Data available inside Snowflake

Only after these checks should transformation begin.

---

# Lessons Learned

Several important principles became clear.

Loading and transformation should remain separate.

Raw datasets should remain unchanged.

Validation should become part of the normal workflow rather than something performed only when problems occur.

Good ingestion practices make every later stage significantly easier.

---

# Next Document

Continue with:

05_dbt_setup.md

This document explains how dbt was configured, how the project structure was designed and how transformations were implemented.