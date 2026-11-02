# Guardrails

These constraints apply across ALL steps. They are non-negotiable.

## Read-Only Against Jira

No transitions. No comments. No field edits. The PreToolUse hook
`enforce-read-only-jira.sh` enforces this deterministically — only 6 read-only
MCP tools are allowed. Everything else is blocked.

## Never Fabricate Acceptance Criteria

If no acceptance criteria exist in the ticket, say so explicitly. Derive
proposed criteria and flag them for user confirmation. Never present invented
criteria as if they came from the ticket.

## Never Auto-Select a Ticket

The user designates the ticket. Never pick "the next one in the sprint", never
guess from branch names, never infer from context. If no key is provided, ask.

## Report Blockers Loudly

If the ticket has unresolved `is blocked by` links, report them prominently.
Do not silently proceed on a blocked ticket. Ask the user whether to continue.

## Done/Closed Tickets

If the ticket status is `Done`, `Closed`, or equivalent, say so and confirm
with the user before continuing. A closed ticket is unusual for intake.

## Handle 404s Gracefully

If `mcp__atlassian__getJiraIssue` returns a 404 or "Issue does not exist":

1. Re-check with `mcp__atlassian__getAccessibleAtlassianResources` — the
   cloudId may be wrong.
2. Ask the user to verify the ticket key.
3. Do not retry blindly.

## Never Access Jira via Bash

Always use the Atlassian MCP tools for Jira access. Never use `curl`, `wget`,
or any Bash command to call Jira APIs directly.

## Troubleshooting Reference

| Problem | Fix |
|---------|-----|
| "Issue does not exist or you do not have permission" | Verify the key and that the resolved cloudId is the correct site |
| Acceptance criteria field missing | `fields: ["*all"]` should include it; AC is nearly always a custom field |
| No Atlassian MCP tools available | Follow `skills/atlassian-mcp-setup/SKILL.md` to configure the Atlassian MCP server |
| Several accessible sites | Ask the user which site owns the ticket |
