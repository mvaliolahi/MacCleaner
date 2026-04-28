#!/usr/bin/env bash
# =============================================================================
# Summary handling – records what was cleaned and reports final stats
# =============================================================================

# Global array storing "module:freed_space" strings
declare -a SUMMARY=()

# Total freed kilobytes from modules
declare -i FREED_KB=0
# Disk free at start (kilobytes)
declare -i START_FREE=0

# -------------------------------------------------------------------------
# Initialise any required state (currently just clears the array)
# -------------------------------------------------------------------------
init_summary() {
  SUMMARY=()
  FREED_KB=0
  START_FREE=$(df -k "$HOME" | awk 'NR==2 {print $4}')
}

# -------------------------------------------------------------------------
# Append an entry to the global summary (module name + freed space)
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
# Show final report: cleaned modules, total space reclaimed by modules,
# current disk free space, and net change in disk free space.
# -------------------------------------------------------------------------
print_summary() {
  END_FREE=$(df -k "$HOME" | awk 'NR==2 {print $4}')

  echo ""
  echo "=============================="
  echo "📊 CLEANUP SUMMARY"
  echo "=============================="

  for s in "${SUMMARY[@]}"; do
    echo "• $s"
  done

  echo ""
  # Estimated freed space from modules (convert KB to bytes for numfmt)
  local reclaimed_bytes=$((FREED_KB * 1024))
  echo "📦 Estimated freed space: $(numfmt --to=iec $reclaimed_bytes)"

  # Current disk free space
  local free_bytes=$((END_FREE * 1024))
  echo "💾 Current disk free: $(numfmt --to=iec $free_bytes)"

  # Net change in disk free space (ensure non-negative for display)
  local change_bytes=$(( (END_FREE - START_FREE) * 1024 ))
  if (( change_bytes < 0 )); then
    echo "📈 Disk change: $(numfmt --to=iec 0) (no net decrease)"
  else
    echo "📈 Disk change: +$(numfmt --to=iec $change_bytes)"
  fi

  echo "=============================="
}