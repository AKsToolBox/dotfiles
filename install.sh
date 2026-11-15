#!/usr/bin/env bash
# ==============================================================================
# AKsToolBox / dotfiles - Installation & Bootstrap Script
# ==============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

echo -e "${GREEN}=== AKsToolBox Dotfiles Installer ===${NC}\n"

# 1. Verify Core Dependencies
info "Checking dependencies..."
deps=(zsh git curl)
missing=()
for cmd in "${deps[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
done

if (( ${#missing[@]} > 0 )); then
  error "Missing required dependencies: ${missing[*]}"
  info "Please install them using your system package manager."
  exit 1
fi
success "Core dependencies found."

# 2. Check Optional CLI Tools
optional_tools=(starship ezlo fzf eza bat batcat fd fdfind zoxide rg)
for cmd in "${optional_tools[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    success "Tool found: $cmd"
  fi
done

# 3. Create XDG Standard State and Cache Directories
info "Ensuring XDG directories exist..."
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$DOTFILES_DIR/ezlo/recipes"
success "XDG state & cache directories ready."

# 4. Setup local.zsh from template if missing
if [[ ! -f "$DOTFILES_DIR/local.zsh" ]]; then
  if [[ -f "$DOTFILES_DIR/local.zsh.example" ]]; then
    info "Creating local.zsh from template..."
    cp "$DOTFILES_DIR/local.zsh.example" "$DOTFILES_DIR/local.zsh"
    success "Created $DOTFILES_DIR/local.zsh"
  fi
else
  info "Existing local.zsh preserved."
fi

# 5. Check or configure ZDOTDIR in ~/.zshenv
USER_ZSHENV="$HOME/.zshenv"
ZDOTDIR_SNIPPET='if [[ -z "$XDG_CONFIG_HOME" ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi
if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi'

if [[ -f "$USER_ZSHENV" ]] && grep -q 'ZDOTDIR' "$USER_ZSHENV" 2>/dev/null; then
  info "ZDOTDIR is already configured in $USER_ZSHENV."
elif [[ -f /etc/zsh/zshenv ]] && grep -q 'ZDOTDIR' /etc/zsh/zshenv 2>/dev/null; then
  info "ZDOTDIR is already configured in /etc/zsh/zshenv."
else
  info "Adding ZDOTDIR bootstrap snippet to $USER_ZSHENV..."
  echo "" >> "$USER_ZSHENV"
  echo "$ZDOTDIR_SNIPPET" >> "$USER_ZSHENV"
  success "Added ZDOTDIR configuration to $USER_ZSHENV."
fi

echo -e "\n${GREEN}=== Installation Complete ===${NC}"
info "Start a new shell session:  exec zsh"
if [[ "$SHELL" != *"zsh"* ]]; then
  warn "Zsh is not your current login shell ($SHELL)."
  info "To set Zsh as your default shell, run:  chsh -s $(which zsh)"
fi
