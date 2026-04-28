#!/usr/bin/env bash
# =============================================================================
# Python cleanup module
# =============================================================================

run_python() {
  local module="Python"
  local before=$(size_of "$HOME_PIP_CACHE")
  [[ -z "$before" ]] && before=0
  
  if (( before == 0 )); then
    echo "📦 $module – no caches found."
    add_summary "🐍 $module skipped (no caches)"
    return
  fi
  
  echo "🔧 $module – cache size before: $(kb_to_human "$before")"

  if ! confirm "Remove pip cache?"; then
    add_summary "🐍 $module skipped (user declined)"
    return
  fi

  if $DRY_RUN; then
    echo "🧪 [dry-run] rm -rf $HOME_PIP_CACHE"
  else
    rm -rf "$HOME_PIP_CACHE" 2>/dev/null
  fi

  local after=$(size_of "$HOME_PIP_CACHE")
  [[ -z "$after" ]] && after=0
  local freed=$((before - after))
  (( freed < 0 )) && freed=0

  add_summary "🐍 $module reclaimed $(kb_to_human "$freed")"
  add_freed "$freed"
}
