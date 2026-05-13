# /checkpoint — Session closer

Run this at the end of a session to persist state for the next one. Updates `.cc/` files based on what actually happened in the conversation.

## Process

1. Verify `.cc/` exists. If not, tell the user to run `cc-init` first and stop. Do not create `.cc/` yourself.

2. Gather: current branch (`git rev-parse --abbrev-ref HEAD`), latest commit summary (`git log -1 --oneline`), and a recap from the conversation of what was shipped, what's in progress, and any blockers. Do not infer beyond what was discussed.

3. Rewrite `.cc/session.md` with these sections, in this order:
   - Branch
   - Last commit
   - Shipped this session
   - In progress
   - Next 3 actions
   - Blockers

4. Refresh `.cc/state.md` only if the current snapshot has changed: what's live, what's in flight, environment notes. Leave it alone if nothing material moved.

5. Ask the user: "Did you make an architectural decision this session?" If yes, append a dated entry to `.cc/decisions.md` in the existing ADR-lite format (date, decision, why, alternatives considered). If no, skip.

6. Report which files you touched. One line each. Do not diff.

## Rules
- Never invent items for "Next 3 actions" or "Blockers". Only what was discussed.
- Never edit `.cc/roadmap.md` from /checkpoint. Roadmap is owned by /roadmap.
- Never touch `~/.claude/CLAUDE.md`. Global rules belong to /spank.
- If `swarm.yml` exists, do not write to any swarm-managed file. `.cc/` is yours; swarm config is not.
- Keep entries terse. Bullet lists, not paragraphs.
