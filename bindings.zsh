# =========================================================
# Keybindings (Native Emacs / Bash mode)
# =========================================================

# Establish native Bash/Emacs keymap as baseline
bindkey -e

# Treat '/' as a word delimiter so word motions, kills, and ghost acceptance operate one directory level at a time
WORDCHARS="${WORDCHARS//\//}"

# ---------------------------------------------------------
# 1. WORD & CHARACTER NAVIGATION (Bash / Emacs Compatibility)
# ---------------------------------------------------------
# Forward one word; if ghost text is present at EOL, accepts exactly one word
_forward_word_or_ghost_word() {
  # 1. Ezlo partial ghost-text acceptance:
  if [[ -n "${_ezlo_ghost:-}" && $CURSOR -eq ${#BUFFER} ]]; then
    _ezlo_on_redraw 2>/dev/null || true
    local -i orig_len=${#BUFFER}
    BUFFER+="$_ezlo_ghost"
    zle .forward-word
    if (( CURSOR > orig_len )); then
      BUFFER="${BUFFER[1,$CURSOR]}"
    else
      BUFFER="${BUFFER[1,$orig_len]}"
    fi
    _ezlo_on_redraw 2>/dev/null || true
    zle -R 2>/dev/null || true
    return
  fi

  # 2. zsh-autosuggestions fallback partial acceptance:
  if (( $+widgets[autosuggest-accept] )) && [[ -n "${POSTDISPLAY:-}" && $CURSOR -eq ${#BUFFER} ]]; then
    zle forward-word
    return
  fi

  # 3. Standard cursor navigation: strictly one word forward
  zle .forward-word
}
zle -N _forward_word_or_ghost_word

bindkey '^F' .forward-char              # Ctrl+F -> strictly 1 char forward (never accepts ghost text)
bindkey '^B' .backward-char             # Ctrl+B -> strictly 1 char backward
bindkey '^[f' _forward_word_or_ghost_word     # Alt+F -> Forward 1 word / accept 1 ghost word at EOL
bindkey '^[F' _forward_word_or_ghost_word     # Alt+Shift+F -> Forward 1 word / accept 1 ghost word at EOL
bindkey '^[b' .backward-word            # Alt+B -> strictly 1 word backward
bindkey '^[B' .backward-word            # Alt+Shift+B -> strictly 1 word backward
bindkey '^[[1;5C' _forward_word_or_ghost_word # Ctrl+Right -> Forward 1 word / accept 1 ghost word at EOL
bindkey '^[[1;5D' .backward-word        # Ctrl+Left -> strictly 1 word backward
bindkey '^[^?' backward-kill-word       # Alt+Backspace -> Kill word backward
bindkey '^[[3;3~' backward-kill-word    # Alt+Backspace (alt sequence)
bindkey '^[^H' backward-kill-word       # Alt+Backspace (alt sequence)
bindkey '^[d' kill-word                 # Alt+D -> Kill word forward
bindkey '^U' backward-kill-line         # Ctrl+U -> Kill line backward (Bash style)

# Shift+Enter -> Insert newline without running (multi-line buffer editing)
_insert_newline() {
  LBUFFER+=$'\n'
}
zle -N _insert_newline
bindkey '^[OM' _insert_newline
bindkey '^[[27;2;13~' _insert_newline
bindkey '^[[13;2u' _insert_newline

# ---------------------------------------------------------
# 2. FZF FILE PICKER
# ---------------------------------------------------------
bindkey '^G' _fzf_file_no_hidden        # Ctrl+G -> fzf (no hidden files)

# ---------------------------------------------------------
# 3. AUTOSUGGESTIONS (Fallback when ezlo is not active)
# ---------------------------------------------------------
if (( $+widgets[autosuggest-toggle] )); then
  bindkey '^\' autosuggest-toggle       # Ctrl+\ -> Toggle autosuggestions
fi

# ---------------------------------------------------------
# 3.1 TAB COMPLETION & GHOST WORD ADVANCE
# Single tap of Tab accepts one ghost word forward;
# reassesses dropdown menu options after every word forward.
# ---------------------------------------------------------
_tab_forward_ghost_or_complete() {
  # 1. Ezlo ghost-text partial acceptance:
  if [[ -n "${_ezlo_ghost:-}" && $CURSOR -eq ${#BUFFER} ]]; then
    _ezlo_on_redraw 2>/dev/null || true
    local -i orig_len=${#BUFFER}
    local full_text="$BUFFER$_ezlo_ghost"
    BUFFER="$full_text"
    zle .forward-word
    local -i new_len=$CURSOR
    local remaining_ghost=""
    if (( new_len > orig_len )); then
      remaining_ghost="${full_text[$((new_len + 1)),$#full_text]}"
      BUFFER="${full_text[1,$new_len]}"
      CURSOR=$new_len
    else
      BUFFER="${full_text[1,$orig_len]}"
      CURSOR=$orig_len
    fi
    zle list-choices 2>/dev/null || true
    _ezlo_ghost="$remaining_ghost"
    _ezlo_on_redraw 2>/dev/null || true
    zle -R 2>/dev/null || true
    return 0
  fi

  # 2. zsh-autosuggestions partial acceptance:
  if (( $+widgets[autosuggest-accept] )) && [[ -n "${POSTDISPLAY:-}" && $CURSOR -eq ${#BUFFER} ]]; then
    local -i orig_len=${#BUFFER}
    local full_text="$BUFFER$POSTDISPLAY"
    BUFFER="$full_text"
    zle .forward-word
    local -i new_len=$CURSOR
    local remaining_ghost=""
    if (( new_len > orig_len )); then
      remaining_ghost="${full_text[$((new_len + 1)),$#full_text]}"
      BUFFER="${full_text[1,$new_len]}"
      CURSOR=$new_len
    else
      BUFFER="${full_text[1,$orig_len]}"
      CURSOR=$orig_len
    fi
    zle list-choices 2>/dev/null || true
    POSTDISPLAY="$remaining_ghost"
    if (( $+functions[_zsh_autosuggest_highlight_apply] )); then
      _zsh_autosuggest_highlight_apply
    fi
    zle -R 2>/dev/null || true
    return 0
  fi

  # 3. Standard Tab completion fallback (fzf-completion or expand-or-complete)
  if (( $+widgets[fzf-completion] )); then
    zle fzf-completion
  else
    zle ${fzf_default_completion:-expand-or-complete}
  fi
}
zle -N _tab_forward_ghost_or_complete
bindkey '^I' _tab_forward_ghost_or_complete

# ---------------------------------------------------------
# 4. HISTORY NAVIGATION & SEARCH (Bash / Emacs Mode)
# [AI-GUARD: DO NOT REMAP OR OVERRIDE Ctrl+N / Ctrl+P]
# ---------------------------------------------------------
bindkey '^P' up-line-or-history               # Ctrl+P -> Previous history (like Bash)
bindkey '^N' down-line-or-history             # Ctrl+N -> Next history (like Bash)
bindkey '^[[A' history-substring-search-up    # Up arrow -> Search history
bindkey '^[[B' history-substring-search-down  # Down arrow -> Search history

# ---------------------------------------------------------
# 5. NATURAL LANGUAGE COMMAND TRANSLATION (Gemini API)
# ---------------------------------------------------------
_ezlo_ai_query() {
  if [[ -z "$BUFFER" ]]; then
    return
  fi

  local original_query="$BUFFER"
  local translate_bin="${commands[ezlo-ai-translate]:-$HOME/.local/bin/ezlo-ai-translate}"

  if [[ ! -x "$translate_bin" ]]; then
    zle -M "ezlo-ai-translate not found or not executable."
    return
  fi

  zle -M "Translating via Gemini API..."

  local translated_cmd
  translated_cmd=$("$translate_bin" "$original_query")

  if [[ -n "$translated_cmd" ]]; then
    BUFFER="$translated_cmd"
    CURSOR=$#BUFFER
    zle -M "Translated: $original_query"
  else
    zle -M "Translation failed or empty output."
  fi
}
zle -N _ezlo_ai_query
bindkey '^[k' _ezlo_ai_query                  # Alt+K -> Translate prompt via Gemini API


#-------------------------------------------------
# 6. EZLO EXPLAIN: AUTOSAVE IMPORT USING SPEC_TOOL
#-------------------------------------------------

ezlo-add() {
  if [[ -z "${1:-}" ]]; then
    echo "Usage: ezlo-add <tool-name>" >&2
    return 1
  fi

  if ! command -v ezlo >/dev/null 2>&1; then
    echo "Error: ezlo binary not found in PATH." >&2
    return 1
  fi

  ezlo import "$1" || return 1

  local src="$HOME/.cache/ezlo/generated/${1}.ezlo"
  local dest_dir="${EZLO_CONFIG_DIR:-${ZDOTDIR:-$HOME/.config/zsh}/ezlo}/specs"

  mkdir -p "$dest_dir"
  if [[ -f "$src" ]]; then
    mv "$src" "$dest_dir/${1}.ezlo" && echo "Permanent spec saved: $dest_dir/${1}.ezlo"
  else
    echo "Error: Generated spec not found at $src" >&2
    return 1
  fi
}
