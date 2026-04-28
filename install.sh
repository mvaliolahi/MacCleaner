#!/usr/bin/env bash
# =============================================================================
# Installation script for maccleaner
# =============================================================================

set -euo pipefail

TARGET="/usr/local/bin/maccleaner"
SOURCE="$(cd "$(dirname "$0")" && pwd)/maccleaner"

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root (or with sudo) to install."
  exit 1
fi

# Remove existing installation if present
if [[ -L "$TARGET" ]] || [[ -f "$TARGET" ]]; then
  rm -f "$TARGET"
fi

# Create symlink to the actual script
ln -s "$SOURCE" "$TARGET"
chmod +x "$TARGET"

echo "✅ maccleaner installed to $TARGET (symlinked to $SOURCE)"