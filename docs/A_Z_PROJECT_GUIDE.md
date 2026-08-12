# A-Z Project Build Guide

This guide documents how to rebuild the completed **Customer Sales Analytics Engineering Platform** from the beginning using Snowflake and dbt.

---

## A. Create the Snowflake Database

Create the project database:

```sql
CREATE DATABASE IF NOT EXISTS DBT_ENGNR;
```

Create the schemas used by the project:

```sql
CREATE SCHEMA IF NOT EXISTS DBT_ENGNR.RAW;
CREATE SCHEMA IF NOT EXISTS DBT_ENGNR.STAGING;
CREATE SCHEMA IF NOT EXISTS DBT_ENGNR.INTERMEDIATE;
CREATE SCHEMA IF NOT EXISTS DBT_ENGNR.MARTS;
```

The final structure is:

```text
DBT_ENGNR
├── RAW
├── STAGING
├── INTERMEDIATE
└── MARTS
```

---

## B. Load the Raw Tables

Load the source datasets into `DBT_ENGNR.RAW`.

The project uses six source tables:

```text
ACCOUNTS
CUSTOMERS
CUSTOMER_SERVICE
LOANS
MARKETING_CAMPAIGNS
TRANSACTIONS
```

Confirm they exist:

```sql
SHOW TABLES IN SCHEMA DBT_ENGNR.RAW;
```

Check a source table before moving on:

```sql
SELECT *
FROM DBT_ENGNR.RAW.CUSTOMERS
LIMIT 10;
```

---

## C. Create or Open the dbt Project

Create/open the dbt project and ensure the project contains these directories:

```text
analyses/
macros/
models/
seeds/
snapshots/
tests/
```

Inside `models/`, create:

```text
models/
├── staging/
├── intermediate/
└── marts/
```

Inside `marts/`, create:

```text
marts/
├── dimensions/
└── facts/
```

---

## D. Configure `dbt_project.yml`

Configure the model paths and schema mapping so the Snowflake database stays clean:

```yaml
name: customer_sales_data_engnr
version: '1.0.0'
config-version: 2

model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

models:
  customer_sales_data_engnr:
    staging:
      +schema: STAGING

    intermediate:
      +schema: INTERMEDIATE

    marts:
      +schema: MARTS
```

The exact project/profile names can differ by environment, but the important outcome is:

```text
staging models      -> DBT_ENGNR.STAGING
intermediate models -> DBT_ENGNR.INTERMEDIATE
mart models         -> DBT_ENGNR.MARTS
```

---

## E. Add the Custom Schema Macro

Without a custom naming macro, dbt environments can create schema names such as `STAGING_STAGING` or `STAGING_MARTS`.

Create:

```text
macros/generate_schema_name.sql
```

Use:

```sql
{% macro generate_schema_name(custom_schema_name, node) %}

{% if custom_schema_name is not none %}
    {{ custom_schema_name }}
{% else %}
    {{ target.schema }}
{% endif %}

{% endmacro %}
```

This keeps the intended Snowflake schemas as:

```text
STAGING
INTERMEDIATE
MARTS
```

---

## F. Define the Raw Sources

Create:

```text
models/staging/schema.yml
```

Define the RAW source:

```yaml
version: 2

sources:
  - name: raw
    database: DBT_ENGNR
    schema: RAW

    tables:
      - name: customers
      - name: accounts
      - name: loans
      - name: transactions
      - name: customer_service
      - name: marketing_campaigns
```

Use `source()` in staging models rather than hard-coding raw table names.

Example:

```sql
select *
from {{ source('raw', 'customers') }}
```

---

## G. Build the Staging Layer

Create these models:

```text
models/staging/
├── stg_accounts.sql
├── stg_customers.sql
├── stg_customer_service.sql
├── stg_loans.sql
├── stg_marketing_campaigns.sql
└── stg_transactions.sql
```

The staging layer should stay close to the raw source and perform straightforward preparation such as:

- column selection
- renaming
- basic type handling
- simple filtering

Build it:

```bash
dbt build --select staging
```

If the folder selector does not match in the environment, use:

```bash
dbt build --select path:models/staging
```

Confirm in Snowflake:

```sql
SHOW VIEWS IN SCHEMA DBT_ENGNR.STAGING;
```

---

## H. Build the Intermediate Layer

Create:

```text
models/intermediate/
├── int_customer_profile.sql
├── int_customer_loans.sql
├── int_customer_transactions.sql
└── schema.yml
```

### `int_customer_profile`

Combines customer and account information.

Typical fields include:

```text
CUSTOMER_ID
CUSTOMER_SINCE
COUNTRY
REGION
CUSTOMER_SEGMENT
CUSTOMER_STATUS
ACCOUNT_ID
ACCOUNT_TYPE
OPENED_DATE
BALANCE
CURRENCY
```

### `int_customer_loans`

Combines customers with their loan records.

Typical fields:

```text
CUSTOMER_ID
COUNTRY
CUSTOMER_SEGMENT
LOAN_ID
LOAN_TYPE
LOAN_AMOUNT
INTEREST_RATE
LOAN_STATUS
```

