---
name: ship
description: Ship uncommitted changes from master to a new branch with commit, push, and PR. For Nordnet projects with Jira tickets. Use when the user says "ship", "ship it", wants to create a branch + PR from current changes, or invokes /ship. Expects a Jira ticket ID as argument (e.g. /ship ACP-3821).
disable-model-invocation: true
argument-hint: [TICKET-ID]
---

# Ship

Move uncommitted work on master into a properly named branch, commit, push, and open a PR.

## Critical Rules

- NEVER add Co-Authored-By headers or mention AI/Claude anywhere
- NEVER push to master
- NEVER use `git add .` or `git add -A` — stage specific files

## Input

Parse `$ARGUMENTS` for the Jira ticket ID (e.g. `ACP-3821`).

If not provided, ask the user for:
1. **Ticket ID** — e.g. `ACP-3821`
2. **Team name** — e.g. `CREAM`, `FIREFLY`, `ATLAS` (default: `CREAM` if not specified)

If no description is given, infer a short kebab-case description from the changes.

## Workflow

### 1. Verify state

Confirm currently on `master` (or `main`) and there are uncommitted/staged changes. Abort if clean.

### 2. Before screenshot (visual changes only)

If the change is visual (UI components, styling, layout):
1. `git stash` — revert changes temporarily
2. Take a screenshot and save to `/tmp/ship-before.png`
3. `git stash pop` — restore changes

Skip for non-visual changes (config, backend, types, tests).

**Scaling:** Simulator screenshots are 3x Retina resolution. Scale down to 1x before saving:
```
sips --resampleWidth 402 /tmp/ship-before.png
```

### 3. Create branch

Format: `TICKET/TEAM/description`

Example: `ACP-3821/CREAM/add-bank-logos`

- Ticket: uppercase as provided
- Team: uppercase
- Description: lowercase kebab-case, 2-4 words

### 4. Stage and commit

- Stage only relevant files by name
- Exclude `.env`, credentials, large binaries
- Commit message: imperative, concise

### 5. Push

```
git push -u origin TICKET/TEAM/description
```

### 6. After screenshot

If a before screenshot was taken:
- Take an after screenshot, save to `/tmp/ship-after.png`
- Scale to 1x: `sips --resampleWidth 402 /tmp/ship-after.png`
- Show both to the user

### 7. Create PR

**Title format**: `TICKET: [TEAM] Description`
Example: `ACP-3821: [CREAM] Add bank logos to deposit form`

**Body structure**:
```
## Why
[Motivation]

## Approach
[Rationale]

## How it works
[Technical details]

## Screenshots
[If taken — tell user to drag-drop /tmp/ship-before.png and /tmp/ship-after.png]

## Links
- [TICKET](https://nordnet.atlassian.net/browse/TICKET)
```

Use a HEREDOC for the body. Do NOT include AI attribution.

### 8. Report

Output: branch name, PR URL, screenshot reminder if applicable.
