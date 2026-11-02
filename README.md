# Jira Ticket Intake Agent

Phase 1 of the Plan > Implement > Verify agentic development cycle. Turns a
user-designated Jira ticket into a structured, unambiguous work brief that
downstream phases consume.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed
- [Atlassian MCP server](https://github.com/atlassian/atlassian-mcp-server) connected
  (`.mcp.json` in this repo declares the SSE endpoint; OAuth authenticates via browser.
  See `skills/atlassian-mcp-setup/SKILL.md` for setup instructions)
- Git available on PATH
- Python 3 available on PATH (used by hook scripts)

## Quick Start

```bash
git clone https://github.com/MorganJudd-fd/jira-intake-agent.git
cd jira-intake-agent
```

Open the repo in your IDE with Claude Code enabled. Then:

```
intake PROJ-1234
```

The agent reads the Jira ticket, extracts acceptance criteria, classifies the
work, resolves the target git repository, and writes a state file to
`<target-repo>/.claude/jira-cycle/PROJ-1234.json`.

## Directory Structure

```
jira-intake-agent/
├── CLAUDE.md              # Router: points Claude to rules, mcp, templates
├── .claude/
│   └── settings.json      # Permissions, hooks, tool allowlist
├── .mcp.json              # Atlassian MCP server declaration
├── rules/                 # Behavioral logic, one file per workflow step
│   ├── 01-identity.md
│   ├── 02-ticket-resolution.md
│   ├── 03-fetch-and-context.md
│   ├── 04-repo-resolution.md
│   ├── 05-acceptance-criteria.md
│   ├── 06-classification.md
│   ├── 07-state-file.md
│   └── guardrails.md
├── mcp/
│   └── atlassian.md       # MCP tool reference (names, params, consumed fields)
├── hooks/
│   ├── enforce-read-only-jira.sh   # Blocks Jira write operations
│   └── validate-state-file.sh      # Advisory schema check on state writes
├── schemas/
│   └── cycle-state.schema.json     # State file contract
├── skills/
│   └── atlassian-mcp-setup/
│       └── SKILL.md               # MCP server setup guide (OAuth, SSE)
├── templates/
│   └── output-brief.md             # User-facing output format
├── .gitignore
├── .editorconfig
├── README.md
└── LICENSE
```

## How It Works

1. **rules/** — Each numbered file is one step of the intake workflow. Claude
   reads them in order. Guardrails apply across all steps.
2. **hooks/** — Shell scripts that enforce constraints deterministically.
   `enforce-read-only-jira.sh` allowlists 6 read-only MCP tools and blocks
   everything else. `validate-state-file.sh` checks state file structure after
   writes (advisory, not blocking).
3. **schemas/** — The JSON Schema defines the state file contract that
   downstream phases depend on.
4. **.claude/settings.json** — Scoped permissions so the agent can only run
   read-only git commands, read files, and write to `.claude/jira-cycle/`.

## Forking and Customization

Fork this repo to adapt the agent for your team:

- **Add rules** — Drop a new numbered `.md` file in `rules/` and reference it
  from CLAUDE.md.
- **Modify MCP tools** — Update `mcp/atlassian.md` and the hook allowlist in
  `hooks/enforce-read-only-jira.sh`.
- **Extend the schema** — Edit `schemas/cycle-state.schema.json`. Remove
  `additionalProperties: false` if you need flexible extensions.
- **Change permissions** — Edit `.claude/settings.json` to adjust what the
  agent can do.
- **Override locally** — Create `.claude/settings.local.json` for personal
  overrides (gitignored).

## Full Development Cycle

```
1. jira-intake-agent           <<<  (this agent)
2. agentic-implementation-planner
3. plan-review-gate             [blocking human approval]
4. conventional-branch-setup
5. parallel-agent-executor
6. context-docs-updater
7. conventional-pr-creator
8. agentic-pr-reviewer
```

Each phase reads and appends to the shared state file at
`.claude/jira-cycle/<KEY>.json` in the target repository.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "Issue does not exist or you do not have permission" | Verify the ticket key and that the resolved cloudId is the correct site |
| Acceptance criteria field missing | The agent uses `fields: ["*all"]`; AC is nearly always a custom field |
| No Atlassian MCP tools available | Follow `skills/atlassian-mcp-setup/SKILL.md` for setup instructions |
| Several accessible Atlassian sites | The agent will ask which site owns the ticket |
| Hook errors on invocation | Ensure `python3` is on PATH and hooks are executable (`chmod +x hooks/*.sh`) |

## License

MIT
