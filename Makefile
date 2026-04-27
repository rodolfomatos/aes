.PHONY: setup run test lint format build deploy check doctor metrics roadmap new-project clean install-claude install-opencode install-all uninstall-skill

# Include language config if exists
-include .aes/config.mk

# Set safe defaults if not defined (AES itself uses bash)
AES_LANGUAGE ?= bash
AES_LINT ?= shellcheck
AES_TEST ?= echo
AES_FORMAT ?= shfmt
AES_BUILD ?= echo
AES_RUN ?= echo

# Export to subprocesses
export AES_LANGUAGE AES_LINT AES_TEST AES_FORMAT AES_BUILD AES_RUN

setup:
	@echo "🔧 Setting up $(AES_LANGUAGE) project..."
	@chmod +x scripts/*.sh
	@./scripts/detect-language.sh
	@./scripts/install-deps.sh

run:
	@echo "▶️  Running application..."
	@./scripts/run.sh

test:
	@echo "🧪 Running tests..."
	@./scripts/test.sh --coverage --verbose

lint:
	@echo "🔍 Linting code..."
	@./scripts/lint.sh --fix

format:
	@echo "✨ Formatting code..."
	@./scripts/format.sh

build:
	@echo "🏗️  Building project..."
	@./scripts/build.sh

deploy:
	@echo "🚀 Deploying..."
	@./scripts/deploy.sh

# Quality Gates - runs ALL checks, fails on any failure
check: docs-check code-check test-check lint-check
	@./scripts/check.sh --strict
	@echo "✅ ALL QUALITY GATES PASSED"

# Individual gate checks (for debugging)
docs-check:
	@echo "📄 Validating documentation..."
	@./scripts/validate-docs.sh

code-check:
	@echo "🔍 Code structure check..."
	@./scripts/validate-code.sh

test-check:
	@echo "🧪 Test coverage gate..."
	@./scripts/validate-tests.sh

lint-check:
	@echo "🔧 Lint compliance..."
	@./scripts/lint.sh --no-fix || exit 1

# Diagnostics & Metrics
doctor:
	@./scripts/doctor.sh --all

metrics:
	@./scripts/metrics.sh --format=cli

roadmap:
	@bash scripts/roadmap.sh --status

# Project scaffolding
new-project:
	@if [ -z "$(NAME)" ]; then echo "❌ Usage: make new-project NAME=project-name [LANGUAGE=python] [DIR=.]"; exit 1; fi
	@./scripts/new-project.sh "$(NAME)" "$(LANGUAGE)" "$(DIR)"

# Skill Installation
install-claude:
	@./scripts/install-skill.sh --claude

install-opencode:
	@./scripts/install-skill.sh --opencode

install-all:
	@./scripts/install-skill.sh --all

# CLI Wrapper Installation
install-cli:
	@echo "📦 Installing AES CLI wrapper..."
	@echo ""
	@if [ -w /usr/local/bin ]; then \
		cp bin/aes /usr/local/bin/aes && \
		chmod +x /usr/local/bin/aes && \
		echo "✅ CLI wrapper installed to /usr/local/bin/aes"; \
	else \
		echo "❌ /usr/local/bin is not writable. Run with sudo:"; \
		echo "   sudo make install-cli"; \
		exit 1; \
	fi
	@echo ""
	@echo "📦 Installing AES library to /usr/local/lib/aes"
	@if [ -w /usr/local/lib ]; then \
		mkdir -p /usr/local/lib/aes && \
		cp -r . /usr/local/lib/aes && \
		echo "✅ AES library installed to /usr/local/lib/aes"; \
	else \
		echo "⚠️  /usr/local/lib is not writable. Skipping library install."; \
		echo "   You can still use AES if it's in your PATH or AES_ROOT is set."; \
	fi
	@echo ""
	@echo "✅ AES CLI ready! Try: aes help"
	@echo "   Set AES_ROOT if AES is installed elsewhere."

# Install everything: skill + CLI wrapper
install: install-all install-cli
	@echo "✅ AES fully installed!"
	@echo "  • Skill available in ~/.config/opencode/skills/aes and ~/.claude/skills/aes"
	@echo "  • CLI wrapper at /usr/local/bin/aes"
	@echo ""
	@echo "Usage:"
	@echo "  In OpenCode: /load aes"
	@echo "  From terminal: aes new-project NAME=myapp LANG=python"

uninstall-cli:
	@echo "🗑️  Removing AES CLI wrapper and library..."
	@rm -f /usr/local/bin/aes
	@rm -rf /usr/local/lib/aes
	@echo "✅ Uninstalled from /usr/local/bin/aes and /usr/local/lib/aes"

uninstall-skill:
	@./scripts/install-skill.sh --uninstall

list-skill:
	@./scripts/install-skill.sh --list

# Housekeeping
clean:
	@echo "🧹 Cleaning artifacts..."
	@rm -rf tmp build dist coverage.xml .coverage .pytest_cache node_modules .tox target
	@find . -name '*.pyc' -delete
	@find . -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Clean complete"

# Help
help:
	@echo "AES (Aggressive Engineering System) - Available targets:"
	@echo ""
	@echo "  Development:"
	@echo "    setup        - Install dependencies (detect language automatically)"
	@echo "    run          - Run the application"
	@echo "    test         - Run tests with coverage"
	@echo "    lint         - Run linter and auto-fix issues"
	@echo "    format       - Format code"
	@echo "    build        - Build artifacts"
	@echo "    deploy       - Deploy (configure in scripts/deploy.sh)"
	@echo ""
	@echo "  Quality Gates:"
	@echo "    check        - Run ALL quality gates (fail fast)"
	@echo "    doctor       - System diagnostics"
	@echo "    metrics      - Health dashboard"
	@echo "    docs-check   - Validate required docs exist and are complete"
	@echo "    code-check   - Check code structure"
	@echo "    test-check   - Verify test coverage >= 80%"
	@echo "    lint-check   - Ensure no lint errors"
	@echo ""
	@echo "  Project Management:"
	@echo "    roadmap      - Show task status"
	@echo "    new-project NAME=myapp LANG=python  - Scaffold new AES project"
	@echo "                                     Supported: python, javascript, go, rust, java, php, flutter"
	@echo ""
	@echo "  Skill Management:"
	@echo "    install-claude   - Install AES as Claude Code skill"
	@echo "    install-opencode - Install AES as OpenCode skill"
	@echo "    install-all      - Install for both"
	@echo "    uninstall-skill  - Remove installed skill"
	@echo "    list-skill       - Show installation locations"
	@echo ""
	@echo "  CLI Wrapper:"
	@echo "    install-cli      - Install aes command to /usr/local/bin (may require sudo)"
	@echo "    uninstall-cli    - Remove aes command from /usr/local/bin"
	@echo "    install          - Install everything (skills + CLI wrapper)"
	@echo ""
	@echo "  Maintenance:"
	@echo "    clean        - Remove build artifacts"
	@echo "    help         - Show this help"
	@echo ""
	@echo "Quick start:"
	@echo "  1. make setup"
	@echo "  2. make test"
	@echo "  3. make check"
	@echo ""

# Default target
.DEFAULT_GOAL := help
