# Dotfiles

Bash setup for macOS and Linux, managed by [chezmoi](https://www.chezmoi.io/).

## Layout

```
.chezmoi.toml.tmpl                              # asks once: use 1Password for API keys?
run_onchange_before_install-packages-darwin.sh.tmpl  # Brewfile; re-runs when the list changes
bootstrap.sh                                    # fresh machine: deps, chezmoi, chsh to bash
dot_bash_profile.tmpl   → ~/.bash_profile       # environment: PATH, Homebrew, mise shims
dot_bashrc              → ~/.bashrc             # interactive: history, shopts, loads ~/.config/bash/*.sh
dot_config/bash/
  10-colors.sh          # LS_COLORS (vivid), bat man pages, grep/gcc/python colors
  20-tools.sh           # completions, mise, direnv, fzf, zoxide, starship
  30-aliases.sh
  40-functions.sh
  private_apikeys.sh.tmpl                       # 1Password → ~/.config/bash/apikeys.sh (0600)
dot_config/mise/config.toml                     # global runtime versions (node LTS)
dot_config/starship.toml                        # prompt
dot_config/nvim/                                # LazyVim
dot_gitconfig                                   # delta pager, zdiff3, rebase on pull
```

## Agent-friendly by design

LLM agents (Claude Code, Codex, Cursor, …) run commands through bash. Shells
where `AI_AGENT`, `CLAUDECODE`, `CODEX_SANDBOX`, `CURSOR_AGENT` or `GEMINI_CLI`
is set, `TERM=dumb`, or stdout is not a terminal get the same PATH and runtimes
as you, but none of the replacements: `cat`, `ls` and `cd` are the real commands
and there is no starship prompt.

## Runtimes

[mise](https://mise.jdx.dev) replaces nvm, pyenv and SDKMAN. It reads `.nvmrc`,
`.node-version`, `.python-version`, `.tool-versions` and `mise.toml`.
Interactive shells use `mise activate`; login and agent shells use mise shims.
Python projects use `uv`.

## New machine

```bash
curl -fsSL https://raw.githubusercontent.com/cloudbring/dotfiles/master/bootstrap.sh | bash
```

or, with Homebrew already installed:

```bash
brew install chezmoi
chezmoi init --apply cloudbring/dotfiles
echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells && chsh -s /opt/homebrew/bin/bash
```

For API keys, install the 1Password CLI, run `op signin`, then
`chezmoi init --promptBool onepassword=true --apply`.

## Daily use

```bash
chezmoi edit --apply ~/.bashrc   # or the `bashrc` alias
chezmoi diff                     # what would change
chezmoi update                   # pull and apply
reup                             # reload the current shell
```
