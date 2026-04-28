#!/usr/bin/env bash
# =============================================================================
# Command‑line flag handling
# =============================================================================

AUTO_YES=false
DRY_RUN=false

# -------------------------------------------------------------------------
# Parse arguments (must be called before any interactive prompts)
# -------------------------------------------------------------------------
parse_flags() {
  for arg in "$@"; do
    case "$arg" in
      --yes) AUTO_YES=true ;;
      --dry) DRY_RUN=true ;;
      --help)
        print_help
        exit 0
        ;;
      --*)
        echo "❌ Unknown flag: $arg"
        print_help
        exit 1
        ;;
    esac
  done
}

# -------------------------------------------------------------------------
# Confirmation wrapper – respects --yes flag and loops until valid input
# -------------------------------------------------------------------------
confirm() {
  if $AUTO_YES; then
    return 0
  fi
  local answer
  while true; do
    read -p "⚠️ $1 (y/N): " answer
    case "$answer" in
      [Yy]* ) return 0 ;;
      [Nn]*|"" ) return 1 ;;
      * ) echo "Please answer y or n." ;;
    esac
  done
}