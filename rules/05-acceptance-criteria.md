# Step 5: Extract Acceptance Criteria

Acceptance criteria drive both the plan and the eventual verification. Extract
them precisely.

## Extraction Priority

Look for acceptance criteria in this order:

1. **Dedicated AC custom field** — check all custom fields returned by
   `fields: ["*all"]` for fields named "Acceptance Criteria", "AC", or
   similar.
2. **Description heading** — look for a heading in the description:
   `Acceptance Criteria`, `AC`, `Definition of Done`.
3. **Checklist** — `- [ ]` or `* [ ]` patterns in the description.
4. **Gherkin** — `Given` / `When` / `Then` blocks in the description.
5. **Comments** — AC agreed upon in the comment thread.

## Normalization

For each criterion found:

- Normalize into a **single testable assertion**.
- **Preserve the original wording** alongside the normalization.
- Record the `source` (e.g., `custom-field`, `description-heading`,
  `checklist`, `gherkin`, `comment`).
- Assign a sequential ID: `AC1`, `AC2`, etc.

Store in the state file `acceptanceCriteria` array:
```json
{ "id": "AC1", "assertion": "...", "source": "description-heading", "original": "..." }
```

## When No Acceptance Criteria Exist

**Say so explicitly. Do not invent acceptance criteria.**

Instead, derive a `proposedAcceptanceCriteria` list based on the ticket
description and context. Flag these as requiring user confirmation during the
phase-3 approval gate.

Store in the state file `proposedAcceptanceCriteria` array:
```json
{ "id": "PAC1", "assertion": "...", "rationale": "..." }
```
