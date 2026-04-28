#!/usr/bin/env bash
# =============================================================================
# Uninstall script for maccleaner
# =============================================================================

set -e

TARGET="/usr/local/bin/maccleaner"

if [[ -f "$TARGET" ]]; then
  rm -f "$TARGET"
  echo "✅ maccleaner removed from $TARGET"
else
  echo "⚠️  maccleaner not found at $TARGET"
fi