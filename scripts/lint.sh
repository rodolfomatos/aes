#!/bin/bash
set -e

# AES Lint Script
# Runs linter with optional fix mode

# Load configuration
if [ -f ".aes/config.mk" ]; then
  . .aes/config.mk
fi

FIX_MODE=""

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --fix)
      FIX_MODE="--fix"
      ;;
    --no-fix)
      FIX_MODE=""
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

if [ -z "$AES_LINT" ]; then
  echo "❌ AES_LINT not set. Run 'make setup' first."
  exit 1
fi

echo "🔍 Linting code with: $AES_LINT $FIX_MODE"

case "$AES_LANGUAGE" in

  javascript)
    # Try eslint, fallback to tsc
    if command -v eslint >/dev/null 2>&1; then
      npx eslint . $FIX_MODE || true
    else
      echo "ESLint not found, trying TypeScript compiler..."
      npx tsc --noEmit || true
    fi
    ;;

  python)
    if command -v ruff >/dev/null 2>&1; then
      ruff check . $FIX_MODE || true
    elif command -v flake8 >/dev/null 2>&1; then
      flake8 || true
    else
      echo "No Python linter found (ruff/flake8)"
    fi
    ;;

  go)
    echo "Running go vet and staticcheck..."
    go vet ./... || true
    if command -v staticcheck >/dev/null 2>&1; then
      staticcheck ./... || true
    fi
    ;;

  rust)
    echo "Running clippy..."
    cargo clippy -- -D warnings || true
    ;;

  java)
    if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
      ./gradlew check || ./gradlew lint
    elif [ -f "pom.xml" ]; then
      mvn checkstyle:check || true
    fi
    ;;

  php)
    echo "Linting PHP files..."
    if command -v php >/dev/null 2>&1; then
      find . -name "*.php" -not -path "./vendor/*" -exec php -l {} \; | grep -v "No syntax errors" || true
    fi
    ;;

  *)
    echo "❓ Unknown language: $AES_LANGUAGE"
    ;;
esac

echo "✅ Lint complete"
