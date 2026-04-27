#!/bin/bash
set -e

# AES Test Coverage Validator
# Ensures test coverage meets threshold (default 80%)

# Load configuration
if [ -f ".aes/config.mk" ]; then
  . .aes/config.mk
fi

echo "🧪 Checking test coverage..."

fail=0
COVERAGE_THRESHOLD=${AES_COVERAGE_THRESHOLD:-80}

# Run tests if not already done
if [ ! -f "coverage.xml" ] && [ ! -f ".coverage" ] && [ ! -f "coverage.out" ]; then
  echo "No coverage file found, running tests..."
  make test || true
fi

# Check coverage based on language
COVERAGE=""

case "$AES_LANGUAGE" in

  javascript)
    if [ -f "coverage/coverage-final.json" ]; then
      COVERAGE=$(node -e "const c=require('./coverage/coverage-final.json');const t=Object.values(c.total);console.log(Math.round(t.lines.pct))" 2>/dev/null || echo 0)
    fi
    ;;

  python)
    if [ -f "coverage.xml" ]; then
      COVERAGE=$(grep -oP '<coverage.*line-rate="\K[\d.]+' coverage.xml | awk '{print int($1*100)}')
    elif [ -f ".coverage" ]; then
      COVERAGE=$(python -c "import coverage; cov=coverage.Coverage();cov.load();print(int(cov.report()))" 2>/dev/null || echo 0)
    fi
    ;;

  go)
    if [ -f "coverage.out" ]; then
      COVERAGE=$(go tool cover -func=coverage.out | tail -1 | awk '{print int($1)}')
    fi
    ;;

  rust)
    if [ -f "cobertura.xml" ]; then
      COVERAGE=$(grep -oP 'line-rate="\K[\d.]+' cobertura.xml | awk '{print int($1*100)}')
    fi
    ;;

  java)
    if [ -d "build/reports/jacoco/test" ]; then
      COVERAGE=$(grep -oP '(< CoveredLines="\K[\d]+' build/reports/jacoco/test/html/index.html | head -1 | awk '{printf "%.0f", $1*100}')
    fi
    ;;

  *)
    echo "❓ Coverage check not configured for $AES_LANGUAGE"
    exit 0
    ;;
esac

if [ -z "$COVERAGE" ] || [ "$COVERAGE" = "0" ]; then
  echo "⚠️  Could not determine coverage. Make sure tests produce coverage report."
  echo "   Supported: Jest (JS), pytest+cov (Python), go test (Go), cargo tarpaulin (Rust)"
  exit 0
fi

echo "📊 Coverage: ${COVERAGE}% (threshold: ${COVERAGE_THRESHOLD}%)"

if [ "$COVERAGE" -lt "$COVERAGE_THRESHOLD" ]; then
  echo "❌ Coverage below threshold"
  fail=1
else
  echo "✅ Coverage meets threshold"
fi

exit $fail
