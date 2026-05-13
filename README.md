# Claudatron

A lean Claude Code setup for solo founders who want discovery-first workflows, step-by-step architect control, and a self-improving feedback loop.

Claudatron lives in two places at once:

- **Globally** at `~/.claude/` on your computer. The CLAUDE.md baseline and all slash commands load into every Claude Code session, in every project, automatically.
- **Per project** via an optional `./CLAUDE.md` (stack and conventions specific to that repo) and an optional `.cc/` folder (continuity state between sessions). Both layered on top of the global config.

Two extras stack on top: a continuity layer for cross-session memory, and an optional swarm template for multi-agent Rails development.

## What's inside

### Global config (`global/`)

User-level configuration that loads into every Claude Code session.

**CLAUDE.md** sets your baseline: writing preferences, token discipline, code principles, stack context. Under 40 lines, roughly 800 tokens per session.

**Nine slash commands:**

| Command | What it does | Tokens |
|---------|-------------|--------|
| `/audit` | Structured discovery before implementation. Reads code, assesses risk, produces a plan. | ~250 |
| `/architect` | Full planning workflow. Clarifies requirements, breaks tasks into steps, assigns risk levels. Writes no code. | ~350 |
| `/backend` | Backend implementation with Rails conventions. Thin controllers, service objects, N+1 awareness. | ~400 |
| `/frontend` | Frontend implementation. Hotwire-first, DaisyUI/Tailwind, no inline variable assignments in views. | ~350 |
| `/tests` | Write and run tests. Matches existing test patterns, runs the suite, reports results. | ~300 |
| `/spank` | Teach Claude a lesson he won't forget. Writes the rule to project memory or global CLAUDE.md depending on scope. | ~200 |
| `/resume` | Session opener. Reads `.cc/` plus recent git activity, returns a 5-line summary. | ~300 |
| `/checkpoint` | Session closer. Updates `.cc/session.md` and `.cc/state.md`, optionally appends a decision. | ~300 |
| `/roadmap` | View or edit `.cc/roadmap.md` (now / next / later). Never invents items. | ~250 |

Commands load only when invoked. Zero cost when unused.

**Example prompts:**

```
/resume
  -> "On branch payments-webhooks. Last session shipped the Stripe signature
      verifier. Next: handle subscription.deleted. Blocker: missing test fixture."

/audit how is Pundit wired across the admin controllers?
  -> reads policies, controllers, base classes; reports the pattern, gaps,
     and any inconsistencies before you touch anything.

/architect add a referral program with single-use codes and a 10% lifetime discount
  -> clarifies questions, lists affected models/services, breaks the work into
     numbered steps with risk levels. No code written.

/backend implement step 1 of the plan: the ReferralCode model + generator service
  -> writes the model, service, migration; flags Pundit/Sidekiq touchpoints;
     asks before moving to step 2.

/frontend build the referral dashboard card on the billing page
  -> matches existing DaisyUI patterns; no inline assignments in the view;
     responsive across mobile/tablet/desktop.

/tests cover ReferralCode.generate! and the dashboard card
  -> writes specs that match existing patterns, runs the suite, reports pass/fail.

/spank Pundit policies for admin namespace must inherit from AdminPolicy, not ApplicationPolicy
  -> writes a 2-3 line rule to project memory so next session knows. Claude won't make that mistake twice.

/roadmap move "referral analytics" from later to next
  -> edits .cc/roadmap.md in place. Refuses to invent items you didn't mention.

/checkpoint
  -> updates .cc/session.md and .cc/state.md with what shipped, what's next,
     and any blockers. Asks before logging a decision to .cc/decisions.md.
```

**Project template** (`templates/CLAUDE.md.template`): a 15-line starting point for any new project's CLAUDE.md.

### Continuity layer

For founders running multiple projects in parallel. Per-project state survives between Claude Code sessions, lives in plain markdown under `.cc/`, and is read by `/resume` at session start and written by `/checkpoint` at session end. Optional. Claudatron still works in projects without a `.cc/` folder, the commands just fall back to git.

| File | Purpose | Owner |
|------|---------|-------|
| `.cc/state.md` | Current snapshot (live / in flight / environment) | `/checkpoint` |
| `.cc/session.md` | Last session summary (branch, shipped, next 3, blockers) | `/checkpoint` |
| `.cc/roadmap.md` | Now / next / later, one line per item | `/roadmap` |
| `.cc/decisions.md` | ADR-lite log, newest entries on top | `/checkpoint` (asks first) |

Scaffold with `cc-init` inside a project (helper installed by `install.sh`).

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

This copies commands and templates to `~/.claude/`. If no `~/.claude/CLAUDE.md` exists, it creates one from the example. If one exists, it skips it. It also asks (y/N) whether to install the `cc-init` helper to `~/.local/bin/` for scaffolding `.cc/` into projects.

After installing, edit `~/.claude/CLAUDE.md` to match your preferences and stack.

### Swarm template (Rails projects, optional)

```bash
cd claudatron
./swarm/install.sh /path/to/your/rails/project
```

