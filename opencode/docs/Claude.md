# Claude (Anthropic) — opencode Best Practices

> **⚠️ Paid service.** Claude requires an Anthropic API key (usage-based billing) or a Claude Pro/Max subscription. You are charged per token by Anthropic.
>
> **Reference:** [Anthropic provider docs](https://opencode.ai/docs/providers/#anthropic) | [Anthropic](https://anthropic.com) | [Pricing](https://www.anthropic.com/pricing)

## Quick Start (for new users)

This project runs opencode in Docker with the web interface at `http://localhost:PORT`.

- **Prerequisites:** An [Anthropic account](https://console.anthropic.com/) with billing enabled and an API key, or a Claude Pro/Max subscription
- **Cost:** Claude is usage-based. Rates vary by model — Sonnet is more affordable, Opus is premium. Set spending limits in the Anthropic console.
- **First run:** Use `/init` to generate an `AGENTS.md` — opencode analyzes your project structure, frameworks, and patterns, then writes a conventions file so future sessions know your code style, testing approach, naming conventions, and file organization
- **Undo:** Run `/undo` to revert the last change. Run it multiple times to undo further back. Use `/redo` to restore. All changes are tracked via git-style snapshots within the session.

## Provider Configuration

> **There is no `opencode.json` config needed** for the built-in Anthropic provider. Just run `/connect` and select Anthropic, then authenticate.

The `anthropic` provider is built into opencode. After authenticating via `/connect`, all Claude models appear in the model picker.

Authentication options:
1. **Claude Pro/Max** — opens your browser to authorize with your Anthropic account (OpenCode uses your subscription tokens)
2. **API key** — paste a key from [console.anthropic.com](https://console.anthropic.com/settings/keys)

```jsonc
// Optional: explicitly set the model or configure thinking budget
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-5-20250929",
  "permission": {
    "edit": "ask",
    "bash": "ask"
  }
}
```

Permission values: `"allow"` (runs automatically), `"ask"` (prompts for approval), `"deny"` (disabled entirely). You can also use glob patterns for fine-grained control — e.g. `"grep *": "allow"`, `"git push": "ask"`.

## Model Tiers

Reference: [Anthropic models](https://docs.anthropic.com/en/docs/about-claude/models)

| Model | Best for | Cost |
|---|---|---|
| **Claude Sonnet 4.5** | General development — best balance of speed, quality, and cost | Moderate |
| **Claude Opus 4.5** | Complex reasoning, large refactors, architecture decisions | Highest |
| **Claude Haiku 4.5** | Quick tasks, planning, exploration | Lowest |

## Thinking / Reasoning

Claude supports extended thinking for complex tasks. Configure via model options:

```jsonc
{
  "provider": {
    "anthropic": {
      "models": {
        "claude-sonnet-4-5-20250929": {
          "options": {
            "thinking": {
              "type": "enabled",
              "budgetTokens": 16000
            }
          }
        }
      }
    }
  }
}
```

Built-in thinking variants: `high` (default), `max` (maximum budget). Cycle between them with the variant keybind.

## Capabilities

- **200k token context window** — can handle very large files and long conversations
- **Excellent tool-calling** — rarely misses complex multi-tool workflows
- **Code quality** — among the best for code generation and refactoring
- **Slower than smaller models** for simple tasks due to reasoning overhead

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

- **Custom tools:** Place TypeScript files in `.opencode/tools/`. The filename becomes the tool name. Can invoke scripts in any language (Python, shell, etc.).
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
      "model": "anthropic/claude-sonnet-4-5-20250929"
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

## Prompting Tips (for Claude)

- **Skip pleasantries.** Every "please", "thanks", or "could you" consumes tokens and adds cost. Claude responds best to direct, imperative commands: *"Refactor this function"* not *"Could you please help me by refactoring this function?"*
- **Use thinking variants** when you need deeper reasoning — complex refactors, architecture decisions, debugging
- **Use Haiku or default** for quick tasks — grep searches, minor edits, exploration. No need to pay Opus rates for simple work.
- **200k context** means you can reference large files, but prefer targeted reads with line ranges
- **If Claude gets stuck**, `/undo` and add more context or break the task into smaller steps
- **Reference files with `@filename`** for fuzzy search
- **Use Plan mode first** for multi-file changes, review the plan, then build
- **Attach images** via drag-and-drop for UI/design context
- **Set spending limits** in the Anthropic console to avoid surprise bills
