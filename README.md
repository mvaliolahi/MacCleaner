# 🧼 MacCleaner

> ⚡ Smart • Safe • Developer-first macOS cleanup tool (pure Bash)

MacCleaner is a lightweight, interactive cleanup script designed for developers who want to reclaim disk space on macOS **without breaking their environment**.

It scans and removes hidden caches, unused dependencies, and common disk hogs — all with **explicit confirmation and full transparency**.

---

## ✨ Features

- 🧠 **Developer-focused cleanup**
- ⚡ **Interactive (y/N per section)**
- ⏳ **Animated CLI spinner (no dependencies)**
- 📊 **Disk usage summary before/after**
- 🔒 **Safe by default (no silent deletes)**
- 🧩 **Zero dependencies (pure Bash)**

---

## 🧹 What it cleans

- 🍺 Homebrew cache & unused formulae
- 🐳 Docker images, volumes, build cache
- 📦 Node.js caches (npm, yarn, pnpm)
- 🐍 Python pip cache
- 🧑‍💻 Xcode DerivedData & archives
- 🧠 IDE caches (VS Code, JetBrains)
- 🧼 macOS user caches (safe scope)
- 🗑 Trash

---

## 🚀 Usage

```bash
chmod +x run.sh
./run.sh
