# Roadmap

## [CRITICAL] Core Protocol Implementation

### R-1: Implement functional Makefile targets
- **Impact:** High - Without this, AES is just documentation
- **Effort:** Medium - 4-6 hours
- **Status:** doing
- **Validation:** `make check` actually runs tools and reports real issues
- **Dependencies:** R-2, R-3

### R-2: Validate docs via Makefile target
- **Impact:** High - Doc completeness is core to AES
- **Effort:** Low - 1-2 hours
- **Status:** done
- **Validation:** `make docs-check` fails on placeholders, empty files, TODOs in required docs
- **Dependencies:** R-1

### R-3: Scaffolding with inline Makefiles
- **Impact:** High - Enables adoption by new projects
- **Effort:** Medium - 3-4 hours
- **Status:** done
- **Validation:** `make new-project NAME=test` creates working project that passes `make check`
- **Dependencies:** R-1, R-2, R-4

### R-4: Language detection in SKILL.md
- **Impact:** High - Multi-language support is required
- **Effort:** Medium - 3-5 hours
- **Status:** doing
- **Validation:** SKILL.md contains complete language playbooks; Makefiles generated inline with correct commands
- **Dependencies:** R-3

### R-6: Makefile doctor target
- **Impact:** High - Helps users fix configuration issues
- **Effort:** Low - 2 hours
- **Status:** todo
- **Validation:** `make doctor` reports actionable diagnostics
- **Dependencies:** R-1, R-2, R-4

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

### R-0: Initial project structure (v3.0)
- **Impact:** High
- **Effort:** Low
- **Status:** done
- **Validation:** Repository has SKILL.md (v3.0 self-contained), Makefile, docs/, template/

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
