# Global Guidelines for Personal Projects

Personal projects are located in `/Users/karmal/Documents/Projects/`.

## Communication Style

- Be extremely concise in all interactions and commit messages. Sacrifice grammar for concision.
- Plans must be multi-phase.
- End each plan with unresolved questions (if any). Keep questions extremely concise.

## npm Registry Issues

When running `npm install` on a machine with a corporate/private npm registry configured (e.g., Nordnet's Artifact Registry), the `package-lock.json` will contain resolved URLs pointing to that private registry. This causes EAS builds and other CI/CD pipelines to fail with `E401` authentication errors.

**Fix**: Always use the public registry for personal projects:
```bash
npm install --registry https://registry.npmjs.org/
```

**If you encounter E401 errors in CI/CD**:
1. Delete `node_modules` and `package-lock.json`
2. Run `npm install --registry https://registry.npmjs.org/`
3. Commit the regenerated `package-lock.json`

## No Assumptions Policy

Never assume answers to unclear requirements. When facing ambiguity about:
- User intent or desired behavior
- Design/UX choices
- Implementation approach (multiple valid options)
- Scope (what's included/excluded)

Use AskUserQuestion with concrete options instead of guessing. Bias toward asking over assuming.

## Session Continuity

On session start, if `.claude/handoff.md` exists in the project, read it first. It contains context from the previous session. Acknowledge briefly what was done and what's pending.

## Session Hygiene

- Hard limit: 80 messages per session. After ~70 messages, warn the user: "Heads up — we're around 70 messages. Wrap up the current sub-task, commit, and start a fresh session."
- If the session clearly exceeds 80 messages, stop accepting new sub-tasks. Finish current work, commit, and insist on a new session.
- No scope creep: one session = one focused task. If the user pivots to something unrelated, suggest starting a new session.
- If the user gives a terse mid-session prompt (e.g. "fix it", "next", "do it"), ask for clarification by restating the current goal and asking what specifically to do next.
- For exploration/research tasks, ask the user to define concrete deliverables before starting (e.g. "what should the output be?"). Don't begin open-ended exploration without exit criteria.
