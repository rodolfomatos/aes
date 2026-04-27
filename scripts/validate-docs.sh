#!/bin/bash
set -e

# AES Documentation Validator
# Checks that all required docs exist and are complete (no placeholders, TODOs)

echo "📄 Validating documentation..."

fail=0

REQUIRED_FILES=(
  "docs/VISION.md:Problem|Solution|Value"
  "docs/PERSONAS.md:Developer|Maintainer"
  "docs/REQUIREMENTS.md:Functional|Non-Functional"
  "docs/ROADMAP.md:Impact|Effort|Status"
)

for item in "${REQUIRED_FILES[@]}"; do
  IFS=':' read -r file pattern <<< "$item"

  if [ ! -f "$file" ]; then
    echo "❌ Missing: $file"
    fail=1
    continue
  fi

  # Check for placeholders (triple dots)
  if grep -q "\.\.\." "$file"; then
    echo "⚠️  Incomplete: $file (contains placeholder '...')"
    fail=1
  fi

  # Check for TODO markers (only TODO: with colon to avoid false positives)
  if grep -q "TODO:" "$file"; then
    echo "⚠️  Incomplete: $file (contains TODO: marker)"
    fail=1
  fi

  # Check for required keywords
  if [ -n "$pattern" ]; then
    missing_pattern=true
    for p in $(echo "$pattern" | tr '|' ' '); do
      if grep -q "$p" "$file"; then
        missing_pattern=false
        break
      fi
    done
    if [ "$missing_pattern" = true ]; then
      echo "⚠️  Incomplete: $file (missing required keywords: $pattern)"
      fail=1
    fi
  fi

  if [ $fail -eq 0 ]; then
    echo "✅ Valid: $file"
  fi
done

# Check that at least one task exists in docs/TASKS/ or template/
TASK_COUNT=$(find docs -name "*.md" -type f | grep -i task | wc -l || echo 0)
if [ "$TASK_COUNT" -lt 1 ] && [ ! -f "template/task.md" ]; then
  echo "⚠️  No task templates found. Create docs/TASKS/ or template/task.md"
  fail=1
else
  echo "✅ Found $TASK_COUNT task file(s) in docs/"
fi

exit $fail
