# Step 6: Classify the Work

Determine each of the following with a **one-line justification**.

## Change Type

One of: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`,
`ci`.

This drives the branch prefix and the conventional commit type.

## Scope

The affected module or package. Later phases use this as the commit scope
**only if** the repo's convention is module-as-scope. Where the repo puts the
ticket key instead (e.g., `feat(PROJ-1234): ...`), the key wins and this value
is informational.

## Breaking Change

Does this alter a public contract? Answer `true` or `false`.

## Blockers

Check `fields.issuelinks` for any `is blocked by` link whose target issue is
not yet resolved (status is not `Done`, `Closed`, or equivalent).

**Report blockers prominently.** A blocked ticket usually should not proceed.
Ask the user before continuing.

## Ambiguities

Identify every question whose answer would change the implementation. These
become the agenda for the approval gate in phase 3.

Store each as:
```json
{ "question": "...", "whyItMatters": "..." }
```

## State File

Store in the `classification` object:
```json
{
  "changeType": "feat",
  "scope": "checkout",
  "breaking": false,
  "justification": "Adds new caching layer to the pricing endpoint"
}
```

Store blockers in the top-level `blockers` array.
Store ambiguities in the top-level `ambiguities` array.
