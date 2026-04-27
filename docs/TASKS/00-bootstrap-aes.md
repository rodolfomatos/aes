# Task: Initial AES Project Setup

## Goal
Bootstrap the AES (Aggressive Engineering System) repository with complete documentation, functional Makefile, robust scripts, and CI/CD. The project must pass all quality gates on itself.

## Hostile Analysis
- Assumption: AES will be used by others, so must work on first try
- Risk: Over-engineering the tooling itself (dogfooding paradox)
- Tradeoff: Simplicity vs. completeness - need enough features to be useful but not so much it's complex
- Question: Should AES support non-git projects? No - git assumed
- Edge: What if language detection fails? Must provide manual override

## Proposed Solution
1. Implement complete Makefile with all required targets
2. Write scripts for detection, validation, lint, test, doctor, metrics
3. Fill documentation (VISION, PERSONAS, REQUIREMENTS, ROADMAP) with real content
4. Add scaffolding capability (`make new-project`)
5. Create CI workflow (GitHub Actions)
6. Write SKILL.md in ECC format for Claude Code/OpenCode
7. Add self-test suite

**Why this approach?** All-or-nothing. Partial implementation is useless - AES must be production-ready on day 1.

**Simpler alternative considered?** No. This is the simplest version that actually works.

## Surgical Plan
1. Create core scripts (detect-language, validate-docs, check, doctor, metrics) → verify: `bash scripts/*.sh --help` works
2. Implement Makefile with all targets → verify: `make help` shows all commands
3. Fill docs with concrete requirements → verify: `./scripts/validate-docs.sh` passes
4. Add new-project scaffolding → verify: `make new-project NAME=test LANG=python` creates working project
5. Write SKILL.md → verify: contains `name:` and `summary:` fields (ECC format)
6. Create CI workflow → verify: `.github/workflows/ci.yml` exists and references `make check`
7. Add self-tests → verify: `tests/aes-self-test.sh` passes
8. Run `make check` on AES itself → verify: exits 0

## Validation
- [x] All required scripts exist and are executable
- [x] Makefile has all required targets (setup, test, lint, format, check, doctor, metrics, etc.)
- [x] Documentation is complete (no placeholders, meaningful content)
- [x] `make check` passes on AES project itself (dogfooding)
- [x] `make new-project` generates a working project that passes `make check`
- [x] CI workflow is present and will run on push
- [x] SKILL.md is in valid ECC format
- [x] Self-test suite exists and passes

## Failing Cases
- Missing script → `make check` fails
- Incomplete docs → `./scripts/validate-docs.sh` returns non-zero
- Language detection broken → `make setup` fails
- new-project generates broken project → manual verification fails
- CI workflow syntax invalid → GitHub Actions rejects

## Critical Review
- Can this be simpler? The core scripts are ~200 lines total. Could be smaller but clarity matters.
- Did I touch only what's needed? Yes, this is greenfield - all code is necessary.
- Side effects? None - AES is self-contained.
- What's still missing? 
  - Template files for all languages are minimal; could have more examples
  - No VS Code extension (future)
  - No Windows PowerShell support (by design)
  - No AI-assisted task generation (future)