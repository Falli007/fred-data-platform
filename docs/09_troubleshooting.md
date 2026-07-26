# Troubleshooting

## Purpose

Every engineering project encounters problems.

This document records the issues encountered during the Road Safety Analytics project, how they were investigated, the root causes and the solutions applied.

Documenting problems is just as valuable as documenting successful implementations because it provides a knowledge base for future work.

Each issue is presented using the following structure.

- Problem
- Investigation
- Root Cause
- Solution
- Lessons Learned

---

# Issue 1

## Duplicate Models Appearing in Snowflake

### Problem

After updating the dbt schema configuration, duplicate models appeared inside multiple schemas.

Objects were visible in:

```

STAGING

STAGING_STAGING

STAGING_INTERMEDIATE

STAGING_MARTS

```

Initially this suggested that dbt had created duplicate models.

---

### Investigation

The warehouse was inspected using `INFORMATION_SCHEMA.TABLES`.

Object names, schemas and materialisations were compared.

The new models had been created correctly.

The unexpected objects were all older relations.

---

### Root Cause

The project configuration had changed.

dbt correctly created models using the new schema configuration.

However, dbt does not automatically remove relations created by previous configurations.

---

### Solution

Legacy objects were manually removed.

Views

```sql
DROP VIEW IF EXISTS ...
```

Tables

```sql
DROP TABLE IF EXISTS ...
```

After cleanup, validation confirmed that only the expected six models remained.

---

### Lesson Learned

Changing a dbt schema configuration does not automatically clean up previous objects.

Always validate the warehouse after configuration changes.

---

# Issue 2

## DROP VIEW Returned an Error

### Problem

Snowflake reported that an object was a table rather than a view.

---

### Investigation

The object type was checked using `INFORMATION_SCHEMA.TABLES`.

---

### Root Cause

The model had been materialised as a table.

Attempting to remove it using `DROP VIEW` caused the error.

---

### Solution

The statement was replaced with:

```sql
DROP TABLE IF EXISTS ...
```

---

### Lesson Learned

Always verify the materialisation type before removing an object.

---

# Issue 3

## One Legacy View Remained

### Problem

After cleanup, one legacy view still existed.

---

### Investigation

The remaining object was compared with the cleanup script.

---

### Root Cause

The object name in the cleanup script contained a typo.

As a result, the intended view was never dropped.

---

### Solution

The statement was corrected and executed again.

Validation confirmed the warehouse was now clean.

---

### Lesson Learned

Always compare cleanup scripts with the warehouse rather than assuming every statement executed successfully.

---

# Issue 4

## Git Commands in dbt Cloud

### Problem

An attempt was made to execute Git commands from the dbt command interface.

---

### Investigation

The interface accepted dbt commands rather than terminal Git commands.

---

### Root Cause

dbt Cloud provides Git functionality through its Version Control interface rather than through a shell.

---

### Solution

Git operations were completed using the Version Control panel.

---

### Lesson Learned

Understand which interface is responsible for which operations.

Not every development environment exposes a terminal.

---

# Issue 5

## Assuming a Successful Build Was Sufficient

### Problem

Initially, a successful dbt build was treated as confirmation that everything was correct.

---

### Investigation

Validation queries against `INFORMATION_SCHEMA` revealed unexpected legacy objects.

---

### Root Cause

Successful execution only confirms that SQL completed successfully.

It does not confirm that the warehouse contains the intended objects.

---

### Solution

Warehouse validation became a standard part of the development workflow.

---

### Lesson Learned

Never rely solely on build status.

Always inspect the deployed warehouse.

---

# General Troubleshooting Process

Every issue throughout the project followed the same approach.

```

Observe Problem

↓

Gather Evidence

↓

Investigate

↓

Identify Root Cause

↓

Apply Fix

↓

Validate

↓

Document

```

Following a structured process prevented guesswork and made future troubleshooting significantly easier.

---

# Best Practices

Future projects should continue following these principles.

- Never assume.
- Validate changes.
- Investigate before deleting.
- Document every issue.
- Record lessons learned.
- Confirm the fix before closing the issue.

---

# Knowledge Check

Before moving on, make sure you can answer the following.

- Why did duplicate schemas appear?
- Why did `DROP VIEW` fail?
- Why is `INFORMATION_SCHEMA` so useful?
- Why should warehouse validation occur after every build?
- Why is documenting troubleshooting valuable?

If you can answer these confidently, you understand the troubleshooting approach used throughout this project.

---

# Next Document

Continue with:

10_rebuild_checklist.md

This document provides a complete end-to-end checklist for rebuilding the project from scratch.