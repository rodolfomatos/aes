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
  version: 2.1
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

Run quality gates (adapt to the project):
```bash
make check    # or: npm test / pytest / go test ./... / cargo test
```

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
| ✅ Tests pass | `make check` (or equivalent) exits 0 |
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

## Worked Example — Hostile Analysis in Practice

**Task:** *"Add rate limiting to the API."*

```
ASSUMPTIONS I'M MAKING:
- Rate limiting should apply per-IP (not per-user or per-API-key)
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

## Makefile Quick Reference

```bash
make check          # ALL quality gates (docs + code + tests)
make test           # Tests with coverage
make lint           # Auto-fix lint issues
make format         # Format code
make doctor         # Diagnostics if check fails
make metrics        # Health dashboard
make roadmap        # Show task status
make new-project NAME=myapp LANG=python   # Scaffold new project
```

Language auto-detected via `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, etc.
Supported: JavaScript/TypeScript, Python, Go, Rust, Java, PHP, Dart.

---

## Installation

```bash
# As skill for LLM interfaces
make install-claude      # → ~/.claude/skills/aep-aes
make install-opencode    # → ~/.config/opencode/skills/aep-aes

# As CLI tool
sudo make install-cli    # → /usr/local/bin/aes

# Scaffold a new project from anywhere
aes new-project NAME=myapp LANG=python DIR=/opt
```

---

**Version:** 2.1 | **Compatible with:** Claude Code, OpenCode, Claude Desktop
