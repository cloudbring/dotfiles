# Secrets come from 1Password on demand; nothing is exported into the shell,
# so agents and child processes never inherit API keys.
#
#   opx CMD…        run CMD with every key in ~/.config/op/secrets.env
#   opx-env         list which variables opx provides (names only)
#   op read op://…  one value, e.g. inside a tool's own config

opx() { op run --env-file "$HOME/.config/op/secrets.env" -- "$@"; }
opx-env() { grep -E '^[A-Z_]+=' "$HOME/.config/op/secrets.env" | cut -d= -f1; }
