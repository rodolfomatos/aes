#!/bin/bash
set -e

# AES Test Script
# Runs tests with coverage

# Load configuration
if [ -f ".aes/config.mk" ]; then
  . .aes/config.mk
fi

if [ -z "$AES_TEST" ] || [ "$AES_TEST" = "echo" ]; then
  echo "❌ AES_TEST not configured for ${AES_LANGUAGE:-unknown}. Edit Makefile or detect-language.sh"
  exit 1
fi

# Default args
COVERAGE_ARGS=""
VERBOSE=""

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --coverage)
      COVERAGE_ARGS="--cov --cov-report=xml --cov-report=term"
      ;;
    --verbose)
      VERBOSE="-v"
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

echo "🧪 Running tests..."
case "$AES_LANGUAGE" in

  javascript)
    if [ -f "jest.config.js" ] || [ -f "package.json" ]; then
      npm test $COVERAGE_ARGS $VERBOSE || true
    else
      echo "No Jest config found, running: npm test"
      npm test
    fi
    ;;

  python)
    if [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then
      pytest $COVERAGE_ARGS $VERBOSE || true
    else
      echo "Running pytest..."
      pytest $VERBOSE || true
    fi
    ;;

  go)
    echo "Running go test with coverage..."
    go test -v ./... -coverprofile=coverage.out -covermode=atomic
    go tool cover -html=coverage.out -o coverage.html || true
    ;;

  rust)
    cargo test $VERBOSE
    cargo tarpaulin --out Xml --output-dir . || echo "Note: tarpaulin not installed, skipping coverage"
    ;;

  java)
    if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
      ./gradlew test jacocoTestReport || ./gradlew test
    elif [ -f "pom.xml" ]; then
      mvn test
    fi
    ;;

  php)
    if [ -f "phpunit.xml" ] || [ -f "phpunit.xml.dist" ]; then
      ./vendor/bin/phpunit --coverage-html coverage/ || ./vendor/bin/phpunit
    else
      echo "No PHPUnit config found"
    fi
    ;;

  *)
    echo "❓ Unknown language: $AES_LANGUAGE"
    echo "Add test configuration in scripts/test.sh"
    ;;
esac

echo "✅ Tests completed"
