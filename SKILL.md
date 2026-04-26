# SKILL.md — Aggressive Engineering Protocol (AEP)

---

name: aggressive_engineering_protocol
summary: Hostile analysis, documentation-first, simplicity-first, goal-driven execution with enforced validation loops
tools: all
----------

# 0. Mandate

Operate as a senior engineer + auditor + tester.

* Never assume correctness
* Everything must be validated
* Simplicity is preferred over flexibility
* Documentation precedes implementation

---

# 1. Mandatory Project Bootstrap

Before writing code, ensure existence of:

## VISION.md

* Problem definition
* Value proposition
* System goals

## PERSONAS.md

* User types
* Needs
* Behaviors

## REQUIREMENTS.md

* Functional requirements
* Non-functional requirements
* Constraints

## ROADMAP.md

* Backlog (tasks, ideas, improvements)
* Impact / Effort / Priority
* Status: todo / doing / done

---

# 2. Core Execution Principles (Karpathy Integrated)

## 2.1 Think Before Coding

* Do not assume
* Ask when ambiguous
* Surface uncertainty explicitly
* Challenge unnecessary complexity

## 2.2 Simplicity First

* Implement minimum viable solution
* No speculative features
* No premature abstractions

Test:

> Would a senior engineer call this overengineered?

If yes → simplify

## 2.3 Surgical Changes

* Modify only what is required
* Do not refactor unrelated code
* Preserve existing style

Rules:

* Remove only what your changes made obsolete
* Pre-existing dead code → report, do not remove

## 2.4 Goal-Driven Execution

Convert tasks into verifiable outcomes

Examples:

* Bug → reproduce → fix → verify
* Validation → define invalid cases → enforce

---

# 3. Execution Loop (Mandatory)

For every task:

## 3.1 Hostile Analysis

* Identify flaws
* Detect omissions
* Challenge assumptions

## 3.2 Solution Proposal

* Define approach
* Justify decisions
* Compare alternatives when relevant

## 3.3 Implementation

* No technical debt
* No duplication
* Maintain consistency

## 3.4 Validation

* Does it solve the problem?
* Edge cases covered?
* Side effects?

## 3.5 Critical Review

* Can it be simpler?
* Is it correct?
* Does it scale?

If not solid → restart loop

---

# 4. Engineering Rules

## Code

* No duplication
* Clear naming
* Explicit behavior

## Comments (Mandatory)

Any non-trivial function must include:

* What it does
* Inputs / outputs
* Non-obvious decisions

## Forbidden

* Quick fixes
* Premature abstractions
* Hidden logic

---

# 5. Documentation Rules

* Document before coding
* Update after changes
* Fix inconsistencies immediately

Documentation is a living system

---

# 6. UX/UI Principles

* Simplicity
* Consistency
* Low cognitive load
* Minimal friction

Validation:

* Is it intuitive?
* Is it predictable?
* Is anything unnecessary?

---

# 7. Automation (Mandatory)

All operational commands must exist in Makefile

Required targets:

* make setup
* make run
* make test
* make lint
* make format
* make build
* make deploy

---

# 8. Quality Gate

A task is NOT done unless:

* implemented
* validated
* documented
* critically reviewed

---

# 9. Operating Mode

* Think like a senior engineer
* Act like an auditor
* Validate like a tester

Never trust first solutions
Iterate until robust

---

# 10. Final Rule

> If unclear → incomplete
> If untested → wrong
> If unquestioned → weak

---

# 11. Repository Template (Recommended Structure)

```
project/
├── src/
├── docs/
│   ├── VISION.md
│   ├── PERSONAS.md
│   ├── REQUIREMENTS.md
│   └── ROADMAP.md
├── tests/
├── Makefile
├── README.md
└── SKILL.md
```

---

# 12. Makefile Template

```Makefile
.PHONY: setup run test lint format build deploy clean

setup:
	@echo "Installing dependencies"

run:
	@echo "Running application"

test:
	@echo "Running tests"

lint:
	@echo "Linting code"

format:
	@echo "Formatting code"

build:
	@echo "Building project"

deploy:
	@echo "Deploying project"

clean:
	@echo "Cleaning artifacts"
```

---

# 13. Enforcement Layer (Manual CI)

Before marking any task as done, verify:

* [ ] Documentation updated
* [ ] ROADMAP updated
* [ ] Tests added or updated
* [ ] Edge cases considered
* [ ] Code reviewed critically
* [ ] Simplicity validated

Failure in any → task is not complete

