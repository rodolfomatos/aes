---
name: aes
description: >
  Aggressive Engineering Protocol (AEP) — Use for any non-trivial engineering task:
  tasks touching 3+ files, architectural decisions, new dependencies, new features,
  refactors, or anything where a wrong decision is costly. Enforces hostile analysis,
  documentation-first, surgical changes, and Karpathy's 4 principles.
  Do NOT use for: typo fixes, one-liners, throwaway scripts, or trivial config changes.
compatibility: claude-code, opencode, claude-desktop
metadata:
  author: AES Maintainers
  version: 3.0
  tags: engineering, protocol, quality, documentation, testing
---

# AES — Aggressive Engineering Protocol

You are operating under the **AES protocol**. This is not optional. Every task goes through the
Execution Loop below. No exceptions for "quick fixes" unless explicitly scoped as trivial (< 3 lines,
zero side effects, no architectural impact).

---

## The 3 Rules (Non-Negotiable)

> **If it's not documented, it doesn't exist.**
> **If it's not tested, it's broken.**
> **If it's not questioned, it's wrong.**

---

## Karpathy Principles

### 1. Think Before Coding
Never assume. Surface tradeoffs before touching a file. If the task is ambiguous, **ask one
clarifying question** before starting — not five, not zero.

### 2. Simplicity First
Write the minimum code that solves the problem. If 40 lines solve it, don't write 120.
No speculative abstractions. No "while I'm here" refactors.

### 3. Surgical Changes
Touch **only** what the task requires. Do not "improve" adjacent code. Match existing style exactly.
Every changed line must be justified.

### 4. Goal-Driven Execution
Before implementing, define: *"This task is done when [X] is verifiably true."*
Transform vague requests: `"Add login"` → `"Write tests for login flow, then make them pass."`

---

## Execution Loop (Mandatory for Every Task)

### Phase 1 — Hostile Analysis

Before writing a single line of code, answer these questions explicitly:

```
ASSUMPTIONS I'M MAKING (that could be wrong):
- [list each one]

WHAT WASN'T SPECIFIED (that matters):
- [list gaps in the requirements]

ALTERNATIVES I DIDN'T CHOOSE (and why):
- Option A: [describe] — rejected because [reason]
- Option B: [describe] — rejected because [reason]

RISKS & SIDE EFFECTS:
- [what could break, degrade, or become harder to change]

COST OF BEING WRONG:
- [low / medium / high — and why]
```

If cost of being wrong is HIGH → pause and confirm with the user before proceeding.

### Phase 2 — Solution Proposal

State the chosen approach clearly:
- What you will change and why
- What you will NOT change (and why)
- Verification criteria: how will you know it worked?

### Phase 3 — Implementation

- Minimal diff. No dead code. No commented-out blocks.
- Every new function has a docstring or inline comment explaining *why*, not *what*.
- If you discover scope creep mid-implementation → stop, document it as a separate task, continue.

### Phase 4 — Validation

Run quality gates appropriate for the project's language (see Language Playbooks below).

Explicitly verify:
- [ ] Tests pass (including edge cases you identified in Phase 1)
- [ ] No regressions in adjacent functionality
- [ ] Docs updated if behaviour changed

### Phase 5 — Critical Review

Before declaring done, answer:
- *Can this be simpler?* (If yes → simplify it)
- *Is this correct for all inputs I identified?*
- *Does this introduce any technical debt?* (If yes → create a task for it)
- *Would a teammate understand this without asking me?*

**If any answer is unsatisfactory → restart the loop from Phase 1.**

---

## Quality Gates (Task is NOT Done Until All Pass)

| Gate | Check |
|------|-------|
| ✅ Implemented | Code works for the happy path |
| ✅ Edge cases | Boundary conditions handled and tested |
| ✅ Tests pass | Language-specific test command exits 0 |
| ✅ Lint passes | Language-specific linter exits 0 |
| ✅ Format correct | Code formatter reports no changes needed |
| ✅ Docs updated | VISION/REQUIREMENTS/ROADMAP reflect the change |
| ✅ Reviewed | Simplicity and correctness confirmed |

---

## Project Documentation (Required for Non-Trivial Projects)

Every AES project must have these files in `docs/`:

| File | Contents |
|------|----------|
| `VISION.md` | Problem, solution, value proposition |
| `PERSONAS.md` | Who uses this and how |
| `REQUIREMENTS.md` | Functional + non-functional requirements |
| `ROADMAP.md` | Backlog with Impact / Effort / Priority / Status |

If these don't exist → create them **before** any feature work. A feature without a VISION is
a guess. A ROADMAP without priorities is noise.

---

## Language Detection & Configuration (Self-Contained Playbook)

As an LLM executing AES, you must determine the project language by inspecting the filesystem.
No external scripts are used. Detection is based on presence of canonical files:

