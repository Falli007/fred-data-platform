# Rebuild Checklist

## Purpose

This document provides a complete checklist for rebuilding the Road Safety Analytics platform from scratch.

Rather than explaining concepts, this document focuses on execution.

It can be used whenever the project needs to be recreated on a new machine, in a new Snowflake account or by another engineer joining the project.

---

# Prerequisites

Before starting, ensure you have access to:

□ GitHub

□ dbt Cloud (or dbt Core)

□ Snowflake

□ AWS Account

□ AWS S3

□ SQL Editor

□ Git

---

# Phase 1 — Clone the Repository

□ Clone repository

□ Review README

□ Review project documentation

□ Confirm project structure

Expected folders

```

docs/

learning/

models/

analyses/

macros/

tests/

```

---

# Phase 2 — Configure AWS

□ Create S3 bucket

□ Upload Road Safety datasets

□ Verify uploads

Datasets

□ Collisions

□ Casualties

□ Vehicles

---

# Phase 3 — Configure Snowflake

□ Create warehouse

□ Create database

□ Create schemas

Expected schemas

```

RAW

STAGING_STAGING

STAGING_INTERMEDIATE

STAGING_MARTS

```

---

# Phase 4 — Load Raw Data

□ Create stage

□ Configure file format

□ Load datasets

□ Validate row counts

□ Verify columns

---

# Phase 5 — Configure dbt

□ Configure profiles

□ Configure dbt_project.yml

□ Configure Sources

□ Validate project

Command

```bash
dbt parse
```

---

# Phase 6 — Build Models

Run

```bash
dbt build
```

Confirm:

□ Staging models

□ Intermediate model

□ Fact model

□ Aggregate model

---

# Phase 7 — Validate Warehouse

Inspect

```
INFORMATION_SCHEMA.TABLES
```

Confirm:

□ Correct schemas

□ Correct object names

□ Correct materialisations

□ Correct row counts

---

# Phase 8 — Documentation

Generate documentation

```bash
dbt docs generate
```

Review lineage.

---

# Phase 9 — Version Control

□ Create feature branch

□ Commit changes

□ Push changes

□ Create Pull Request

□ Merge into main

---

# Final Validation

Confirm final warehouse contains

```

STAGING_STAGING

STG_COLLISIONS

STG_CASUALTIES

STG_VEHICLES

STAGING_INTERMEDIATE

INT_COLLISION_SUMMARY

STAGING_MARTS

FCT_COLLISIONS

AGG_DAILY_SUMMARY

```

---

# Project Complete

If every checklist item has been completed successfully, the analytics platform has been rebuilt successfully.

---

# Knowledge Check

Can you rebuild the project without external tutorials?

If yes, this documentation has achieved its purpose.