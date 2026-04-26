.PHONY: setup run test lint format build deploy clean check roadmap

setup:
	@echo "Setting up project..."
	@mkdir -p docs

run:
	@echo "Run your app here"

test:
	@echo "Running tests..."
	@if [ -d tests ]; then echo "Tests exist"; else echo "No tests found"; fi

lint:
	@echo "Linting..."
	@if command -v eslint >/dev/null 2>&1; then eslint . || true; fi
	@if command -v php >/dev/null 2>&1; then php -l $(shell find . -name '*.php') || true; fi

format:
	@echo "Formatting..."
	@if command -v prettier >/dev/null 2>&1; then prettier --write . || true; fi

build:
	@echo "Build step (customize)"

deploy:
	@echo "Deploy step (customize)"

roadmap:
	@bash scripts/roadmap.sh

check:
	@bash scripts/check.sh

clean:
	@echo "Cleaning..."
	@rm -rf tmp build dist
