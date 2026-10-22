# Completions, direnv, fzf, zoxide and the prompt.
# Every `tool init` is cached (see cached_source in ~/.bashrc).

# Completions load on first <Tab> per command, not at startup.
# Homebrew drops ~35 scripts into etc/bash_completion.d, which bash-completion
# would source eagerly (~40 ms). Link them into a lazy-load directory instead.
_brew_comp=${HOMEBREW_PREFIX:-/nonexistent}/etc/bash_completion.d
_lazy_comp=$BASH_CACHE/completion/completions
if [[ -d $_brew_comp && ( ! -e $_lazy_comp/.stamp || $_brew_comp -nt $_lazy_comp/.stamp ) ]]; then
  rm -rf "$_lazy_comp" && mkdir -p "$_lazy_comp"
  for _f in "$_brew_comp"/*; do
    _n=${_f##*/}; _n=${_n%.bash}; _n=${_n%.sh}; _n=${_n%-completion}
    ln -sf "$_f" "$_lazy_comp/$_n"
  done
  : >"$_lazy_comp/.stamp"
fi
export BASH_COMPLETION_COMPAT_DIR=/nonexistent
export BASH_COMPLETION_USER_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion:$BASH_CACHE/completion
[[ -r ${HOMEBREW_PREFIX:-/nonexistent}/etc/profile.d/bash_completion.sh ]] &&
  . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
unset _brew_comp _lazy_comp _f _n

# direnv, but only re-evaluated after a `cd` or inside a direnv directory,
# instead of a direnv process before every prompt.
if hash direnv 2>/dev/null; then
  _direnv_hook() {
    local status=$?
    if [[ $PWD != "${_direnv_pwd-}" || -n ${DIRENV_DIR-} ]]; then
      _direnv_pwd=$PWD
      eval "$(direnv export bash)"
    fi
    return $status
  }
  direnv() { command direnv "$@"; local s=$?; _direnv_pwd=; return $s; }
  PROMPT_COMMAND="_direnv_hook${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi

is_agent_shell && return

cached_source fzf fzf fzf --bash         # Ctrl-R history, Ctrl-T files, Alt-C dirs
cached_source zoxide zoxide zoxide init bash # z, zi
[[ -r ~/.iterm2_shell_integration.bash ]] && . ~/.iterm2_shell_integration.bash

# Starship last: it wraps PROMPT_COMMAND. Its command timer runs the
# `starship` binary in a subshell before and after every command; bash 5's
# $EPOCHREALTIME gives the same milliseconds without a process.
_starship_init() {
  local now='${EPOCHREALTIME/./}/1000'
  starship init bash --print-full-init | sed \
    -e "s|\"\$(starship_preexec_ps0)\"|$now|" \
    -e "s|\$([^()]*starship time)|\$(( $now ))|g"
}
cached_source starship starship _starship_init
