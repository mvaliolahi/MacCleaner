#!/usr/bin/env bash
# =============================================================================
# Trash cleanup module
# =============================================================================

run_trash() {
  local module="Trash"
  local before=$(size_of "$HOME_TRASH")
  [[ -z "$before" ]] && before=0

  if (( before == 0 )); then
    echo "📦 $module – empty."
    add_summary "🗑️ $module skipped (empty)"
    return
  fi

  echo "🔧 $module – size before: $(kb_to_human "$before")"

  if ! confirm "Empty the Trash?"; then
    add_summary "🗑️ $module skipped (user declined)"
    return
  fi

  if $DRY_RUN; then
    echo "🧪 [dry-run] rm -rf $HOME_TRASH/*"
  else
    rm -rf "$HOME_TRASH"/* 2>/dev/null
  fi

  local after=$(size_of "$HOME_TRASH")
  [[ -z "$after" ]] && after=0
  local freed=$((before - after))
  (( freed < 0 )) && freed=0

  add_summary "🗑️ $module reclaimed $(kb_to_human "$freed")"
  add_freed "$freed"
}
