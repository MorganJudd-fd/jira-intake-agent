# Step 4: Resolve the Target Repository

The ticket rarely names the repo cleanly. Resolve in this order and **state
which signal you used** in the output:

## Resolution Order

1. **Explicit repo** named in the ticket description, a comment, or a remote
   link (e.g., a GitHub PR URL).
2. **Current working directory**, if `git rev-parse --show-toplevel` succeeds
   and the cwd is not this agent repo.
3. **Ask the user** if neither of the above resolves a repo.

## Git Commands

Run these to gather repo metadata:

```bash
git -C <path> rev-parse --show-toplevel 2>/dev/null
git -C <path> remote get-url origin 2>/dev/null
git -C <path> symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'
```

## What to Record

Store in the state file `repository` object:

- `toplevel`: absolute path to repo root
- `originUrl`: the origin remote URL
- `defaultBranch`: the default branch name (e.g., `main`, `master`)
- `resolvedVia`: one of `ticket`, `cwd`, `user`
- `dirty`: boolean — whether the working copy has uncommitted changes

## Dirty Working Copy

If the working copy is dirty, **surface this immediately** in the output. A
dirty working copy will block clean branch creation in phase 4 of the cycle.
Do not silently proceed.
