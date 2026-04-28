#!/usr/bin/env bash
# =============================================================================
# Docker cleanup module
# =============================================================================

run_docker() {
  local module="Docker"
  # Get disk usage from docker system df (in bytes)
  local before_str=$(docker system df --format "{{.Size}}" 2>/dev/null | head -1)
  local before_kb=0
  if [[ "$before_str" =~ ^[0-9]+(\.[0-9]+)?[BKMGTPE]?$ ]]; then
    local before_bytes=$(numfmt --from=iec "$before_str" 2>/dev/null || echo 0)
    before_kb=$((before_bytes / 1024))
  fi
  echo "🐳 $module – usage before: $(kb_to_human "$before_kb")"

  if ! confirm "Prune Docker system (containers, images, networks, build cache)?"; then
    add_summary "🐳 $module skipped"
    return
  fi

  if $DRY_RUN; then
    echo "🧪 [dry-run] docker system prune -af"
    echo "🧪 [dry-run] docker volume prune -f"
    echo "🧪 [dry-run] docker builder prune -af"
  else
    # Prune system (removes stopped containers, dangling images, etc.)
    docker system prune -af
    # Prune volumes
    docker volume prune -f
    # Prune build cache
    docker builder prune -af
  fi

  local after_str=$(docker system df --format "{{.Size}}" 2>/dev/null | head -1)
  local after_kb=0
  if [[ "$after_str" =~ ^[0-9]+(\.[0-9]+)?[BKMGTPE]?$ ]]; then
    local after_bytes=$(numfmt --from=iec "$after_str" 2>/dev/null || echo 0)
    after_kb=$((after_bytes / 1024))
  fi

  local freed=$((before_kb - after_kb))
  (( freed < 0 )) && freed=0

  add_summary "🐳 $module reclaimed $(kb_to_human "$freed")"
  add_freed "$freed"
}
