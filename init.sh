#!/bin/bash
# ============================================================
# jv-project-context-scaffold v2 — One-Command Setup
# ============================================================
#
# Usage (run inside your project folder):
#
#   curl -sL https://raw.githubusercontent.com/joaofvalente/jv-project-context-scaffold/main/init.sh | bash
#
# Flags:
#   --claude-only    Only CLAUDE.md + .context/ (no AGENTS.md, no Cursor)
#   --with-cursor    Also generate .cursor/rules/*.mdc
#   --all            Everything: Claude + AGENTS.md + Cursor
#   (default)        CLAUDE.md + .context/ + AGENTS.md
#
# Safe to run multiple times — never overwrites existing files.
# ============================================================

set -e

# ── Parse flags ──────────────────────────────────────────────

CLAUDE=true
AGENTS=true
CURSOR=false

for arg in "$@"; do
  case "$arg" in
    --claude-only)
      AGENTS=false
      CURSOR=false
      ;;
    --with-cursor)
      CURSOR=true
      ;;
    --all)
      AGENTS=true
      CURSOR=true
      ;;
  esac
done

# ── Colors ───────────────────────────────────────────────────

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
DIM='\033[2m'
NC='\033[0m'

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Project Context Scaffold v2${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ── Helper: create file only if it doesn't exist ─────────────

create_file() {
  local filepath="$1"
  local content="$2"

  mkdir -p "$(dirname "$filepath")"

  if [ -f "$filepath" ]; then
    echo -e "  ${YELLOW}SKIP${NC}    $filepath"
  else
    printf '%s\n' "$content" > "$filepath"
    echo -e "  ${GREEN}CREATE${NC}  $filepath"
  fi
}

create_empty() {
  local filepath="$1"

  mkdir -p "$(dirname "$filepath")"

  if [ -f "$filepath" ]; then
    echo -e "  ${YELLOW}SKIP${NC}    $filepath"
  else
    touch "$filepath"
    echo -e "  ${GREEN}CREATE${NC}  $filepath"
  fi
}

create_dir() {
  local dirpath="$1"

  if [ -d "$dirpath" ]; then
    echo -e "  ${YELLOW}SKIP${NC}    $dirpath/"
  else
    mkdir -p "$dirpath"
    echo -e "  ${GREEN}CREATE${NC}  $dirpath/"
  fi
}

# ══════════════════════════════════════════════════════════════
# CLAUDE.md
# ══════════════════════════════════════════════════════════════

echo -e "${DIM}  ── Claude Code ──${NC}"

create_file "CLAUDE.md" '# Project Context

@.context/project.md
@.context/state.md

## Knowledge Base

Before starting work, read `.context/knowledge/INDEX.md` to see available knowledge files.
Load only the files relevant to your current task — do not load all of them.

## Context Write Policy

@.context/write-policy.md

## Memory Boundaries

For project-specific context (status, decisions, architecture, conventions, lessons, tech debt), use the `.context/` system exclusively. Do not duplicate project context in the built-in memory system. The built-in memory should only store user-level preferences and feedback that apply across projects.

## Helper Documents

On-demand reference documents live in `.docs/`:
- `plans/` — Implementation plans for complex tasks
- `audits/` — Code, security, or performance audits
- `guides/` — How-to guides and explanations

These are never auto-loaded. Reference them explicitly when relevant.'

# ══════════════════════════════════════════════════════════════
# AGENTS.md (cross-tool portable)
# ══════════════════════════════════════════════════════════════

if [ "$AGENTS" = true ]; then
  echo ""
  echo -e "${DIM}  ── Cross-Tool ──${NC}"

  create_file "AGENTS.md" '# [Project Name]

## Overview

[Brief project description — what it does, who it serves, 2-3 sentences]

## Tech Stack

[Key technologies, frameworks, and infrastructure]

## Project Context

This project uses a structured context system in `.context/`:

- `.context/project.md` — Project overview, stack, and goals
- `.context/state.md` — Current focus, blockers, and next steps
- `.context/knowledge/INDEX.md` — Index of accumulated project knowledge (decisions, conventions, lessons, architecture, tech debt)
- `.context/log.jsonl` — Structured activity chronicle (for reports, not regular work)

**Start here:** Read `state.md` for current state, then `knowledge/INDEX.md` to see what knowledge is available. Load only the knowledge files relevant to your current task.

## Key Conventions

[3-5 most important project conventions — keep inline, not referencing external files]

## After Significant Work

Update the relevant `.context/` files:

1. **Always**: Update `state.md` with current focus and next steps
2. **If applicable**: Update the relevant `knowledge/*.md` file (decisions, conventions, lessons, architecture, or tech debt)
3. **Always**: Append a structured JSON entry to `log.jsonl`:
   ```json
   {"date":"YYYY-MM-DD","type":"<type>","summary":"<summary>","files":["<paths>"],"detail":"<context>"}
   ```

Only update when the change is significant — routine fixes do not need context updates.'
fi

# ══════════════════════════════════════════════════════════════
# .context/ — Tiered knowledge base
# ══════════════════════════════════════════════════════════════

echo ""
echo -e "${DIM}  ── Context: Tier 1 (Always Loaded) ──${NC}"

create_file ".context/project.md" '# Project Overview

## Name
[Project name]

## Description
[What does this project do? Who is it for? 2-3 sentences.]

## Tech Stack
- **Language**: [e.g., TypeScript, Python]
- **Framework**: [e.g., Next.js, FastAPI]
- **Database**: [e.g., PostgreSQL, MongoDB]
- **Infrastructure**: [e.g., Vercel, AWS, Docker]
- **Key Libraries**: [notable dependencies]

## Goals
- [Primary goal]
- [Secondary goal]

## Repository
- **Repo**: [URL or location]
- **Branch strategy**: [e.g., main + feature branches]

## Team
- [Role: Name or description]'

create_file ".context/state.md" '# Current State

## Current Focus
[What is actively being worked on right now? 1-2 sentences.]

## Blockers
- [None, or list active blockers]

## Next Steps
- [ ] [Immediate next task]
- [ ] [Following task]

## Recent Changes
<!-- Most recent first. Keep last 5. Archive older entries to archive/state.archive.md -->'

echo ""
echo -e "${DIM}  ── Context: Write Policy ──${NC}"

create_file ".context/write-policy.md" '# Context Write Policy

## Quality Gate

Only update context files when the change is **significant** — meaning it would affect how you approach similar work in the future. Routine code changes, minor fixes, and formatting updates do not warrant context updates.

Ask yourself: "If a new session started right now, would this information help it work better?" If no, do not write it.

## Update Triggers

| Event | Update | Also append to `log.jsonl` |
|-------|--------|-----------------------------|
| Work session ending | `state.md`: current focus, blockers, next steps | — |
| Technical decision made | `knowledge/decisions.md` | `{"type":"decision"}` |
| New code pattern established | `knowledge/conventions.md` | `{"type":"convention"}` |
| Approach failed or abandoned | `knowledge/lessons.md` | `{"type":"failure"}` |
| System structure changed | `knowledge/architecture.md` | `{"type":"refactor"}` |
| Shortcut or hack taken | `knowledge/tech-debt.md` | `{"type":"debt-added"}` |
| Tech debt resolved | `knowledge/tech-debt.md` (remove entry) | `{"type":"debt-resolved"}` |
| Feature or milestone completed | `state.md` | `{"type":"milestone"}` |
| Bug fixed | — | `{"type":"bugfix"}` |

## Write Rules

- Use ISO dates: `YYYY-MM-DD`
- Keep entries to 1-3 sentences
- In `lessons.md`: always explain **why** the approach failed
- In `decisions.md`: always include **rationale** and **alternatives considered**
- New entries go at the top of each file (most recent first)
- Update `knowledge/INDEX.md` when adding or removing knowledge files
- Update `last-updated` in frontmatter when editing any knowledge file
- Do not ask permission to update context files — update silently after significant work

## log.jsonl Format

One JSON object per line. Schema:

```json
{"date":"YYYY-MM-DD","type":"<type>","summary":"<1-line summary>","files":["<affected paths>"],"detail":"<brief context or rationale>"}
```

Valid types: `decision`, `milestone`, `failure`, `convention`, `refactor`, `bugfix`, `feature`, `debt-added`, `debt-resolved`

The log is append-only. Never edit or delete existing entries. Never auto-load this file during regular work — it exists for report generation only.

## Archiving Rules

When a context file approaches its size limit, archive older entries to keep the active file compact.

| File | Max Size | Keep in Active | Move to Archive |
|------|----------|----------------|-----------------|
| `state.md` | ~80 lines | Current focus + blockers + last 5 changes | Older changes to `archive/state.archive.md` |
| `knowledge/decisions.md` | ~100 lines | Last 8-10 decisions | Older/superseded to `archive/decisions.archive.md` |
| `knowledge/lessons.md` | ~100 lines | Active/relevant lessons | Resolved/old to `archive/lessons.archive.md` |
| Other knowledge files | ~100 lines | Current entries | Older entries to respective archive file |

**Archive = move, not copy.** Prepend a date-stamped header in the archive file:

```markdown
## Archived YYYY-MM-DD
[moved entries here]
```

Archive files are never auto-loaded. They exist for historical reference and report generation.'

echo ""
echo -e "${DIM}  ── Context: Tier 2 (Knowledge — Conditional) ──${NC}"

create_file ".context/knowledge/INDEX.md" '# Knowledge Index

Available knowledge files for this project. Load only what is relevant to your current task.

- [decisions.md](decisions.md) — Key technical decisions and their rationale
- [conventions.md](conventions.md) — Code patterns, naming standards, formatting rules
- [lessons.md](lessons.md) — Approaches that failed and why
- [architecture.md](architecture.md) — System structure, dependencies, data flow
- [tech-debt.md](tech-debt.md) — Known shortcuts and planned fixes'

create_file ".context/knowledge/decisions.md" '---
description: "Key technical decisions and their rationale"
last-updated: YYYY-MM-DD
---

# Decisions

<!-- Entry format:
## YYYY-MM-DD — [Decision Title]
**Context**: [Why this decision was needed]
**Decision**: [What was decided]
**Alternatives**: [What else was considered]
**Rationale**: [Why this option was chosen]
-->'

create_file ".context/knowledge/conventions.md" '---
description: "Code patterns, naming standards, formatting rules"
last-updated: YYYY-MM-DD
---

# Conventions

<!-- Entry format:
## [Convention Name]
[Description of the pattern or standard. 1-3 sentences.]
-->'

create_file ".context/knowledge/lessons.md" '---
description: "Approaches that failed and why"
last-updated: YYYY-MM-DD
---

# Lessons

<!-- Entry format:
## YYYY-MM-DD — [What Was Attempted]
**Approach**: [What was tried]
**Why it failed**: [The specific reason it did not work]
**Lesson**: [What to do instead]
-->'

create_file ".context/knowledge/architecture.md" '---
description: "System structure, dependencies, data flow"
last-updated: YYYY-MM-DD
---

# Architecture

## High-Level Structure
[How the system is organized — services, modules, layers]

## Key Dependencies
[External services, APIs, critical libraries and their roles]

## Data Flow
[How data moves through the system — request lifecycle, key pipelines]'

create_file ".context/knowledge/tech-debt.md" '---
description: "Known shortcuts and planned fixes"
last-updated: YYYY-MM-DD
---

# Tech Debt

<!-- Entry format:
## YYYY-MM-DD — [Shortcut Description]
**Where**: [Files or areas affected]
**Why it exists**: [Why the shortcut was taken]
**Fix plan**: [What the proper solution looks like]
**Priority**: [low / medium / high]
-->'

# ══════════════════════════════════════════════════════════════
# Tier 3: Chronicle + Archive (never auto-loaded)
# ══════════════════════════════════════════════════════════════

echo ""
echo -e "${DIM}  ── Context: Tier 3 (Chronicle + Archive) ──${NC}"

create_empty ".context/log.jsonl"

create_dir ".context/archive"

create_file ".context/archive/state.archive.md" '# State Archive

<!-- Archived "Recent Changes" entries from state.md. Never auto-loaded. -->'

create_file ".context/archive/decisions.archive.md" '# Decisions Archive

<!-- Archived entries from knowledge/decisions.md. Never auto-loaded. -->'

create_file ".context/archive/lessons.archive.md" '# Lessons Archive

<!-- Archived entries from knowledge/lessons.md. Never auto-loaded. -->'

# ══════════════════════════════════════════════════════════════
# .docs/ — Helper documents
# ══════════════════════════════════════════════════════════════

echo ""
echo -e "${DIM}  ── Helper Docs ──${NC}"

create_dir ".docs/plans"
create_dir ".docs/audits"
create_dir ".docs/guides"

# ══════════════════════════════════════════════════════════════
# Cursor rules (optional)
# ══════════════════════════════════════════════════════════════

if [ "$CURSOR" = true ]; then
  echo ""
  echo -e "${DIM}  ── Cursor Rules ──${NC}"

  create_file ".cursor/rules/context-always.mdc" '---
alwaysApply: true
---

# Project Context

At session start, read these files:
- `.context/project.md` — Project overview, stack, and goals
- `.context/state.md` — Current focus, blockers, and next steps
- `.context/knowledge/INDEX.md` — Index of available knowledge files

Only load knowledge files from `.context/knowledge/` that are relevant to the current task.

## After Significant Work

Only update context when the change would affect how a future session approaches similar work.

1. Update `.context/state.md` with current focus, blockers, and next steps
2. Update the relevant `.context/knowledge/*.md` file if a decision was made, convention established, lesson learned, architecture changed, or tech debt added/resolved
3. Append a structured entry to `.context/log.jsonl`:
   ```json
   {"date":"YYYY-MM-DD","type":"<type>","summary":"<summary>","files":["<paths>"],"detail":"<context>"}
   ```
   Types: `decision`, `milestone`, `failure`, `convention`, `refactor`, `bugfix`, `feature`, `debt-added`, `debt-resolved`

## Write Rules

- ISO dates (`YYYY-MM-DD`), entries 1-3 sentences
- New entries at the top of each file
- In `decisions.md`: include rationale and alternatives considered
- In `lessons.md`: always explain why the approach failed
- Update `knowledge/INDEX.md` when adding or removing knowledge files
- Archive entries when files approach ~100 lines (see `.context/write-policy.md` for details)'

  create_file ".cursor/rules/context-knowledge.mdc" '---
description: "Load relevant project knowledge when making architectural decisions, establishing code patterns, evaluating approaches, or addressing tech debt. Knowledge files are indexed in .context/knowledge/INDEX.md."
---

# Project Knowledge Base

When your task involves decisions, conventions, past failures, system architecture, or tech debt:

1. Read `.context/knowledge/INDEX.md` for the list of available knowledge files
2. Load only the files relevant to your current task
3. Use existing knowledge to avoid repeating past mistakes and to stay consistent with established patterns

Available knowledge types:
- `decisions.md` — Technical decisions with rationale and alternatives
- `conventions.md` — Code patterns, naming, formatting standards
- `lessons.md` — Failed approaches and why they did not work
- `architecture.md` — System structure, dependencies, data flow
- `tech-debt.md` — Known shortcuts and planned fixes'
fi

# ══════════════════════════════════════════════════════════════
# .gitignore additions
# ══════════════════════════════════════════════════════════════

echo ""
echo -e "${DIM}  ── Git Config ──${NC}"

GITIGNORE=".gitignore"
touch "$GITIGNORE"

add_gitignore() {
  local entry="$1"
  local comment="$2"
  if ! grep -qF "$entry" "$GITIGNORE" 2>/dev/null; then
    echo "" >> "$GITIGNORE"
    [ -n "$comment" ] && echo "# $comment" >> "$GITIGNORE"
    echo "$entry" >> "$GITIGNORE"
    echo -e "  ${GREEN}ADDED${NC}   .gitignore: $entry"
  fi
}

add_gitignore ".cursor/rules/personal.mdc" "Personal cursor rules (not shared)"

# ══════════════════════════════════════════════════════════════
# Summary
# ══════════════════════════════════════════════════════════════

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Done! Project context scaffold v2 is ready.${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  Structure created:"
echo ""
echo "  CLAUDE.md                              ← Claude Code entry point"
if [ "$AGENTS" = true ]; then
echo "  AGENTS.md                              ← Cross-tool portable context"
fi
echo ""
echo "  .context/project.md                    ← Tier 1: Project overview (always loaded)"
echo "  .context/state.md                      ← Tier 1: Current state (always loaded)"
echo "  .context/write-policy.md               ← Write policy (imported by CLAUDE.md)"
echo ""
echo "  .context/knowledge/INDEX.md            ← Tier 2: Knowledge index (always read)"
echo "  .context/knowledge/decisions.md        ← Tier 2: Loaded when relevant"
echo "  .context/knowledge/conventions.md"
echo "  .context/knowledge/lessons.md"
echo "  .context/knowledge/architecture.md"
echo "  .context/knowledge/tech-debt.md"
echo ""
echo "  .context/log.jsonl                     ← Tier 3: Structured chronicle (reports only)"
echo "  .context/archive/                      ← Tier 3: Archived entries (never loaded)"
echo ""
if [ "$CURSOR" = true ]; then
echo "  .cursor/rules/context-always.mdc       ← Cursor: always-active rules"
echo "  .cursor/rules/context-knowledge.mdc    ← Cursor: conditional knowledge loading"
echo ""
fi
echo "  .docs/plans/                           ← Implementation plans"
echo "  .docs/audits/                          ← Code/security audits"
echo "  .docs/guides/                          ← How-to guides"
echo ""
echo -e "  ${BLUE}Next step:${NC} Open .context/project.md and describe your project."
echo ""