Requires: [claude-swarm](https://github.com/paladinsec/claude-swarm) gem. Optional: [rails-mcp-server](https://github.com/nicholasgriffintn/rails-mcp-server) gem.

### Updating

The global layer is shared across every project, so updating is one command:

```bash
cd ~/code/claudatron && git pull && ./install.sh
```

This refreshes `~/.claude/commands/` and `~/.claude/templates/`. Every project picks up the new slash commands on its next session. Nothing to re-run per project.

What `install.sh` leaves alone:

- `~/.claude/CLAUDE.md` (skipped if it exists, so your personal edits stay)
- `.cc/` folders inside projects (those are state, not config)
- Project-level `CLAUDE.md` files

Two cases where you do re-run something per project:

1. **Swarm template changed** and you want the update in a Rails project: re-run `./swarm/install.sh /path/to/project`. This overwrites `claude-swarm.yml` and the `.claude-on-rails/prompts/*.md` files, so commit local tweaks first. `settings.local.json` is skip-if-exists.
2. **New `.cc/` template files** and you want them in an existing project: run `cc-init` inside the project. Skip-if-exists per file, so your continuity state is safe.

### Using Claudatron with a non-Rails stack

Claudatron as a whole is stack-agnostic. The global CLAUDE.md is a baseline you edit to match your own stack. The nine slash commands adapt to whatever project they run in. The continuity layer (`.cc/`) is plain markdown; no stack assumptions.

Only two pieces ship with Rails-specific conventions out of the box:

1. **`global/CLAUDE.md`** — my personal stack notes (Rails, Mongo, Sidekiq, DaisyUI). After running `install.sh`, open `~/.claude/CLAUDE.md` and replace the "My stack" section with yours. The rest of the file (writing style, token discipline, code principles) is stack-neutral and worth keeping.

2. **`swarm/` prompts** — the four agent prompts in `swarm/prompts/` are Lightning Rails. If you want the swarm in a non-Rails project, ask Claude to rewrite them. Setup is identical: run `./swarm/install.sh /path/to/your/project`, then paste the prompt below.

The global slash commands (`/audit`, `/architect`, `/backend`, `/frontend`, `/tests`, etc.) read the project's own CLAUDE.md and existing code patterns at runtime. They don't need rewriting per stack. Drop a project CLAUDE.md that describes your stack and they adapt.

To retarget the swarm prompts, paste this into Claude inside your target project, swapping the placeholders:

```
Rewrite the four prompt files in .claude-on-rails/prompts/ (architect.md,
backend.md, frontend.md, tests.md) to match this project's stack.

Replace Rails-specific conventions with conventions for:
- Language/runtime: {{LANGUAGE}}             # e.g. TypeScript / Node 20
- Backend framework: {{BACKEND}}             # e.g. Next.js App Router, Django, Phoenix, Fastify
- Frontend stack: {{FRONTEND}}               # e.g. React + Tailwind, LiveView, HTMX, Svelte
- ORM / data layer: {{DATA}}                 # e.g. Prisma, Drizzle, SQLAlchemy, Ecto
- Auth: {{AUTH}}                             # e.g. Clerk, NextAuth, Devise, Phoenix.LiveView auth
- Payments: {{PAYMENTS}}                     # e.g. Stripe SDK, Lemon Squeezy, none
- Background jobs: {{JOBS}}                  # e.g. BullMQ, Celery, Oban, none
- Testing: {{TESTING}}                       # e.g. Vitest + Playwright, Pytest, ExUnit

Rules:
1. Keep the section headings and overall structure of each prompt.
2. Replace every Rails-specific example (ActiveRecord, Pundit, Sidekiq, Turbo,
   Stimulus, Devise, Pay gem, Lightning Rails) with the equivalent in my stack.
   If there is no equivalent, drop the section.
3. Keep the "Safety — Stop and Ask Before" list. Rewrite items to reflect
   risky areas in my stack (auth, payments, migrations, destructive changes).
4. Do not invent libraries I did not list. If a section has no real equivalent
   in my stack, remove it rather than guessing.
5. Keep prompts under 120 lines each.

After rewriting, also update claude-swarm.yml: change the `description` field
of each agent to mention my stack, and rename the .claude-on-rails directory
reference if you like (optional).

Show me a diff before writing.
```

You can also rename `.claude-on-rails/` to something stack-appropriate (e.g. `.claude-on-next/`) — just update the four `prompt_file:` paths in `claude-swarm.yml` to match.

## The feedback loop

Claudatron includes a self-improvement mechanism via `/spank`.

**During a session:** You notice something Claude does wrong. Type `/spank`. Claude writes a 2-3 line rule to the project's memory directory (or global CLAUDE.md for universal lessons). Next session, Claude reads it automatically. Same mistake twice earns another spanking.

**Weekly (5 min):** Scan your active projects' memory files. Prune stale entries. If a lesson shows up in multiple projects, promote it to global.

Three stages: **Noted** (written via /spank) -> **Applied** (auto-loaded next session) -> **Permanent** (promoted to global CLAUDE.md).

## Token budget

| Component | Tokens | When |
|-----------|--------|------|
| Global CLAUDE.md | ~800 | Every session |
| Project CLAUDE.md | ~400 | Every session in that project |
| Each command | 200-400 | On invocation only |
| `.cc/` files | 150-300 | When `/resume` reads them, otherwise zero |

Total baseline: roughly 1,200 tokens before your first message. Commands add to context only when you use them.

## Design principles

**Lean.** Every line pays rent. No kitchen-sink maximalism.

**Layered.** Global rules at `~/.claude/CLAUDE.md`, project rules at `./CLAUDE.md`, no duplication. Global commands work everywhere. Swarm templates add project-specific depth.

**Discovery-first.** Audit before architecture. Architecture before implementation. Implementation before polish.

**Token-conscious.** Grep over full reads. Structure before content. Haiku for grunt work.

## License

MIT
