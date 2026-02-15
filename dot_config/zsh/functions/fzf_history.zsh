keybindings="$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"

if [ -f "$keybindings" ]; then
  source "$keybindings"
  bindkey '^r' fzf-history-widget
fi