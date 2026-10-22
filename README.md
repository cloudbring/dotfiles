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

## Speed

Measured on an M-series Mac (bare `bash -i` is ~6 ms):

| | time |
|---|---|
| New terminal (interactive login shell) | ~26 ms |
| Agent command (`bash -lc …`) | ~7 ms |
| Prompt redraw, git + node project | ~15 ms |

How:

- `.bash_profile` starts no processes: `brew shellenv` and mise's shim PATH are inlined.
- Each `tool init` (fzf, zoxide, starship, vivid) is cached in `~/.cache/bash/`
  and regenerated when the tool or Homebrew changes. `reshell` clears it.
- Homebrew's ~35 bash completions load on first <Tab>, not at startup (saves ~40 ms).
- No per-prompt hooks that start processes: mise uses shims instead of
  `mise activate`, direnv only runs after `cd`, and starship's command timer
  uses `$EPOCHREALTIME` instead of running `starship time` twice per command.
- starship shows versions only where they're cheap; node and bun show an icon,
  because asking `node` for its version costs ~50 ms per prompt.

## Runtimes

[mise](https://mise.jdx.dev) replaces nvm, pyenv and SDKMAN. It reads `.nvmrc`,
`.node-version`, `.python-version`, `.tool-versions` and `mise.toml`, and works
through shims, so it costs nothing per prompt and agents get the same versions.
`mise [env]` variables are not loaded into the shell; use direnv for those.
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
