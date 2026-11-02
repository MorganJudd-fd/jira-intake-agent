# Atlassian MCP Tool Reference

This agent uses 6 read-only Atlassian MCP tools. These are the ONLY Atlassian
tools permitted — the PreToolUse hook blocks all others.

## Tools

### mcp__atlassian__getAccessibleAtlassianResources

Returns the list of Atlassian sites accessible with the current credentials.

**Parameters**: none

**Consumed fields**:
- `id` — the cloudId (use for all subsequent calls)
- `url` — the site URL (e.g., `https://yourorg.atlassian.net`)
- `name` — human-readable site name

---

### mcp__atlassian__getJiraIssue

Fetches a single Jira issue with all fields.

**Parameters**:
- `cloudId` (string, required) — from getAccessibleAtlassianResources
- `issueIdOrKey` (string, required) — e.g., `PROJ-1234`
- `fields` (array, required) — always use `["*all"]`
- `expand` (string, optional) — use `"renderedFields"` for HTML-rendered descriptions

**Consumed fields**:
- `fields.summary` — ticket title
- `fields.issuetype.name` — Story, Bug, Task, etc.
- `fields.status.name` — current status
- `fields.priority.name` — priority level
- `fields.assignee.displayName` — assignee (may be null)
- `fields.reporter.displayName` — reporter
- `fields.parent` — parent issue / epic reference
- `fields.labels` — array of label strings
- `fields.components` — array of {name} objects
- `fields.comment.comments` — array of {author.displayName, created, body}
- `fields.issuelinks` — array of linked issues with type and direction
- `fields.subtasks` — array of subtask references
- `fields.description` — plain text description
- `renderedFields.description` — HTML-rendered description
- Custom fields — story points, acceptance criteria, etc. (field names vary by project)

---

### mcp__atlassian__getJiraIssueRemoteIssueLinks

Fetches remote links attached to a Jira issue (design docs, PRs, external URLs).

**Parameters**:
- `cloudId` (string, required)
- `issueIdOrKey` (string, required)

**Consumed fields**:
- Array of `{object.url, object.title}` — the linked resource URL and title

---

### mcp__atlassian__getTransitionsForJiraIssue

Returns available workflow transitions for an issue. Recorded for downstream
phases — this agent does not execute transitions.

**Parameters**:
- `cloudId` (string, required)
- `issueIdOrKey` (string, required)

**Consumed fields**:
- Array of `{id, name}` — transition ID and display name

---

### mcp__atlassian__getConfluencePage

Fetches a Confluence page by ID. Use when a linked Confluence page appears in
the ticket description or remote links.

**Parameters**:
- `cloudId` (string, required)
- `pageId` (string, required) — extract from Confluence URL

**Consumed fields**:
- `title` — page title
- `body.storage.value` — page content in storage format (HTML)

---

### mcp__atlassian__search

Searches Jira using JQL. Used only when the user describes a ticket by name
instead of providing a key.

**Parameters**:
- `cloudId` (string, required)
- `jql` (string, required) — e.g., `summary ~ "caching bug" ORDER BY updated DESC`
- `fields` (array, optional) — e.g., `["summary", "status"]`
- `maxResults` (number, optional) — use `5` for fuzzy searches

**Consumed fields**:
- `issues` — array of `{key, fields.summary, fields.status.name}`

## Error Patterns

| Error | Meaning | Action |
|-------|---------|--------|
| 404 / "Issue does not exist" | Wrong key or wrong site | Re-check cloudId via getAccessibleAtlassianResources |
| 401 / 403 | Auth expired or insufficient permissions | Ask user to re-authenticate the MCP server |
| Tool not found | MCP server not connected | Follow `skills/atlassian-mcp-setup/SKILL.md` to set up the Atlassian MCP server |
