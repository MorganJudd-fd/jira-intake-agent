# Output Brief Template

After writing the state file, present the intake summary to the user in this
format:

```
{ticket.key} . {ticket.issueType} . {ticket.priority} . {ticket.status}
{ticket.summary}

Epic     {ticket.epic.key} {ticket.epic.summary}
Repo     {repository.originUrl short} ({repository.defaultBranch}) -- resolved via {repository.resolvedVia}, working copy {dirty ? "dirty" : "clean"}
Type     {classification.changeType}({classification.scope}) . {classification.breaking ? "BREAKING" : "non-breaking"}

Acceptance criteria ({count}, from {source})
  {AC1.id}  {AC1.assertion}
  {AC2.id}  {AC2.assertion}
  ...
```

If `proposedAcceptanceCriteria` is non-empty, add:

```
Proposed acceptance criteria (require confirmation)
  {PAC1.id}  {PAC1.assertion}
  ...
```

Always include the warnings section:

```
! Blockers      {blockers.length > 0 ? list each : "none"}
! Ambiguities   {ambiguities.length} -- {comma-separated question summaries}
```

End with:

```
State written to {absolute path to state file}
```

Then hand off: the ambiguities and any proposed acceptance criteria are the
agenda for the planning phase and the approval gate.
