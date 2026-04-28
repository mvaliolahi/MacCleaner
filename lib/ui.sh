#!/usr/bin/env bash
# =============================================================================
# UI helpers – logo, system info, interactive menus, spinners, help output
# =============================================================================

# -------------------------------------------------------------------------
# ASCII logo
# -------------------------------------------------------------------------
print_logo() {
  cat <<'EOF'
 __  __                 ____ _
|  \/  | __ _  ___     / ___| | ___  __ _ _ __
| |\/| |/ _` |/ __|   | |   | |/ _ \/ _` | '_ \
| |  | | (_| | (__    | |___| |  __/ (_| | | | |
|_|  |_|\__,_|\___|    \____|_|\___|\__,_|_| |_|

      🧼 MacCleaner
EOF
}

# -------------------------------------------------------------------------
# System information (user, date, macOS version)
# -------------------------------------------------------------------------
print_system_info() {
  echo "👤 User: $(whoami)"
  echo "🗓️ Date: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "💻 OS : $(sw_vers -productName) $(sw_vers -productVersion)"
  echo
}

# -------------------------------------------------------------------------
# Help text – displayed with `maccleaner --help`
# -------------------------------------------------------------------------
print_help() {
  cat <<'EOF'

🧼 MacCleaner - Smart macOS cleanup tool

Usage:
  maccleaner [command] [options]

Commands:
  all        Run full cleanup
  brew       Clean Homebrew
  docker     Clean Docker
  node       Clean Node.js caches
  python     Clean Python caches
  java       Clean Java data
  xcode      Clean Xcode data
  ide        Clean IDE caches
  system     Clean macOS user cache
  trash      Empty Trash

Options:
  --yes      Skip confirmations
  --dry      Preview only
  --help     Show this help

Examples:
  maccleaner all --yes
  maccleaner docker
  maccleaner --dry

EOF
}

# -------------------------------------------------------------------------
# Interactive top‑level menu (shown when no command is supplied)
# -------------------------------------------------------------------------
interactive_mode() {
  echo ""
  echo "=============================="
  echo "🧼 MacCleaner Menu"
  echo "=============================="
  echo "1) Full cleanup (all modules)"
  echo "2) Choose single module"
  echo "3) Exit"
  echo "------------------------------"
  read -p "Select option: " opt
  case "$opt" in
    1) run_all ;;
    2) select_module ;;
    *) exit 0 ;;
  esac
}

# -------------------------------------------------------------------------
# Sub‑menu to pick a single module
# -------------------------------------------------------------------------
select_module() {
  echo ""
  echo "Select module:"
  echo "1) Brew"
  echo "2) Docker"
  echo "3) Node"
  echo "4) Python"
  echo "5) Java"
  echo "6) Xcode"
  echo "7) IDE"
  echo "8) System"
  echo "9) Trash"
  read -p "Choice: " c
  case "$c" in
    1) run_brew   ;;
    2) run_docker ;;
    3) run_node   ;;
    4) run_python ;;
    5) run_java   ;;
    6) run_xcode  ;;
    7) run_ide    ;;
    8) run_system ;;
    9) run_trash  ;;
    *) echo "Invalid choice" ;;
  esac
}

# -------------------------------------------------------------------------
# Simple spinner – runs a command in background and draws a rotating glyph
# -------------------------------------------------------------------------
run_with_spinner() {
  local msg="$1"
  shift
  "$@" &
  local pid=$!
  local spin='|/-\'
  local i=0

  printf "⏳ %s " "$msg"
  while kill -0 "$pid" 2>/dev/null; do
    printf "\b${spin:i++%${#spin}:1}"
    sleep 0.1
  done
  wait "$pid"
  echo " ✔️"
}