If a left join creates customers without loans, filter the final intermediate loan model where required:

```sql
where loan_id is not null
```

### `int_customer_transactions`

Combines transaction, account and customer information.

Typical fields:

```text
TRANSACTION_ID
ACCOUNT_ID
CUSTOMER_ID
TRANSACTION_DATE
TRANSACTION_TYPE
AMOUNT
MERCHANT_CATEGORY
PAYMENT_METHOD
STATUS
ACCOUNT_TYPE
CURRENCY
COUNTRY
REGION
CUSTOMER_SEGMENT
```

Build:

```bash
dbt build --select path:models/intermediate
```

Validate:

```sql
SELECT *
FROM DBT_ENGNR.INTERMEDIATE.INT_CUSTOMER_TRANSACTIONS
LIMIT 10;
```

---

## I. Add Intermediate Tests

In `models/intermediate/schema.yml`, test important keys.

Example:

```yaml
version: 2

models:
  - name: int_customer_transactions
    columns:
      - name: transaction_id
        tests:
          - unique
          - not_null

  - name: int_customer_loans
    columns:
      - name: loan_id
        tests:
          - unique
          - not_null

  - name: int_customer_profile
    columns:
      - name: customer_id
        tests:
          - not_null
```

Run:

```bash
dbt test --select path:models/intermediate
```

---

## J. Create the Dimensions

Create:

```text
models/marts/dimensions/
├── dim_customer.sql
├── dim_account.sql
├── dim_campaign.sql
└── schema.yml
```

### `dim_customer`

The grain must be:

```text
1 row = 1 customer
```

Do not include account-level columns in `dim_customer`, because one customer can have multiple accounts and that would duplicate `CUSTOMER_ID`.

Use customer-level attributes only, for example:

```text
CUSTOMER_ID
CUSTOMER_SINCE
COUNTRY
REGION
CUSTOMER_SEGMENT
CUSTOMER_STATUS
```

### `dim_account`

The grain is:

```text
1 row = 1 account
```

Typical fields:

```text
ACCOUNT_ID
CUSTOMER_ID
ACCOUNT_TYPE
OPENED_DATE
BALANCE
CURRENCY
```

### `dim_campaign`

Use the actual staging campaign fields:

```text
CAMPAIGN_ID
CUSTOMER_ID
CAMPAIGN_TYPE
OPENED
CONVERTED
```

Do not invent fields that do not exist in the source, such as `campaign_name`.

Build dimensions:

```bash
dbt build --select path:models/marts/dimensions
```

---

## K. Create the Facts

Create:

```text
models/marts/facts/
├── fact_transactions.sql
├── fact_loans.sql
├── fact_marketing.sql
└── schema.yml
```

### `fact_transactions`

Grain:

```text
1 row = 1 transaction
```

Use the prepared intermediate transaction model.

### `fact_loans`

Grain:

```text
1 row = 1 loan
```

Fields used in the completed model:

```text
LOAN_ID
CUSTOMER_ID
LOAN_TYPE
LOAN_AMOUNT
INTEREST_RATE
LOAN_STATUS
```

### `fact_marketing`

Grain:

```text
1 row = 1 campaign activity record
```

Completed SQL pattern:

```sql
select
    campaign_id,
    customer_id,
    campaign_type,
    opened,
    converted

from {{ ref('stg_marketing_campaigns') }}

where campaign_id is not null
```

Build facts:

```bash
dbt build --select path:models/marts/facts
```

---

## L. Add Dimension and Fact Tests

Use `unique` and `not_null` on primary keys.

Example:

```yaml
- name: fact_loans
  columns:
    - name: loan_id
      tests:
        - unique
        - not_null
```

Add relationship tests where foreign keys should exist in a parent dimension.

Example for `dim_account.customer_id`:

```yaml
- name: customer_id
  tests:
    - not_null
    - relationships:
        to: ref('dim_customer')
        field: customer_id
```

Use the same relationship pattern for customer IDs in:

```text
FACT_TRANSACTIONS
FACT_LOANS
FACT_MARKETING
```

Run all tests:

```bash
dbt test
```

The completed project reached a fully passing test suite.

---

## M. Create the Business Marts

Create:

```text
models/marts/
├── mart_customer_360.sql
├── mart_loan_performance.sql
├── mart_marketing_campaign.sql
├── mart_transaction_summary.sql
└── schema.yml
```

### `mart_customer_360`

Customer-level analytical output containing measures such as:

```text
CUSTOMER_ID
COUNTRY
REGION
CUSTOMER_SEGMENT
CUSTOMER_STATUS
TOTAL_ACCOUNTS
TOTAL_TRANSACTION_VALUE
TOTAL_TRANSACTIONS
TOTAL_LOANS
TOTAL_LOAN_AMOUNT
```

### `mart_loan_performance`

Provides analytical loan metrics and loan performance information.

### `mart_marketing_campaign`

Provides campaign opening and conversion analysis.

### `mart_transaction_summary`

Provides transaction-level or aggregated transaction reporting metrics.

Build the entire mart layer:

