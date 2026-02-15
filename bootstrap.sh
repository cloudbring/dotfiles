#!/bin/bash
# Bootstrap script for fresh Linux/macOS systems
# Installs dependencies and applies chezmoi dotfiles

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}[bootstrap]${NC} $1"; }
err() {
	echo -e "${RED}[error]${NC} $1"
	exit 1
}

detect_os() {
	if [[ "$(uname)" == "Darwin" ]]; then
		OS="macos"
	elif [[ "$(uname)" == "Linux" ]]; then
		OS="linux"
		if command -v apt-get &>/dev/null; then
			DISTRO="debian"
		elif command -v dnf &>/dev/null; then
			DISTRO="fedora"
		elif command -v pacman &>/dev/null; then
			DISTRO="arch"
		fi
	else
		err "Unsupported OS: $(uname)"
	fi
	log "Detected: $OS (${DISTRO:-generic})"
}

install_deps_macos() {
	log "Installing Homebrew packages..."

	if ! command -v brew &>/dev/null; then
		log "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	brew install git zsh nvim starship eza bat zoxide fzf direnv
	brew install --cask 1password-cli 2>/dev/null || brew install 1password-cli
}

install_deps_debian() {
	log "Installing apt packages..."
	sudo apt-get update
	sudo apt-get install -y git zsh curl wget build-essential

	# Install newer neovim from appimage or ppa
	if ! command -v nvim &>/dev/null || [[ "$(nvim --version | head -1)" < "v0.10" ]]; then
		log "Installing Neovim 0.11+..."
		sudo add-apt-repository -y ppa:neovim-ppa/unstable 2>/dev/null || true
		sudo apt-get update
		sudo apt-get install -y neovim
	fi

	# Install other tools
	sudo apt-get install -y fzf direnv

	# Install starship
	if ! command -v starship &>/dev/null; then
		log "Installing Starship..."
		curl -sS https://starship.rs/install.sh | sh -s -- --yes
	fi

	# Install eza (modern ls) - use GitHub releases for better ARM support
	if ! command -v eza &>/dev/null; then
		log "Installing eza..."
		ARCH=$(uname -m)
		case $ARCH in
		x86_64) EZA_ARCH="x86_64" ;;
		aarch64 | arm64) EZA_ARCH="aarch64" ;;
		*) log "Unknown arch $ARCH, skipping eza" && return ;;
		esac
		EZA_URL=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest |
			grep "browser_download_url.*${EZA_ARCH}-unknown-linux-gnu.tar.gz" | cut -d'"' -f4 | head -1)
		if [ -n "$EZA_URL" ]; then
			mkdir -p ~/.local/bin
			curl -sL "$EZA_URL" | tar xzf - -C ~/.local/bin --strip-components=1 ./eza
			chmod +x ~/.local/bin/eza
		else
			log "Could not find eza release for $EZA_ARCH, skipping"
		fi
	fi

	# Install bat
	sudo apt-get install -y bat
	mkdir -p ~/.local/bin
	ln -sf /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || true

	# Install zoxide
	if ! command -v zoxide &>/dev/null; then
		log "Installing zoxide..."
		curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
	fi
}

install_deps_fedora() {
	log "Installing dnf packages..."
	sudo dnf install -y git zsh curl wget neovim starship fzf direnv bat
	# eza
	sudo dnf copr enable -y atim/eza
	sudo dnf install -y eza
	# zoxide
	curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

install_deps_arch() {
	log "Installing pacman packages..."
	sudo pacman -S --noconfirm git zsh curl wget neovim starship eza bat zoxide fzf direnv
}

install_deps() {
	case "$OS" in
	macos) install_deps_macos ;;
	linux)
		case "$DISTRO" in
		debian) install_deps_debian ;;
		fedora) install_deps_fedora ;;
		arch) install_deps_arch ;;
		*) err "Unsupported Linux distro" ;;
		esac
		;;
	esac
}

install_chezmoi() {
	if ! command -v chezmoi &>/dev/null; then
		log "Installing chezmoi..."
		sh -c "$(curl -fsLS get.chezmoi.io)"
	fi
}

apply_dotfiles() {
	if [ "${SKIP_CHEZMOI:-0}" = "1" ]; then
		log "Skipping chezmoi (SKIP_CHEZMOI=1)"
		return
	fi

	log "Applying dotfiles with chezmoi..."

	if [ ! -d "$HOME/.local/share/chezmoi" ]; then
		log "Initializing chezmoi from GitHub..."
		chezmoi init --apply https://github.com/cloudbring/dotfiles.git
	else
		log "Applying existing chezmoi config..."
		chezmoi apply
	fi
}

change_shell() {
	if [[ "$SHELL" != *"zsh" ]]; then
		log "Changing default shell to zsh..."
		sudo chsh -s "$(which zsh)" "$USER" 2>/dev/null || true
	fi
}

main() {
	log "Starting bootstrap..."

	detect_os
	install_deps
	install_chezmoi
	apply_dotfiles
	change_shell

	log "Bootstrap complete! Restart your shell or run: exec zsh"
}

main "$@"
