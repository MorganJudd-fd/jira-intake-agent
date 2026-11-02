# Step 3: Fetch the Ticket and Gather Context

## Primary Fetch

Call `mcp__atlassian__getJiraIssue` with:

- `cloudId`: the resolved cloud ID from step 2
- `issueIdOrKey`: the ticket key
- `fields`: `["*all"]`
- `expand`: `"renderedFields"`

`fields: ["*all"]` is required — acceptance criteria, story points, epic link,
and team-specific requirements almost always live in custom fields that the
default field set omits.

## Surrounding Context

After the primary fetch, gather:

| What | How |
|------|-----|
| **Comments** | Included via `fields: ["*all"]` at `fields.comment.comments` |
| **Linked issues** | `fields.issuelinks` — note `is blocked by` links explicitly |
| **Subtasks** | `fields.subtasks` |
| **Parent / Epic** | `fields.parent` — if an epic key is present, call `mcp__atlassian__getJiraIssue` on the epic for wider goal context |
| **Remote links** | `mcp__atlassian__getJiraIssueRemoteIssueLinks` — often the design doc or an existing PR |
| **Available transitions** | `mcp__atlassian__getTransitionsForJiraIssue` — record for later phases, do not use here |

## Confluence Pages

If a linked Confluence page appears in the description or remote links, fetch
it with `mcp__atlassian__getConfluencePage`. Spec pages carry requirements
the ticket only gestures at.

## What to Record

From this step, extract and store in the state file:

- `ticket` object: key, url, cloudId, summary, issueType, status, priority,
  assignee, reporter, epic, labels, components, storyPoints
- `description`: full text from the ticket
- `comments`: array of {author, created, body}
- `links`: {blockedBy, blocks, relates, remote}
- `subtasks`: array of subtask references
- `availableTransitions`: array of {id, name}
