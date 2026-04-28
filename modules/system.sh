#!/usr/bin/env bash
# =============================================================================
# System cleanup module (safe, user-level caches)
# =============================================================================

run_system() {
  local module="System"
  local before=$(size_of "$HOME_SYSTEM_CACHES")
  [[ -z "$before" ]] && before=0

  if (( before == 0 )); then
    echo "📦 $module – no caches found."
    add_summary "⚙️ $module skipped (no caches)"
    return
  fi

  echo "🔧 $module – cache size before: $(kb_to_human "$before")"

  if ! confirm "Remove user-level system caches (${HOME}/Library/Caches)?"; then
    add_summary "⚙️ $module skipped (user declined)"
    return
  fi

  if $DRY_RUN; then
    echo "🧪 [dry-run] rm -rf $HOME_SYSTEM_CACHES/*"
  else
    find "$HOME_SYSTEM_CACHES" -maxdepth 1 -type d -not -name '.' -print0 2>/dev/null | xargs -0 rm -rf 2>/dev/null
  fi

  local after=$(size_of "$HOME_SYSTEM_CACHES")
  [[ -z "$after" ]] && after=0
  local freed=$((before - after))
  (( freed < 0 )) && freed=0

  add_summary "⚙️ $module reclaimed $(kb_to_human "$freed")"
  add_freed "$freed"
}
