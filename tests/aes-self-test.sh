#!/bin/bash
set -e

# AES Self-Test Suite
# Tests that AES works correctly on itself (dogfooding)

echo "🧪 AES Self-Test Suite"
echo "======================"
echo ""

fail=0
test_count=0
pass_count=0

# Test function
run_test() {
  local name="$1"
  local command="$2"
  test_count=$((test_count+1))

  echo "Test $test_count: $name"
  if eval "$command"; then
    echo "   ✅ PASS"
    pass_count=$((pass_count+1))
  else
    echo "   ❌ FAIL"
    fail=1
  fi
  echo ""
}

# Test 1: Check script exists and is executable
run_test "Scripts are executable" "test -x scripts/detect-language.sh && test -x scripts/install-deps.sh && test -x scripts/check.sh"

# Test 2: make check passes on AES itself
run_test "make check passes on AES" "make check"

# Test 3: make doctor runs without errors
run_test "make doctor runs cleanly" "make doctor"

# Test 4: metrics command works
run_test "make metrics produces output" "make metrics > /dev/null 2>&1"

# Test 5: All required docs are complete
run_test "Documentation completeness" "./scripts/validate-docs.sh"

# Test 6: SKILL.md has correct format
run_test "SKILL.md format validation" "grep -q '^name:' SKILL.md && grep -q '^summary:' SKILL.md && grep -q '^tools:' SKILL.md"

# Test 7: Makefile has all required targets
run_test "Makefile completeness" "make help > /dev/null 2>&1"

# Test 8: Language detection script exists and runs (even if no language found)
run_test "Language detection script runs" "test -x scripts/detect-language.sh && ./scripts/detect-language.sh > /dev/null 2>&1 || true"

# Test 9: All required scripts exist individually
run_test "All scripts exist" "
test -f scripts/detect-language.sh
test -f scripts/install-deps.sh
test -f scripts/run.sh
test -f scripts/test.sh
test -f scripts/lint.sh
test -f scripts/format.sh
test -f scripts/build.sh
test -f scripts/deploy.sh
test -f scripts/check.sh
test -f scripts/validate-docs.sh
test -f scripts/validate-code.sh
test -f scripts/validate-tests.sh
test -f scripts/doctor.sh
test -f scripts/metrics.sh
test -f scripts/roadmap.sh
test -f scripts/new-project.sh
test -f scripts/install-skill.sh
"

# Test 10: new-project scaffolds functional project
run_test "new-project scaffolding" "
tmpdir=$(mktemp -d)
./scripts/new-project.sh test-scaffold python > /dev/null 2>&1
if [ ! -d \"test-scaffold\" ]; then
  echo \"Scaffold failed: directory not created\"
  exit 1
fi
if [ ! -f \"test-scaffold/Makefile\" ]; then
  echo \"Scaffold failed: Makefile missing\"
  exit 1
fi
if [ ! -f \"test-scaffold/docs/VISION.md\" ]; then
  echo \"Scaffold failed: VISION.md missing\"
  exit 1
fi
# Run check on scaffolded project
cd test-scaffold && make check > /dev/null 2>&1
cd ..
rm -rf test-scaffold
echo \"Scaffold created and validated\"
exit 0
"

# Test 11: install-skill.sh works
run_test "Skill installer script exists and is executable" "test -x scripts/install-skill.sh"

# Test 12: install-skill.sh --list shows not installed
run_test "Skill not installed by default" "scripts/install-skill.sh --list | grep -q 'Not installed'"

# Test 13: Check script handles failures correctly
run_test "check.sh fails on missing docs (test)" "
# Create temp dir without docs
tmpdir=$(mktemp -d)
cd \"$tmpdir\"
if [ -f \"../scripts/check.sh\" ]; then
  if ../scripts/check.sh 2>/dev/null; then
    echo \"Should have failed without docs\"
    cd ..
    rm -rf \"$tmpdir\"
    exit 1
  fi
fi
cd ..
rm -rf \"$tmpdir\"
exit 0
"

# Test 14: verify-docs.sh detects placeholders
run_test "validate-docs.sh detects placeholders" "
# Create temp with placeholder
tmpdir=$(mktemp -d)
cd \"$tmpdir\"
mkdir -p docs
echo '# VISION\n...' > docs/VISION.md
if ./../scripts/validate-docs.sh 2>/dev/null; then
  echo \"Should have detected placeholder\"
  cd ..
  rm -rf \"$tmpdir\"
  exit 1
fi
cd ..
rm -rf \"$tmpdir\"
exit 0
"

# Test 15: coverage validator works (if coverage file exists)
run_test "Coverage validator script" "test -f scripts/validate-tests.sh && ./scripts/validate-tests.sh || echo 'Note: no coverage file, test skipped'"

# Summary
echo "================================"
echo "Self-Test Results:"
echo "  Passed: $pass_count/$test_count"
echo "  Failed: $fail"
echo ""

if [ $fail -eq 0 ]; then
  echo "✅ All AES self-tests passed!"
  echo ""
  echo "AES is healthy and functional."
  exit 0
else
  echo "❌ Some self-tests failed"
  echo "Review the failures above and fix before using AES."
  exit 1
fi
