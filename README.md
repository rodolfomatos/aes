# AES — Aggressive Engineering System

A disciplined engineering protocol for LLM-assisted development.

## What this is

AES is **not** a prompt. It's a **full execution system** combining:

- 📄 **Documentation-first** - VISION, PERSONAS, REQUIREMENTS, ROADMAP mandatory
- 🔍 **Hostile analysis** - Question everything before coding
- ✂️ **Surgical changes** - Touch only what's necessary
- 🎯 **Goal-driven** - Verifiable success criteria
- ✅ **Continuous validation** - `make check` enforces quality gates

Based on Karpathy's 4 principles for LLM-assisted development.

## Quick Start

### As a Skill (Claude Code / OpenCode)

Install the skill globally:

```bash
# From the AES repository root
make install-claude      # Install for Claude Code only → ~/.claude/skills/aes
# or
make install-opencode    # Install for OpenCode only → ~/.config/opencode/skills/aes
# or
make install-all         # Install for both
```

Then in your LLM interface:
```
/load aes
```

The skill will activate AES protocol for the session.

### Via CLI Wrapper (Recommended)

Install the `aes` command globally:

```bash
# Install CLI wrapper to /usr/local/bin/aes
sudo make install-cli

# Or copy manually:
# sudo cp bin/aes /usr/local/bin/aes
# sudo chmod +x /usr/local/bin/aes
```

Now you can use `aes` from anywhere:

```bash
aes new-project NAME=myapp LANG=python            # Creates ./myapp
aes new-project NAME=myapp LANG=python DIR=/opt   # Creates /opt/myapp
aes install --claude                               # Install skill
aes list                                           # Show installations
```

### As a Project Template

Create a new project directly:

```bash
# Create in current directory
make new-project NAME=myapp LANG=python

# Create in specific directory
make new-project NAME=myapp LANG=python DIR=/opt

# Or use the script directly
./scripts/new-project.sh myapp javascript ~/projects
```

This generates:
- Complete directory structure with docs/
- Language-specific Makefile
- Pre-configured lint/test/format scripts
- Task templates

Then:
```bash
cd /opt/myapp  # or wherever you created it
make setup        # Install dependencies
make check        # Validate everything
make doctor       # Diagnostics if needed
```

## The AES Loop (For Every Task)

1. **Hostile Analysis** - List assumptions, risks, alternatives
2. **Proposed Solution** - Justify approach, compare alternatives
3. **Surgical Plan** - Steps with verification checkpoints
4. **Implementation** - Minimal changes only
5. **Validation** - Tests pass, edge cases covered
6. **Critical Review** - Simpler? Correct? Side effects?

Task is DONE only when all quality gates pass.

## Makefile Commands

| Command         | Description                                  |
|-----------------|----------------------------------------------|
| `make setup`    | Install dependencies (detects language)      |
| `make run`      | Run the application                          |
| `make test`     | Run tests with coverage                      |
| `make lint`     | Auto-fix lint issues                         |
| `make format`   | Format code                                  |
| `make build`    | Build artifacts                              |
| `make check`    | **ALL quality gates** (docs, code, tests)   |
| `make doctor`   | System diagnostics                           |
| `make metrics`  | Health dashboard                             |
| `make roadmap`  | Show task status                             |
| `make new-project NAME=... LANG=...` | Scaffold new AES project |

## Supported Languages

- JavaScript/TypeScript (Node.js, React, Next.js)
- Python (Django, Flask, FastAPI)
- Go
- Rust
- Java (Spring Boot, Gradle)
- PHP (Laravel)

Language auto-detected via `package.json`, `pyproject.toml`, `go.mod`, etc.

## Project Structure

```
myproject/
├── docs/
│   ├── VISION.md        # Problem, solution, value
│   ├── PERSONAS.md      # User & maintainer profiles
│   ├── REQUIREMENTS.md  # Functional & non-functional
│   ├── ROADMAP.md       # Backlog with Impact/Effort/Priority/Status
│   └── TASKS/           # Individual task files (hostile analysis, etc.)
├── src/                 # Source code
├── tests/               # Test files
├── .aes/
│   └── config.mk        # Auto-generated config (language, commands)
├── .github/workflows/ci.yml  # CI pipeline (auto-generated)
├── Makefile             # All commands
├── SKILL.md (optional)  # If you want this project to be installable as skill
└── scripts/             # Shared scripts (detect, validate, lint, test, etc.)
```

## Philosophy

> If it's not documented, it doesn't exist.  
> If it's not tested, it's broken.  
> If it's not questioned, it's wrong.

## Karpathy Principles (Integrated)

1. **Think Before Coding** - Never assume. Surface tradeoffs.
2. **Simplicity First** - Minimum code that solves the problem.
3. **Surgical Changes** - Modify only what the task requires.
4. **Goal-Driven Execution** - Define verification upfront.

## Self-Hosting

AES uses AES to develop AES:

```bash
# From the AES repository itself
make check      # 100% passing self-tests
make doctor     # Diagnostics
make metrics    # Health dashboard
```

See `tests/aes-self-test.sh` for the test suite.

## Installation Options

```bash
# Install as skill for LLM interfaces
make install-claude      # ~/.claude/skills/aes
make install-opencode    # ~/.config/opencode/skills/aes
make install-all         # Both locations
make list-skill          # Show installed locations
make uninstall-skill     # Remove (or: ./scripts/install-skill.sh --uninstall)
```

## Extending AES

- Add new language support: extend `scripts/detect-language.sh` and create templates in `templates/[lang]/`
- Custom quality gates: add scripts to `scripts/validate-*.sh`
- Plugins: drop scripts into `.aes/plugins/` (executed pre/post check)

## Troubleshooting

**`make check` fails?**
- Run `make doctor` to diagnose
- Fix missing docs (VISION, PERSONAS, REQUIREMENTS, ROADMAP)
- Ensure `scripts/*.sh` are executable
- Set correct permissions: `chmod +x scripts/*.sh`

**Language detection wrong?**
- Set manually in `.aes/config.mk`: `AES_LANGUAGE=python`

**Tests not running?**
- Ensure test framework installed (pytest, jest, etc.)
- Verify `AES_TEST` is set in `.aes/config.mk`

## Credits

Built with the **Aggressive Engineering Protocol (AEP)**, inspired by Karpathy's guidelines for LLM-assisted development.

## License

MIT
