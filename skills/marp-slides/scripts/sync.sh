#!/usr/bin/env bash
# sync.sh — overwrite themes/ and Makefile in an existing slides directory from this skill
# Usage: bash sync.sh [--force] <absolute-path-to-target-slides-dir>
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

FORCE=false
if [[ "${1:-}" == "--force" ]]; then
  FORCE=true
  shift
fi

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 [--force] <target-slides-dir>" >&2
  exit 1
fi

# Resolve to absolute path (portable: no GNU realpath -m needed)
case "$1" in
  /*) TARGET="$1" ;;
  *)  TARGET="$(pwd)/$1" ;;
esac

# Verify the target looks like an initialised slides dir
if [[ ! -d "$TARGET/themes" ]] || [[ ! -f "$TARGET/Makefile" ]]; then
  echo "Error: $TARGET does not look like an initialised slides directory." >&2
  echo "Expected themes/ and Makefile to exist. Run init.sh first." >&2
  exit 1
fi

echo "Syncing themes/ and Makefile into: $TARGET"
echo ""

# Show local modifications (if inside a git repo)
if git -C "$TARGET" rev-parse --is-inside-work-tree &>/dev/null; then
  DIFF=$(git -C "$TARGET" diff --stat -- themes Makefile 2>/dev/null || true)
  if [[ -n "$DIFF" ]]; then
    echo "Local modifications to themes/ and/or Makefile:"
    echo "$DIFF"
    echo ""
    if [[ "$FORCE" != true ]]; then
      echo "These will be overwritten. Re-run with --force to proceed, or commit/stash first."
      exit 1
    fi
    echo "Proceeding with --force..."
    echo ""
  fi
else
  echo "(Not a git repo — skipping local-diff check)"
  echo ""
fi

# Overwrite
cp -r "$SKILL_DIR/themes/." "$TARGET/themes/"
cp    "$SKILL_DIR/Makefile"  "$TARGET/Makefile"

echo "  ✓ themes/ updated"
echo "  ✓ Makefile updated"
echo ""

# Show what changed
if git -C "$TARGET" rev-parse --is-inside-work-tree &>/dev/null; then
  AFTER=$(git -C "$TARGET" diff --stat -- themes Makefile 2>/dev/null || true)
  if [[ -n "$AFTER" ]]; then
    echo "Changes:"
    echo "$AFTER"
  else
    echo "No changes (themes and Makefile were already up to date)."
  fi
fi
