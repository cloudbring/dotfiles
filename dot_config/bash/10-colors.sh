# Colors for ls/eza, grep, less, man, compilers and runtimes.
# Every tool here still turns color off when output isn't a terminal,
# so pipes and agents get plain text.

export CLICOLOR=1                       # BSD ls
export COLORTERM=${COLORTERM:-truecolor}
_ls_colors() { printf 'export LS_COLORS=%q\n' "$(vivid generate catppuccin-mocha)"; }
cached_source ls-colors-catppuccin-mocha vivid _ls_colors

export GREP_COLORS='mt=1;31'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export BAT_THEME=${BAT_THEME:-"Catppuccin Mocha"}
export PYTHON_COLORS=1                  # Python 3.13+ tracebacks and REPL

# Colored man pages through bat
if hash bat 2>/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT='-c'
fi

alias grep='grep --color=auto'
alias diff='diff --color=auto'
