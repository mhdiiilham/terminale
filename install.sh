#!/usr/bin/env bash
# install.sh — Bootstrap terminal config on a new Mac
#
# Author : Muhammad Ilham <hi@muhammadilham.xyz>
# GitHub : https://github.com/mhdiiilham
# Website: https://muhammadilham.xyz
#
# One-liner usage:
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

binstall() {
  if brew list --formula "$1" &>/dev/null || command -v "$1" &>/dev/null; then skip "$1"
  else brew install -q "$1"; fi
}
cinstall() {
  if brew list --cask "$1" &>/dev/null; then skip "$1"
  else brew install -q --cask "$1"; fi
}

# ── Menu data ─────────────────────────────────────────────────────────────────
# Format: "TYPE|LABEL|ID"
# TYPE: H=header (not selectable), F=brew formula, C=brew cask, S=special
ENTRIES=(
  "H|── Shell Tools ──|"
  "F|fzf|fzf"
  "F|zoxide|zoxide"
  "F|zsh-autosuggestions|zsh-autosuggestions"
  "F|zsh-syntax-highlighting|zsh-syntax-highlighting"
  "F|direnv|direnv"
  "F|btop|btop"
  "F|gh (GitHub CLI)|gh"
  "F|jq|jq"
  "F|eza|eza"
  "F|bat|bat"
  "F|ripgrep|ripgrep"
  "F|lazygit|lazygit"
  "F|httpie|httpie"
  "F|mkcert|mkcert"
  "F|ffmpeg|ffmpeg"
  "F|imagemagick|imagemagick"
  "H|── Kubernetes & Infra ──|"
  "F|kubectl|kubectl"
  "F|helm|helm"
  "F|k9s (Kubernetes TUI)|k9s"
  "F|terraform|terraform"
  "H|── Cloud CLIs ──|"
  "F|awscli|awscli"
  "C|gcloud (Google Cloud)|google-cloud-sdk"
  "H|── Local Databases ──|"
  "F|postgresql|postgresql"
  "F|redis|redis"
  "H|── Version Managers ──|"
  "F|goenv|goenv"
  "S|nvm + Node LTS + pnpm|nvm-node-pnpm"
  "S|uv (Python pkg manager)|uv"
  "H|── Go Tools ──|"
  "F|golangci-lint|golangci-lint"
  "F|gopls (Go LSP)|gopls"
  "F|delve (debugger)|delve"
  "F|air (live reload)|air"
  "F|mockgen|mockgen"
  "F|goose (migrations)|goose"
  "F|evans (gRPC client)|evans"
  "H|── Apps ──|"
  "C|Ghostty (terminal)|ghostty"
  "C|Zed (editor)|zed"
  "C|Raycast (launcher)|raycast"
  "C|Rectangle (window manager)|rectangle"
  "C|OrbStack (containers)|orbstack"
  "C|JetBrains Mono Nerd Font|font-jetbrains-mono-nerd-font"
  "C|Postman (API testing)|postman"
  "C|TablePlus (DB GUI)|tableplus"
  "C|Insomnia (REST/GraphQL)|insomnia"
  "C|Figma (design)|figma"
  "C|Slack|slack"
  "C|Discord|discord"
  "C|1Password|1password"
  "C|Notion|notion"
  "H|── Setup ──|"
  "S|Oh My Zsh|ohmyzsh"
  "S|Config: .zshrc|config-zshrc"
  "S|Config: .zprofile|config-zprofile"
  "S|Config: .zshenv|config-zshenv"
  "S|Config: ghostty|config-ghostty"
  "S|Claude CLI|claude-cli"
)

# Build selected map (default: none) and group data
# declare -a (indexed) not -A (associative) — macOS ships bash 3.2 which lacks -A
declare -a SELECTED
GROUPS=()       # group display names
GROUP_ITEMS=()  # space-separated ENTRIES indices per group

_cur_name="" ; _cur_items=""
for _i in "${!ENTRIES[@]}"; do
  IFS='|' read -r _t _label _ <<< "${ENTRIES[$_i]}"
  if [[ "$_t" == "H" ]]; then
    [[ -n "$_cur_name" ]] && { GROUPS+=("$_cur_name"); GROUP_ITEMS+=("$_cur_items"); }
    _cur_name="$_label" ; _cur_items=""
  else
    SELECTED[$_i]=0
    _cur_items="$_cur_items $_i"
  fi
done
[[ -n "$_cur_name" ]] && { GROUPS+=("$_cur_name"); GROUP_ITEMS+=("$_cur_items"); }
unset _i _t _label _cur_name _cur_items

# Basic set — original tools only (pre-expansion)
BASIC_IDS=(
  fzf zoxide zsh-autosuggestions zsh-syntax-highlighting direnv btop gh jq
  eza bat ripgrep lazygit httpie mkcert goenv nvm-node-pnpm uv golangci-lint
  ghostty zed raycast rectangle orbstack font-jetbrains-mono-nerd-font
  ohmyzsh config-zshrc config-zprofile config-zshenv config-ghostty claude-cli
)

