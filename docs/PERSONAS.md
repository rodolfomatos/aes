# Personas

## Developer (Primary User)

**Profile:** Engineer using LLMs to write code faster

**Goals:**
- Ship features with confidence
- Avoid LLM hallucinations & over-engineering
- Maintain codebase quality
- Document decisions automatically

**Needs:**
- Clear tasks with verifiable outcomes
- Validation that code works before commit
- Consistent structure across all work
- Time-saving templates, not bureaucracy

**Behaviors:**
- Runs `make check` before every commit
- Writes task.md before coding
- Updates ROADMAP when work starts/completes
- Asks clarifying questions when goals are vague
- Rejects "extra features" not in REQUIREMENTS

## Maintainer (Secondary User)

**Profile:** Engineer responsible for codebase health

**Goals:**
- Ensure all contributions follow protocol
- Keep documentation accurate
- Prevent tech debt accumulation
- Onboard new contributors quickly

**Needs:**
- Automated enforcement via `make check`
- Clear gaps in docs/tests visible at a glance
- Metrics on project health
- Ways to update docs without friction

**Behaviors:**
- Reviews PRs by running AES checks locally first
- Uses `make doctor` to diagnose issues
- Updates ROADMAP priorities based on system goals
- Fixes documentation inconsistencies immediately
- Rejects PRs that don't pass `make check`

## Auditor (Tertiary User)

**Profile:** Team lead or external reviewer

**Goals:**
- Understand project status without reading all code
- Verify requirements are met
- Assess quality and risk
- Trace decisions to requirements

**Needs:**
- ROADMAP with impact/effort/priority clear
- Task files showing hostile analysis and validation
- Running `make check` as quality gate
- Git history with AES-compliant commit messages

**Behaviors:**
- Reads VISION.md first to understand intent
- Scans ROADMAP for high-impact / low-effort items
- Checks recent task files for rigor
- Runs `make metrics` for health dashboard
- Looks for "surgical changes" in git diff
