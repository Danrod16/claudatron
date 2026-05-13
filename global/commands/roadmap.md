# /roadmap — Now / next / later view and edit

Read or update `.cc/roadmap.md`. Source of truth for what's on deck for this project.

## Process

1. Check for `.cc/roadmap.md`. If missing, tell the user to run `cc-init` and stop. Do not create it yourself.

2. Read the file and print the three sections (Now, Next, Later) as they are. Do not reformat or reorder.

3. If the user asked to add, move, or close items, apply only those changes:
   - Add: append to the named section.
   - Move: cut from one section, paste to another.
   - Close: remove the line (or strike through if the file uses that convention already).

4. Save the file. Report which section(s) changed and the exact lines that moved.

## Rules
- Never invent items. Only add what the user explicitly mentioned in this conversation.
- Never silently reorder existing items.
- Never promote items between sections without being asked. "Now" stays "Now" unless the user says otherwise.
- Keep each item to one line. If the user gives a paragraph, ask for a one-line version.
- View-only by default. If the user just typed `/roadmap` with no instruction, print and stop.
