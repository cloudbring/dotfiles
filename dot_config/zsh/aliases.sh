# Aliases

alias npmrc="nvim ~/.npmrc"
alias t="tmux"
alias tcfg="nvim ~/.tmux.conf"
alias vimrc="nvim ~/.config/nvim/init.vim"
alias zshcfg="nvim ~/.zshrc"

# REPLACEMENTS

# Eza (exa fork) to Replace ls
if command -v eza >/dev/null; then
	alias ls="eza"
	alias ll="eza -alh"
	alias la="eza -a"
	alias tree="eza --tree"
elif command -v exa >/dev/null; then
	alias ls="exa"
	alias ll="exa -alh"
	alias tree="exa --tree"
fi

# Bat replaces Cat
if command -v bat >/dev/null; then
	alias cat='bat'
fi

# Zoxide replaces cd
if command -v zoxide >/dev/null; then
	eval "$(zoxide init zsh)"
	# builtin alias z=__zoxide_z
	# builtin alias zi=__zoxide_zi
	if command -v z >/dev/null; then
		alias cd='z'
		alias zz='z -'
	fi
fi

alias gs='git status'
