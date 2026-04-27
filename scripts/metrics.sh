#!/bin/bash

# AES Metrics Dashboard
# Shows project health and progress

FORMAT="cli"

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --format=json)
      FORMAT="json"
      ;;
    --format=cli)
      FORMAT="cli"
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

# Initialize variables
total_tasks=0
done_tasks=0
todo_tasks=0
doing_tasks=0
completion_pct=0
coverage="null"
lint_issues=0
todo_count=0

# 1. Tasks from ROADMAP
if [ -f "docs/ROADMAP.md" ]; then
  total_tasks=$(grep -c "Status:" docs/ROADMAP.md || echo 0)
  done_tasks=$(grep -c "Status: done" docs/ROADMAP.md || echo 0)
  todo_tasks=$(grep -c "Status: todo" docs/ROADMAP.md || echo 0)
  doing_tasks=$(grep -c "Status: doing" docs/ROADMAP.md || echo 0)

  if [ "$total_tasks" -gt 0 ]; then
    completion_pct=$((done_tasks * 100 / total_tasks))
  fi
fi

# 2. Test coverage
if [ -f "coverage.xml" ]; then
  cov=$(grep -oP '<coverage[^>]*line-rate="\K[\d.]+' coverage.xml 2>/dev/null | head -1 | awk '{printf "%.1f", $1*100}')
  coverage="${cov:-0}"
elif [ -f ".coverage" ]; then
  if command -v python >/dev/null 2>&1; then
    cov=$(python -c "import coverage; c=coverage.Coverage(); c.load(); print(int(c.report()))" 2>/dev/null || echo "null")
    coverage="$cov"
  fi
elif [ -f "coverage.out" ]; then
  if command -v go >/dev/null 2>&1; then
    cov=$(go tool cover -func=coverage.out 2>/dev/null | tail -1 | awk '{print int($1)}')
    coverage="$cov"
  fi
fi

# 3. Lint issues
if command -v eslint >/dev/null 2>&1 && [ -f "package.json" ]; then
  lint_issues=$(npx eslint . --format json 2>/dev/null | jq 'length' 2>/dev/null || echo 0)
elif command -v ruff >/dev/null 2>&1 && [ -f "pyproject.toml" ]; then
  lint_issues=$(ruff check . 2>&1 | grep -c ":" || echo 0)
elif command -v go >/dev/null 2>&1 && [ -f "go.mod" ]; then
  lint_issues=$(go vet ./... 2>&1 | wc -l || echo 0)
fi

# 4. Language detection (source detection script)
if [ -f "scripts/detect-language.sh" ]; then
  . ./scripts/detect-language.sh 2>/dev/null || true
fi

# 5. Git info
if command -v git >/dev/null 2>&1; then
  commits_total=$(git rev-list --count HEAD 2>/dev/null || echo 0)
  recent_commit=$(git log -1 --oneline 2>/dev/null || echo "none")
fi

# 6. TODO count (blocking)
if [ -d "." ]; then
  todo_count=$(grep -R "TODO:" . \
    --exclude-dir={.git,node_modules,templates,examples,scripts} \
    --exclude={Makefile,SKILL.md,README.md} \
    2>/dev/null | wc -l || echo 0)
fi

# 7. Last check status
if [ -f ".aes/last-check.status" ]; then
  last_status=$(cat .aes/last-check.status)
fi

# Output
if [ "$FORMAT" = "json" ]; then
  # Build JSON manually (no jq dependency)
  cat <<EOF
{
  "tasks": {
    "total": $total_tasks,
    "done": $done_tasks,
    "todo": $todo_tasks,
    "doing": $doing_tasks,
    "completion": $completion_pct
  },
  "coverage": $coverage,
  "lint_issues": $lint_issues,
  "language": "$AES_LANGUAGE",
  "last_check": "$last_status",
  "git": {
    "total_commits": $commits_total,
    "latest": "$recent_commit"
  },
  "todos": $todo_count
}
EOF
else
  # CLI output
  echo "╔═══════════════════════════════════════╗"
  echo "║   AES Project Metrics Dashboard     ║"
  echo "╚═══════════════════════════════════════╝"
  echo ""

  echo "📋 Roadmap Progress"
  if [ -f "docs/ROADMAP.md" ]; then
    echo "   Total tasks:  $total_tasks"
    echo "   Completed:    $done_tasks ($completion_pct%)"
    echo "   In progress:  $doing_tasks"
    echo "   To do:        $todo_tasks"
  else
    echo "   No ROADMAP.md found"
  fi
  echo ""

  echo "🧪 Testing"
  if [ "$coverage" != "null" ] && [ "$coverage" != "" ]; then
    echo "   Coverage:    ${coverage}%"
  else
    echo "   Coverage:    ? (run 'make test')"
  fi
  echo "   Lint issues: $lint_issues"
  echo ""

  echo "⚙️  System"
  if [ -n "$AES_LANGUAGE" ]; then
    echo "   Language:    $AES_LANGUAGE"
  else
    echo "   Language:    ? (run 'make setup')"
  fi

  if [ -d ".git" ]; then
    echo "   Git:         $commits_total commits"
    echo "   Latest:      $recent_commit"
  fi
  echo ""

  echo "💉 Health"
  if [ "$todo_count" -gt 0 ]; then
    echo "   TODOs:       $todo_count (resolve before commit)"
  else
    echo "   TODOs:       0 ✅"
  fi

  if [ -f ".aes/last-check.status" ]; then
    if [ "$last_status" = "passed" ]; then
      echo "   Last check:  ✅ PASSED"
    else
      echo "   Last check:  ❌ FAILED"
    fi
  else
    echo "   Last check:  ? (run 'make check')"
  fi
  echo ""

  echo "───────────────────────────────────────"
  echo "Run 'make doctor' for diagnostics"
  echo "Run 'make check' for quality gates"
  echo ""
fi
