# Contributing to AKsToolBox / dotfiles

Thank you for your interest in contributing to this dotfiles repository!

---

## 🧭 Invariants & Architectural Guidelines

Before submitting pull requests or modifying configurations, please review the following critical invariants:

1. **Native History Navigation Guard**:
   - `Ctrl+N` and `Ctrl+P` must **never** be remapped or overridden. They are reserved exclusively for native Bash/Emacs history navigation (`down-line-or-history` and `up-line-or-history`).
2. **Word Delimiter Invariant**:
   - `/` is strictly stripped from `WORDCHARS` so that path navigation and backward deletion (`Alt+Backspace`) operate exactly one directory segment at a time.
3. **Ghost-Text Isolation**:
   - Ghost-text acceptance widgets (`Alt+F` / `Ctrl+Right`) must consume only one word at a time when the cursor is at the end of the line, leaving standard cursor motions untouched when inside the buffer.
4. **Secrets Isolation**:
   - Never commit sensitive tokens, keys, passwords, or personal hostnames. All private credentials belong exclusively in `local.zsh` (which must remain in `.gitignore`).

---

## 🛠️ Adding New Ezlo Specs

Custom CLI specifications are located in `ezlo/specs/<tool>.ezlo`.

1. Generate a draft spec using `ezlo`:
   ```sh
   ezlo import <tool>
   ```
2. Move and refine the generated file:
   ```sh
   ezlo-add <tool>
   ```
3. Test your spec interactively in a new subshell (`zsh`) before opening a PR.

---

## 📝 Commit Conventions

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` A new feature, keybinding, or tool spec
- `fix:` A bug fix or widget correction
- `docs:` Documentation improvements
- `refactor:` Code refactoring that neither fixes a bug nor adds a feature
- `chore:` Maintenance tasks, dependency bumps, or housekeeping

---

## 🚀 Development Workflow

1. Fork the repository on GitHub.
2. Clone your fork locally and create a dedicated feature branch:
   ```sh
   git checkout -b feature/my-new-feature
   ```
3. Test your changes thoroughly in Zsh.
4. Commit your changes with descriptive messages adhering to Conventional Commits.
5. Push to your branch and open a Pull Request against `main`.
