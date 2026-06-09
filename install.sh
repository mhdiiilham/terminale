#!/usr/bin/env bash
# install.sh — Bootstrap terminal config on a new Mac
#
# One-liner usage (after pushing to GitHub):
#   curl -fsSL https://raw.githubusercontent.com/mhdiiilham/sebash-duls/main/install.sh | bash
#
# Or clone and run locally:
#   git clone https://github.com/mhdiiilham/sebash-duls && cd sebash-duls && bash install.sh

set -e

# ── Config ────────────────────────────────────────────────────────────────────
GITHUB_USER="mhdiiilham"
GITHUB_REPO="sebash-duls"
BRANCH="main"
RAW="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$BRANCH"
# ─────────────────────────────────────────────────────────────────────────────

info()    { echo "  [+] $*"; }
success() { echo "  ✓  $*"; }
skip()    { echo "  –  $* (already installed, skipping)"; }
header()  { echo ""; echo "── $* ──"; }

# Idempotent brew helpers — skip if already installed
binstall() {
  if brew list --formula "$1" &>/dev/null || command -v "$1" &>/dev/null; then skip "$1"
  else brew install -q "$1"; fi
}
cinstall() {
  if brew list --cask "$1" &>/dev/null; then skip "$1"
  else brew install -q --cask "$1"; fi
}

echo ""
echo "Terminal config installer"
echo "========================="

# ── 1. Homebrew ───────────────────────────────────────────────────────────────
header "Homebrew"
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)"
fi
success "Homebrew ready"

# ── 2. Shell tools ────────────────────────────────────────────────────────────
header "Shell tools"
for pkg in \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  fzf \
  zoxide \
  direnv \
  btop \
  gh \
  jq \
  eza \
  bat \
  ripgrep \
  lazygit \
  httpie \
  mkcert; do
  binstall "$pkg"
done
success "Shell tools done"

# ── 3. Version managers ───────────────────────────────────────────────────────
header "Version managers"

# goenv — Go version manager
binstall goenv
success "goenv ready  (next: goenv install <x.y.z> && goenv global <x.y.z>)"

# nvm — installed via Homebrew so .zprofile sources it from /opt/homebrew/opt/nvm
binstall nvm
mkdir -p "$HOME/.nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
success "nvm ready"

# Node LTS
if ! command -v node &>/dev/null; then
  info "Installing Node.js LTS..."
  nvm install --lts
  nvm use --lts
fi
success "Node $(node -v) ready"

# pnpm
if ! command -v pnpm &>/dev/null; then
  npm install -g pnpm
fi
success "pnpm ready"

# uv — Python package manager
if ! command -v uv &>/dev/null; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
success "uv ready"

# ── 4. Go tools ───────────────────────────────────────────────────────────────
header "Go tools"
binstall golangci-lint
success "Go tools done"

# ── 5. Apps ───────────────────────────────────────────────────────────────────
header "Apps"
for cask in \
  ghostty \
  zed \
  raycast \
  rectangle \
  orbstack \
  font-jetbrains-mono-nerd-font; do
  cinstall "$cask"
done
success "Apps done"

# ── 6. Oh My Zsh ─────────────────────────────────────────────────────────────
header "Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  skip "oh-my-zsh"
fi
success "Oh My Zsh ready"

# ── 7. Config files ───────────────────────────────────────────────────────────
header "Config files"

download() {
  local src="$1" dst="$2"
  local local_file
  local_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)/$(basename "$dst")"
  if [ -f "$local_file" ]; then
    cp "$local_file" "$dst"
  else
    curl -fsSL "$RAW/$src" -o "$dst"
  fi
}

download ".zshrc"         "$HOME/.zshrc"
download ".zprofile"      "$HOME/.zprofile"
download ".zshenv"        "$HOME/.zshenv"

mkdir -p "$HOME/.config/ghostty"
download "ghostty-config" "$HOME/.config/ghostty/config"

success "Config files in place"

# ── 8. Claude CLI ─────────────────────────────────────────────────────────────
header "Claude CLI"
if ! command -v claude &>/dev/null; then
  npm install -g @anthropic-ai/claude-code
else
  skip "claude"
fi
success "Claude CLI ready"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "============================================================"
echo "  All done! Next steps:"
echo ""
echo "  1. Open a new terminal (or: source ~/.zshrc)"
echo "  2. Pick a Go version:   goenv install <x.y.z> && goenv global <x.y.z>"
echo "  3. Log in to GitHub:    gh auth login"
echo "  4. Log in to Claude:    claude"
echo "  5. Launch Raycast:      open /Applications/Raycast.app"
echo "============================================================"
echo ""
