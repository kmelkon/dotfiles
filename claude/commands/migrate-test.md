---
description: Migrate .test files to .spec/.flow for a team. Usage /migrate-test <batch> where batch is easy|components|screens or a file path
allowed-tools: Bash, Read, Write, Edit, Grep, Glob, Task
---

# Test Migration: .test → .spec/.flow

Migrate legacy `.test.` files to the new `.spec.` or `.flow.` patterns.

## Input

Parse the argument to determine scope:

| Input | Action |
|-------|--------|
| `easy` | Migrate pure unit tests (actions, selectors, utils) - just rename + remove snapshots |
| `components` | Migrate component/hook tests - full rewrite to renderAsync pattern |
| `screens` | Migrate screen tests - determine spec vs flow, full rewrite |
| `<file-path>` | Migrate a single specific file |
| `status` | Show migration progress from tracking document |
| (no args) | Show status + suggest next batch |

## Step 1: Read tracking document

Read `.local/test-migration-cream.md` (relative to project root) to understand:
- Which files still need migration
- Which category the target files belong to

## Step 2: For each file to migrate

### 2a. Read the current test file

Understand what it tests and how.

### 2b. Read the component being tested

Understand its accessible elements (roles, labels, text) so you can write proper queries.

### 2c. Ask the user before proceeding

Before writing any code, present the user with:
1. **Summary** of what the current test does
2. **Recommendation**: `.spec` or `.flow` (with reasoning)
3. **Migration plan**: what will change (imports, assertions, removed mocks, etc.)
4. **Questions**: anything unclear about the component behavior, expected test coverage, or edge cases

Use `AskUserQuestion` to confirm:
- Target extension (`.spec` vs `.flow`)
- Whether any test cases should be dropped or added
- Any ambiguities about expected behavior

Wait for user confirmation before proceeding to the rewrite.

### 2d. Rewrite the test

**Target patterns (MUST follow):**

```typescript
// 🤖
import React from 'react';
import { renderAsync, screen } from '@nn-test-utils/integration';
import Component from '../Component';

describe('when [condition]', () => {
  it('should [expected behavior]', async () => {
    jest.useFakeTimers();
    const { user } = await renderAsync(<Component />);

    expect(await screen.findByRole('text', { name: 'Expected text' })).toBeVisible();

    await user.press(await screen.findByRole('button', { name: 'Button label' }));
    jest.useRealTimers();
  });
});
```

**For flow tests:**

```typescript
// 🤖
import { renderAppAsync, screen } from '@nn-test-utils/flow';

describe('when [navigation scenario]', () => {
  it('should [navigate and show expected screen]', async () => {
    jest.useFakeTimers();
    const { user } = await renderAppAsync();
    // Use helpers from nn-test-utils/flowHelpers/ to navigate
    jest.useRealTimers();
  });
});
```

**For pure unit tests (actions, selectors, utils):**

```typescript
// 🤖
import { mySelector } from '../mySelectors';

describe('when [state condition]', () => {
  it('should [return expected value]', () => {
    const state = { /* minimal state */ };
    expect(mySelector(state)).toBe(expectedValue);
  });
});
```

### Rules (STRICTLY enforced):

1. Add `// 🤖` at top of file
2. Use `renderAsync` from `@nn-test-utils/integration` (spec) or `renderAppAsync` from `@nn-test-utils/flow` (flow)
3. Use `screen.findByRole()` over `findByText()` — use `logRoles(screen.toJSON())` to discover available roles if needed
4. Use actual translation strings, not `t()` function calls
5. **NO** snapshots (`toMatchSnapshot`, `toMatchInlineSnapshot`)
6. **NO** mocks (`jest.mock`)
7. **NO** spies (`jest.spyOn`)
8. **NO** `beforeEach`/`afterEach` hooks
9. **NO** `UNSAFE` functions from render return
10. Wrap user interactions with `jest.useFakeTimers()`/`jest.useRealTimers()`
11. Use MSW handlers for backend data (not jest.mock)
12. Pass feature flags directly to render: `await renderAsync(<C />, { featureFlags: [...] })`
13. Pass Redux state via: `await renderAsync(<C />, { preloadedState: {...} })`
14. Use `describe("when...")` + `it("should...")` naming

### What to do when a test CAN'T be cleanly migrated:

Some tests mock internal implementation details heavily. In these cases:
- Focus on testing the **user-visible behavior** instead
- If the component can't be rendered without heavy mocking, note it in the tracking doc and skip
- Duck tests (actions/selectors) that test thunks with side effects may need to keep some mocks — that's OK for pure unit tests

### 2e. Rename the file

```bash
git mv old-path/Component.test.tsx old-path/Component.spec.tsx
```

### 2f. Write the new content

Write the rewritten test to the new file path.

### 2g. Run the test

```bash
npm run test-specs <new-file-path>
```

If it fails, debug and fix. Use `logRoles(screen.toJSON())` to discover accessible elements.

## Step 3: Update tracking document

After each file is migrated (or skipped), update the tracking doc:
- Change status from `[ ]` to `[x]` for migrated files
- Add notes for skipped files

## Step 4: Commit

After each batch, commit with message like:
```
migrate team-cream tests: [category] batch N
```

## Guidelines

- Work in batches of 3-5 files per session to keep quality high
- Always run tests after migration to verify they pass
- If a test is too complex to migrate cleanly, mark it as skipped with a reason
- Prefer deleting tests that only test implementation details over keeping bad tests
