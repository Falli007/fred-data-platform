# Engineering Decisions & Reasoning

## Purpose

This document explains the reasoning behind the architectural decisions made throughout the Road Safety Analytics project.

Understanding why a decision was made is often more valuable than understanding what was built.

---

# Decision 1

## Why use dbt?

Alternative

Large SQL scripts.

Chosen

dbt.

Reason

- modular SQL
- documentation
- testing
- lineage
- maintainability

---

# Decision 2

## Why Snowflake?

Alternative

Traditional relational database.

Chosen

Snowflake.

Reason

- separation of storage and compute
- scalability
- cloud native
- dbt integration

---

# Decision 3

## Why AWS S3?

Alternative

Load files directly.

Chosen

S3.

Reason

Storage should remain independent from transformation.

S3 becomes the permanent landing zone for raw data.

---

# Decision 4

## Why Layer Models?

Alternative

One large SQL model.

Chosen

Staging

↓

Intermediate

↓

Mart

Reason

- reusable logic
- smaller SQL
- easier debugging
- clearer lineage

---

# Decision 5

## Why Keep Raw Data?

Raw data should never be modified.

Reasons

- auditing
- reproducibility
- debugging
- future transformations

---

# Decision 6

## Why Views for Staging?

Views

Reason

- lightweight
- always current
- no duplicate storage

---

# Decision 7

## Why Tables for Marts?

Tables

Reason

Reporting workloads benefit from faster query performance.

---

# Decision 8

## Why Separate Schemas?

Alternative

Everything inside STAGING.

Chosen

```

STAGING_STAGING

STAGING_INTERMEDIATE

STAGING_MARTS

```

Reason

- organisation
- permissions
- scalability
- debugging

---

# Decision 9

## Why Feature Branches?

Alternative

Commit directly to main.

Chosen

Feature branch.

Reason

Protects production code.

Allows review.

Supports collaboration.

---

# Decision 10

## Why Validate in Snowflake?

Alternative

Trust dbt output.

Chosen

Validate warehouse.

Reason

Execution success does not guarantee deployment correctness.

---

# Decision 11

## Why Document Everything?

Documentation is not an afterthought.

Documentation reduces onboarding time.

Documentation preserves engineering knowledge.

Documentation enables future maintenance.

---

# Lessons Learned

Good engineering is largely about making deliberate decisions.

Every architectural choice should have a clear justification.

Whenever a future engineer asks "Why?", this document should provide the answer.

---

# Knowledge Check

If someone challenged one of these design decisions during a design review, could you explain why it was made?

If yes, you understand the architecture rather than simply knowing how to use the tools.