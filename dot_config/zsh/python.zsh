# Python icu4c
  export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
  export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"

# For compilers to find icu4c you may need to set:
  export LDFLAGS="-L/opt/homebrew/opt/icu4c/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/icu4c/include"

# For pkg-config to find icu4c you may need to set:
  export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig"

# PyENV Python Version Manager
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)" # Pyenv-virtualenv Plugin
