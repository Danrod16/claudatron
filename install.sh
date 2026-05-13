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

# Copy templates (recursive, so subdirs like cc/ come along)
for tmpl in "$SCRIPT_DIR/global/templates/"*; do
  filename=$(basename "$tmpl")
  cp -R "$tmpl" ~/.claude/templates/"$filename"
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

# Optional: install cc-init helper for scaffolding .cc/ into projects
echo ""
read -r -p "Install cc-init helper to ~/.local/bin? [y/N] " reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
  mkdir -p ~/.local/bin
  cat > ~/.local/bin/cc-init <<'CCINIT'
#!/bin/bash
set -euo pipefail
SRC="$HOME/.claude/templates/cc"
DEST="./.cc"
if [ ! -d "$SRC" ]; then
  echo "cc-init: $SRC missing. Reinstall Claudatron." >&2
  exit 1
fi
mkdir -p "$DEST"
for t in "$SRC"/*.template; do
  name=$(basename "$t" .template)
  if [ -e "$DEST/$name" ]; then
    echo "  skip $DEST/$name (exists)"
  else
    cp "$t" "$DEST/$name"
    echo "  +    $DEST/$name"
  fi
done
echo "Done. Continuity files live in $DEST/"
CCINIT
  chmod +x ~/.local/bin/cc-init
  echo -e "  ${GREEN}+${NC} ~/.local/bin/cc-init"
fi

echo ""
echo "Done. Available commands:"
echo "  /audit       — Structured discovery before implementation"
echo "  /architect   — Plan, assess risk, coordinate implementation"
echo "  /backend     — Backend implementation (Rails conventions)"
echo "  /frontend    — Frontend implementation (Hotwire/Tailwind)"
echo "  /tests       — Write and run tests"
echo "  /spank       — Teach Claude a lesson he won't forget"
echo "  /resume      — Session opener (reads .cc/ + git)"
echo "  /checkpoint  — Session closer (writes .cc/session.md)"
echo "  /roadmap     — View / edit .cc/roadmap.md"
echo ""
echo "Next: edit ~/.claude/CLAUDE.md to match your preferences and stack."
echo "      In a project, run cc-init to scaffold .cc/ (if you installed the helper)."
echo ""
