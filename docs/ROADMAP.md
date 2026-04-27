# Roadmap

## [CRITICAL] Core Protocol Implementation

### R-1: Implement functional Makefile targets
- **Impact:** High - Without this, AES is just documentation
- **Effort:** Medium - 4-6 hours
- **Status:** doing
- **Validation:** `make check` actually runs tools and reports real issues
- **Dependencies:** R-2, R-3

### R-2: Create scripts/validate-docs.sh
- **Impact:** High - Doc completeness is core to AES
- **Effort:** Low - 1-2 hours
- **Status:** todo
- **Validation:** Fails on placeholders, empty files, TODOs in required docs
- **Dependencies:** None

### R-3: Create scripts/new-project.sh scaffolding
- **Impact:** High - Enables adoption by new projects
- **Effort:** Medium - 3-4 hours
- **Status:** todo
- **Validation:** `make new-project NAME=test` creates working project that passes `make check`
- **Dependencies:** R-1, R-2, R-4

### R-4: Language detection & config
- **Impact:** High - Multi-language support is required
- **Effort:** Medium - 3-5 hours
- **Status:** todo
- **Validation:** Correctly detects JS/Python/Go and sets env vars for lint/test commands
- **Dependencies:** R-3

## [HIGH] Quality & Automation

### R-5: GitHub Actions CI workflow
- **Impact:** High - Automated quality gate essential
- **Effort:** Low - 1 hour
- **Status:** todo
- **Validation:** PRs fail if `make check` fails
- **Dependencies:** R-1, R-2

### R-6: Scripts/doctor.sh diagnostics
- **Impact:** High - Helps users fix configuration issues
- **Effort:** Low - 2 hours
- **Status:** todo
- **Validation:** `make doctor` reports actionable fixes for common problems
- **Dependencies:** R-1, R-2, R-4

### R-7: Scripts/metrics.sh dashboard
- **Impact:** Medium - Progress tracking
- **Effort:** Low - 2 hours
- **Status:** todo
- **Validation:** `make metrics` shows tasks, coverage, lint issues, check status
- **Dependencies:** R-1

### R-8: Self-test suite (tests/aes-self-test.sh)
- **Impact:** High - AES must test itself
- **Effort:** Low - 2 hours
- **Status:** todo
- **Validation:** `make test` runs AES's own compliance as tests
- **Dependencies:** R-1, R-3

## [MEDIUM] Templates & Experience

### R-9: Language-specific templates (JS, Python, Go, Rust)
- **Impact:** Medium - Better out-of-box experience
- **Effort:** Medium - 4-6 hours
- **Status:** todo
- **Validation:** `make new-project NAME=foo LANG=js` generates correct Makefile for that ecosystem
- **Dependencies:** R-4

### R-10: Enhanced task template with Karpathy checklist
- **Impact:** Medium - Enforces rigor
- **Effort:** Low - 1 hour
- **Status:** todo
- **Validation:** Generated task files include pre-implementation checklist, verification steps
- **Dependencies:** None

### R-11: Plugin system (.aes/plugins)
- **Impact:** Low - Extensibility for advanced users
- **Effort:** Medium - 3-4 hours
- **Status:** todo
- **Validation:** Plugins in `.aes/plugins/pre-commit` automatically run
- **Dependencies:** R-1

## [MEDIUM] Skill & Distribution

### R-12: Transform SKILL.md to ECC format
- **Impact:** High - Makes AES installable as skill
- **Effort:** Low - 1 hour
- **Status:** todo
- **Validation:** Can be loaded by Claude Code via skill system
- **Dependencies:** None (but should happen after core implementation)

### R-13: Create aes-cli (standalone binary)
- **Impact:** Medium - Better UX than raw Makefile
- **Effort:** High - 8-12 hours
- **Status:** todo
- **Validation:** `aes init`, `aes task`, `aes check` work independently
- **Dependencies:** R-1, R-2, R-3, R-4

### R-14: Publish to package registries
- **Impact:** Low - Distribution
- **Effort:** Medium - 2-3 hours
- **Status:** todo
- **Validation:** `pip install aes-protocol` or `npm install -g aes-cli` works
- **Dependencies:** R-13

## [LOW] Polish & Advanced Features

### R-15: VS Code extension
- **Impact:** Low - IDE integration
- **Effort:** High - 12-16 hours
- **Status:** todo
- **Validation:** Real-time AES compliance highlighting
- **Dependencies:** R-12, R-13

### R-16: LSP (Language Server Protocol)
- **Impact:** Low - Generic IDE support
- **Effort:** High - 12-16 hours
- **Status:** todo
- **Validation:** Works with any LSP-compatible editor
- **Dependencies:** R-15

### R-17: AI-assisted task generation (AES.AI)
- **Impact:** Medium - Auto-create tasks from issues/PRs
- **Effort:** High - 8-12 hours
- **Status:** todo
- **Validation:** `aes generate-task --from-issue=123` produces valid task.md
- **Dependencies:** R-12, R-13

## Completed

### R-0: Initial project structure
- **Impact:** High
- **Effort:** Low
- **Status:** done
- **Validation:** Repository has SKILL.md, Makefile, docs/, templates/, scripts/

---

## Milestones

**M1: Core Functional (R-1 through R-8)**
- AES actually works on real projects
- Quality gates enforced
- CI/CD automated
- Target: Week 1

**M2: Developer Experience (R-9 through R-11)**
- Great templates and scaffolding
- Self-testing passes
- Target: Week 2

**M3: Distribution (R-12 through R-14)**
- Installable as skill and CLI
- Target: Week 3

**M4: Polish (R-15 through R-17)**
- IDE integration
- AI-assisted features
- Target: Week 4

---

## Metrics of Success

- ✅ `make check` passes on AES itself (dogfooding)
- ✅ New project scaffolded in <5 minutes
- ✅ CI fails on ANY quality gate violation
- ✅ Test coverage >80% on AES codebase
- ✅ Zero TODO placeholders in production code
- ✅ Documentation updated with every change
