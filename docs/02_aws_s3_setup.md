# AWS S3 Setup

## Purpose

This document explains how Amazon S3 fits into the Road Safety Analytics platform.

Although dbt performs data transformations, dbt does not ingest raw files directly from external storage.

Instead, Amazon S3 is used as the landing zone for raw datasets before they are loaded into Snowflake.

Understanding this architecture is important because separating storage from transformation is one of the core principles of modern cloud data platforms.

---

# Why AWS S3?

Amazon S3 is an object storage service designed to store virtually unlimited amounts of data.

Unlike a relational database, S3 does not organise data into tables.

Instead, it stores objects inside buckets.

Each object consists of:

- File
- Metadata
- Storage location

Typical file formats include:

- CSV
- Parquet
- JSON
- Avro

For this project, S3 acts as the raw storage layer.

```
Road Safety Files

↓

Amazon S3

↓

Snowflake

↓

dbt

↓

Analytics Tables
```

---

# Why Separate Storage From Transformation?

One of the first design discussions during this project was whether data should simply be stored directly inside Snowflake.

Instead, a layered architecture was chosen.

Benefits include:

- Raw data remains unchanged.
- Data can be reloaded if required.
- Multiple systems can consume the same files.
- Storage is significantly cheaper than keeping raw copies inside compute engines.
- Raw files are preserved for auditing.

Keeping raw data immutable is considered best practice within modern data engineering.

---

# Creating the S3 Bucket

The first AWS resource required was an S3 bucket.

A bucket acts as the top level container for all stored objects.

When creating a bucket, several design decisions should be considered.

## Bucket Naming

Bucket names should:

- be unique
- use lowercase letters
- avoid spaces
- avoid special characters
- remain meaningful

Example

```
fred-data-platform
```

---

# Bucket Structure

During development, several possible folder structures were discussed.

A common beginner approach is placing every file directly inside the bucket.

Although this works for small projects, it becomes difficult to manage as additional datasets are introduced.

Instead, a structured hierarchy was preferred.

Example

```
road_safety/

    raw/

        collisions/

        casualties/

        vehicles/

    processed/

    archive/
```

This structure keeps datasets organised while allowing future pipelines to be added without creating confusion.

---

# Why Use Folders?

Technically, S3 does not contain real folders.

Folders are simply prefixes within object names.

However, using a logical folder hierarchy makes projects much easier to navigate.

Benefits include:

- easier maintenance
- cleaner organisation
- simpler permissions
- easier automation
- improved scalability

---

# Uploading the Datasets

The Road Safety datasets were uploaded into Amazon S3 before loading into Snowflake.

The primary datasets included:

- Collisions
- Casualties
- Vehicles

These datasets formed the raw source layer for the analytics pipeline.

The uploaded files remained unchanged throughout the project.

All cleaning and transformation occurred later inside dbt.

---

# Data Platform Architecture

The complete ingestion architecture is shown below.

```
Road Safety CSV Files

        │

        ▼

Amazon S3

        │

        ▼

Snowflake Stage

        │

        ▼

Raw Snowflake Tables

        │

        ▼

dbt Sources

        │

        ▼

Staging Models

        │

        ▼

Intermediate Models

        │

        ▼

Mart Models

        │

        ▼

Business Reporting
```

Each component has one responsibility.

Separating responsibilities makes the platform easier to maintain and extend.

---

# Lessons Learned

Several important concepts became clear during this stage.

## S3 Is Storage

S3 should not be viewed as a database.

Its purpose is storing files rather than executing SQL.

---

## Raw Data Should Remain Untouched

One of the biggest design principles in modern data engineering is preserving raw data.

Cleaning should occur after ingestion rather than modifying the original files.

---

## Folder Structure Matters

Although S3 technically stores objects rather than folders, using a logical hierarchy makes projects much easier to understand.

Planning this structure early reduces maintenance effort later.

---

## Think About Future Growth

The Road Safety pipeline is only one subject area.

Designing the bucket so additional domains can be added later helps prevent major restructuring in future.

---

# Future Improvements

As the platform evolves, several AWS enhancements could be introduced.

Examples include:

- Snowpipe for automatic ingestion
- EventBridge notifications
- Lambda processing
- S3 lifecycle policies
- Object versioning
- IAM least privilege permissions
- Encryption using AWS KMS
- Monitoring through CloudWatch

These services were not required for the initial version of the project but represent logical next steps as the platform matures.

---

# Next Document

The next stage explains how Snowflake was configured, how the database was organised and how the raw datasets were prepared for transformation.

Continue with:

03_snowflake_setup.md