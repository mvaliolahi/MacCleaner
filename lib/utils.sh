#!/usr/bin/env bash
# =============================================================================
# Utility helpers – shared logic across modules
# =============================================================================

# -------------------------------------------------------------------------
# Size in kilobytes for a given path (used for freed‑space calculations)
# -------------------------------------------------------------------------
size_of() {
  du -sk "$1" 2>/dev/null | awk '{print $1}'
}

# -------------------------------------------------------------------------
# Convert kilobytes to human-readable format
# -------------------------------------------------------------------------
kb_to_human() {
  numfmt --to=iec $((${1:-0} * 1024))
}

# -------------------------------------------------------------------------
# Safe removal wrapper – respects --dry flag and suppresses permission errors
# -------------------------------------------------------------------------
safe_rm() {
  local target="$1"
  if $DRY_RUN; then
    echo "🧪 [dry‑run] rm -rf $target"
  else
    rm -rf "$target" 2>/dev/null
  fi
}

# -------------------------------------------------------------------------
# Append a human‑readable entry to the global summary
# -------------------------------------------------------------------------
add_summary() {
  SUMMARY+=("$1")
}

# -------------------------------------------------------------------------
# Add freed kilobytes to the running total (used by modules that compute KB)
# -------------------------------------------------------------------------
add_freed() {
  FREED_KB=$((FREED_KB + ${1:-0}))
}

# -------------------------------------------------------------------------
# Run every module in sequence (used for `maccleaner all`)
# -------------------------------------------------------------------------
run_all() {
  run_brew
  run_docker
  run_node
  run_python
  run_java
  run_xcode
  run_ide
  run_system
  run_trash
}
