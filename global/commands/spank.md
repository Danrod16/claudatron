# /spank — Teach Claude a lesson he won't forget

When invoked, capture a lesson from this session. The user just caught you doing something wrong (or worth keeping) and is spanking you so you remember. Turn it into a rule. If the user didn't specify what the lesson is, infer it from recent conversation context or ask.

## Process

1. State the lesson in 2-3 lines. The rule, not the story behind it.

2. Decide scope:
   - Project-specific (default): a convention, gotcha, or pattern unique to this codebase.
   - Global: applies to how Daniel works across all projects. Only choose this if the lesson has nothing to do with the current project's specifics.

3. Write it:
   - Project-specific: Create a short markdown file in the project's memory directory (the auto-memory path shown in your system prompt). Update MEMORY.md index with a one-line summary.
   - Global: Append to ~/.claude/CLAUDE.md under a "## Learned" section at the bottom. Create the section if it doesn't exist. Keep entries on one line each.

4. Confirm what was written and where.

Keep entries terse. "Don't use X, use Y instead" is the right density. No front-matter, no metadata, no timestamps.
