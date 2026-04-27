#!/bin/bash
set -e

# AES Format Script
# Auto-formats code

# Load configuration
if [ -f ".aes/config.mk" ]; then
  . .aes/config.mk
fi

if [ -z "$AES_FORMAT" ] || [ "$AES_FORMAT" = "echo" ]; then
  echo "❌ AES_FORMAT not configured for ${AES_LANGUAGE:-unknown}. Edit Makefile or detect-language.sh"
  exit 1
fi

echo "✨ Formatting code with: $AES_FORMAT"

case "$AES_LANGUAGE" in

  javascript)
    if command -v prettier >/dev/null 2>&1; then
      npx prettier --write .
    elif command -v eslint >/dev/null 2>&1; then
      npx eslint . --fix
    else
      echo "No formatter found (prettier/eslint)"
    fi
    ;;

  python)
    if command -v black >/dev/null 2>&1; then
      black .
    elif command -v ruff >/dev/null 2>&1; then
      ruff format .
    else
      echo "No Python formatter found (black/ruff)"
    fi
    ;;

  go)
    go fmt ./...
    ;;

  rust)
    cargo fmt --all
    ;;

  java)
    if command -v google-java-format >/dev/null 2>&1; then
      find . -name "*.java" -exec google-java-format -i {} \;
    else
      echo "google-java-format not installed"
    fi
    ;;

  php)
    if command -v php-cs-fixer >/dev/null 2>&1; then
      php-cs-fixer fix
    else
      echo "php-cs-fixer not installed"
    fi
    ;;

  *)
    echo "❓ Unknown language: $AES_LANGUAGE"
    ;;
esac

echo "✅ Format complete"
