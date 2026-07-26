# Git Workflow

## Purpose

Version control is a fundamental part of modern software and analytics engineering.

This document explains how Git and GitHub were used throughout the Road Safety Analytics project to safely develop, review and merge changes.

The objective was to ensure that every modification was traceable, reversible and reviewed before becoming part of the main codebase.

This workflow mirrors the development practices used by professional engineering teams.

---

# Why Version Control?

Without version control, it becomes difficult to answer questions such as:

- What changed?
- Who changed it?
- Why was it changed?
- When was it changed?
- How can it be reverted?

Git provides a complete history of every change made to the project.

---

# Git Architecture

The project followed a standard Git workflow.

```

Developer

↓

Feature Branch

↓

Commit

↓

Push

↓

Pull Request

↓

Review

↓

Merge

↓

Main Branch

```

This approach keeps the main branch stable while allowing new features to be developed independently.

---

# Repository

The project was stored inside a GitHub repository.

The repository contains:

- SQL models
- YAML files
- Documentation
- Configuration
- Git history

Everything required to rebuild the project is version controlled.

---

# Branching Strategy

Development did not take place directly on the main branch.

Instead, a dedicated feature branch was created.

Example

```

main

↓

feature/road-safety-models

```

Working on a feature branch provides several advantages.

- Changes remain isolated.
- Multiple developers can work simultaneously.
- The main branch always remains stable.
- Features can be reviewed before merging.

---

# Development Workflow

Every change followed the same process.

```

Create Branch

↓

Implement Feature

↓

Test

↓

Validate

↓

Commit

↓

Sync

↓

Create Pull Request

↓

Review

↓

Merge

```

Following a consistent workflow reduces mistakes and simplifies collaboration.

---

# Commits

A commit represents a snapshot of the project at a particular point in time.

Each commit should contain a logical unit of work.

Examples include:

- Create staging models
- Configure schemas
- Add documentation
- Fix materialisation issue
- Remove legacy objects

Small, focused commits make project history much easier to understand.

---

# Syncing Changes

Once changes had been committed locally, they were synchronised with GitHub.

This ensured that:

- changes were backed up,
- collaborators could access the latest work,
- pull requests reflected the current project state.

---

# Pull Requests

After development was complete, a Pull Request (PR) was created.

Purpose of a Pull Request:

- review changes,
- discuss implementation,
- identify issues,
- approve the feature before merging.

The Pull Request contained:

- commit history,
- changed files,
- additions,
- deletions,
- discussion.

---

# Merge

After confirming there were no merge conflicts, the Pull Request was merged into the main branch.

This marked the feature as complete.

The feature branch could then be deleted to keep the repository organised.

---

# Git in dbt Cloud

Development was carried out using dbt Cloud's integrated Git functionality.

Rather than using Git commands in a terminal, common actions such as:

- committing,
- syncing,
- creating branches,
- opening pull requests,

were performed through the Version Control interface.

This simplified the workflow while still following standard Git practices.

---

# Lessons Learned

Several important lessons emerged during development.

Never develop directly on the main branch.

Commit regularly.

Use meaningful commit messages.

Test changes before committing.

Review Pull Requests carefully.

Version control should be considered part of the engineering process rather than an optional extra.

---

# Best Practices

Future projects should continue following these principles.

- One feature per branch.
- Small commits.
- Descriptive commit messages.
- Review before merging.
- Keep the main branch deployable.
- Delete merged feature branches.

---

# Knowledge Check

Before continuing, make sure you can answer the following.

- Why should development occur on a feature branch?
- What is the purpose of a Pull Request?
- Why are small commits preferable?
- Why should the main branch remain stable?
- What information does Git preserve?
- How does dbt Cloud integrate with Git?

If you can confidently answer these questions, you understand the version control workflow used throughout this project.

---

# Next Document

Continue with:

09_troubleshooting.md