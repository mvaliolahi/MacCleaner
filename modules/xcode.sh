#!/usr/bin/env bash
# =============================================================================
# Xcode cleanup module
# =============================================================================

run_xcode() {
  local module="Xcode"
  local total_before=0
  local paths=("$HOME_XCODE_DERIVED" "$HOME_XCODE_ARCHIVES" "$HOME_XCODE_SIM")
  local p

  for p in "${paths[@]}"; do
    if [[ -d "$p" ]]; then
      local size=$(size_of "$p")
      total_before=$((total_before + size))
      echo "🔧 $module – $(basename "$p") → $(kb_to_human "$size")"
    fi
  done

  if (( total_before == 0 )); then
    echo "📦 $module – no caches found."
    add_summary "🛠️ $module skipped (no caches)"
    return
  fi

  echo "🔧 $module – total size before: $(kb_to_human "$total_before")"

  if ! confirm "Remove Xcode data (DerivedData, Archives, Simulators)?"; then
    add_summary "🛠️ $module skipped (user declined)"
    return
  fi

  for p in "${paths[@]}"; do
    if [[ -d "$p" ]]; then
      if $DRY_RUN; then
        echo "🧪 [dry-run] rm -rf $p"
      else
        rm -rf "$p" 2>/dev/null
      fi
    fi
  done

  local total_after=0
  for p in "${paths[@]}"; do
    if [[ -d "$p" ]]; then
      local size=$(size_of "$p")
      total_after=$((total_after + size))
    fi
  done

  local freed=$((total_before - total_after))
  (( freed < 0 )) && freed=0

  add_summary "🛠️ $module reclaimed $(kb_to_human "$freed")"
  add_freed "$freed"
}
