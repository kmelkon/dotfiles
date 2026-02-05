---
name: nn-app-review
description: Review code changes against Nordnet mobile app patterns and conventions
---

# Nordnet Mobile App Code Review

Review code changes against project-specific patterns and conventions defined in CLAUDE.md.

## Invocation

Parse the user's input to determine scope:

| Input | Action |
|-------|--------|
| `/nn-app-review` | Smart detection (see below) |
| `/nn-app-review <branch>` | Review branch vs master via `git diff master...<branch>` |
| `/nn-app-review --pr <number>` | Review PR via `gh pr diff <number>` |

### Smart Detection (no arguments)

When invoked without arguments, auto-detect what to review:

1. **Check uncommitted changes**: `git diff` - if non-empty, review those
2. **Check for open PR**: `gh pr view --json number,url 2>/dev/null` - if PR exists for current branch, review it
3. **Check committed changes vs master**: `git diff master...HEAD` - if non-empty, review those
4. **No changes found**: Output helpful error:
   ```
   No changes to review. Options:
   - Make changes and run `/nn-app-review` again
   - Review a specific branch: `/nn-app-review feature-branch`
   - Review a PR: `/nn-app-review --pr 123`
   ```

## Diff Parsing

Extract changed lines using unified diff format:
- `@@ -start,count +start,count @@` headers indicate changed ranges
- Track `+start` to `+start+count` as changed lines for new code
- Only flag issues where line number falls within these ranges
- Store as `changedLines` map: `{ "path/file.ts": [[10,15], [42,50]] }`

## Review Process

1. **Get diff + extract changed line ranges** per file based on invocation scope
2. **Identify changed files** and their types (component, screen, test, API, etc.)
3. **Apply relevant checks** only on lines within `changedLines` ranges - skip issues on unchanged lines
4. **Score each issue with Haiku agents** - launch parallel Haiku agents to score confidence (0-100):
   - **0**: False positive, doesn't hold up to scrutiny, or pre-existing issue
   - **25**: Might be real, but couldn't verify. Stylistic issue not in CLAUDE.md
   - **50**: Verified real, but nitpick or low impact
   - **75**: Verified, will impact functionality, or explicitly in CLAUDE.md
   - **100**: Confirmed real, will happen frequently, evidence confirms
5. **Filter issues** scoring below 70 confidence
6. **Categorize findings** by severity
7. **Output structured report**

## Review Criteria

### Green Layer Compliance (All Files)

- [ ] Uses RTK Query over plain Redux for new API code
- [ ] Uses Design System components from `@/designSystem/`
- [ ] Uses styled-components, not inline styles
- [ ] No imports from deprecated `src/ducks/` in new code

### RTK Query Endpoints (`src/api/endpoint/**`)

- [ ] Uses `nnApi` or `nnxApi` as base
- [ ] Exports hooks only (not raw endpoints)
- [ ] Uses `<Response, Request>` generic order
- [ ] Follows folder structure: `index.ts`, `endpoint.ts`, `types.ts`

### Component Patterns (`src/designSystem/**`, `src/components/**`)

- [ ] Uses namespace pattern for subcomponents
- [ ] Has `displayName` property set
- [ ] Wrapped with `withDevDebugHighlight` (Design System only)
- [ ] Component file 40-110 lines (flag if outside range)
- [ ] Index file exports only main component

### Styling (`*.styled.ts`)

- [ ] Uses theme callback: `({ theme }) => ...`
- [ ] Values align to 4px grid (4, 8, 12, 16, 20, 24, etc.)
- [ ] No hardcoded colors (use `theme.colors.*`)
- [ ] No hardcoded spacing (use theme spacing or 4px multiples)

### Screen Components (`src/screens/**`)

- [ ] Wrapped with `memo()`
- [ ] Uses `useAppNavigation` for navigation
- [ ] Event handlers wrapped in `useCallback`
- [ ] Uses `useOnViewFocus` for screen focus effects

### Feature Flags

- [ ] Flag names have `md-` prefix
- [ ] Uses `useDecision` hook from `@optimizely/react-sdk`
- [ ] Checks `.enabled` property, not just truthy value
- [ ] Flag defined in `src/constants/featureFlags/featureFlags.ts`

