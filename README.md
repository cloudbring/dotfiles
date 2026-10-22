# Dotfiles

Bash setup for macOS and Linux, managed by [chezmoi](https://www.chezmoi.io/).

## Layout

```
.chezmoidata.toml                               # public values (SSH signing key)
run_onchange_before_install-packages-darwin.sh.tmpl  # Brewfile; re-runs when the list changes
bootstrap.sh                                    # fresh machine: deps, chezmoi, chsh to bash
dot_bash_profile.tmpl   → ~/.bash_profile       # environment: PATH, Homebrew, mise shims
dot_bashrc              → ~/.bashrc             # interactive: history, shopts, loads ~/.config/bash/*.sh
dot_config/bash/
  10-colors.sh          # LS_COLORS (vivid), bat man pages, grep/gcc/python colors
  20-tools.sh           # completions, mise, direnv, fzf, zoxide, starship
  30-aliases.sh
  40-functions.sh
  50-secrets.sh         # opx: run a command with secrets from 1Password
dot_config/op/secrets.env                       # op:// references only, no values
private_dot_ssh/config.tmpl                     # all keys via the 1Password SSH agent
dot_config/mise/config.toml                     # global runtime versions (node LTS)
dot_config/starship.toml                        # prompt
dot_config/nvim/                                # LazyVim
dot_gitconfig.tmpl                              # delta, zdiff3, SSH-signed commits via 1Password
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

Then in 1Password › Settings › Developer, turn on **Use the SSH agent** and
**Integrate with 1Password CLI**. `chezmoi apply` itself never needs 1Password.

## Secrets

Everything secret lives in 1Password. The repo and the disk hold only
`op://` references and public keys.

- **SSH**: keys are 1Password items served by its SSH agent. `~/.ssh` has no private keys.
- **Git signing**: commits and tags are signed with the same SSH key via `op-ssh-sign`.
  The public key is in `.chezmoidata.toml`.
- **API keys**: listed as references in `~/.config/op/secrets.env`. Nothing is
  exported into the shell, so agents and child processes never inherit them.
  `opx CMD…` runs one command with them; `op read op://…` fetches one value.
  Add a key: create the item in 1Password, add a `NAME=op://…` line.

## Daily use

```bash
chezmoi edit --apply ~/.bashrc   # or the `bashrc` alias
chezmoi diff                     # what would change
chezmoi update                   # pull and apply
reup                             # reload the current shell
```
