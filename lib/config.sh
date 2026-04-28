#!/usr/bin/env bash
# =============================================================================
# Configuration defaults – centralized paths
# =============================================================================

# Homebrew
HOME_BREW_CACHE="${HOME}/Library/Caches/Homebrew"

# Docker (no simple dir, we use docker commands)

# Node.js
HOME_NPM_CACHE="${HOME}/.npm"
HOME_YARN_CACHE="${HOME}/.cache/yarn"
HOME_PNPM_STORE="${HOME}/.pnpm-store"

# Python
HOME_PIP_CACHE="${HOME}/Library/Caches/pip"

# Java
HOME_GRADLE_CACHE="${HOME}/.gradle/caches"
HOME_M2_REPO="${HOME}/.m2/repository"

# Xcode
HOME_XCODE_DERIVED="${HOME}/Library/Developer/Xcode/DerivedData"
HOME_XCODE_ARCHIVES="${HOME}/Library/Developer/Xcode/Archives"
HOME_XCODE_SIM="${HOME}/Library/Developer/CoreSimulator"

# IDEs
HOME_JETBRAINS_CACHE="${HOME}/Library/Caches/JetBrains"
HOME_VSCODE_CACHE="${HOME}/Library/Application Support/Code/CachedData"
HOME_VSCODE_EXT="${HOME}/Library/Application Support/Code/extensions"

# System (user-level caches)
HOME_SYSTEM_CACHES="${HOME}/Library/Caches"

# Trash
HOME_TRASH="${HOME}/.Trash"