# ── Terminal helpers ───────────────────────────────────────────────────────────
_KEY=""
_read_key() {
  local _esc=$'\x1b' _rest=""
  IFS= read -r -s -n1 _KEY
  if [[ "$_KEY" == "$_esc" ]]; then
    IFS= read -r -s -n2 -t 0.15 _rest || true
    _KEY="${_KEY}${_rest}"
  fi
}

_restore() { tput cnorm 2>/dev/null || true; }
trap '_restore' EXIT INT TERM

# ── Mode selection screen ──────────────────────────────────────────────────────
MODE="custom"
choose_mode() {
  tput civis 2>/dev/null || true
  while true; do
    clear
    echo ""
    echo "  ┌─────────────────────────────────────┐"
    echo "  │            SEBASH DULS              │"
    echo "  │      Terminal config installer      │"
    echo "  └─────────────────────────────────────┘"
    echo ""
    printf "  \033[2mby Muhammad Ilham\033[0m\n"
    printf "  \033[2m   github.com/mhdiiilham  ·  muhammadilham.xyz  ·  hi@muhammadilham.xyz\033[0m\n"
    echo ""
    printf "  \033[1m[b]\033[0m  Basic   \033[2m— original set (shell, go, apps, dotfiles)\033[0m\n"
    printf "  \033[1m[c]\033[0m  Custom  \033[2m— pick tool by tool, category by category\033[0m\n"
    echo ""
    printf "  \033[2m[q]  Quit\033[0m\n"
    echo ""
    _read_key
    case "$_KEY" in
      b|B) MODE="basic";  break ;;
      c|C) MODE="custom"; break ;;
      q|Q) _restore; clear; echo "Aborted."; exit 0 ;;
    esac
  done
}

apply_basic() {
  for _i in "${!ENTRIES[@]}"; do
    IFS='|' read -r _t _ _id <<< "${ENTRIES[$_i]}"
    [[ "$_t" == "H" ]] && continue
    for _bid in "${BASIC_IDS[@]}"; do
      [[ "$_id" == "$_bid" ]] && { SELECTED[$_i]=1; break; }
    done
  done
  unset _i _t _id _bid
}

