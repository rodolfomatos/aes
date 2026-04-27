name: aep-aes
summary: Aggressive Engineering Protocol - Disciplined LLM-assisted development with hostile analysis, documentation-first, and Karpathy principles
tags:
  - engineering
  - protocol
  - quality
  - documentation
  - testing
tools: all
compatible:
  - opencode
  - claude-code
  - claude-desktop
---

# Aggressive Engineering Protocol (AEP) / AES

## When to Use

Invoke this skill when:
- Working on **non-trivial** tasks requiring rigor
- Setting up a new project from scratch
- Need to enforce quality gates before commit
- Want structured approach to problem-solving
- Developing with LLM assistance but need discipline
- Onboarding teams to consistent engineering standards

**Do NOT use for:**
- Simple typo fixes
- One-line obvious changes
- Quick experiments without lasting impact

## How to Activate

In Claude Code or OpenCode:

```
/load aep-aes
```

or if already loaded:

```
/skill aep-aes
```

The skill will automatically adopt the AES protocol for all subsequent work in the current session.

## Core Principles (Karpathy Integrated)

### 1. Think Before Coding

**Never assume. Never hide confusion. Surface tradeoffs.**

- If ambiguous, **ask before implementing**
- Present multiple interpretations when they exist
- Push back when simpler approach exists
- Stop and name what isn't clear

**In AES:** Mandatory "Hostile Analysis" phase before any implementation.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what's asked
- No abstractions for single-use code
- No "flexibility" or "configurability" not requested
- If 50 lines solve it, don't write 200

**Test:** Would a senior engineer call this overengineered? If yes → simplify.

**In AES:** "Can this be simpler?" is asked in every Critical Review.

### 3. Surgical Changes

**Touch only what's necessary. Clean only your own mess.**

- Don't "improve" adjacent code, comments, formatting
- Don't refactor things that aren't broken
- Match existing style
- If you notice unrelated dead code, **mention it** - don't DELETE

When your changes create orphans:
- Remove imports/variables/functions YOUR changes made obsolete
- Don't remove pre-existing dead code unless asked

**Test:** Every altered line must trace directly to the user's request.

**In AES:** "Did I touch only what was necessary?" is a Critical Review checkpoint.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Convert imperative tasks into verifiable outcomes:

- Instead of "Add validation" → "Write tests for invalid inputs, then make pass"
- Instead of "Fix the bug" → "Write test that reproduces, then make pass"
- Instead of "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

**Strong criteria = independent loops. Weak criteria ("make it work") = constant clarifications.**

**In AES:** Every task MUST have a "Surgical Plan" with verification checkpoints.

## AES Execution Loop (Mandatory)

For **every** task:

```
1. HOSTILE ANALYSIS
   - Identify assumptions
   - Detect omissions
   - Challenge requirements

2. SOLUTION PROPOSAL
   - Define approach
   - Justify decisions
   - Compare alternatives

3. IMPLEMENTATION
   - No technical debt
   - No duplication
   - Maintain consistency

4. VALIDATION
   - Does it solve the problem?
   - Edge cases covered?
   - Side effects?

5. CRITICAL REVIEW
   - Can it be simpler?
   - Is it correct?
   - Does it scale?

If not solid → restart loop
```

## Quality Gates (Non-Negotiable)

A task is **NOT DONE** unless:

- ✅ Implemented (code works)
- ✅ Validated (tests pass, edge cases covered)
- ✅ Documented (docs updated: VISION, PERSONAS, REQUIREMENTS, ROADMAP)
- ✅ Critically reviewed (simplicity, correctness, scalability checked)

**Failure in any → task is incomplete.**

## Project Bootstrap Checklist

Before starting any work, ensure the project has:

```
docs/VISION.md          - Problem, solution, value
docs/PERSONAS.md        - User types, needs, behaviors
docs/REQUIREMENTS.md    - Functional & non-functional requirements
docs/ROADMAP.md         - Backlog with Impact/Effort/Priority/Status
Makefile               - With all required targets
scripts/               - Detection, validation, lint, test, etc.
template/task.md       - Structured task template
```

