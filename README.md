# Customer Sales Analytics Engineering Platform

End-to-end analytics engineering project built with **Snowflake, dbt, SQL, Jinja and GitHub**. The project transforms raw customer, account, transaction, loan, marketing and customer-service data into tested analytical models for reporting and analysis.

## Project Architecture

```text
Snowflake RAW
    |
    v
STAGING
    |
    v
INTERMEDIATE
    |
    v
MARTS
    |
    +-- Dimensions
    |   +-- DIM_CUSTOMER
    |   +-- DIM_ACCOUNT
    |   +-- DIM_CAMPAIGN
    |
    +-- Facts
    |   +-- FACT_TRANSACTIONS
    |   +-- FACT_LOANS
    |   +-- FACT_MARKETING
    |
    +-- Business Marts
        +-- MART_CUSTOMER_360
        +-- MART_LOAN_PERFORMANCE
        +-- MART_MARKETING_CAMPAIGN
        +-- MART_TRANSACTION_SUMMARY
```

## Technology Stack

| Technology | Purpose |
|---|---|
| Snowflake | Cloud data warehouse |
| dbt | SQL transformation, testing and documentation |
| SQL | Data modelling and business logic |
| Jinja | Dynamic SQL and reusable dbt logic |
| Git/GitHub | Version control and project repository |

## Snowflake Structure

Database:

```text
DBT_ENGNR
```

Schemas:

```text
RAW
STAGING
INTERMEDIATE
MARTS
```

The RAW schema contains the source tables:

```text
ACCOUNTS
CUSTOMERS
CUSTOMER_SERVICE
LOANS
MARKETING_CAMPAIGNS
TRANSACTIONS
```

## dbt Model Structure

```text
models/
├── staging/
│   ├── stg_accounts.sql
│   ├── stg_customers.sql
│   ├── stg_customer_service.sql
│   ├── stg_loans.sql
│   ├── stg_marketing_campaigns.sql
│   ├── stg_transactions.sql
│   └── schema.yml
│
├── intermediate/
│   ├── int_customer_profile.sql
│   ├── int_customer_loans.sql
│   ├── int_customer_transactions.sql
│   └── schema.yml
│
└── marts/
    ├── dimensions/
    │   ├── dim_customer.sql
    │   ├── dim_account.sql
    │   ├── dim_campaign.sql
    │   └── schema.yml
    │
    ├── facts/
    │   ├── fact_transactions.sql
    │   ├── fact_loans.sql
    │   ├── fact_marketing.sql
    │   └── schema.yml
    │
    ├── mart_customer_360.sql
    ├── mart_loan_performance.sql
    ├── mart_marketing_campaign.sql
    ├── mart_transaction_summary.sql
    └── schema.yml
```

## Macros and Jinja

The project uses Jinja through dbt functions such as `ref()` and includes reusable macros in the `macros/` directory.

```text
macros/
├── generate_schema_name.sql
└── calculate_risk_band.sql
```

`generate_schema_name.sql` ensures models are created in the intended Snowflake schemas instead of prefixed schema names.

`calculate_risk_band.sql` demonstrates reusable business logic through a custom Jinja macro.

## Data Quality

The project includes dbt data tests for:

- `not_null`
- `unique`
- `relationships`

Relationship tests validate referential integrity between customer foreign keys and `dim_customer`.

The completed project passed the full dbt test suite with no test errors.

## Core Commands

Build the complete project:

```bash
dbt build
```

Run all tests:

```bash
dbt test
```

Generate dbt documentation metadata:

```bash
dbt docs generate
```

Build a specific model:

```bash
dbt build --select <model_name>
```

Build models from a folder:

```bash
dbt build --select path:models/marts
```

## Example Validation in Snowflake

```sql
SELECT *
FROM DBT_ENGNR.MARTS.MART_CUSTOMER_360
LIMIT 10;
```

```sql
SELECT *
FROM DBT_ENGNR.MARTS.FACT_TRANSACTIONS
LIMIT 10;
```

```sql
SELECT *
FROM DBT_ENGNR.MARTS.FACT_LOANS
LIMIT 10;
```

```sql
SELECT *
FROM DBT_ENGNR.MARTS.FACT_MARKETING
LIMIT 10;
```

## Documentation

A complete rebuild guide is available here:

**[A-Z Project Build Guide](docs/A_Z_PROJECT_GUIDE.md)**

It documents the full process from Snowflake raw tables through staging, intermediate models, dimensions, facts, marts, testing, macros, documentation and GitHub.

## Project Status

**Completed.**

The finished project contains a layered dbt architecture, dimensional modelling, analytical marts, automated data tests, relationship validation, Jinja/macros and generated dbt documentation metadata.