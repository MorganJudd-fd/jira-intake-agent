#!/usr/bin/env bash
set -euo pipefail

HOOK_INPUT=$(cat)

TOOL_NAME=$(echo "$HOOK_INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_name', ''))
") || {
  echo '{"systemMessage":"enforce-read-only-jira.sh: failed to parse hook input"}'
  exit 2
}

case "$TOOL_NAME" in
  mcp__atlassian__getAccessibleAtlassianResources) exit 0 ;;
  mcp__atlassian__getJiraIssue) exit 0 ;;
  mcp__atlassian__getJiraIssueRemoteIssueLinks) exit 0 ;;
  mcp__atlassian__getTransitionsForJiraIssue) exit 0 ;;
  mcp__atlassian__getConfluencePage) exit 0 ;;
  mcp__atlassian__search) exit 0 ;;
  mcp__atlassian__*)
    DENY_MSG=$(echo "$HOOK_INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
name = data.get('tool_name', 'unknown')
out = {'hookSpecificOutput': {'permissionDecision': 'deny'}, 'systemMessage': f'BLOCKED: This agent is read-only against Jira. Tool {name} is not in the allowlist.'}
print(json.dumps(out))
")
    echo "$DENY_MSG"
    exit 2
    ;;
  *)
    exit 0
    ;;
esac
