# DeepSeek V4 Flash Free — opencode Best Practices

> **Reference:** [opencode docs](https://opencode.ai/docs) | [Config schema](https://opencode.ai/config.json) | [DeepSeek](https://chat.deepseek.ai/)

## Quick Start (for new users)

This project runs opencode in Docker with the web interface at `http://localhost:PORT`.

- **First run:** Use `/init` to generate an `AGENTS.md` — opencode analyzes your project structure, frameworks, and patterns, then writes a conventions file so future sessions know your code style, testing approach, naming conventions, and file organization
- **Undo:** Run `/undo` to revert the last change. Run it multiple times to undo further back. Use `/redo` to restore. All changes are tracked via git-style snapshots within the session.

## Sample opencode.json

Reference: [Config docs](https://opencode.ai/docs/config/) | [Permissions](https://opencode.ai/docs/permissions/)

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "opencode/deepseek-v4-flash-free",
  "permission": {
    "edit": "ask",       // prompts you before modifying files
    "bash": "ask",       // prompts you before running shell commands
  }
}
```

Permission values: `"allow"` (runs automatically), `"ask"` (prompts for approval), `"deny"` (disabled entirely). You can also use glob patterns for fine-grained control — e.g. `"grep *": "allow"`, `"git push": "ask"`.

## Tools (Built-in)

Reference: [Tools docs](https://opencode.ai/docs/tools/)

Tools are functions the LLM can call to interact with your codebase — they're how opencode reads files, searches code, runs commands, and makes changes. Each tool has a specific purpose:

- **`read`** — Read files. Prefer this over `bash cat` (structured output, line numbers).
- **`grep`** — Search file contents by regex. Faster and more targeted than `bash grep`.
- **`glob`** — Find files by pattern (e.g., `**/*.tsx`). Use instead of `bash find`.
- **`edit`** — Modify existing files via exact string replacement. Preferred for small changes.
- **`write`** — Create new files or overwrite existing ones.
- **`bash`** — Run arbitrary shell commands (git, npm, docker, etc.).
- **`skill`** — Load reusable instructions from a `SKILL.md` file.
- **`task`** — Delegate work to a subagent for parallel execution.
- **`webfetch`** / **`websearch`** — Fetch URLs or search the web (docs lookups, research).
- **`question`** — The agent asks you for clarification when instructions are ambiguous.

## Custom Tools & MCP Servers

Reference: [Custom Tools](https://opencode.ai/docs/custom-tools/) | [MCP Servers](https://opencode.ai/docs/mcp-servers/)

- **Custom tools**: Place TypeScript files in `.opencode/tools/`. The filename becomes the tool name. Can invoke scripts in any language (Python, shell, etc.).
- **MCP** (**Model Context Protocol**) — an open standard for connecting LLMs to external tools and services. Configure MCP servers in `opencode.json` to give opencode access to databases, APIs, file systems, etc.

```jsonc
// Example MCP server for a database
{
  "mcp": {
    "my-db": {
      "type": "stdio",
      "command": "node",
      "args": ["path/to/mcp-server.js"]
    }
  }
}
```

## Subagents

Reference: [Agents docs](https://opencode.ai/docs/agents/)

Invoke with `@name` in your prompt. Subagents run in separate sessions and can work in parallel:

- **`@explore`** — Fast, read-only codebase explorer. *Use case:* "Find all places where the auth middleware is applied" — returns file paths and line numbers, no file changes.
- **`@general`** — Full subagent with all tools. *Use case:* "Refactor these three files in parallel" — fires multiple independent agents simultaneously, each handling one file.
- **`@scout`** — Read-only dependency researcher. Clones repos into a managed cache, inspects library source.

**Example — refactoring with parallel subagents:**
> "Extract the validation logic from controllers into a shared middleware.
> @general handle /users, @general handle /orders, @general handle /products"

Create custom subagents via `.opencode/agents/` (markdown files) or in `opencode.json`:

```jsonc
{
  "agent": {
    "review": {
      "description": "Reviews code without making changes",
      "mode": "subagent",
      "permission": { "edit": "deny" },
      "model": "opencode/deepseek-v4-flash-free"
    }
  }
}
```

## Skills

Reference: [Skills docs](https://opencode.ai/docs/skills/)

Skills are reusable instruction files placed in `.opencode/skills/<name>/SKILL.md`. The agent sees them in the `skill` tool description and loads them on-demand when a task matches.

```yaml
---
name: git-release
description: Create consistent releases and changelogs
---

Instructions for creating releases...
```

## Permissions

Reference: [Permissions docs](https://opencode.ai/docs/permissions/)

Control tool access globally or per-agent:
- `"allow"` — runs without asking
- `"ask"` — prompts for approval
- `"deny"` — disabled entirely

Permissions support glob patterns for fine-grained control over specific tools or commands.

## AGENTS.md

After running `/init`, opencode generates an `AGENTS.md` in your project root. This file captures your project's conventions and is read at the start of every session so the agent understands:
- Code style and naming conventions
- Framework and library choices
- Testing approach and commands
- File organization and patterns
- Any project-specific rules

Keep it committed to git — it's the single source of truth for how the agent should behave in your project.

## Prompting Tips (for DeepSeek)

- **Skip pleasantries.** Every "please", "thanks", or "could you" consumes tokens and context window space. DeepSeek responds best to direct, imperative commands: *"Refactor this function"* not *"Could you please help me by refactoring this function?"*
- Reference files with `@filename` for fuzzy search.
- Use Plan mode first for complex multi-step tasks, then review before building.
- Attach images via drag-and-drop for UI/design context.
- Use `/undo` to roll back changes and refine prompts.
- Be specific about what you want — state the file, the change, and the expected outcome.

## Paid Upgrade: DeepSeek V4 Pro

DeepSeek V4 Flash Free is a free tier with limited rate and capabilities. For production work, upgrade to **DeepSeek V4 Pro**:

- **Provider:** DeepSeek (not opencode) — requires an API key from [platform.deepseek.com](https://platform.deepseek.com/)
- **Setup:** Run `/connect`, select DeepSeek, enter your API key, then run `/models` and pick *DeepSeek V4 Pro*
- **Better:** Higher rate limits, larger context, stronger reasoning and tool calling
- **Cost:** Usage-based billing through DeepSeek

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "deepseek/deepseek-v4-pro",
  "permission": {
    "edit": "ask",
    "bash": "ask"
  }
}
```
