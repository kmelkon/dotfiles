---
name: ship-personal
description: Ship uncommitted changes from master to a new branch with commit, push, and PR. For personal projects using GitHub issues. Use when the user says "ship", "ship it", or invokes /ship-personal. Optionally takes a GitHub issue number as argument (e.g. /ship-personal 42).
disable-model-invocation: true
argument-hint: [ISSUE-NUMBER]
---

# Ship Personal

Move uncommitted work on master into a properly named branch, commit, push, and open a PR. Designed for personal projects using GitHub issues (not Jira).

## Critical Rules

- NEVER add Co-Authored-By headers or mention AI/Claude anywhere
- NEVER push to master
- NEVER use `git add .` or `git add -A` — stage specific files

## Input

Parse `$ARGUMENTS` for a GitHub issue number (e.g. `42` or `#42`). Strip the `#` if present.

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

### 3. Create branch

**With issue:** `42/add-dark-mode`
**Without issue:** `add-dark-mode`

- Issue number: as provided (digits only)
- Description: lowercase kebab-case, 2-4 words

### 4. Stage and commit

- Stage only relevant files by name
- Exclude `.env`, credentials, large binaries
- Commit message: imperative, concise

### 5. Push

```
git push -u origin <branch-name>
```

### 6. After screenshot

If a before screenshot was taken:
- Take an after screenshot, save to `/tmp/ship-after.png`
- Show both to the user

### 7. Create PR

**Title format (with issue):** `#42: Add dark mode`
**Title format (without issue):** `Add dark mode`

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

Closes #42
```

Use a HEREDOC for the body. Do NOT include AI attribution. Only include `Closes #42` line when an issue number was provided.

### 8. Report

Output: branch name, PR URL, screenshot reminder if applicable.
