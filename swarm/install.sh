#!/bin/bash
set -euo pipefail

# Claudatron — Swarm Template Installer
# Sets up claude-swarm agents in a Rails project

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Helper: safe template replacement using awk
fill_template() {
  local placeholder="$1"
  local value="$2"
  local infile="$3"
  local outfile="$4"
  awk -v pat="$placeholder" -v rep="$value" '{
    idx = index($0, pat)
    while (idx > 0) {
      $0 = substr($0, 1, idx - 1) rep substr($0, idx + length(pat))
      idx = index($0, pat)
    }
    print
  }' "$infile" > "$outfile"
}

fill_template_inplace() {
  local placeholder="$1"
  local value="$2"
  local file="$3"
  local tmpfile
  tmpfile=$(mktemp)
  fill_template "$placeholder" "$value" "$file" "$tmpfile"
  mv "$tmpfile" "$file"
}

# Check dependencies
MISSING_DEPS=()

if ! command -v claude &>/dev/null; then
  MISSING_DEPS+=("claude (Claude CLI — https://docs.claude.com)")
fi

if ! command -v claude-swarm &>/dev/null && ! gem list claude_swarm --installed &>/dev/null 2>&1; then
  MISSING_DEPS+=("claude-swarm (gem install claude_swarm)")
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
  echo -e "${RED}Missing required dependencies:${NC}"
  for dep in "${MISSING_DEPS[@]}"; do
    echo -e "  ${RED}x${NC} $dep"
  done
  exit 1
fi

if ! command -v rails-mcp-server &>/dev/null && ! gem list rails-mcp-server --installed &>/dev/null 2>&1; then
  echo -e "${YELLOW}Optional: rails-mcp-server not found. Remove mcps section from claude-swarm.yml if not needed.${NC}"
  echo ""
fi

echo -e "${CYAN}Claudatron — Swarm Setup for Rails${NC}"
echo ""

# Target directory
if [ -n "${1:-}" ]; then
  TARGET="$1"
else
  read -rp "Target Rails project path: " TARGET
fi

TARGET=$(realpath "$TARGET")

if [ ! -d "$TARGET" ]; then
  echo -e "${RED}Error: $TARGET does not exist${NC}"
  exit 1
fi

# Project name
DEFAULT_NAME=$(basename "$TARGET")
read -rp "Project name [$DEFAULT_NAME]: " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_NAME}

# Detect Rails/Ruby versions
RAILS_VERSION="8.0"
RUBY_VERSION="3.3"

if [ -f "$TARGET/Gemfile.lock" ]; then
  DETECTED_RAILS=$(grep -A1 '^\s*rails\s' "$TARGET/Gemfile.lock" 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)
  if [ -n "$DETECTED_RAILS" ]; then
    RAILS_VERSION="$DETECTED_RAILS"
    echo -e "${GREEN}Detected Rails $RAILS_VERSION${NC}"
  fi
fi

if [ -f "$TARGET/.ruby-version" ]; then
  DETECTED_RUBY=$(tr -d '[:space:]' < "$TARGET/.ruby-version")
  if [[ "$DETECTED_RUBY" =~ ^[a-zA-Z0-9._-]+$ ]] && [ -n "$DETECTED_RUBY" ]; then
    RUBY_VERSION="$DETECTED_RUBY"
    echo -e "${GREEN}Detected Ruby $RUBY_VERSION${NC}"
  fi
fi

# Project-specific notes
echo ""
echo -e "${YELLOW}Project-specific notes for the agents? (safety warnings, external services, etc.)${NC}"
echo "Press Enter to skip, or type notes (end with an empty line):"
PROJECT_NOTES=""
while IFS= read -r line; do
  [ -z "$line" ] && break
  PROJECT_NOTES="${PROJECT_NOTES}${line}
"
done

if [ -n "$PROJECT_NOTES" ]; then
  PROJECT_NOTES_BLOCK="## Project-Specific Notes

${PROJECT_NOTES}"
else
  PROJECT_NOTES_BLOCK=""
fi

# Copy files
echo ""
echo "Installing swarm files..."

TEMPLATE_DIR="$SCRIPT_DIR/rails"

mkdir -p "$TARGET/.claude-on-rails/prompts"
mkdir -p "$TARGET/.claude"

# claude-swarm.yml
fill_template "{{PROJECT_NAME}}" "$PROJECT_NAME" "$TEMPLATE_DIR/claude-swarm.yml" "$TARGET/claude-swarm.yml"
echo -e "  ${GREEN}+${NC} claude-swarm.yml"

# settings.local.json
if [ ! -f "$TARGET/.claude/settings.local.json" ]; then
  cp "$TEMPLATE_DIR/settings.local.json" "$TARGET/.claude/settings.local.json"
  echo -e "  ${GREEN}+${NC} .claude/settings.local.json"
else
  echo -e "  ${YELLOW}~${NC} .claude/settings.local.json (exists, skipping)"
fi

# context.md
fill_template "{{RAILS_VERSION}}" "$RAILS_VERSION" "$TEMPLATE_DIR/context.md" "$TARGET/.claude-on-rails/context.md"
fill_template_inplace "{{RUBY_VERSION}}" "$RUBY_VERSION" "$TARGET/.claude-on-rails/context.md"
echo -e "  ${GREEN}+${NC} .claude-on-rails/context.md"

# WORKFLOW.md
cp "$TEMPLATE_DIR/WORKFLOW.md" "$TARGET/.claude-on-rails/WORKFLOW.md"
echo -e "  ${GREEN}+${NC} .claude-on-rails/WORKFLOW.md"

# Prompt files
for prompt_file in "$TEMPLATE_DIR/prompts/"*.md; do
  filename=$(basename "$prompt_file")
  fill_template "{{PROJECT_NAME}}" "$PROJECT_NAME" "$prompt_file" "$TARGET/.claude-on-rails/prompts/$filename"
  fill_template_inplace "{{PROJECT_NOTES}}" "$PROJECT_NOTES_BLOCK" "$TARGET/.claude-on-rails/prompts/$filename"
  echo -e "  ${GREEN}+${NC} .claude-on-rails/prompts/$filename"
done

echo ""
echo "Done. Next steps:"
echo "  1. Review claude-swarm.yml and adjust agents/models as needed"
echo "  2. cd $TARGET && claude-swarm"
echo ""
