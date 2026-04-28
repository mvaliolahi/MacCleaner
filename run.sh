#!/bin/bash

set -e

cat << "EOF"

 __  __                 ____ _
|  \/  | __ _  ___     / ___| | ___  __ _ _ __   ___ _ __
| |\/| |/ _` |/ __|   | |   | |/ _ \/ _` | '_ \ / _ \ '__|
| |  | | (_| | (__    | |___| |  __/ (_| | | | |  __/ |
|_|  |_|\__,_|\___|    \____|_|\___|\__,_|_| |_|\___|_|

      🧼 MacCleaner - Smart Dev Cleanup for macOS
      ⚡ Safe • Selective • Animated

EOF

echo "👤 User: $USER"
echo "📅 Date: $(date)"
echo "📦 macOS: $(sw_vers -productVersion)"
echo ""

SUMMARY=()

START_FREE=$(df -k "$HOME" | awk 'NR==2 {print $4}')

to_gb() {
  awk "BEGIN {printf \"%.2f GB\", $1/1024/1024}"
}

confirm() {
  read -p "⚠️ $1 (y/N): " c
  [[ "$c" == "y" ]]
}

add_summary() {
  SUMMARY+=("$1")
}

# -----------------------------------
# ⏳ SPINNER (native bash)
# -----------------------------------
spinner() {
  local pid=$1
  local msg=$2
  local spin='|/-\'
  local i=0

  while kill -0 "$pid" 2>/dev/null; do
    i=$(( (i+1) %4 ))
    printf "\r⏳ %s %s" "$msg" "${spin:$i:1}"
    sleep 0.1
  done

  printf "\r⏳ %s ✔️\n" "$msg"
}

run_with_spinner() {
  local msg=$1
  shift

  (
    eval "$@" >/dev/null 2>&1
  ) &

  spinner $! "$msg"
}

# -----------------------------------
# 🧭 START
# -----------------------------------
if ! confirm "Start full cleanup?"; then
  echo "👋 Cancelled"
  exit 0
fi

# -----------------------------------
# 🍺 HOMEWBREW
# -----------------------------------
echo ""
echo "🍺 Homebrew"

if command -v brew &>/dev/null; then
  brew outdated | head

  if confirm "Clean Homebrew cache + packages?"; then
    run_with_spinner "Cleaning Homebrew" "
      brew autoremove
      brew cleanup -s
    "
    add_summary "🍺 Homebrew cleaned"
  else
    add_summary "🍺 Homebrew skipped"
  fi
fi

# -----------------------------------
# 🐳 DOCKER
# -----------------------------------
echo ""
echo "🐳 Docker"

if command -v docker &>/dev/null; then
  docker system df

  if confirm "Clean Docker system?"; then
    run_with_spinner "Cleaning Docker" "
      docker system prune -af
      docker volume prune -f
      docker builder prune -af
    "
    add_summary "🐳 Docker cleaned"
  else
    add_summary "🐳 Docker skipped"
  fi
fi

# -----------------------------------
# 📦 NODE
# -----------------------------------
echo ""
echo "📦 Node.js"

if confirm "Clean Node caches?"; then
  run_with_spinner "Cleaning Node cache" "
    rm -rf ~/.npm ~/.cache/yarn ~/.pnpm-store
  "
  add_summary "📦 Node cleaned"
else
  add_summary "📦 Node skipped"
fi

# -----------------------------------
# 🐍 PYTHON
# -----------------------------------
echo ""
echo "🐍 Python"

PIP_CACHE="$HOME/.cache/pip"

if [ -d "$PIP_CACHE" ]; then
  SIZE=$(du -sh "$PIP_CACHE" 2>/dev/null | awk '{print $1}')
  echo "pip cache → $SIZE"

  if confirm "Clean pip cache?"; then
    run_with_spinner "Cleaning pip cache" "
      rm -rf \"$PIP_CACHE\"
    "
    add_summary "🐍 Python cache cleaned"
  else
    add_summary "🐍 Python skipped"
  fi
else
  echo "pip cache → not found"
  add_summary "🐍 Python cache not found"
fi

# -----------------------------------
# 🧑‍💻 XCODE
# -----------------------------------
echo ""
echo "🧑‍💻 Xcode"

if confirm "Clean Xcode caches?"; then
  run_with_spinner "Cleaning Xcode" "
    rm -rf ~/Library/Developer/Xcode/DerivedData/*
    rm -rf ~/Library/Developer/Xcode/Archives/*
  "
  add_summary "🧑‍💻 Xcode cleaned"
else
  add_summary "🧑‍💻 Xcode skipped"
fi

# -----------------------------------
# 🧠 IDEs
# -----------------------------------
echo ""
echo "🧠 IDEs"

if confirm "Clean IDE caches?"; then
  run_with_spinner "Cleaning IDEs" "
    rm -rf ~/Library/Caches/JetBrains/*
    rm -rf ~/Library/Application\ Support/Code/Cache
  "
  add_summary "🧠 IDEs cleaned"
else
  add_summary "🧠 IDEs skipped"
fi

# -----------------------------------
# 🧼 USER CACHE
# -----------------------------------
echo ""
echo "🧼 User cache"

if confirm "Clean user caches?"; then
  run_with_spinner "Cleaning user cache" "
    find ~/Library/Caches -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +
  "
  add_summary "🧼 User cache cleaned"
else
  add_summary "🧼 User cache skipped"
fi

# -----------------------------------
# 🗑 TRASH
# -----------------------------------
echo ""
if confirm "Empty Trash?"; then
  run_with_spinner "Emptying Trash" "
    rm -rf ~/.Trash/*
  "
  add_summary "🗑 Trash emptied"
fi

# -----------------------------------
# 📊 SUMMARY
# -----------------------------------
END_FREE=$(df -k "$HOME" | awk 'NR==2 {print $4}')

echo ""
echo "=============================="
echo "📊 CLEANUP SUMMARY"
echo "=============================="

for s in "${SUMMARY[@]}"; do
  echo "• $s"
done

echo ""
echo "💾 Free space: $(to_gb $END_FREE)"
echo "📈 Change: $(to_gb $((END_FREE - START_FREE)))"

echo ""
echo "🎉 Done!"
