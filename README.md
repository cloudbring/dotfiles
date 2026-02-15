# Dotfiles

Managed by [chezmoi](https://www.chezmoi.io/).

## Structure

```
~/.local/share/chezmoi/
├── README.md                # This file
├── changelog/               # Detailed change log
│   └── 2025-02-15-setup.md
├── dot_zshrc                # ~/.zshrc
├── dot_zprofile             # ~/.zprofile
├── dot_zlogin               # ~/.zlogin
├── dot_gitconfig            # ~/.gitconfig
└── dot_config/
    ├── starship.toml        # Prompt configuration
    └── zsh/
        ├── aliases.sh       # Shell aliases (eza, bat, zoxide)
        ├── apikeys.sh.tmpl  # API keys (1Password template)
        ├── completions/     # Shell completions
        ├── functions/       # Custom functions
        ├── fzf.zsh          # FZF configuration
        └── iterm2.zsh       # iTerm2 integration
```

## Key Features

- **Lazy-loaded tools**: NVM, pyenv, SDKMAN load on first use (~1s startup)
- **1Password integration**: API keys stored securely, fetched via chezmoi templates
- **Modern replacements**: `eza` (ls), `bat` (cat), `zoxide` (cd)

## Commands

```bash
# Edit a dotfile
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply

# Check what changed
chezmoi diff

# Add a new file
chezmoi add ~/.newconfig

# Update from repo
chezmoi update
```

## Setup on New Machine

1. Install chezmoi: `brew install chezmoi`
2. Install 1Password CLI: `brew install op`
3. Authenticate: `op signin`
4. Initialize: `chezmoi init --apply https://github.com/YOUR_USERNAME/dotfiles.git`

## Secrets

API keys are stored in 1Password and fetched via chezmoi templates:
- OpenAI keys: `OpenAI` item in Personal vault
- OpenRouter: `OpenRouter` item in Personal vault
- Z.ai: `Z.ai` item in Personal vault
