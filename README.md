# AES — Aggressive Engineering System

A disciplined engineering protocol for LLM-assisted development.

## What this is

AES is not a prompt.

It is a **full execution system**:
- Documentation-first development
- Hostile analysis
- Goal-driven execution
- Continuous validation

## How to use

1. Load `SKILL.md` into your LLM (Claude / OpenCode)
2. Start every project by creating:
   - docs/VISION.md
   - docs/PERSONAS.md
   - docs/REQUIREMENTS.md
   - docs/ROADMAP.md
3. Use templates in `/templates`
4. Execute tasks following the protocol
5. Use `make check` before considering anything done

## Philosophy

> If it's not documented, it doesn't exist  
> If it's not tested, it's broken  
> If it's not questioned, it's wrong  

## Structure

- `SKILL.md` → core protocol
- `docs/` → project documentation
- `templates/` → execution templates
- `scripts/` → enforcement
- `Makefile` → command center
