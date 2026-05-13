# /resume — Session opener

Run this at the start of a session to rebuild context fast. Read first, then summarize. Do not write anything.

## Process

1. Check for `.cc/`. If it exists, read `.cc/session.md` and `.cc/state.md`. Read `.cc/roadmap.md` only if the session file points at it. Skip files that don't exist.

2. Git context: run `git log -10 --oneline`, `git status -sb`, and list the 5 most recently modified tracked files (`git ls-files -m -o --exclude-standard | head -5`, or `ls -t` over the repo if that's empty).

3. If `.cc/` is missing entirely, fall back to git only and at the end of your summary tell the user: "No .cc/ found. Run `cc-init` to scaffold it."

4. Output a 5-line summary, one bullet per line, in this exact order:
   - Where I left off
   - Immediate next action
   - Any blockers
   - Files to reopen
   - Risk / notes

5. Stop. Do not start working on the next action. Wait for the user to direct the session.

## Rules
- Read-only. /resume never edits `.cc/`, never commits, never runs `/checkpoint` for the user.
- Don't invent state. If `.cc/session.md` is empty or stale (older than the latest commit), say so in the summary rather than fabricating context from git alone.
- If a `swarm.yml` exists, mention it in the risk line so the user knows orchestration is owned by swarm. Don't try to coordinate with swarm agents from here.
- Keep the summary to 5 lines. Do not expand into a full status report.
