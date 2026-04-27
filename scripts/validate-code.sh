#!/bin/bash
set -e

# AES Code Validator
# Checks code structure and conventions

echo "🔍 Validating code structure..."

fail=0

# Check for forbidden patterns
echo "Checking for forbidden patterns..."

# TODO comments in source code (ok in docs)
TODO_IN_CODE=$(grep -R "TODO:" . \
  --include="*.js" --include="*.ts" --include="*.py" --include="*.go" --include="*.rs" --include="*.java" --include="*.php" \
  --exclude-dir={.git,node_modules,tests,test,vendors,coverage,docs,.aes} \
  2>/dev/null | wc -l)

if [ "$TODO_IN_CODE" -gt 0 ]; then
  echo "❌ Found $TODO_IN_CODE TODOs in source code (not allowed)"
  fail=1
else
  echo "✅ No TODOs in source code"
fi

# Check for large files (>500 lines)
echo "Checking for large files..."
LARGE_FILES=$(find src -name "*.py" -o -name "*.js" -o -name "*.ts" | xargs wc -l 2>/dev/null | awk '$1 > 500 {print $2}')
if [ -n "$LARGE_FILES" ]; then
  echo "⚠️  Large files (>500 lines):"
  echo "$LARGE_FILES"
  fail=1
else
  echo "✅ No overly large files"
fi

# Check directory structure
echo "Checking directory structure..."
if [ ! -d "src" ] && [ ! -d "lib" ] && [ ! -d "app" ]; then
  echo "⚠️  No src/lib/app directory found - consider organizing code"
fi

# Check Makefile exists
if [ ! -f "Makefile" ]; then
  echo "❌ Missing Makefile"
  fail=1
else
  echo "✅ Makefile present"
fi

# Check for main entry point (heuristic)
if [ "$AES_LANGUAGE" = "javascript" ] && [ ! -f "index.js" ] && [ ! -f "src/index.js" ]; then
  echo "⚠️  No obvious main entry point (index.js or src/index.js)"
fi

if [ "$AES_LANGUAGE" = "python" ] && [ ! -f "main.py" ] && [ ! -f "src/main.py" ] && [ ! -f "__main__.py" ]; then
  echo "⚠️  No obvious main entry point (main.py, src/main.py, or __main__.py)"
fi

exit $fail
