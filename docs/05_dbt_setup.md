# dbt Setup

## Purpose

This document explains how dbt was configured and used throughout the Road Safety Analytics project.

The goal of dbt was not simply to execute SQL.

Its purpose was to transform raw operational datasets into trusted analytical models using a structured, modular and maintainable approach.

By the end of this document you should understand:

- What dbt is
- Why dbt was chosen
- How the project was structured
- How models were organised
- How dependencies work
- How schemas were configured
- How dbt executes models
- How the project was validated

---

# What is dbt?

dbt stands for Data Build Tool.

Unlike traditional ETL tools, dbt does not ingest data.

Instead, dbt transforms data that already exists inside the data warehouse.

For this project:

```

Amazon S3

↓

Snowflake

↓

dbt

↓

Analytics Tables

```

dbt executes SQL directly inside Snowflake.

No data is moved outside the warehouse during transformation.

---

# Why dbt?

Traditional SQL development often results in:

- Very large SQL scripts
- Repeated business logic
- Difficult maintenance
- Limited documentation
- No automated testing

dbt solves these problems by encouraging modular development.

Benefits include:

- Modular SQL
- Automatic dependency management
- Testing
- Documentation
- Data lineage
- Version control
- Reusable models

---

# Creating the Project

A new dbt project was created.

The project automatically generated several folders.

```

analyses/

macros/

models/

seeds/

snapshots/

tests/

target/

dbt_project.yml

README.md

```

Although many folders existed from the beginning, only a subset was required for this project.

The remaining folders allow the platform to expand without restructuring the repository.

---

# Understanding the Project Structure

One of the first design decisions was organising the models directory.

Rather than storing every SQL file together, models were separated into layers.

```

models/

    staging/

    intermediate/

    marts/

```

Each folder represents one stage of the transformation pipeline.

This makes the project significantly easier to understand.

---

# Why We Created Additional Subfolders

Inside each transformation layer another folder was created.

```

models/

    staging/

        road_safety/

    intermediate/

        road_safety/

    marts/

        road_safety/

```

This approach keeps subject areas separated.

If customer data, weather data or insurance data are introduced later, each can have its own folder without affecting the existing project.

Example

```

models/

    staging/

        customers/

        weather/

        road_safety/

```

The repository therefore scales naturally.

---

# dbt_project.yml

One of the most important files in the project is:

```

dbt_project.yml

```

This file controls how dbt behaves.

Examples include:

- model locations
- schemas
- materialisations
- documentation settings

Without this configuration every model would be created using default behaviour.

---

# Schema Configuration

One of the major improvements during development was separating transformation layers into dedicated schemas.

Final configuration

```

STAGING_STAGING

↓

STAGING_INTERMEDIATE

↓

STAGING_MARTS

```

Initially every object was created inside:

```

STAGING

```

Later the configuration was updated to better reflect production architecture.

---

# Why Separate Schemas?

Using dedicated schemas provides several advantages.

## Easier Navigation

Objects become much easier to locate.

---

## Better Security

Permissions can later be assigned per layer.

---

## Cleaner Warehouse

The warehouse reflects the transformation pipeline.

---

## Easier Maintenance

Old models are easier to identify.

---

## Better Scalability

Future subject areas can follow exactly the same pattern.

---

# Materialisations

Materialisation controls what dbt creates inside Snowflake.

This project used two materialisations.

Views

```

view

```

Tables

```

table

```

---

# Why Views?

Views were used for:

- staging
- intermediate

Reasons

Views always return the latest underlying data.

They also reduce storage because only SQL is stored.

---

# Why Tables?

Tables were used for:

- fact models
- aggregate models

Reasons

Fact tables are queried frequently.

Materialising them as tables improves reporting performance.

---

# Sources

Raw Snowflake tables should never be referenced directly throughout multiple models.

Instead dbt Sources were created.

Benefits include:

- centralised references
- documentation
- lineage
- easier maintenance
- freshness testing

Every staging model begins with a source.

```

Raw Table

↓

dbt Source

↓

Staging Model

```

---

# Model Naming Convention

A consistent naming convention was used.

```

stg_

```

Staging

```

int_

```

Intermediate

```

fct_

```

Fact

```

agg_

```

Aggregate

Using prefixes makes the purpose of every model immediately obvious.

---

# Dependency Management

One of dbt's biggest strengths is dependency management.

Rather than executing SQL manually in the correct order, dbt builds a dependency graph.

For this project

```

Sources

↓

STG_COLLISIONS

↓

INT_COLLISION_SUMMARY

↓

FCT_COLLISIONS

↓

AGG_DAILY_SUMMARY

```

dbt automatically determines the execution order.

---

# Commands Used

Throughout development several dbt commands were used repeatedly.

## Parse

```bash
dbt parse
```

Checks project syntax.

---

## Run

```bash
dbt run --select road_safety
```

Builds the selected models.

---

## Test

```bash
dbt test --select road_safety
```

Executes configured tests.

---

## Build

```bash
dbt build --select road_safety
```

Runs the complete pipeline.

---

## Documentation

```bash
dbt docs generate
```

Creates project documentation.

---

# Validation

After every build, Snowflake was inspected.

Validation included:

- schemas
- object names
- row counts
- timestamps
- object types

This became one of the most valuable habits developed during the project.

Never assume a successful dbt run means everything is correct.

Always verify inside Snowflake.

---

# Lessons Learned

Several important lessons became clear.

Writing modular SQL is much easier than maintaining one large SQL script.

Naming conventions matter.

Folder organisation matters.

Documentation should be written during development rather than afterwards.

Validation inside Snowflake is just as important as successful dbt execution.

---

# Best Practices

Future projects should continue following these principles.

- One responsibility per model.
- One subject area per folder.
- Separate transformation layers.
- Use Sources.
- Keep staging lightweight.
- Validate every deployment.
- Document every design decision.

---

# Knowledge Check

Can you answer the following without looking at your notes?

- What is the difference between dbt and Snowflake?
- Why are staging models separated from marts?
- Why were views used in the staging layer?
- Why were tables used in the mart layer?
- Why was `dbt_project.yml` one of the most important files?
- What does `dbt build` do that `dbt run` does not?
- Why did we introduce `STAGING_STAGING`, `STAGING_INTERMEDIATE` and `STAGING_MARTS`?

If you can confidently explain each answer, you understand how dbt was configured for this project.

---

# Next Document

Continue with:

06_model_design.md

This document explains every SQL model in detail, including why it exists, what it produces, how it depends on other models and how the complete transformation pipeline works.