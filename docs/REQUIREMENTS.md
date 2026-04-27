# Requirements

## Functional

### FR-1: Documentation-First Workflow
The system enforces that key documentation files exist before any code is written:
- `docs/VISION.md` - Problem, solution, value
- `docs/PERSONAS.md` - User types and needs
- `docs/REQUIREMENTS.md` - Functional & non-functional requirements
- `docs/ROADMAP.md` - Backlog with Impact/Effort/Priority/Status

### FR-2: Task Structuring
Every piece of work is captured in `docs/TASKS/[name].md` or `template/task.md` format including:
- Hostile analysis (assumptions, risks, alternatives)
- Proposed solution with justification
- Surgical execution plan with verification checkpoints
- Validation criteria (pass/fail cases)
- Critical review questions

### FR-3: Makefile Automation
The project has a `Makefile` with at least these targets:
- `setup` - Install dependencies
- `run` - Execute the application
- `test` - Run tests with coverage
- `lint` - Code quality checks
- `format` - Code formatting
- `build` - Build artifacts
- `deploy` - Deployment (if applicable)
- `check` - Full validation (runs all quality gates)
- `doctor` - System diagnostics
- `metrics` - Health dashboard

### FR-4: Quality Gates
`make check` fails if ANY of:
- Required docs missing or contain placeholders/TODOs
- Test coverage below threshold (default 80%)
- Lint errors present
- TODO comments found in code (non-documentation files)
- Makefile missing required targets

### FR-5: Multi-Language Support
AES works with:
- JavaScript/TypeScript (Node.js, React, Next.js)
- Python (Django, Flask, FastAPI)
- Go
- Rust
- Java (Spring Boot)
- PHP (Laravel)
- Flutter (Dart)

Detection via canonical files (package.json, pyproject.toml, go.mod, Cargo.toml, pom.xml, build.gradle, composer.json, pubspec.yaml).

### FR-6: Scaffolding
AES provides `make new-project NAME [LANGUAGE]` to generate:
- Complete directory structure
- Base Makefile for detected language
- GitHub Actions CI workflow
- Pre-populated documentation templates
- Example task file

### FR-7: CI/CD Integration
Generated projects include `.github/workflows/ci.yml` that:
- Runs `make check` on every push/PR
- Uploads coverage to Codecov
- Fails if quality gates not met

### FR-8: Karpathy Compliance
The protocol enforces the 4 principles:
1. Think Before Coding - via mandatory hostlie analysis
2. Simplicity First - via "could this be simpler?" review
3. Surgical Changes - via "only touch what's necessary" rule
4. Goal-Driven - via verifiable checkpoints in execution plan

## Non-Functional Requirements

### NFR-1: Simplicity
- No unnecessary abstractions
- Scripts in bash for portability
- Minimal dependencies (runs on any Unix-like system)
- Clear, readable configuration

### NFR-2: Maintainability
- Self-documenting code in scripts
- Each script does ONE thing
- Easy to extend for new languages
- Can be used to build AES itself (dogfooding)

### NFR-3: Performance
- `make check` completes in <30s for typical project
- Language detection is instantaneous
- Scaffolding generates full project in <5s

### NFR-4: Reliability
- Check script must never false-positive (no "works on my machine")
- All scripts have exit codes
- CI must be deterministic

### NFR-5: Extensibility
- Plugin system in `.aes/plugins/` for custom hooks
- Language-specific overrides via `templates/[lang]/`
- Configurable thresholds (coverage %, lint rules) via `.aes/config`

### NFR-6: Observability
- `make metrics` provides JSON/CLI output of:
  - Tasks completed vs total
  - Test coverage %
  - Lint issues count
  - Last check status
  - Time since last docs update

## Constraints

### C-1: Tooling Dependencies
- Assumes standard tooling per language (eslint/pytest/go test/etc.)
- Does NOT install language runtimes (developer must have them)
- Uses `make` as orchestrator (POSIX-compatible)

### C-2: Git Integration
- Assumes project is in git repository
- Uses `git log` for metrics
- Does not manage branches or commits automatically

### C-3: Platform
- Designed for Unix-like systems (Linux, macOS)
- Windows requires WSL or Git Bash
- No Windows PowerShell native support (bash required)

## Future Requirements (Out of Scope v1.0)

- Visual IDE plugin (VS Code extension)
- Web dashboard for metrics
- AI-assisted task generation from issues
- Automatic PR description generation
- Multi-repo aggregation
