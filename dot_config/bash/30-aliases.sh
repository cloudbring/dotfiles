# Aliases. Tool replacements are for humans only; agents get the real commands.

alias reup='source ~/.bash_profile'
alias bashrc='chezmoi edit --apply ~/.bashrc'
alias cz='chezmoi'
alias gs='git status'
alias t='tmux'
alias v='nvim'

is_agent_shell && return

if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first'
  alias ll='eza -alh --git --icons=auto --group-directories-first'
  alias la='eza -a'
  alias lt='eza --tree --level=2 --icons=auto'
else
  alias ll='ls -alFh'
  alias la='ls -A'
fi

command -v bat >/dev/null && alias cat='bat --paging=never'
