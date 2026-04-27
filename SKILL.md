---
name: aes
description: Aggressive Engineering Protocol - Disciplined LLM-assisted development with hostile analysis, documentation-first, and Karpathy principles. All details in docs/INDEX.md.
compatibility: opencode
metadata:
  author: "AES Maintainers"
  version: "2.0"
  tags: "engineering,protocol,quality,documentation,testing"
---

# AES (Aggressive Engineering Protocol)

**Full documentation:** See `docs/INDEX.md` in this skill directory.

## When to Use

- **Non-trivial** tasks requiring rigor
- New project setup from scratch
- Quality gate enforcement needed
- Structured problem-solving approach
- LLM-assisted development with discipline

**Do NOT use:** Simple typo fixes, one-liners, throwaway experiments.

## Activation

```
/load aes
```

or if already loaded:

```
/skill aes
```

## CLI Wrapper (Optional)

For command-line convenience, install the `aes` wrapper:

```bash
sudo make install-cli   # Installs to /usr/local/bin/aes
```

Then use anywhere:

```bash
aes new-project NAME=myapp LANG=python DIR=/opt
aes install --claude
aes list
```

See [INSTALLATION.md](docs/INSTALLATION.md) for details.

## Core Principles (Karpathy)

### 1. Think Before Coding
Never assume. Question everything. If ambiguous, ask before implementing.

### 2. Simplicity First
Minimum code that solves. No speculative features. If 50 lines solve it, don't write 200.

### 3. Surgical Changes
Touch only what's necessary. Don't "improve" adjacent code. Match existing style.

### 4. Goal-Driven Execution
Define verifiable success criteria. Loop until verified. Transform "Add X" → "Write tests for X, then make pass".

## Execution Loop (Mandatory)

For **every** task:
1. **Hostile Analysis** - Identify assumptions, omissions, tradeoffs
2. **Solution Proposal** - Define approach, justify decisions, compare alternatives
3. **Implementation** - No technical debt, no duplication
4. **Validation** - Does it solve? Edge cases? Side effects?
5. **Critical Review** - Can it be simpler? Correct? Scalable?

If not solid → restart loop.

## Quality Gates (Non-Negotiable)

A task is **NOT DONE** unless:
- ✅ Implemented (code works)
- ✅ Validated (tests pass, edge cases covered)
- ✅ Documented (docs updated)
- ✅ Critically reviewed (simplicity, correctness checked)

**Complete documentation** lives in `docs/`:
- [INDEX.md](docs/INDEX.md) - Documentation hub
- [PRINCIPLES.md](docs/PRINCIPLES.md) - Core principles detailed
- [EXECUTION-LOOP.md](docs/EXECUTION-LOOP.md) - 5-phase workflow
- [PHILOSOPHY.md](docs/PHILOSOPHY.md) - Manifesto and values
- [QUALITY-GATES.md](docs/QUALITY-GATES.md) - Completion criteria
- [BOOTSTRAP.md](docs/BOOTSTRAP.md) - Project setup checklist
- [COMMANDS.md](docs/COMMANDS.md) - Makefile targets reference
- [TEMPLATES.md](docs/TEMPLATES.md) - Task template and structure
- [INSTALLATION.md](docs/INSTALLATION.md) - Setup instructions (includes CLI wrapper)
- [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Common issues
- [LANGUAGE-SUPPORT.md](docs/LANGUAGE-SUPPORT.md) - Auto-configuration
- [EXAMPLES.md](docs/EXAMPLES.md) - Complete examples

## Philosophy Summary

- If it's not documented, it doesn't exist.
- If it's not tested, it's broken.
- If it's not questioned, it's wrong.
- Simplicity over flexibility.
- Surgical changes only.
- Quality gates are non-negotiable.

---

**Version:** 2.0
**Last Updated:** 2026-04-26
**Compatible with:** OpenCode, Claude Code, Claude Desktop
