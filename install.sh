#!/bin/bash
set -euo pipefail

# Claudatron — Global Config Installer
# Installs commands, templates, and optionally CLAUDE.md to ~/.claude/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "Claudatron — Installing global Claude Code config"
echo ""

# Check claude is installed
if ! command -v claude &>/dev/null; then
  echo "Error: Claude CLI not found. Install it first: https://docs.claude.com"
  exit 1
fi

# Create directories
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/templates

# Copy commands
for cmd in "$SCRIPT_DIR/global/commands/"*.md; do
  filename=$(basename "$cmd")
  cp "$cmd" ~/.claude/commands/"$filename"
  echo -e "  ${GREEN}+${NC} ~/.claude/commands/$filename"
done

# Copy templates
for tmpl in "$SCRIPT_DIR/global/templates/"*; do
  filename=$(basename "$tmpl")
  cp "$tmpl" ~/.claude/templates/"$filename"
  echo -e "  ${GREEN}+${NC} ~/.claude/templates/$filename"
done

# Handle CLAUDE.md carefully
if [ -f ~/.claude/CLAUDE.md ]; then
  echo ""
  echo -e "  ${YELLOW}~/.claude/CLAUDE.md already exists. Skipping.${NC}"
  echo -e "  ${YELLOW}Compare with global/CLAUDE.md.example and merge manually if needed.${NC}"
else
  cp "$SCRIPT_DIR/global/CLAUDE.md.example" ~/.claude/CLAUDE.md
  echo -e "  ${GREEN}+${NC} ~/.claude/CLAUDE.md (from example — edit to personalize)"
fi

echo ""
echo "Done. Available commands:"
echo "  /audit      — Structured discovery before implementation"
echo "  /architect  — Plan, assess risk, coordinate implementation"
echo "  /backend    — Backend implementation (Rails conventions)"
echo "  /frontend   — Frontend implementation (Hotwire/Tailwind)"
echo "  /tests      — Write and run tests"
echo "  /lesson     — Capture a lesson learned"
echo ""
echo "Next: edit ~/.claude/CLAUDE.md to match your preferences and stack."
echo ""
