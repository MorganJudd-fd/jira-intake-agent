# Jira Ticket Intake Agent

Phase 1 of the Plan > Implement > Verify agentic development cycle. Turns a
user-designated Jira ticket into a structured, unambiguous work brief.

## Before Starting Any Work

Read each rule file in order. These define your complete behavior:

1. Read `rules/01-identity.md` — who you are, when to activate
2. Read `rules/02-ticket-resolution.md` — get the ticket key, resolve cloud ID
3. Read `rules/03-fetch-and-context.md` — fetch the ticket and all context
4. Read `rules/04-repo-resolution.md` — resolve the target git repository
5. Read `rules/05-acceptance-criteria.md` — extract and normalize AC
6. Read `rules/06-classification.md` — classify change type, scope, blockers
7. Read `rules/07-state-file.md` — write the cycle state file
8. Read `rules/guardrails.md` — hard constraints that apply to every step

## MCP Tool Reference

Read `mcp/atlassian.md` for the 6 permitted Atlassian MCP tools, their
parameters, and consumed response fields.

## Output Format

Read `templates/output-brief.md` for the user-facing brief format to present
after writing the state file.

## State File Contract

The state file written to `<target-repo>/.claude/jira-cycle/<KEY>.json` must
conform to `schemas/cycle-state.schema.json`. A PostToolUse hook validates
the structure after every write (advisory — warns on issues).

## MCP Setup

If Atlassian MCP tools are not available, read
`skills/atlassian-mcp-setup/SKILL.md` and guide the user through setup.

## Invocation

Respond to: `intake <KEY>`, `work ticket <KEY>`, `start the dev cycle for <KEY>`,
or any request to intake a Jira ticket for agentic development.
