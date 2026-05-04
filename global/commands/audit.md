# /audit — Structured discovery before implementation

Run this before starting any non-trivial task. Output is a written assessment only. Do not write code.

## Steps

1. Structure: Glob key directories. Identify framework, language, major patterns. Note the presence or absence of CLAUDE.md, README, tests, CI config.

2. Relevant code: For the specific task, use grep to find entry points and related files. Read only what's directly relevant. Do not dump entire files when a targeted read will do.

3. Conventions: Note existing patterns (naming, file organization, test style, error handling). Check for linters, formatters, or style configs. If a CLAUDE.md exists, read it and follow it.

4. Dependencies: Check Gemfile, package.json, or equivalent. Flag anything outdated, duplicated, or surprising.

5. Risks: What could break? Shared state, database migrations, external API calls, background jobs, caching layers. Name the blast radius.

6. Report: Present findings as a short written assessment (10-20 lines). End with a proposed approach and explicit risks. Ask for approval before proceeding.

Do not skip steps. Do not start implementing during the audit.
