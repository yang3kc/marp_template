#!/usr/bin/env bash
# init.sh — bootstrap a slides directory for a project from the marp-slides skill
# Usage: bash init.sh <absolute-path-to-target-slides-dir>
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <target-slides-dir>" >&2
  exit 1
fi

# Resolve to absolute path (portable: no GNU realpath -m needed)
case "$1" in
  /*) TARGET="$1" ;;
  *)  TARGET="$(pwd)/$1" ;;
esac

# Refuse if already initialised
if [[ -d "$TARGET/themes" ]]; then
  echo "Error: $TARGET/themes already exists." >&2
  echo "Use sync.sh to update an existing slides directory." >&2
  exit 1
fi

echo "Initialising slides directory: $TARGET"

mkdir -p "$TARGET"

# Copy bundled assets
cp -r "$SKILL_DIR/themes"             "$TARGET/themes"
cp    "$SKILL_DIR/Makefile"           "$TARGET/Makefile"
cp    "$SKILL_DIR/template_slides.md" "$TARGET/template_slides.md"
cp -r "$SKILL_DIR/vscode"             "$TARGET/.vscode"   # restore leading dot

echo "  ✓ themes/"
echo "  ✓ Makefile"
echo "  ✓ template_slides.md"
echo "  ✓ .vscode/"

# Locate the nearest enclosing .gitignore (walk up from TARGET)
GITIGNORE=""
SEARCH_DIR="$TARGET"
while [[ "$SEARCH_DIR" != "/" ]]; do
  if [[ -f "$SEARCH_DIR/.gitignore" ]]; then
    GITIGNORE="$SEARCH_DIR/.gitignore"
    break
  fi
  SEARCH_DIR="$(dirname "$SEARCH_DIR")"
done

# If none found, create one at the parent of TARGET (project root heuristic)
if [[ -z "$GITIGNORE" ]]; then
  # Walk up to find nearest .git to determine project root
  GIT_ROOT=""
  SEARCH_DIR="$TARGET"
  while [[ "$SEARCH_DIR" != "/" ]]; do
    if [[ -d "$SEARCH_DIR/.git" ]]; then
      GIT_ROOT="$SEARCH_DIR"
      break
    fi
    SEARCH_DIR="$(dirname "$SEARCH_DIR")"
  done
  GITIGNORE="${GIT_ROOT:+$GIT_ROOT}/.gitignore"
  [[ -z "$GIT_ROOT" ]] && GITIGNORE="$(dirname "$TARGET")/.gitignore"
  touch "$GITIGNORE"
  echo "  ✓ created $GITIGNORE"
fi

# Append PDFs/ and node_modules/ if missing
for PATTERN in "PDFs/" "node_modules/"; do
  if ! grep -qxF "$PATTERN" "$GITIGNORE" 2>/dev/null; then
    echo "$PATTERN" >> "$GITIGNORE"
    echo "  ✓ added '$PATTERN' to $GITIGNORE"
  fi
done

echo ""
echo "Done! Next steps:"
echo "  1. Copy template_slides.md to your first deck, e.g.:"
echo "       cp $TARGET/template_slides.md $TARGET/my_talk.md"
echo "  2. Edit the deck."
echo "  3. Build PDFs:"
echo "       cd $TARGET && make"
