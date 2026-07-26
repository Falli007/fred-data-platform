# Testing and Validation

## Purpose

Building data models is only one part of analytics engineering.

Equally important is validating that those models produce the expected results.

This document explains how the Road Safety Analytics project was tested and validated throughout development.

The objective was to ensure that every transformation was accurate, complete and successfully deployed into Snowflake.

Testing was performed continuously during development rather than only at the end of the project.

---

# Why Testing Matters

A successful dbt run does not automatically guarantee a correct solution.

For example:

- SQL may execute successfully but return incorrect results.
- Models may be created in the wrong schema.
- Legacy objects may still exist.
- Row counts may not match expectations.
- Relationships between models may be incorrect.

For these reasons, every build was independently validated.

---

# Validation Workflow

The project followed the same validation workflow after every significant change.

```

Develop SQL

↓

dbt Parse

↓

dbt Run / Build

↓

dbt Test

↓

Snowflake Validation

↓

Investigate Issues

↓

Fix

↓

Repeat

```

Validation was treated as part of development rather than as a separate activity.

---

# Validation Categories

The project used several different validation techniques.

## 1. Syntax Validation

Before executing models, the project syntax was checked.

Command

```bash
dbt parse
```

Purpose

- Validate SQL syntax
- Validate Jinja syntax
- Validate project configuration

Running `dbt parse` early helped identify configuration issues before executing transformations.

---

## 2. Model Execution

Models were built using:

```bash
dbt build --select road_safety
```

Unlike `dbt run`, the `build` command also executes tests after models have been created.

This became the preferred command once development was stable.

---

## 3. dbt Tests

Built-in dbt tests were executed after model creation.

Examples include:

- not_null
- unique
- relationships
- accepted_values (where appropriate)

The objective was to identify structural data quality issues before models were consumed downstream.

---

# 4. Snowflake Validation

After every successful build, the warehouse itself was inspected.

This step was critical because a successful dbt execution only confirms that SQL ran successfully.

It does not confirm that objects were created where they were expected.

Typical validation included:

- Schema name
- Table name
- View name
- Materialisation type
- Row count
- Creation timestamp
- Last altered timestamp

This information was retrieved using Snowflake's `INFORMATION_SCHEMA`.

---

# Example Validation

A validation query was executed against:

```
INFORMATION_SCHEMA.TABLES
```

The purpose was to confirm:

- Expected schemas existed.
- Models had the correct names.
- Views and tables were materialised correctly.
- No unexpected objects remained.

This proved to be one of the most useful debugging techniques used during the project.

---

# Duplicate Schema Investigation

During validation an unexpected issue was discovered.

Objects existed in both:

```
STAGING
```

and

```
STAGING_STAGING

STAGING_INTERMEDIATE

STAGING_MARTS
```

Initially this appeared to indicate that dbt had built duplicate models.

However, further investigation showed that the new schema configuration was working correctly.

The objects in `STAGING` were legacy relations created before the schema configuration was updated.

dbt does not automatically remove obsolete relations after configuration changes.

---

# Resolution

Legacy objects were manually removed.

Views were removed using:

```sql
DROP VIEW IF EXISTS ...
```

Tables were removed using:

```sql
DROP TABLE IF EXISTS ...
```

During cleanup, one statement attempted to remove a table using `DROP VIEW`.

Snowflake correctly returned an error indicating that the object was a table rather than a view.

The statement was corrected and executed successfully.

A final validation confirmed that only the expected six models remained.

---

# Final Warehouse Validation

The completed warehouse contained:

```
STAGING_STAGING

    STG_ROAD_SAFETY__COLLISIONS

    STG_ROAD_SAFETY__CASUALTIES

    STG_ROAD_SAFETY__VEHICLES

STAGING_INTERMEDIATE

    INT_ROAD_SAFETY__COLLISION_SUMMARY

STAGING_MARTS

    FCT_ROAD_SAFETY__COLLISIONS

    AGG_ROAD_SAFETY__DAILY_SUMMARY
```

This matched the intended analytics architecture.

---

# Row Count Validation

In addition to confirming that objects existed, row counts were reviewed.

Examples included:

- Fact table row count
- Aggregate table row count

Comparing row counts with expectations helped identify missing or duplicate data early in the development process.

---

# Documentation Validation

Documentation was treated as another form of validation.

After each milestone the following were updated:

- README
- Engineering documentation
- Project notes
- Git commits

Maintaining documentation alongside development reduced the likelihood of important design decisions being forgotten.

---

# Lessons Learned

Several important lessons emerged during testing.

A successful dbt build should never be the final validation step.

Always inspect the warehouse after deployment.

Always verify schemas and materialisations.

Always investigate unexpected objects rather than deleting them immediately.

Validation should become part of the normal development workflow.

---

# Best Practices

Future projects should continue following these principles.

- Validate after every major change.
- Use `dbt build` during regular development.
- Inspect the warehouse directly.
- Compare row counts against expectations.
- Investigate anomalies before making changes.
- Keep documentation updated alongside implementation.

---

# Knowledge Check

Before continuing, make sure you can answer the following.

- What is the difference between `dbt run` and `dbt build`?
- Why is `dbt parse` useful?
- Why was `INFORMATION_SCHEMA` queried after every build?
- Why did duplicate models appear in the `STAGING` schema?
- Why were both row counts and object types validated?
- Why should warehouse validation be performed even when dbt reports success?

If you can confidently answer these questions, you understand the testing and validation approach used throughout this project.

---

# Next Document

Continue with:

08_git_workflow.md

This document explains how version control was used throughout the project, including feature branches, commits, pull requests and merging changes into the main branch.