| Language | Detection Files | Lint Command | Test Command | Format Command | Build Command | Run Command |
|----------|----------------|--------------|--------------|----------------|---------------|-------------|
| TypeScript/JavaScript | `package.json` | `npx eslint . --ext .js,.ts` | `npx jest` or `npm test` | `npx prettier --write .` | `npm run build` | `npm start` |
| Python | `pyproject.toml` or `setup.py` or `setup.cfg` | `ruff check` | `pytest` | `ruff format` or `black` | `python -m build` | `python -m src` |
| Go | `go.mod` | `go vet ./...` | `go test ./...` | `gofmt -w .` (in-place) or `go fmt ./...` | `go build` | `go run` |
| Rust | `Cargo.toml` | `cargo clippy --all-targets --all-features` | `cargo test` | `cargo fmt --all --check` | `cargo build` | `cargo run` |
| Java (Gradle) | `pom.xml` or `build.gradle` or `build.gradle.kts` | `./gradlew check` | `./gradlew test` | `google-java-format -i **/*.java` | `./gradlew build` | `./gradlew run` |
| PHP (Composer) | `composer.json` | `php -l` (syntax) + `./vendor/bin/phpstan analyse` if present | `./vendor/bin/pest` or `./vendor/bin/phpunit` | `php-cs-fixer fix` | `composer install` | `php -S localhost:8000` |
| Dart/Flutter | `pubspec.yaml` | `dart analyze` or `flutter analyze` | `dart test` or `flutter test` | `dart format .` | `flutter build` | `flutter run` |

**Detection logic** (use this ordering):
1. If `package.json` exists → JavaScript/TypeScript
2. Else if `pyproject.toml` or `setup.py` or `setup.cfg` exists → Python
3. Else if `go.mod` exists → Go
4. Else if `Cargo.toml` exists → Rust
5. Else if `pom.xml` or `build.gradle*` exists → Java
6. Else if `composer.json` exists → PHP
7. Else if `pubspec.yaml` exists → Dart/Flutter
8. Else → unknown (use generic placeholders)

**Note**: For Makefile generation, store detected commands in variables:
- `AES_LANGUAGE`
- `AES_LINT`
- `AES_TEST`
- `AES_FORMAT`
- `AES_BUILD`
- `AES_RUN`

---

## Scaffolding Playbook (Self-Contained)

When creating a new project (`make new-project NAME=myapp LANG=python`), the LLM must:

1. Create directory structure:
   ```
   myapp/
   ├── docs/
   │   ├── VISION.md
   │   ├── PERSONAS.md
   │   ├── REQUIREMENTS.md
   │   ├── ROADMAP.md
   │   └── TASKS/
   ├── src/ (or language-specific equivalent)
   ├── tests/ (or language-specific equivalent)
   ├── .github/workflows/
   ├── .aes/plugins/
   ├── Makefile
   └── (language-specific config files)
   ```

2. Populate `docs/` with templates (use placeholders that user must fill).

3. Generate **base source code** using native ecosystem tools **when available**:
   - **JavaScript/TypeScript**: Use `npm create` (or `pnpm create`, `yarn create`) to scaffold, then add `package.json` scripts if missing.
     - Or create minimal: `src/index.js` or `src/index.ts` + `package.json` with scripts: `start`, `test`, `lint`, `format`, `build`.
   - **Python**: Use `uv init` (preferred) or `python -m venv .venv && pip install -e .`; create `pyproject.toml` with `[tool.ruff]`, `[tool.pytest]`, `[tool.black]`; minimal `src/main.py` or package structure.
   - **Go**: Use `go mod init <module-name>`; create `main.go` in root or `src/`.
   - **Rust**: Use `cargo new` (creates structure automatically).
   - **Java (Gradle)**: Use `gradle init` (application type) or create `build.gradle` with `application` plugin and `src/main/java/...`.
   - **PHP**: Create `composer.json` with `"autoload": {"psr-4": {"App\\": "src/"}}`; minimal `src/index.php`.
   - **Dart/Flutter**: Use `flutter create` if available; otherwise create `pubspec.yaml` and minimal `lib/main.dart`.

4. Generate **Makefile** (see reference below).

5. Generate **GitHub Actions CI** (`.github/workflows/ci.yml`) that runs `make check`.

6. Generate **.gitignore** with language-appropriate entries.

7. Initialize git and make initial commit (if not already a git repo).

**Important**: The LLM must NOT copy shell scripts from a template directory. All logic must be inline in the generated Makefile or documented in SKILL.md for the user to implement manually.

---

## Makefile Reference (Inline, No External Scripts)

The Makefile should contain targets that directly invoke language-native tools. Example for **Python**:

```makefile
.PHONY: setup run test lint format build deploy check doctor help

AES_LANGUAGE ?= python
AES_LINT ?= ruff check
AES_TEST ?= pytest
AES_FORMAT ?= ruff format
AES_BUILD ?= python -m build
AES_RUN ?= python -m src

export AES_LANGUAGE AES_LINT AES_TEST AES_FORMAT AES_BUILD AES_RUN

setup:
	@echo "🔧 Setting up $(AES_LANGUAGE) project..."
	pip install -e .

run:
	@$(AES_RUN)

test:
	@$(AES_TEST) --cov=src

lint:
	@$(AES_LINT)

format:
	@$(AES_FORMAT)

build:
	@$(AES_BUILD)

check: docs-check code-check test-check lint-check

docs-check:
	@# Verify docs/VISION.md, PERSONAS.md, REQUIREMENTS.md, ROADMAP.md exist and have real content
	@test -f docs/VISION.md && grep -q "Problem" docs/VISION.md
	@test -f docs/PERSONAS.md && grep -q "User" docs/PERSONAS.md
	@test -f docs/REQUIREMENTS.md && grep -q "Functional" docs/REQUIREMENTS.md
	@test -f docs/ROADMAP.md && grep -q "Roadmap" docs/ROADMAP.md

code-check:
	@# Verify code structure: src/ exists, no TODO in source files
	@test -d src || test -d lib || test -d app
	@grep -R "TODO:" src/ tests/ 2>/dev/null || true

test-check:
	@# Verify test coverage threshold (default 80%)
	@$(AES_TEST) --cov=src --cov-fail-under=80 || echo "Coverage below 80%"

lint-check:
	@$(AES_LINT)

doctor:
	@echo "Language: $(AES_LANGUAGE)"
	@echo "Lint: $(AES_LINT)"
	@echo "Test: $(AES_TEST)"

metrics:
	@# TODO: implement metrics (git log, coverage xml, etc.)

help:
	@echo "AES Commands:"
	@echo "  make setup      - Install dependencies"
	@echo "  make run        - Run the app"
	@echo "  make test       - Run tests with coverage"
	@echo "  make lint       - Check code quality"
	@echo "  make format     - Format code"
	@echo "  make build      - Build artifacts"
	@echo "  make check      - Run ALL quality gates"
	@echo "  make doctor     - System diagnostics"
```

Adapt the commands for each language using the table above. The `check` target aggregates:
- `docs-check`: ensure required docs exist and contain substantive content (not just placeholders)
- `code-check`: check for `TODO:` in source files, verify directory structure
- `test-check`: run tests with coverage threshold (adjust per project)
- `lint-check`: run linter in non-fix mode

**No external scripts are called**. All logic is inline in the Makefile.

---

## Worked Example — Hostile Analysis in Practice

**Task:** *"Add rate limiting to the API."*

```
ASSUMPTIONS I'M MAKING:
- Rate limiting should apply per-IP (not per-user or per-api-key)
- 100 req/min is an acceptable default
- Redis is available for the token bucket

WHAT WASN'T SPECIFIED:
- What happens when the limit is hit (429? silent drop? queue?)
- Whether authenticated users get a higher limit
- Whether rate limit headers (X-RateLimit-*) are required

ALTERNATIVES I DIDN'T CHOOSE:
- In-memory limiting: rejected — doesn't work across multiple instances
- Third-party service (Cloudflare, etc.): rejected — adds external dependency for core logic

RISKS & SIDE EFFECTS:
- If Redis goes down, all requests may fail (need fallback strategy)
- Existing integration tests don't mock rate limiting — they'll need updating

COST OF BEING WRONG: HIGH — affects all API consumers
→ Confirming with user before proceeding.
```

---

## When NOT to Use AES

Skip the full protocol for:
- Fixing a typo or a single obvious bug with no side effects
- One-liner config changes
- Throwaway prototypes (label them `[PROTOTYPE]` in commits)
- Documentation-only edits

In these cases: make the change, verify locally, done.

---

## Makefile Quick Reference (Generated per project)

Common targets (adapt commands to your language):
```bash
make setup      # Install dependencies
make run        # Run the application
make test       # Run tests with coverage
make lint       # Check/fix lint issues
make format     # Format code
make build      # Build artifacts
make check      # Run ALL quality gates (must pass)
make doctor     # System diagnostics
make help       # Show all targets
```

Language auto-detected via presence of configuration files:
- `package.json` → JavaScript/TypeScript
- `pyproject.toml` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust
- `pom.xml` or `build.gradle*` → Java
- `composer.json` → PHP
- `pubspec.yaml` → Dart/Flutter

---

## Installation

AES is a skill for LLM interfaces (Claude Code, OpenCode, Claude Desktop). Copy `SKILL.md` to:

```bash
# For Claude Code
~/.claude/skills/aes/SKILL.md

# For OpenCode
~/.config/opencode/skills/aes/SKILL.md
```

No external scripts required. The skill is self-contained.

---

## Version History

- **3.0** (current) — Self-contained; no external shell scripts; language playbooks inline
- **2.1** — Script-based implementation with external `scripts/` directory
- **2.0** — Initial formalization of AES Execution Loop

---

**Version:** 3.0 | **Compatible with:** Claude Code, OpenCode, Claude Desktop