#!/usr/bin/env bash
set -euo pipefail

# PostToolUse hook: advisory schema validation for cycle state files.
# Fires after Write/Edit. Checks if the written file is a cycle state file
# and validates its structure. Advisory only — warns but does not block.

HOOK_INPUT=$(cat)

RESULT=$(echo "$HOOK_INPUT" | python3 << 'PYEOF'
import sys, json, os, re

hook_input = json.load(sys.stdin)

tool_name = hook_input.get("tool_name", "")
if tool_name not in ("Write", "Edit"):
    sys.exit(0)

tool_input = hook_input.get("tool_input", {})
file_path = tool_input.get("file_path", "")

if "/.claude/jira-cycle/" not in file_path or not file_path.endswith(".json"):
    sys.exit(0)

if not os.path.isfile(file_path):
    print(json.dumps({"systemMessage": f"State file not found at {file_path} after write"}))
    sys.exit(0)

with open(file_path) as f:
    try:
        data = json.load(f)
    except json.JSONDecodeError as e:
        print(json.dumps({"systemMessage": f"State file is not valid JSON: {e}"}))
        sys.exit(0)

errors = []

required_root = ["schemaVersion", "phase", "ticket", "description", "repository"]
for key in required_root:
    if key not in data:
        errors.append(f"missing required field: {key}")

if "schemaVersion" in data and data["schemaVersion"] != "1.0":
    errors.append(f"schemaVersion must be '1.0', got '{data['schemaVersion']}'")

valid_phases = ["intake_in_progress", "intake_complete"]
if "phase" in data and data["phase"] not in valid_phases:
    errors.append(f"phase must be one of {valid_phases}, got '{data['phase']}'")

if "ticket" in data and isinstance(data["ticket"], dict):
    ticket = data["ticket"]
    required_ticket = ["key", "url", "cloudId", "summary", "issueType", "status"]
    for key in required_ticket:
        if key not in ticket:
            errors.append(f"ticket missing required field: {key}")

    if "key" in ticket and not re.match(r"^[A-Z][A-Z0-9]+-\d+$", str(ticket["key"])):
        errors.append(f"ticket.key does not match pattern: {ticket['key']}")

if "repository" in data and isinstance(data["repository"], dict):
    repo = data["repository"]
    required_repo = ["toplevel", "originUrl", "defaultBranch", "resolvedVia"]
    for key in required_repo:
        if key not in repo:
            errors.append(f"repository missing required field: {key}")

    valid_resolved = ["ticket", "cwd", "user"]
    if "resolvedVia" in repo and repo["resolvedVia"] not in valid_resolved:
        errors.append(f"repository.resolvedVia must be one of {valid_resolved}")

if "classification" in data and isinstance(data["classification"], dict):
    cls = data["classification"]
    valid_types = ["feat", "fix", "refactor", "perf", "docs", "test", "chore", "build", "ci"]
    if "changeType" in cls and cls["changeType"] not in valid_types:
        errors.append(f"classification.changeType must be one of {valid_types}")

if errors:
    msg = "State file validation warnings:\n" + "\n".join(f"  - {e}" for e in errors)
    print(json.dumps({"systemMessage": msg}))
else:
    print(json.dumps({"systemMessage": "State file validated successfully."}))

PYEOF
) || true

if [ -n "${RESULT:-}" ]; then
  echo "$RESULT"
fi

exit 0
