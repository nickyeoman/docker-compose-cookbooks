# Qwen3 8B 16k — opencode Best Practices

> **Reference:** [opencode Ollama docs](https://opencode.ai/docs/providers/#ollama) | [Ollama](https://ollama.com/) | [Qwen3](https://qwen.readthedocs.io/)

## Quick Start (for new users)

This project runs opencode in Docker with the web interface at `http://localhost:PORT`.

- **Prerequisites:** Install [Ollama](https://ollama.com/download) and pull the model: `ollama pull qwen3:8b-16k` — ensure Ollama is running (`ollama serve`)
- **First run:** Use `/init` to generate an `AGENTS.md` — opencode analyzes your project structure, frameworks, and patterns, then writes a conventions file so future sessions know your code style, testing approach, naming conventions, and file organization
- **Undo:** Run `/undo` to revert the last change. Run it multiple times to undo further back. Use `/redo` to restore. All changes are tracked via git-style snapshots within the session.

## Provider Configuration

Reference: [Ollama provider docs](https://opencode.ai/docs/providers/#ollama)

Ollama exposes an OpenAI-compatible API at `http://localhost:11434/v1`. Configure it in your `opencode.json`:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "qwen3:8b-16k": {
          "name": "Qwen3 8B 16k",
          "limit": {
            "context": 16384,
            "output": 4096
          }
        }
      }
    }
  },
  "model": "ollama/qwen3:8b-16k",
  "permission": {
    "edit": "ask",
    "bash": "ask"
  }
}
```

Permission values: `"allow"` (runs automatically), `"ask"` (prompts for approval), `"deny"` (disabled entirely). You can also use glob patterns for fine-grained control — e.g. `"grep *": "allow"`, `"git push": "ask"`.

## Sample opencode.json

Reference: [Config docs](https://opencode.ai/docs/config/) | [Permissions](https://opencode.ai/docs/permissions/)

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "ollama/qwen3:8b-16k",
  "permission": {
    "edit": "ask",
    "bash": "ask"
  }
}
```

## Local Model Considerations

Qwen3 8B runs locally on your machine, which comes with trade-offs compared to a cloud API:

- **Hardware:** ~8GB+ VRAM recommended. Runs on CPU via quantized variants (Q4/Q8) but slower
- **Performance:** Expect 10-40 tokens/second depending on your hardware and quantization
- **Context window:** 16k tokens — be concise in prompts and avoid dumping entire files
- **num_ctx:** If tool calls fail or the model seems confused, try increasing context: `ollama run qwen3:8b-16k --num-ctx 32768`
- **Tool calling:** Qwen3 has solid tool-calling support for a model its size, but may miss complex multi-tool workflows that larger models handle easily
- **No API key needed:** Everything runs locally — no data leaves your machine

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
      "model": "ollama/qwen3:8b-16k"
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

## Prompting Tips (for Qwen3 8B)

- **Context is precious at 16k.** Every token counts. Skip pleasantries — every "please", "thanks", or "could you" consumes space that could hold code or instructions. Prefer direct commands: *"Refactor this function"* not *"Could you please help me by refactoring this function?"*
- **Break complex tasks into smaller, single-responsibility steps** — the model handles focused prompts better than sprawling ones
- **Use Plan mode first** for multi-file changes, review the plan, then build
- **If the model loses track**, use `/undo` and rephrase more specifically with fewer instructions per message
- **Reference files with `@filename`** for fuzzy search
- **Avoid dumping entire large files** — use `read` with line ranges or grep for relevant sections
- **Prefer `edit` over `write`** for changes to existing files — smaller diffs are easier for the model to reason about
- **If tool calls fail**, increase Ollama's context window: `ollama run qwen3:8b-16k --num-ctx 32768`
