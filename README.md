# 🚀 AKsToolBox / dotfiles

A tastefully minimal, lightning-fast, and modular **Zsh** environment built for power users, security professionals, and developers on **Parrot OS**, **Linux**, and **macOS**.

Features contextual autocomplete and ghost-text powered by **[ezlo](https://github.com/denisidoro/ezlo)**, cross-shell **[Starship](https://starship.rs)** prompt, native **[fzf](https://github.com/junegunn/fzf)** fuzzy searching, zero-overhead built-in plugin management, and strict preservation of native Bash/Emacs muscle memory.

---

## 📑 Table of Contents

- [Features](#-features)
- [Repository Structure](#-repository-structure)
- [Prerequisites & Dependencies](#-prerequisites--dependencies)
- [Installation](#-installation)
  - [Automated Setup](#automated-setup)
  - [Manual Setup](#manual-setup)
- [Keybindings Reference](#-keybindings-reference)
- [Ezlo Autocomplete & Specs](#-ezlo-autocomplete--specs)
- [AI & Command Center Integration](#-ai--command-center-integration)
- [Local Overrides & Secrets](#-local-overrides--secrets)
- [Plugin Management](#-plugin-management)
- [Contributing](#-contributing)
- [License & Credits](#-license--credits)

---

## ✨ Features

- **Blazing Fast Startup**: Clean, modular structure using standard XDG directories (`$XDG_CONFIG_HOME`, `$XDG_STATE_HOME`, `$XDG_CACHE_HOME`).
- **Contextual Spec Autocomplete**: Deep CLI subcommand and option completion via `ezlo` with 50+ bundled specs (`docker`, `git`, `python`, `cargo`, `ncat`, `rclone`, etc.).
- **Smart Ghost-Text & Word Motions**:
  - Accept inline ghost text word-by-word (`Alt+F` / `Ctrl+→`).
  - Strict single-directory path backward killing (`Alt+Backspace`).
  - Multi-line command drafting with `Shift+Enter`.
- **Protected Emacs / Bash Muscle Memory**: Uncompromised native history navigation (`Ctrl+P` / `Ctrl+N`) and character navigation (`Ctrl+F` / `Ctrl+B`).
- **Fuzzy Navigation**: Interactive file and directory pickers (`Ctrl+T`, `Ctrl+G`) with live `bat` syntax previews.
- **Zero-Dependency Plugin Manager**: Lightweight built-in Git cloner for plugins (`plugins.zsh`).
- **Informative Prompt**: Custom Tokyo-Night styled `starship.toml` showing execution time, git status, active runtimes, and user privilege badges.
- **Secrets Isolation**: Git-ignored `local.zsh` for API keys and private environment variables.

---

## 📂 Repository Structure

```text
~/.config/zsh/
├── .zshrc               # Master entrypoint: history, options, completions, loader
├── .zshenv              # Environment variables & XDG path initialization
├── aliases.zsh          # Curated system, navigation, and tool aliases
├── bindings.zsh         # Custom ZLE widgets, keymaps, and word boundary logic
├── ezlo.zsh             # Ezlo integration, recipe hooks, and ghost-text bindings
├── fzf.zsh              # FZF defaults, styling, and file preview widgets
├── plugins.zsh          # Built-in lightweight plugin downloader and updater
├── prompt.zsh           # Starship prompt loader and environment isolator
├── starship.toml        # Starship cross-shell prompt configuration
├── local.zsh.example    # Template for machine-local secrets and overrides
├── install.sh           # Non-destructive bootstrap installation script
├── CONTRIBUTING.md      # Invariant rules and contribution guidelines
└── ezlo/
    ├── config.toml      # Ezlo runtime settings
    ├── recipes/         # Interactive command recipe directory
    └── specs/           # Custom CLI completion specifications (*.ezlo)
```

---

## 📦 Prerequisites & Dependencies

The configuration leverages modern Rust-based command line utilities for speed and ergonomics:

| Tool | Purpose | Debian / Parrot / Ubuntu | Arch Linux | macOS |
|:---|:---|:---|:---|:---|
| **zsh** | Core shell interpreter | `apt install zsh` | `pacman -S zsh` | `brew install zsh` |
| **starship** | Fast, cross-shell prompt | `curl -sS https://starship.rs/install.sh \| sh` | `pacman -S starship` | `brew install starship` |
| **ezlo** | Spec autocomplete & ghost text | `cargo install ezlo` | `yay -S ezlo` | `brew install ezlo` |
| **zoxide** | Smart directory jump (`z`) | `curl -sSfL .../zoxide/main/install.sh \| sh` | `pacman -S zoxide` | `brew install zoxide` |
| **fzf** | Fuzzy command & file finder | `apt install fzf` | `pacman -S fzf` | `brew install fzf` |
| **eza** | Modern, icon-rich `ls` replacement | `apt install eza` | `pacman -S eza` | `brew install eza` |
| **bat** | Syntax-highlighting cat / pager | `apt install bat` (`batcat`) | `pacman -S bat` | `brew install bat` |
| **fd** | Fast directory walker for fzf | `apt install fd-find` (`fdfind`) | `pacman -S fd` | `brew install fd` |
| **ripgrep** | Blazing-fast regex file search | `apt install ripgrep` | `pacman -S ripgrep` | `brew install ripgrep` |
| **neovim** | Modern modal text editor | `apt install neovim` | `pacman -S neovim` | `brew install neovim` |

> [!NOTE]
> A **[Nerd Font](https://www.nerdfonts.com)** (e.g., JetBrainsMono Nerd Font, FiraCode Nerd Font) must be active in your terminal emulator to render icons in prompt and `eza`.

---

## 📥 Installation

### Automated Setup

Run the included installer to verify dependencies, create XDG state directories, and configure your Zsh dotfiles:

```sh
git clone https://github.com/AKsToolBox/dotfiles.git ~/.config/zsh
cd ~/.config/zsh
./install.sh
```

### Manual Setup

1. **Clone the repository:**
   ```sh
   git clone https://github.com/AKsToolBox/dotfiles.git ~/.config/zsh
   ```

2. **Configure `ZDOTDIR`:**
   Add the following snippet to `/etc/zsh/zshenv` (or `~/.zshenv`):
   ```sh
   if [[ -z "$XDG_CONFIG_HOME" ]]; then
       export XDG_CONFIG_HOME="$HOME/.config"
   fi

   if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
       export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
   fi
   ```

3. **Create Required State Directories:**
   ```sh
   mkdir -p ~/.local/state/zsh   # History storage
   mkdir -p ~/.cache/zsh         # Completion cache
   ```

4. **Initialize Local Secrets:**
   ```sh
   cp ~/.config/zsh/local.zsh.example ~/.config/zsh/local.zsh
   ```

5. **Set Default Shell:**
   ```sh
   chsh -s $(which zsh)
   ```

---

## ⌨️ Keybindings Reference

### Navigation & Word Motions
| Keybinding | Action | Description |
|:---|:---|:---|
| `Ctrl+P` | `up-line-or-history` | Previous command in history (Bash/Emacs mode) |
| `Ctrl+N` | `down-line-or-history` | Next command in history (Bash/Emacs mode) |
| `Ctrl+F` | `forward-char` | Move cursor 1 character forward (never consumes ghost text) |
| `Ctrl+B` | `backward-char` | Move cursor 1 character backward |
| `Alt+F` / `Ctrl+→` | `_forward_word_or_ghost_word` | Forward 1 word; accepts 1 ghost-text word at end-of-line |
| `Alt+B` / `Ctrl+←` | `backward-word` | Move cursor 1 word backward |
| `Alt+Backspace` | `_backward_kill_dir` | Kill 1 path/directory segment backward (stops at `/`) |
| `Ctrl+U` | `backward-kill-line` | Clear the line backward to cursor |
| `Shift+Enter` | `_insert_newline` | Insert a newline for multi-line command editing |

### Searching & Completions
| Keybinding | Action | Description |
|:---|:---|:---|
| `Tab` | `expand-or-complete` | Native interactive Zsh completion menu |
| `Ctrl+R` | `ezlo / fzf` | Fuzzy history search |
| `Ctrl+T` | `fzf-file-widget` | Fuzzy file search including hidden files (with preview) |
| `Ctrl+G` | `_fzf_file_no_hidden` | Fuzzy file search excluding hidden files (with preview) |
| `↑` / `↓` | `substring-search` | History substring search based on typed prefix |
| `Ctrl+\` | `_ezlo_toggle` | Toggle autosuggestions / ghost-text on/off |

---

## 🧩 Ezlo Autocomplete & Specs

[ezlo](https://github.com/denisidoro/ezlo) provides deterministic CLI option suggestions, contextual help, and workflow recipes without hijacking native completions.

- **Specs Directory**: Located at `~/.config/zsh/ezlo/specs/` with 50+ pre-compiled tools.
- **Recipe Launcher**: Press `Alt+R` to open the interactive recipe picker.
- **Token Explanation**: Press `Alt+E` to inspect documentation for the command token under your cursor.
- **Import New Tools**: Automatically generate and install specs for any CLI tool:
  ```sh
  ezlo-add <tool-name>
  ```

---

## 🤖 AI & Command Center Integration

- **Natural Language Translation**:
  Type a task in plain English on your command line and press `Alt+K`. The built-in widget queries Gemini API via `ezlo-ai-translate` and replaces your prompt with the executable command.
- **AI Command Center Aliases**:
  ```sh
  local-chat       # Interactive terminal chat with local Qwen3-8B
  local-sysadmin   # Interactive sysadmin assistant session
  local-netsec     # Interactive network security analysis session
  local-audit      # Autonomous system security audit
  netsec           # Direct network security audit and hardening CLI
  cc-agent         # Direct entrypoint for AI Command Center local agent
  ```

---

## 🔒 Local Overrides & Secrets

Private machine configurations, tokens, and system-specific exports live in `local.zsh`, which is strictly ignored by Git.

Copy the template:
```sh
cp local.zsh.example local.zsh
```

Example `local.zsh`:
```sh
# Machine-local secrets
export GEMINI_API_KEY="your-api-key"
export OPENROUTER_API_KEY="your-api-key"

# Custom path additions
export PATH="$HOME/.local/bin:$PATH"
```

---

## 🔌 Plugin Management

Plugins are managed without external framework overhead via `$ZDOTDIR/plugins.zsh`. On first shell launch, missing plugins are cloned automatically:

| Plugin | Repository | Purpose | Notes |
|:---|:---|:---|:---|
| **zsh-history-substring-search** | `zsh-users/zsh-history-substring-search` | Up/Down arrow history search matching current buffer prefix | Active always |
| **zsh-autosuggestions** | `zsh-users/zsh-autosuggestions` | Fish-like inline autosuggestions | Active as fallback if `ezlo` is not installed |

> [!NOTE]
> Heavy third-party syntax highlighters (e.g. `fast-syntax-highlighting`) are intentionally excluded to eliminate recursion collisions with `ezlo`'s live redraw hooks and protect shell performance.

To update installed plugins:
```sh
zplugin-update
```

---

## 🤝 Contributing

Contributions, bug reports, and new `ezlo` specs are welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for details on:
- Conventional Commits specifications
- Invariant rules (e.g. preserving `Ctrl+N`/`Ctrl+P` and word delimiter settings)
- Adding and testing new CLI specs

---

## 📜 License & Credits

- Licensed under the **[MIT License](./LICENSE)**.
- Originally forked from [radleylewis/zsh](https://github.com/radleylewis/zsh).
- Enhanced, modularized, and maintained by **[AKsToolBox](https://github.com/AKsToolBox)**.
