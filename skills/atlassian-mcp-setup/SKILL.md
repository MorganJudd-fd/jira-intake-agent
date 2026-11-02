# Atlassian MCP Server Setup

Guide developers through setting up the official Atlassian cloud MCP server
with OAuth authentication. No npm packages or API tokens required.

> **Official repo:** https://github.com/atlassian/atlassian-mcp-server

## When to Use

- The agent reports "No Atlassian MCP tools available"
- `mcp__atlassian__*` tools are not found
- A developer is setting up this agent for the first time

## Prerequisites

- **Atlassian Cloud** site (e.g., `your-org.atlassian.net`)
- A **modern browser** for OAuth 2.1 authorization
- Org admin has not disabled third-party MCP access

## Installation

### Option A: User scope (recommended for individual use)

```bash
claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/sse --scope user
```

### Option B: Project scope (shared via .mcp.json)

The agent repo already includes `.mcp.json` with the correct SSE endpoint.
Opening the repo in Claude Code auto-loads it. No manual setup needed unless
the project-scoped config doesn't take effect.

### Endpoint Note

The official repo also supports streamable HTTP at
`https://mcp.atlassian.com/v1/mcp`. If your Claude Code version supports
streamable HTTP transport, that endpoint is preferred. The `/v1/sse` endpoint
remains supported.

## OAuth Authentication

Authentication happens automatically on first use:

1. Use any Atlassian tool in Claude Code (e.g., search for a Jira issue)
2. A browser window opens to `https://auth.atlassian.com`
3. Log in with your Atlassian account and grant access
4. Return to Claude Code — tools are now active

Tokens refresh automatically. No manual token management.

## Verification

```bash
claude mcp list
claude mcp get atlassian
```

Or type `/mcp` inside Claude Code to see server status and available tools.

Test with a simple query:

```
Search Jira for recent issues in project YOURPROJECT
```

## Re-Authentication

If tokens expire or you need to re-authenticate:

```bash
claude mcp remove atlassian --scope user
claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/sse --scope user
```

Then trigger any Atlassian tool to reopen the OAuth flow.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| OAuth browser window doesn't open | Check default browser is configured; verify connectivity to `mcp.atlassian.com` |
| "Forbidden" or permission errors | Org admin must enable third-party MCP access / Rovo MCP Server in Atlassian Admin > Settings |
| Tools not appearing | Run `/mcp` in Claude Code; try remove + re-add; restart Claude Code |
| "Cloud ID Not Found" | Use `getAccessibleAtlassianResources` to discover your sites and their cloud IDs |