### Spec Tests (`*.spec.tsx`)

- [ ] Has 🤖 emoji at top of file
- [ ] Uses `renderAsync` from `@nn-test-utils/integration`
- [ ] Uses `findByRole()` over `findByText()`
- [ ] Uses actual translation strings, not `t()` function
- [ ] No snapshots (`toMatchSnapshot`)
- [ ] No mocks (`jest.mock`)
- [ ] No spies (`jest.spyOn`)
- [ ] No `beforeEach`/`afterEach` hooks
- [ ] No `UNSAFE` functions from render return
- [ ] User interactions wrapped with `jest.useFakeTimers()`

### Flow Tests (`*.flow.tsx`)

- [ ] Uses `renderAppAsync` from `@nn-test-utils/flow`
- [ ] Uses login helpers from `nn-test-utils/flowHelpers/`
- [ ] Tests full navigation flows

### Internationalization

- [ ] Translation keys in SCREAMING_SNAKE_CASE
- [ ] Keys added to `src/l10n/crowdin.json`
- [ ] Accessibility labels use `_ACCESSIBILITY` suffix
- [ ] All user-facing strings wrapped with `t()`

### Imports

- [ ] Uses path aliases (`@/`) not relative paths for cross-directory imports
- [ ] `useTheme` imported as default (no curly braces)
- [ ] Design System imports from correct paths

### False Positives (Do Not Flag)

- Pre-existing issues on unchanged lines
- Issues linters/typecheckers catch (imports, types, formatting)
- General quality issues not in CLAUDE.md
- Issues silenced with lint-ignore comments
- Intentional functionality changes related to PR purpose

## Output Format

Structure your review as follows:

```markdown
## Code Review: [scope description]

### Summary
[Brief overview of changes: X files changed, primary purpose]

### Issues

| Severity | Score | Category | Issue | Location |
|----------|-------|----------|-------|----------|
| 🔴 | 95 | Category | Issue description | `file.tsx:12` |
| 🟡 | 75 | Category | Issue description | `file.tsx:24` |

*Only issues with confidence score ≥70 shown. 🔴 = Critical (must fix), 🟡 = Warning (should fix)*

### Recommended Actions
[Numbered list of specific actions to address issues]
```

**Do NOT include:** Notes section, Positive Observations, Info-level issues, or any other sections not shown above.

## Severity Guidelines

**🔴 Critical:**

- Using deprecated red layer (plain Redux, custom API wrappers) in new code
- Hardcoded colors or secrets
- Missing `memo()` on screens
- Using `jest.mock` or snapshots in tests
- Security issues (exposed keys, injection vulnerabilities)

**🟡 Warning:**

- Missing 🤖 emoji in test files
- Component exceeds 110 lines
- Missing `displayName`
- Not using `findByRole` in tests
- Inline styles instead of styled-components

## Example Review

```markdown
## Code Review: Uncommitted Changes

### Summary
3 files changed: New UserProfile component with tests.

### Issues

| Severity | Score | Category | Issue | Location |
|----------|-------|----------|-------|----------|
| 🔴 | 95 | Testing | Using `jest.mock` for API | `UserProfile.spec.tsx:12` |
| 🔴 | 88 | Styling | Hardcoded color `#FF0000` | `UserProfile.styled.ts:24` |
| 🟡 | 75 | Testing | Missing 🤖 emoji | `UserProfile.spec.tsx:1` |
| 🟡 | 72 | Component | Missing `memo()` wrapper | `UserProfile.tsx:45` |

*Only issues with confidence score ≥70 shown. 🔴 = Critical (must fix), 🟡 = Warning (should fix)*

### Recommended Actions
1. Replace `jest.mock` with MSW handlers
2. Replace hardcoded color with `theme.colors.status.error`
3. Add 🤖 to test file
4. Wrap component export with `memo()`
```

## Reference Files

When uncertain about patterns, reference these files:

- Component pattern: `src/designSystem/molecules/buttons/Button/`
- Test pattern: `src/components/ActWarning/__tests__/ActWarning.spec.tsx`
- RTK Query: `src/api/endpoint/` (any endpoint folder)
- Styling: Any `*.styled.ts` in Design System
