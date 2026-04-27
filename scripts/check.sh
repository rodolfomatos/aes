#!/bin/bash
set -e

# AES Comprehensive Check
# Runs all quality gates, fails on any failure

echo "🔍 Running AES Comprehensive Check..."
echo ""

fail=0
start_time=$(date +%s)

# Track check status for metrics
mkdir -p .aes

# 1. Documentation Check
echo "📄 Documentation Check"
if ./scripts/validate-docs.sh; then
  echo "✅ Docs valid"
else
  fail=1
  echo "❌ Docs check failed"
fi
echo ""

# 2. Code Check
echo "🔍 Code Structure Check"
if ./scripts/validate-code.sh; then
  echo "✅ Code structure valid"
else
  fail=1
  echo "❌ Code check failed"
fi
echo ""

# 3. Lint Check (non-fix mode)
echo "🔧 Lint Compliance"
if ./scripts/lint.sh --no-fix; then
  echo "✅ Lint passed"
else
  fail=1
  echo "❌ Lint failed (run 'make lint' to auto-fix)"
fi
echo ""

# 4. Test Check
echo "🧪 Test Coverage Gate"
if ./scripts/validate-tests.sh; then
  echo "✅ Coverage meets threshold"
else
  fail=1
  echo "❌ Coverage below threshold"
fi
echo ""

# 5. TODO Check (in source files only)
echo "🔎 TODO Check"
TODO_COUNT=$(grep -R "TODO:" . \
  --exclude-dir={.git,node_modules,templates,examples,scripts} \
  --exclude={Makefile,SKILL.md,README.md,docs/*.md} \
  2>/dev/null | wc -l)

if [ "$TODO_COUNT" -gt 0 ]; then
  echo "⚠️  Found $TODO_COUNT TODOs in source code"
  grep -R "TODO:" . \
    --exclude-dir={.git,node_modules,templates,examples,scripts} \
    --exclude={Makefile,SKILL.md,README.md,docs/*.md} \
    2>/dev/null | head -5
  fail=1
else
  echo "✅ No TODOs in source code"
fi
echo ""

# 6. Makefile Completeness
echo "📋 Makefile Completeness"
REQUIRED_TARGETS=("setup" "test" "lint" "format" "check" "run" "doctor" "metrics")
missing_targets=0
for target in "${REQUIRED_TARGETS[@]}"; do
  if grep -q "^${target}:" Makefile 2>/dev/null; then
    echo "   ✅ Target: $target"
  else
    echo "   ❌ Missing target: $target"
    missing_targets=$((missing_targets+1))
  fi
done

if [ $missing_targets -gt 0 ]; then
  fail=1
fi
echo ""

# 7. Skill Format (if SKILL.md exists)
echo "🎯 Skill Structure Check"
if [ -f "SKILL.md" ]; then
  if grep -q "^name:" SKILL.md && grep -q "^summary:" SKILL.md; then
    echo "   ✅ SKILL.md valid ECC format"
  else
    echo "   ⚠️  SKILL.md missing required ECC fields (name:, summary:)"
    echo "      This won't fail check but should be fixed"
  fi
else
  echo "   ℹ️  No SKILL.md (optional for skill installation)"
fi
echo ""

# Timing
end_time=$(date +%s)
duration=$((end_time - start_time))

# Output result
echo "═══════════════════════════════════════"
if [ $fail -eq 0 ]; then
  echo "✅ CHECK PASSED in ${duration}s"
  echo ".aes/last-check.status" > .aes/last-check.status
  echo "passed" > .aes/last-check.status
  exit 0
else
  echo "❌ CHECK FAILED in ${duration}s"
  echo "Address the issues above and re-run: make check"
  echo ".aes/last-check.status" > .aes/last-check.status
  echo "failed" > .aes/last-check.status
  exit 1
fi

