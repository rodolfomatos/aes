#!/bin/bash

echo "Running AES checks..."

fail=0

check_file () {
  if [ ! -f "$1" ]; then
    echo "❌ Missing: $1"
    fail=1
  else
    echo "✅ Found: $1"
  fi
}

check_file docs/VISION.md
check_file docs/PERSONAS.md
check_file docs/REQUIREMENTS.md
check_file docs/ROADMAP.md

echo "Checking TODOs..."
grep -R "TODO" . && echo "⚠️ TODOs found"

if [ $fail -eq 1 ]; then
  echo "❌ CHECK FAILED"
  exit 1
fi

echo "✅ CHECK PASSED"
