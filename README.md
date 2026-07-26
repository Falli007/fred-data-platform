# 🚦 Fred Data Platform

> An end-to-end Analytics Engineering project demonstrating how raw road safety data can be transformed into trusted analytical datasets using AWS S3, Snowflake, dbt and GitHub.

---

## Overview

This repository contains a complete analytics engineering platform built using modern cloud technologies.

The project demonstrates how raw datasets move through a layered transformation pipeline before becoming analytics-ready models suitable for dashboards and reporting.

Rather than focusing only on SQL, the repository also documents the engineering decisions, testing approach, validation process and deployment workflow used throughout development.

---

## Technologies

| Technology | Purpose |
|------------|----------|
| AWS S3 | Raw data storage |
| Snowflake | Cloud data warehouse |
| dbt | Data transformation |
| SQL | Data modelling |
| Git | Version control |
| GitHub | Collaboration & Pull Requests |

---

## Architecture

```text
                    Road Safety CSV Files
                              │
                              ▼
                    ┌──────────────────┐
                    │     AWS S3       │
                    │ Raw File Storage │
                    └──────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │   Snowflake      │
                    │ Data Warehouse   │
                    └──────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │   dbt Sources    │
                    └──────────────────┘
                              │
                              ▼
              ┌────────────────────────────────┐
              │        Staging Models          │
              │ STG_COLLISIONS                 │
              │ STG_CASUALTIES                 │
              │ STG_VEHICLES                   │
              └────────────────────────────────┘
                              │
                              ▼
              ┌────────────────────────────────┐
              │ Intermediate Models            │
              │ INT_COLLISION_SUMMARY          │
              └────────────────────────────────┘
                              │
                              ▼
              ┌────────────────────────────────┐
              │ Mart Models                    │
              │ FCT_COLLISIONS                 │
              │ AGG_DAILY_SUMMARY             │
              └────────────────────────────────┘
                              │
                              ▼
                    Dashboards & Analytics
```

---

## Repository Structure

```text
fred-data-platform/

README.md

docs/

models/

analyses/

macros/

tests/

learning/
```

---

## Project Highlights

- End-to-end analytics engineering pipeline
- Layered dbt architecture
- Snowflake cloud data warehouse
- AWS S3 raw storage
- Modular SQL models
- Testing and validation
- Git feature branch workflow
- Engineering documentation
- Troubleshooting guide
- Rebuild checklist

---

## Documentation

| Guide | Description |
|--------|-------------|
| 01 | Project Setup |
| 02 | AWS S3 |
| 03 | Snowflake |
| 04 | Data Loading |
| 05 | dbt |
| 06 | Model Design |
| 07 | Testing |
| 08 | Git Workflow |
| 09 | Troubleshooting |
| 10 | Rebuild Checklist |
| 11 | Engineering Decisions |
| 12 | Architecture |
| 13 | Glossary |

---

## Skills Demonstrated

- Analytics Engineering
- Data Engineering
- SQL
- dbt
- Snowflake
- AWS
- Git
- GitHub
- Data Modelling
- Testing
- Documentation
- Cloud Architecture

---

## Future Improvements

- Incremental Models
- Snapshots
- CI/CD
- GitHub Actions
- Data Quality Monitoring
- Snowpipe
- Semantic Models
- Exposures

---

## Author

**Fredrick Alli**

Analytics Engineer | Data Engineer | AI Engineer

GitHub: Falli007

---

## License

MIT