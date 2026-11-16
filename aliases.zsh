# Better ls
alias ls='eza --icons'

# Detailed listing
alias ll='eza -lh --icons --git'

# Detailed listing including hidden files
alias la='eza -lah --icons --git'

# Tree view
alias tree='eza --tree --icons'

# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls

# Better cat
if command -v batcat >/dev/null 2>&1; then
  alias cat='batcat'
elif command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi

# Better fd
if command -v fdfind >/dev/null 2>&1; then
  alias fd='fdfind'
fi

# =========================================================
# Core utilities
# =========================================================

# alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# =========================================================
# Navigation
# =========================================================

alias -- -='cd -'  # -- prevents - being parsed as a flag; cd - jumps to previous directory

# =========================================================
# Editor
# =========================================================

alias vim='nvim'

# =========================================================
# Git
# =========================================================

alias glog='PAGER="less -F -X" git log'                              # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'
alias dotfiles='git -C "${ZDOTDIR:-$HOME/.config/zsh}"'

# =========================================================
# Antigravity / Haven MCP Notifications
# =========================================================

alias haven-notify='/vm-storage/haven-mcp/bin/haven-notify.py'

# =========================================================
# PC Controls MCP Server
# =========================================================

alias pc-controls-mcp='/vm-storage/AI/pandora-framework-hud/openakita-env/bin/python3 /vm-storage/AI/pandora-framework-hud/scripts/pc_controls_mcp.py'

# =========================================================
# OpenAkita Desktop
# =========================================================

alias openakita="/vm-storage/opt/openakita-desktop/launch.sh"

# =========================================================
# AI Command Center / Local Qwen3-8B Agents
# =========================================================

alias cc-agent='python3 /home/pandora/command-center/bin/cc_local_agent.py'
alias local-chat='python3 /home/pandora/command-center/bin/cc_local_agent.py --mode chat -i'
alias local-chat-new='python3 /home/pandora/command-center/bin/cc_local_agent.py --mode chat --new -i'
alias local-sysadmin='python3 /home/pandora/command-center/bin/cc_local_agent.py --mode sysadmin -i'
alias local-netsec='python3 /home/pandora/command-center/bin/cc_local_agent.py --mode netsec -i'
alias local-unified='python3 /home/pandora/command-center/bin/cc_local_agent.py --mode unified -i'
alias local-audit='python3 /home/pandora/command-center/bin/cc_local_agent.py --mode unified -p audit'
alias local-netsec-audit='python3 /home/pandora/command-center/bin/cc_local_agent.py --mode netsec -p audit'
alias netsec='python3 /home/pandora/command-center/bin/netsec_cli.py'

# =========================================================
# Safe Crisis Power-Down / Preservation
# =========================================================

alias safe-powerdown='bash /home/pandora/command-center/bin/safe_powerdown.sh'
alias safe-powerdown-dry='bash /home/pandora/command-center/bin/safe_powerdown.sh --dry-run'
alias safe-powerdown-5m='bash /home/pandora/command-center/bin/safe_powerdown.sh --delay 5'

