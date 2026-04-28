# 🧼 maccleaner

A **pure‑bash**, modular macOS cleanup utility that feels like a real command‑line
tool (similar to `git` or `brew`). It safely removes caches, stale Docker
artifacts, Homebrew leftovers, IDE data, and more.

## Features

- **Modular architecture** – each cleanup area lives in its own `modules/*.sh`.
- **Interactive & non‑interactive modes**.
- **Safety first** – confirmations, `--yes`, and a dry‑run mode (`--dry`).
- **Progress spinner** and emoji‑rich UX.
- No external dependencies – only macOS built‑in tools.

## Installation

```bash
git clone <repo-url>
cd maccleaner
sudo ./install.sh
```

Or use the built-in install command:

```bash
sudo maccleaner --install
```

The script creates a **symlink** at `/usr/local/bin/maccleaner`.

## Uninstall

```bash
sudo ./uninstall.sh
```

Or use the built-in uninstall command:

```bash
sudo maccleaner --uninstall
```

## Usage

```bash
maccleaner                # Interactive menu (full cleanup)
maccleaner all            # Run every module automatically
maccleaner brew           # Homebrew cleanup only
maccleaner docker         # Docker system cleanup
maccleaner node           # Node.js caches
maccleaner python         # pip cache
maccleaner java           # Maven/Gradle caches
maccleaner xcode          # Xcode DerivedData, archives, simulators
maccleaner ide            # JetBrains & VS Code caches
maccleaner system         # User‑level system caches (safe only)
maccleaner trash          # Empty the Trash
```

### Flags

| Flag   | Description                              |
|--------|------------------------------------------|
| `--yes`| Skip all confirmations (auto‑accept).   |
| `--dry`| Show what would be removed, do **not** delete. |
| `--help`| Show help message.                     |

**Examples**

```bash
maccleaner all --yes          # Full cleanup without prompts
maccleaner docker --dry       # Show Docker prune actions without executing
maccleaner               # Interactive selection menu
```

## Safety Notes

- The tool never touches system‑protected directories.
- Each module prints the size of data **before** and **after** cleaning.
- `--dry` mode is perfect for auditing what will be removed.
- Confirmations can be bypassed with `--yes`.

## Extending

Add a new module by creating `modules/<name>.sh` with a `run_<name>`
function. Use the helper functions from `lib/` (`size_of`, `safe_rm`,
`run_with_spinner`, `add_summary`, etc.) to keep behavior consistent.

## License

MIT – feel free to fork, improve, and share.