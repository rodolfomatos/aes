#!/bin/bash

# AES Doctor - System Diagnostics
# Checks common configuration issues and provides fixes

AUTO_FIX=0
ALL_CHECKS=0

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --fix)
      AUTO_FIX=1
      ;;
    --all)
      ALL_CHECKS=1
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

echo "🔧 AES Doctor - System Diagnostics"
echo "================================"
echo ""

issues=0

# 1. Check scripts are executable
echo "1. Checking script permissions..."
for script in scripts/*.sh; do
  if [ -f "$script" ] && [ ! -x "$script" ]; then
    echo "   ❌ $script is not executable"
    issues=$((issues+1))
    if [ $AUTO_FIX -eq 1 ]; then
      chmod +x "$script"
      echo "   ✅ Fixed: chmod +x $script"
    fi
  else
    echo "   ✅ $script is executable"
  fi
done

# 2. Check language detection
echo ""
echo "2. Checking language detection..."
# Load configured language if exists
if [ -f ".aes/config.mk" ]; then
  . .aes/config.mk 2>/dev/null || true
fi

# If still not set, run detection
if [ -z "$AES_LANGUAGE" ] || [ "$AES_LANGUAGE" = "unknown" ]; then
  . ./scripts/detect-language.sh 2>/dev/null || true
fi

if [ -z "$AES_LANGUAGE" ] || [ "$AES_LANGUAGE" = "unknown" ]; then
  echo "   ❌ Language not detected or unknown"
  echo "      Run: make setup"
  issues=$((issues+1))
else
  echo "   ✅ Language: $AES_LANGUAGE"
  echo "      Lint: $AES_LINT"
  echo "      Test: $AES_TEST"
fi

# 3. Check required docs
echo ""
echo "3. Checking documentation..."
required_docs=(docs/VISION.md docs/PERSONAS.md docs/REQUIREMENTS.md docs/ROADMAP.md)
for doc in "${required_docs[@]}"; do
  if [ ! -f "$doc" ]; then
    echo "   ❌ Missing: $doc"
    echo "      Create with: cp template/$doc ."
    issues=$((issues+1))
  else
    echo "   ✅ Found: $doc"
  fi
done

# 4. Check Makefile targets
echo ""
echo "4. Checking Makefile targets..."
required_targets=(setup test lint format check doctor)
for target in "${required_targets[@]}"; do
  if grep -q "^${target}:" Makefile 2>/dev/null; then
    echo "   ✅ Target: $target"
  else
    echo "   ❌ Missing target: $target"
    issues=$((issues+1))
  fi
done

# 5. Check for .aes directory (plugins)
echo ""
echo "5. Checking extensions..."
if [ -d ".aes" ]; then
  echo "   ✅ Found .aes/ directory"
  if [ -d ".aes/plugins" ]; then
    plugin_count=$(ls -1 .aes/plugins/*.sh 2>/dev/null | wc -l)
    echo "      Plugins: $plugin_count"
  fi
else
  echo "   ℹ️  No .aes directory (optional for plugins)"
fi

# 6. Check CI configuration
echo ""
echo "6. Checking CI configuration..."
if [ -f ".github/workflows/ci.yml" ]; then
  echo "   ✅ GitHub Actions CI configured"
else
  echo "   ⚠️  No CI workflow found"
  echo "      Generate with: make new-project (or copy from template)"
  if [ $ALL_CHECKS -eq 1 ]; then
    issues=$((issues+1))
  fi
fi

# 7. Check test configuration
echo ""
echo "7. Checking test setup..."
case "$AES_LANGUAGE" in
  javascript)
    if [ -f "jest.config.js" ] || grep -q '"test"' package.json; then
      echo "   ✅ Jest configured"
    else
      echo "   ❌ No Jest configuration"
      issues=$((issues+1))
    fi
    ;;
  python)
    if [ -f "pytest.ini" ] || grep -q "pytest" pyproject.toml; then
      echo "   ✅ pytest configured"
    else
      echo "   ⚠️  No pytest.ini or pytest in pyproject.toml"
    fi
    ;;
  go)
    if [ -f "go.mod" ]; then
      echo "   ✅ Go modules ready"
    fi
    ;;
  *)
    echo "   ℹ️  Unknown language, skipping test config check"
    ;;
esac

# 8. Check coverage report
echo ""
echo "8. Checking coverage..."
if [ -f "coverage.xml" ] || [ -f "coverage.out" ] || [ -d "coverage" ]; then
  echo "   ✅ Coverage report exists"
else
  echo "   ℹ️  No coverage report (run 'make test' to generate)"
fi

# 9. Check for unused scripts
echo ""
echo "9. Checking script usage..."
unused_scripts=0
for script in scripts/*.sh; do
  script_name=$(basename "$script")
  if ! grep -q "$script_name" Makefile; then
    echo "   ⚠️  $script_name not referenced in Makefile"
    unused_scripts=$((unused_scripts+1))
  fi
done
if [ $unused_scripts -eq 0 ]; then
  echo "   ✅ All scripts referenced in Makefile"
fi

echo ""
echo "================================"
if [ $issues -eq 0 ]; then
  echo "✅ No critical issues found"
  exit 0
else
  echo "❌ Found $issues issue(s)"
  if [ $AUTO_FIX -eq 1 ]; then
    echo "   Re-run with additional --fix options or manually address warnings"
  fi
  exit 1
fi