```bash
dbt build --select path:models/marts
```

---

## N. Validate the Final Snowflake Objects

Run:

```sql
SHOW VIEWS IN SCHEMA DBT_ENGNR.MARTS;
```

The completed MARTS schema contains the dimensions, facts and analytical marts.

Example validation:

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

---

## O. Add Jinja and Macros

The project already uses Jinja whenever it uses dbt syntax such as:

```sql
{{ ref('int_customer_transactions') }}
```

Create reusable custom macros inside `macros/`.

The completed project includes:

```text
generate_schema_name.sql
calculate_risk_band.sql
```

Example risk-band macro:

```sql
{% macro calculate_risk_band(column_name) %}

case
    when {{ column_name }} >= 700 then 'LOW'
    when {{ column_name }} >= 400 then 'MEDIUM'
    else 'HIGH'
end

{% endmacro %}
```

Use custom macros from a dbt model, not directly in a Snowflake worksheet. dbt compiles the Jinja into normal SQL and then executes that compiled SQL in Snowflake.

---

## P. Understand dbt SQL vs Snowflake SQL

In a dbt model you can write:

```sql
from {{ ref('int_customer_transactions') }}
```

In Snowflake, use the actual database object:

```sql
FROM DBT_ENGNR.INTERMEDIATE.INT_CUSTOMER_TRANSACTIONS
```

Do not paste `{{ ref(...) }}` or custom Jinja macros directly into Snowflake worksheets.

---

## Q. Run the Complete Project

Once all model files are saved:

```bash
dbt build
```

`dbt build` runs models and the tests selected as part of the project graph.

Then run the full test suite explicitly:

```bash
dbt test
```

---

## R. Generate dbt Documentation

Run:

```bash
dbt docs generate
```

This generates dbt metadata and documentation artifacts.

In environments where `dbt docs serve` is unsupported, use the documentation/lineage features available in the dbt platform rather than treating that as a model failure.

---

## S. Inspect Lineage

Use dbt lineage to confirm dependencies follow the expected direction:

```text
RAW SOURCE
   |
STAGING
   |
INTERMEDIATE
   |
DIMENSIONS / FACTS
   |
BUSINESS MARTS
```

`ref()` creates the dependency graph automatically.

---

## T. Troubleshoot Schema Names

If Snowflake contains unexpected schemas such as:

```text
STAGING_STAGING
STAGING_INTERMEDIATE
STAGING_MARTS
```

check:

1. `dbt_project.yml`
2. `generate_schema_name.sql`
3. the active dbt target schema

The desired project schemas are:

```text
STAGING
INTERMEDIATE
MARTS
```

After fixing configuration, rebuild the dbt models. Old unwanted schemas can then be dropped manually in Snowflake if they are no longer needed.

---

## U. Troubleshoot a dbt Test Saying an Object Does Not Exist

If a test says:

```text
Object 'DBT_ENGNR.MARTS.<MODEL>' does not exist
```

first build the model itself:

```bash
dbt build --select <model_name>
```

Then test it:

```bash
dbt test --select <model_name>
```

A YAML test does not create the model it tests.

---

## V. Troubleshoot Invalid Identifier Errors

If dbt reports:

```text
invalid identifier '<COLUMN>'
```

check the upstream model in Snowflake before changing SQL:

```sql
SELECT *
FROM DBT_ENGNR.<SCHEMA>.<UPSTREAM_MODEL>
LIMIT 10;
```

Only reference columns that actually exist.

This was important for campaign and customer dimension development.

---

## W. Troubleshoot Duplicate Dimension Keys

If a `unique` test fails on `dim_customer.customer_id`, inspect the grain.

A customer can have several accounts, so selecting account-level fields into the customer dimension creates duplicate customers.

Keep `dim_customer` at customer grain and place account-level records in `dim_account`.

---

## X. Validate Before Committing

Before committing changes, run:

```bash
dbt build
```

Then:

```bash
dbt test
```

Then:

```bash
dbt docs generate
```

Only commit once the project builds and tests successfully.

---

## Y. Commit to Git

Review changes and use a clear commit message such as:

```text
Complete customer sales Snowflake dbt analytics engineering project
```

Commit the project files through the dbt IDE or Git workflow.

Do not commit secrets, credentials or private keys.

---

## Z. Final Project Checklist

A completed rebuild should have all of the following:

```text
[ ] DBT_ENGNR database exists
[ ] RAW schema contains all six source tables
[ ] STAGING contains all stg_* models
[ ] INTERMEDIATE contains all int_* models
[ ] MARTS contains dimensions
[ ] MARTS contains facts
[ ] MARTS contains business marts
[ ] Primary key unique tests pass
[ ] Required not-null tests pass
[ ] Relationship tests pass
[ ] generate_schema_name macro works
[ ] calculate_risk_band macro is available
[ ] dbt build succeeds
[ ] dbt test succeeds
[ ] dbt docs generate succeeds
[ ] Snowflake outputs are manually validated
[ ] Project changes are committed to GitHub
```

When every item above is complete, the project has been rebuilt end-to-end.