# Claudatron

A lean Claude Code setup for solo founders who want discovery-first workflows, step-by-step architect control, and a self-improving feedback loop. Two layers: global config for every session, and an optional swarm template for multi-agent Rails development.

## What's inside

### Global config (`global/`)

User-level configuration that loads into every Claude Code session.

**CLAUDE.md** sets your baseline: writing preferences, token discipline, code principles, stack context. Under 40 lines, roughly 800 tokens per session.

**Six slash commands:**

| Command | What it does | Tokens |
|---------|-------------|--------|
| `/audit` | Structured discovery before implementation. Reads code, assesses risk, produces a plan. | ~250 |
| `/architect` | Full planning workflow. Clarifies requirements, breaks tasks into steps, assigns risk levels. Writes no code. | ~350 |
| `/backend` | Backend implementation with Rails conventions. Thin controllers, service objects, N+1 awareness. | ~400 |
| `/frontend` | Frontend implementation. Hotwire-first, DaisyUI/Tailwind, no inline variable assignments in views. | ~350 |
| `/tests` | Write and run tests. Matches existing test patterns, runs the suite, reports results. | ~300 |
| `/lesson` | Capture a lesson learned. Writes to project memory or global CLAUDE.md depending on scope. | ~200 |

Commands load only when invoked. Zero cost when unused.

**Project template** (`templates/CLAUDE.md.template`): a 15-line starting point for any new project's CLAUDE.md.

### Architect workflow

The commands are designed to work as a step-by-step workflow you control:

```
/architect add webhook handling for subscription cancellations
  -> Claude reads code, assesses risk, produces a numbered plan
  -> You approve

"start with step 1"
  -> /backend implements the webhook controller + service
  -> Reports what changed, asks to continue

"now tests"
  -> /tests writes specs, runs them, reports results
```

You stay in one conversation. You approve each step. No background agents running unsupervised.

### Swarm template (`swarm/`)

Optional. For projects where you want full multi-agent orchestration via [claude-swarm](https://github.com/paladinsec/claude-swarm).

Scaffolds four specialized agents into a Rails project:

| Agent | Role |
|-------|------|
| **Architect** | Plans, scopes risk, coordinates. Entry point for all tasks. |
| **Backend** | Models, services, controllers, jobs, Pundit, Pay gem, Devise. |
| **Frontend** | Views, Tailwind CSS 4, DaisyUI 5, Turbo, Stimulus, Lucide icons. |
| **Tests** | RSpec, FactoryBot, Playwright, policy specs. |

The swarm agents include deep Lightning Rails conventions. The global commands are stack-agnostic and adapt to whatever project they're in.

## Install

### Global config (everyone)

```bash
git clone https://github.com/Danrod16/claudatron.git
cd claudatron
./install.sh
```

This copies commands and templates to `~/.claude/`. If no `~/.claude/CLAUDE.md` exists, it creates one from the example. If one exists, it skips it.

After installing, edit `~/.claude/CLAUDE.md` to match your preferences and stack.

### Swarm template (Rails projects, optional)

```bash
cd claudatron
./swarm/install.sh /path/to/your/rails/project
```

Requires: [claude-swarm](https://github.com/paladinsec/claude-swarm) gem. Optional: [rails-mcp-server](https://github.com/nicholasgriffintn/rails-mcp-server) gem.

## The feedback loop

Claudatron includes a self-improvement mechanism via `/lesson`.

**During a session:** You notice something Claude does wrong. Type `/lesson`. Claude writes a 2-3 line rule to the project's memory directory (or global CLAUDE.md for universal lessons). Next session, Claude reads it automatically.

**Weekly (5 min):** Scan your active projects' memory files. Prune stale entries. If a lesson shows up in multiple projects, promote it to global.

Three stages: **Noted** (written via /lesson) -> **Applied** (auto-loaded next session) -> **Permanent** (promoted to global CLAUDE.md).

## Token budget

| Component | Tokens | When |
|-----------|--------|------|
| Global CLAUDE.md | ~800 | Every session |
| Project CLAUDE.md | ~400 | Every session in that project |
| Each command | 200-400 | On invocation only |

Total baseline: roughly 1,200 tokens before your first message. Commands add to context only when you use them.

## Design principles

**Lean.** Every line pays rent. No kitchen-sink maximalism.

**Layered.** Global rules at `~/.claude/CLAUDE.md`, project rules at `./CLAUDE.md`, no duplication. Global commands work everywhere. Swarm templates add project-specific depth.

**Discovery-first.** Audit before architecture. Architecture before implementation. Implementation before polish.

**Token-conscious.** Grep over full reads. Structure before content. Haiku for grunt work.

## License

MIT
