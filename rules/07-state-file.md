# Step 7: Write the Cycle State File

## File Location

Write to the **target repository** (resolved in step 4), not this agent repo:

```
<target_repo_toplevel>/.claude/jira-cycle/<KEY>.json
```

Use the absolute path from `repository.toplevel`.

## Setup

1. Create parent directories: `mkdir -p <toplevel>/.claude/jira-cycle/`
2. Add `.claude/jira-cycle/` to the target repo's `.gitignore` if not already
   present — this is scratch state, not source code.

## Schema

The state file must conform to `schemas/cycle-state.schema.json` in this
agent repo. A PostToolUse hook validates the structure after every write
(advisory — warns on failure but does not block).

## Required Fields

```json
{
  "schemaVersion": "1.0",
  "phase": "intake_complete",
  "ticket": { ... },
  "description": "...",
  "acceptanceCriteria": [ ... ],
  "proposedAcceptanceCriteria": [ ... ],
  "comments": [ ... ],
  "links": { "blockedBy": [], "blocks": [], "relates": [], "remote": [] },
  "subtasks": [ ... ],
  "classification": { ... },
  "repository": { ... },
  "blockers": [ ... ],
  "ambiguities": [ ... ],
  "availableTransitions": [ ... ]
}
```

See the full schema at `schemas/cycle-state.schema.json` for field types and
constraints.

## Downstream Contract

This file is the **single source of truth** for all downstream phases. Later
phases append to it rather than re-fetching Jira. Do not add ad-hoc fields
not defined in the schema.

## After Writing

Report the file path to the user and present the output brief per
`templates/output-brief.md`.
