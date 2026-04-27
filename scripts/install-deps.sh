#!/bin/bash
set -e

# AES Dependency Installer
# Requires language detection to have run (detect-language.sh)

# Load configuration
if [ -f ".aes/config.mk" ]; then
  . .aes/config.mk
fi

echo "📦 Installing dependencies for ${AES_LANGUAGE:-unknown}..."

case "$AES_LANGUAGE" in

  javascript)
    echo "Using npm ci..."
    npm ci
    ;;

  python)
    echo "Using pip..."
    if [ -f "requirements.txt" ]; then
      pip install -r requirements.txt
    fi
    if [ -f "pyproject.toml" ]; then
      echo "Installing package (non-editable)..."
      pip install . || true
    fi
    ;;

  go)
    echo "Go uses modules automatically. Running go mod download..."
    go mod download
    ;;

  rust)
    echo "Running cargo fetch..."
    cargo fetch
    ;;

  java)
    if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
      ./gradlew dependencies
    elif [ -f "pom.xml" ]; then
      mvn dependency:resolve
    fi
    ;;

  php)
    echo "Running composer install..."
    composer install
    ;;

  *)
    echo "❓ Unknown language: $AES_LANGUAGE"
    echo "Please configure custom install in scripts/install-deps.sh"
    ;;
esac

echo "✅ Dependencies installed"