If missing → run `make new-project NAME=[project] LANGUAGE=[lang]` to scaffold.

## Commands to Use

### Project Setup
```bash
make setup            # Detect language, install dependencies
make new-project NAME=myapp LANG=python  # Scaffold new project
```

### Development Cycle
```bash
make test             # Run tests with coverage
make lint             # Auto-fix lint issues
make format           # Format code
```

### Quality Gates
```bash
make check            # Run ALL gates (docs, code, tests, lint)
make doctor           # System diagnostics
make metrics          # Health dashboard
```

### Project Management
```bash
make roadmap          # Show task status
```

### Skill Management
```bash
make install-claude   # Install this skill for Claude Code
make install-opencode # Install this skill for OpenCode
make list-skill       # Show installations
```

## Auto-Installation

To install this skill in your Claude Code or OpenCode environment:

```bash
# From the AES project root:
make install-claude   # Install for Claude Code only
make install-opencode # Install for OpenCode only
make install-all      # Install for both
```

The skill will be available in `~/.claude/skills/aep-aes` or `~/.config/opencode/skills/aep-aes`.

After installation, in Claude Code:
```
/load aep-aes
```

## Makefile Targets Reference

All AES projects **must** have these targets:

| Target   | Purpose                            | Required |
|----------|------------------------------------|----------|
| `setup`  | Install dependencies               | Yes      |
| `run`    | Execute application                | Yes      |
| `test`   | Run tests with coverage            | Yes      |
| `lint`   | Code quality check (auto-fix)      | Yes      |
| `format` | Code formatting                    | Yes      |
| `build`  | Build artifacts                    | Optional |
| `deploy` | Deployment                         | Optional |
| `check`  | **All quality gates** (fails fast) | **Yes**  |
| `doctor` | System diagnostics                 | Yes      |
| `metrics`| Health dashboard                   | Yes      |
| `roadmap`| Task status                        | Yes      |

## Language Support

AES auto-detects and configures:

| Language  | Linter       | Test Framework | Coverage | Formatter    |
|-----------|--------------|----------------|----------|--------------|
| JavaScript| ESLint       | Jest           | Istanbul | Prettier     |
| Python    | Ruff         | pytest         | Coverage.py | Black     |
| Go        | go vet       | go test        | go tool  | gofmt        |
| Rust      | cargo clippy | cargo test     | tarpaulin| cargo fmt    |
| Java      | Gradle check | JUnit 5        | JaCoCo   | google-java-format |
| PHP       | php -l       | PHPUnit        | --       | php-cs-fixer |
| Flutter   | flutter analyze | flutter test  | --       | dart format   |

## Examples

### Example 1: Fixing a Bug

**User:** "The login fails when email has uppercase"

**AES Response:**

```
I'll use the Aggressive Engineering Protocol.

## Hostile Analysis
- Assumption: validator is case-sensitive
- Possible causes: DB collation, regex, comparison operator
- Edge: empty email, special chars, unicode
- Simpler fix: normalize email to lowercase before validation

## Proposed Solution
1. Write failing test: uppercase@EXAMPLE.com → passes
2. Find validation code (src/auth.js:45)
3. Add .toLowerCase() to email before validation
4. Verify all tests pass

## Surgical Plan
1. Create test → verify: jest test fails
2. Modify validateEmail() → verify: test passes, no regressions
3. Update docs if behavior changed

## Validation
- [x] Test reproduces bug
- [x] Fix makes test pass
- [x] All existing tests still pass
- [x] No lint errors introduced

## Critical Review
- Can this be simpler? (Yes: one-line change)
- Did I touch only what's needed? (Yes: only added .toLowerCase())
- Side effects? (No: lowercase is standard email normalization)
```

### Example 2: New Feature

**User:** "Add user export to CSV"

**AES Response:**