# ── Paginated category picker ──────────────────────────────────────────────────
paginate() {
  local ESC=$'\x1b'
  local UP="${ESC}[A" DOWN="${ESC}[B" RIGHT="${ESC}[C" LEFT="${ESC}[D"
  local total="${#GROUPS[@]}"
  local page=0

  while true; do
    local name="${GROUPS[$page]}"
    read -ra idxs <<< "${GROUP_ITEMS[$page]}"
    local max=$(( ${#idxs[@]} - 1 ))
    local cur=0

    while true; do
      clear

      # ── header bar ────────────────────────────────────────────────────────
      local cols; cols=$(tput cols 2>/dev/null || echo 60)
      # progress dots
      local dots="" p=0
      while (( p < total )); do
        if (( p == page )); then dots="${dots}●"; else dots="${dots}○"; fi
        (( p++ )) || true
      done
      printf "\n  \033[1m%-*s\033[0m  \033[2m%s\033[0m\n\n" \
        30 "$name" "$dots"

      # ── count selected in this page ───────────────────────────────────────
      local sel_count=0
      for idx in "${idxs[@]}"; do
        [ "${SELECTED[$idx]:-0}" -eq 1 ] && (( sel_count++ )) || true
      done
      printf "  \033[2m%d / %d selected\033[0m\n\n" "$sel_count" "${#idxs[@]}"

      # ── item list ─────────────────────────────────────────────────────────
      local pi=0
      for idx in "${idxs[@]}"; do
        IFS='|' read -r _ label _ <<< "${ENTRIES[$idx]}"
        local mark; [ "${SELECTED[$idx]:-0}" -eq 1 ] && mark="\033[32m✓\033[0m" || mark=" "
        if [ "$pi" -eq "$cur" ]; then
          printf "  \033[7m › %s  %-38s\033[0m\n" "$mark" "$label"
        else
          printf "    %s  %-38s\n" "$mark" "$label"
        fi
        (( pi++ )) || true
      done

      # ── footer hint ───────────────────────────────────────────────────────
      echo ""
      if (( page < total - 1 )); then
        printf "  \033[2mspace toggle · a all · n none · → next · ← back · q quit\033[0m\n"
      else
        printf "  \033[2mspace toggle · a all · n none · enter confirm · ← back · q quit\033[0m\n"
      fi
      echo ""

      _read_key
      if   [[ "$_KEY" == "$UP"   || "$_KEY" == "k" ]]; then
        if (( cur > 0 )); then cur=$(( cur - 1 )); fi
      elif [[ "$_KEY" == "$DOWN" || "$_KEY" == "j" ]]; then
        if (( cur < max )); then cur=$(( cur + 1 )); fi
      elif [[ "$_KEY" == " " ]]; then
        local tidx="${idxs[$cur]}"
        [ "${SELECTED[$tidx]:-0}" -eq 1 ] && SELECTED[$tidx]=0 || SELECTED[$tidx]=1
      elif [[ "$_KEY" == "a" || "$_KEY" == "A" ]]; then
        for tidx in "${idxs[@]}"; do SELECTED[$tidx]=1; done
      elif [[ "$_KEY" == "n" || "$_KEY" == "N" ]]; then
        for tidx in "${idxs[@]}"; do SELECTED[$tidx]=0; done
      elif [[ "$_KEY" == "$RIGHT" || "$_KEY" == "" || "$_KEY" == $'\n' || "$_KEY" == "l" ]]; then
        if (( page < total - 1 )); then page=$(( page + 1 )); break
        else return; fi
      elif [[ "$_KEY" == "$LEFT" || "$_KEY" == "h" ]]; then
        if (( page > 0 )); then page=$(( page - 1 )); break; fi
      elif [[ "$_KEY" == "q" || "$_KEY" == "Q" ]]; then
        _restore; clear; echo "Aborted."; exit 0
      fi
    done
  done
}

# ── Run interactive flow ───────────────────────────────────────────────────────
# Redirect stdin to /dev/tty so the menu works even when piped via curl | bash
if [ -e /dev/tty ]; then
  exec 0< /dev/tty
  choose_mode
  [[ "$MODE" == "basic" ]] && apply_basic || paginate
  _restore; clear; trap - EXIT INT TERM
else
  echo "No TTY available — cannot show interactive menu."
  exit 1
fi

# Print summary
echo ""
echo "Installing:"
for i in "${!ENTRIES[@]}"; do
  IFS='|' read -r type label _ <<< "${ENTRIES[$i]}"
  [[ "$type" == "H" ]] && continue
  if [ "${SELECTED[$i]:-0}" -eq 1 ]; then
    echo "  ✓  $label"
  else
    echo "  –  $label (skipped)"
  fi
done
echo ""

# ── Helpers for special installs ──────────────────────────────────────────────
install_nvm_node_pnpm() {
  binstall nvm
  mkdir -p "$HOME/.nvm"
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  success "nvm ready"
  if ! command -v node &>/dev/null; then
    info "Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
  fi
  success "Node $(node -v) ready"
  if ! command -v pnpm &>/dev/null; then
    npm install -g pnpm
  fi
  success "pnpm ready"
}

install_uv() {
  if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
  else
    skip "uv"
  fi
  success "uv ready"
}

install_ohmyzsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    skip "oh-my-zsh"
  fi
  success "Oh My Zsh ready"
}

_dl() {
  local src="$1" dst="$2"
  local local_file
  local_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)/$(basename "$dst")"
  if [ -f "$local_file" ]; then cp "$local_file" "$dst"
  else curl -fsSL "$RAW/$src" -o "$dst"; fi
}

install_config_zshrc()    { _dl ".zshrc"         "$HOME/.zshrc";    success ".zshrc applied"; }
install_config_zprofile() { _dl ".zprofile"       "$HOME/.zprofile"; success ".zprofile applied"; }
install_config_zshenv()   { _dl ".zshenv"         "$HOME/.zshenv";   success ".zshenv applied"; }
install_config_ghostty()  {
  mkdir -p "$HOME/.config/ghostty"
  _dl "ghostty-config" "$HOME/.config/ghostty/config"
  success "ghostty config applied"
}

install_claude_cli() {
  if ! command -v claude &>/dev/null; then
    npm install -g @anthropic-ai/claude-code
  else
    skip "claude"
  fi
  success "Claude CLI ready"
}

# ── 1. Homebrew (always required) ─────────────────────────────────────────────
header "Homebrew"
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)"
fi
success "Homebrew ready"

# ── 2. Install selected items ─────────────────────────────────────────────────
for i in "${!ENTRIES[@]}"; do
  IFS='|' read -r type label id <<< "${ENTRIES[$i]}"
  [[ "$type" == "H" ]] && continue
  [ "${SELECTED[$i]:-0}" -eq 0 ] && continue

  # Note: can't use "case $type|$id in F|*)" — | in case is OR, not literal pipe
  if [[ "$type" == "F" ]]; then
    header "$label"; binstall "$id"
  elif [[ "$type" == "C" ]]; then
    header "$label"; cinstall "$id"
  elif [[ "$type" == "S" ]]; then
    header "$label"
    case "$id" in
      nvm-node-pnpm)   install_nvm_node_pnpm ;;
      uv)              install_uv ;;
      ohmyzsh)         install_ohmyzsh ;;
      config-zshrc)    install_config_zshrc ;;
      config-zprofile) install_config_zprofile ;;
      config-zshenv)   install_config_zshenv ;;
      config-ghostty)  install_config_ghostty ;;
      claude-cli)      install_claude_cli ;;
    esac
  fi
done

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
