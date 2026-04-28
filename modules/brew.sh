#!/usr/bin/env bash
# =============================================================================
# Homebrew cleanup module
# =============================================================================

run_brew() {
  local module="Homebrew"
  local before=$(size_of "$HOME_BREW_CACHE")
  [[ -z "$before" ]] && before=0
  echo "🔧 $module – cache size before: $(kb_to_human "$before")"

  if ! confirm "Clean Homebrew caches and remove outdated formulae?"; then
    add_summary "🍺 $module skipped (user declined)"
    return
  fi

  if $DRY_RUN; then
    echo "🧪 [dry-run] brew cleanup -s"
    echo "🧪 [dry-run] brew autoremove"
  else
    brew cleanup -s
    brew autoremove
  fi

  local after=$(size_of "$HOME_BREW_CACHE")
  [[ -z "$after" ]] && after=0
  local freed=$((before - after))
  (( freed < 0 )) && freed=0

  add_summary "🍺 $module reclaimed $(kb_to_human "$freed")"
  add_freed "$freed"
}

