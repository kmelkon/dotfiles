# Core Prompt Engineering Guidelines

Reference document for prompt refinement based on Anthropic's best practices.

## 1. Be Clear and Direct

**Bad:** "Can you help with some data?"
**Good:** "Analyze this CSV of sales data and identify the top 3 products by revenue in Q4 2024."

**Principles:**
- State the task explicitly upfront
- Avoid vague language ("some", "maybe", "kind of")
- Specify what success looks like

## 2. Use Examples (Few-shot prompting)

Provide 2-3 examples of input → desired output.

**Structure:**
```
Here are examples of the task:

Example 1:
Input: [example input]
Output: [example output]

Example 2:
Input: [example input]
Output: [example output]

Now process this:
Input: [actual input]
```

**When to use:**
- Complex formatting requirements
- Specific style/tone needed
- Ambiguous tasks

## 3. Structure with XML Tags

Use XML tags to separate different parts of the prompt clearly.

**Common tags:**
- `<task>` - what to do
- `<context>` - background information
- `<instructions>` - step-by-step guidance
- `<examples>` - sample inputs/outputs
- `<input>` - the data to process
- `<output_format>` - how to structure the response
- `<constraints>` - limitations or requirements

**Example:**
```xml
<task>
Summarize customer feedback
</task>

<context>
We're analyzing feedback from our mobile app beta launch.
</context>

<instructions>
1. Identify main themes
2. Count positive vs negative mentions
3. Extract specific feature requests
</instructions>

<input>
[feedback data here]
</input>

<output_format>
- Summary: [brief overview]
- Themes: [bullet list]
- Sentiment: [X positive, Y negative]
- Feature requests: [numbered list]
</output_format>
```

## 4. Specify Output Format

Tell Claude exactly how to structure the response.

**Examples:**
- "Respond with a JSON object containing keys: title, summary, tags"
- "Provide a markdown table with columns: Name, Status, Priority"
- "List items as bullet points, each 1-2 sentences"
- "Output valid Python code with no explanation"

## 5. Use Chain-of-Thought for Reasoning

For complex tasks, ask Claude to think step-by-step.

**Patterns:**
- "Before answering, think through this step-by-step"
- "Show your reasoning process before the final answer"
- "Let's approach this systematically:"

**When to use:**
- Math/logic problems
- Multi-step analysis
- Decision-making tasks
- Debugging

## 6. Provide Context

Give Claude relevant background information.

**What to include:**
- Purpose of the task
- Audience for the output
- Domain-specific knowledge
- Constraints or requirements

**Example:**
```
Context: I'm building a REST API for a fintech startup.
We need to handle sensitive financial data and comply with PCI DSS.

Task: Review this code for security vulnerabilities...
```

## 7. Set Constraints and Guardrails

Explicitly state what Claude should or shouldn't do.

**Examples:**
- "Keep responses under 100 words"
- "Don't include any personal opinions"
- "If you're unsure about something, say so rather than guessing"
- "Use only Python standard library, no external packages"

## 8. Use Role Prompting (when helpful)

Assign Claude a specific role/persona for better results.

**Examples:**
- "You are an experienced DevOps engineer..."
- "Act as a technical writer creating documentation..."
- "You're a code reviewer focusing on performance..."

**When to use:**
- Domain expertise needed
- Specific perspective required
- Consistent tone across interactions

## 9. Handle Long Context

For large inputs (documents, codebases):

**Strategies:**
- Use XML tags to separate large sections
- Ask for summaries before detailed analysis
- Break into smaller sub-tasks
- Reference specific sections: "In the <section1> above..."

## 10. Prefill Responses

Start Claude's response for precise control.

**Example in API:**
```
User: Analyze this code for bugs.
Assistant: Here are the bugs I found:
1.
```

This forces a specific format. (Note: In Claude Code chat, prefilling happens naturally through conversation context)

## Quick Reference Table

| Technique | Use When | Example Marker |
|-----------|----------|----------------|
| Examples | Format/style unclear | "Here are examples:" |
| XML tags | Complex multi-part prompt | `<task>`, `<context>` |
| Chain-of-thought | Reasoning needed | "Think step-by-step" |
| Output format | Specific structure needed | "Respond with JSON:" |
| Constraints | Boundaries important | "Must not exceed..." |
| Role prompting | Domain expertise | "You are an expert..." |

## Common Mistakes to Avoid

- **Too vague:** "Make it better"
  - **Better:** "Improve error handling and add input validation"

- **Buried task:** Long context before stating what to do
  - **Better:** State goal, then provide context

- **Assuming knowledge:** "Fix the usual issues"
  - **Better:** "Check for: SQL injection, XSS, CSRF"

- **No examples:** Complex format described in words
  - **Better:** 2-3 concrete input/output pairs

- **Missing format:** "Summarize this"
  - **Better:** "Summarize in 3 bullet points, max 50 words each"