```
Using AES protocol.

## Hostile Analysis
- What's "export"? Format? Destination? Frequency?
- Assumption: one-time download, comma-separated
- Constraints: GDPR - must not leak other users' data
- Tradeoff: streaming vs in-memory (large datasets)
- Simpler: async background job vs synchronous

## Questions before proceeding:
1. Should export be async (email when ready) or sync (immediate download)?
2. What fields? All user data or just basic (email, name)?
3. Any rate limiting? Who can export?
4. Max rows per export? (security: prevent DoS)

Please clarify so I can implement the simplest correct solution.
```

## Troubleshooting

### `make check` fails

```bash
# 1. Run diagnostics
make doctor

# 2. Common fixes:
# - Missing docs: fill docs/VISION.md, etc.
# - Low coverage: add tests in tests/
# - Lint errors: make lint (auto-fix) or edit manually
# - TODOs: either implement or remove TODO comments
```

### Language detection wrong

```bash
# Set manually in Makefile:
export AES_LANGUAGE=python
# or edit scripts/detect-language.sh to add your framework
```

### CI/CD not running

```bash
# Ensure .github/workflows/ci.yml exists and has:
# - steps: make setup, make check, make test
# If missing: make new-project or copy from template
```

### Want to customize lint/test thresholds?

Edit `.aes/config`:
```
AES_COVERAGE_THRESHOLD=90
AES_LINT_ARGS=--max-warnings 10
```

## Templates

Task template (`docs/TASKS/task.md`):

```markdown
# Task: [Name]

## Goal
[SMART: Specific, Measurable, Achievable, Relevant, Time-bound]

## Hostile Analysis
- What assumptions are we making?
- What could go wrong?
- What is the simplest possible solution?
- Are there existing patterns in the codebase?
- What are the tradeoffs?

## Proposed Solution
**Approach:** [One sentence]
**Why this over alternatives:** [Justification]
**Simpler alternative considered:** [Yes/No + reason]

## Surgical Plan
1. [Step] → verify: [How to verify]
2. [Step] → verify: [How to verify]
3. [Step] → verify: [How to verify]

**Rule:** Each step must have a verification (automated or manual check).

## Pre-Implementation Checklist
- [ ] Have I asked clarifying questions?
- [ ] Does this solve ONLY the stated problem?
- [ ] Is there existing code I can reuse?
- [ ] What edge cases exist?
- [ ] How will I know it's correct?

## Validation
**Success criteria:**
- [ ]
- [ ]

**Failing cases to test:**
- [ ]
- [ ]

## Post-Implementation Review
- [ ] Can this be 50% simpler?
- [ ] Did I touch only what was necessary?
- [ ] Are there any side effects?
- [ ] Is it tested?
- [ ] Is it documented?
```

## Philosophy (AES Manifesto)

> **If it's not documented, it doesn't exist.**
> Every decision, requirement, persona must be written down.

> **If it's not tested, it's broken.**
> Code without tests is untrustworthy. Period.

> **If it's not questioned, it's wrong.**
> Hostile analysis surfaces flaws before they're baked in.

> **Simplicity is preferred over flexibility.**
> YAGNI. Build for today's problem, not tomorrow's speculation.

> **Surgical changes only.**
> Refactor only when necessary. Never "clean up" adjacent code.

> **Quality gates are non-negotiable.**
> `make check` must pass. No exceptions.

## Further Reading

- [Karpathy's 4 Principles](https://example.com/karpathy) (inspiration)
- [Test-Driven Development](https://example.com/tdd) (validation mindset)
- [Documentation-Driven Development](https://example.com/ddd) (AES foundation)

## License

MIT - See LICENSE file.

## Support

- Issues: https://github.com/yourusername/aes/issues
- Discussions: https://github.com/yourusername/aes/discussions
- Contributing: See CONTRIBUTING.md

---

**Version:** 2.0
**Last Updated:** 2026-04-26
**Compatible with:** Claude Code, OpenCode, Claude Desktop