# sebash-duls

My terminal setup. One command to go from a fresh Mac to a fully configured dev environment.

## Quick install

```bash
curl -fsSL https://raw.githubusercontent.com/mhdiiilham/sebash-duls/main/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/mhdiiilham/sebash-duls && cd sebash-duls && bash install.sh
```

Already installed tools are automatically skipped — safe to run multiple times.

## What gets installed

### Shell

| Tool | What it does |
|---|---|
| [Oh My Zsh](https://ohmyzsh.sh) | zsh framework |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Fish-like grey suggestions as you type |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Commands turn green (valid) or red (invalid) live |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder — `Ctrl+R` history, `Ctrl+T` file picker |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart `cd` that learns your frequent directories |
| [direnv](https://direnv.net) | Auto-loads `.envrc` files per project directory |

### CLI utilities

| Tool | What it does |
|---|---|
| [eza](https://github.com/eza-community/eza) | Modern `ls` with colors, icons, and git status |
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlighting |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Faster `grep` — `rg` |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git — `lg` |
| [btop](https://github.com/aristocratsaurus/btop) | Beautiful real-time system monitor |
| [gh](https://cli.github.com) | GitHub CLI — PRs, issues, cloning from terminal |
| [jq](https://github.com/jqlang/jq) | JSON processor |
| [httpie](https://httpie.io) | Human-friendly HTTP client — `http GET localhost:8080/` |
| [mkcert](https://github.com/FiloSottile/mkcert) | Local HTTPS certificates in one command |

### Dev tools

| Tool | What it does |
|---|---|
| [goenv](https://github.com/go-env/goenv) | Go version manager |
| [golangci-lint](https://golangci-lint.run) | Go linter (runs 50+ linters at once) |
| [nvm](https://github.com/nvm-sh/nvm) | Node version manager |
| [pnpm](https://pnpm.io) | Fast Node package manager |
| [uv](https://github.com/astral-sh/uv) | Fast Python package manager |
| [Claude CLI](https://github.com/anthropics/claude-code) | Claude AI in the terminal |

### Apps

| App | What it does |
|---|---|
| [Ghostty](https://ghostty.org) | Terminal emulator |
| [Zed](https://zed.dev) | Editor |
| [Raycast](https://raycast.com) | App launcher, clipboard history, window management |
| [Rectangle](https://rectangleapp.com) | Window snapping with keyboard shortcuts |
| [OrbStack](https://orbstack.dev) | Lightweight Docker Desktop replacement — same `docker` and `docker compose` commands |
| JetBrainsMono Nerd Font | Font used in Ghostty (includes icons for eza) |

## Shell shortcuts

| Shortcut | Action |
|---|---|
| `→` or `Alt+Enter` | Accept autocomplete suggestion |
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy pick a file (inserts path) |
| `Ctrl+Right / Left` | Jump word by word |
| `Ctrl+Backspace` | Delete previous word |
| `Ctrl+Delete` | Delete next word |
| `Home / End` | Jump to start/end of line |
| `Ctrl+P / N` | Search history up/down |

## Aliases

| Alias | Expands to |
|---|---|
| `ls` | `eza --icons` |
| `ll` | `eza -lAF --icons --git` |
| `la` | `eza -A --icons` |
| `cat` | `bat` |
| `lg` | `lazygit` |
| `..` | `cd ..` |
| `...` | `cd ../..` |

## Config files

| File | Destination |
|---|---|
| `.zshrc` | `~/.zshrc` |
| `.zprofile` | `~/.zprofile` |
| `.zshenv` | `~/.zshenv` |
| `ghostty-config` | `~/.config/ghostty/config` |

## After install

```bash
# 1. Open a new terminal (or reload current one)
source ~/.zshrc

# 2. Pick a Go version
goenv install 1.23.0
goenv global 1.23.0

# 3. Log in to GitHub CLI
gh auth login

# 4. Log in to Claude
claude

# 5. Launch Raycast and set it as your default launcher
open /Applications/Raycast.app
```

## direnv usage

Add a `.envrc` to any project directory and it will be automatically loaded when you `cd` into it:

```bash
# .envrc
export DATABASE_URL="postgres://localhost/mydb"
export API_KEY="dev-key-123"
```

```bash
direnv allow   # run once to approve the .envrc
```

## Drag & drop files

In Ghostty, drag any file from Finder into the terminal window — its path gets inserted at the cursor automatically.

---

*Named after [@dmtrxw](https://github.com/dmtrxw)'s [sebats-duls](https://github.com/dmtrxw/sebats-duls). In his memory.*
