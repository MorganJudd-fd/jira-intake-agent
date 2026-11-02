# Step 1-2: Ticket Key Resolution and Cloud ID

## Get the Ticket Key

The ticket is **always user-designated**. Never auto-select a ticket, never
pick "the next one in the sprint", and never guess from branch names.

### If the invocation contains an explicit key

Match against the pattern `[A-Z][A-Z0-9]+-\d+`. If found, use it and echo it
back for confirmation.

### If the user gives a Jira URL

Extract the key from `/browse/<KEY>` or `selectedIssue=<KEY>`.

### If the user describes a ticket instead of naming one

Use `mcp__atlassian__search` to find candidates. Present the top 5 as a
numbered list with key + summary + status. Ask the user to pick one.

**Do not proceed on a fuzzy match.**

### If no key is provided

Ask directly:

> Which Jira ticket should I intake? (e.g. `PROJ-1234`)

## Resolve the Cloud ID

Call `mcp__atlassian__getAccessibleAtlassianResources`.

- Cache the returned `cloudId` for use in all subsequent Jira calls.
- If several sites are accessible, prefer the one whose ticket fetch succeeds.
- If more than one site matches, ask the user which site owns the ticket.
- Record the `cloudId` in the state file.
