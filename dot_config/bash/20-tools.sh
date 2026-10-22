# Completions, runtimes and prompt.

if [[ -r ${HOMEBREW_PREFIX:-/opt/homebrew}/etc/profile.d/bash_completion.sh ]]; then
  . "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/profile.d/bash_completion.sh"
fi

# mise: per-directory node/python/go/java versions (replaces nvm, pyenv, sdkman)
command -v mise >/dev/null && eval "$(mise activate bash)"
command -v direnv >/dev/null && eval "$(direnv hook bash)"

command -v op >/dev/null && source <(op completion bash)
[[ -r ~/.bun/completions/bun.bash ]] && . ~/.bun/completions/bun.bash

is_agent_shell && return

command -v fzf >/dev/null && eval "$(fzf --bash)"         # Ctrl-R, Ctrl-T, Alt-C
command -v zoxide >/dev/null && eval "$(zoxide init bash)" # z, zi
[[ -r ~/.iterm2_shell_integration.bash ]] && . ~/.iterm2_shell_integration.bash

# Starship last: it wraps PROMPT_COMMAND
command -v starship >/dev/null && eval "$(starship init bash)"
