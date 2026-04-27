#!/bin/bash

# AES Roadmap Status
# Shows roadmap with colorized status

echo "=== ROADMAP STATUS ==="
echo ""

if [ ! -f "docs/ROADMAP.md" ]; then
  echo "❌ docs/ROADMAP.md not found"
  exit 1
fi

# Extract sections by status
echo "📋 All Tasks:"
grep -A 3 "## \[" docs/ROADMAP.md | grep -v "^--$" | sed 's/^[[:space:]]*//'

echo ""
echo "✅ Done:"
grep -A 3 "Status: done" docs/ROADMAP.md | head -3

echo ""
echo "▶️  In Progress:"
grep -A 3 "Status: doing" docs/ROADMAP.md | head -3

echo ""
echo "⏳ To Do:"
grep -A 3 "Status: todo" docs/ROADMAP.md | head -5

echo ""
echo "📊 Summary:"
total=$(grep -c "Status:" docs/ROADMAP.md || echo 0)
done=$(grep -c "Status: done" docs/ROADMAP.md || echo 0)
doing=$(grep -c "Status: doing" docs/ROADMAP.md || echo 0)
todo=$(grep -c "Status: todo" docs/ROADMAP.md || echo 0)
pct=0
if [ "$total" -gt 0 ]; then
  pct=$((done * 100 / total))
fi
echo "   Total: $total | Done: $done | Doing: $doing | Todo: $todo | Complete: $pct%"

