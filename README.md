# sebash-duls

My terminal setup. One command to go from a fresh Mac to a fully configured dev environment.

**Author:** Muhammad Ilham — [muhammadilham.xyz](https://muhammadilham.xyz) · [hi@muhammadilham.xyz](mailto:hi@muhammadilham.xyz) · [@mhdiiilham](https://github.com/mhdiiilham)

---

## Quick install

```bash
curl -fsSL https://raw.githubusercontent.com/mhdiiilham/sebash-duls/main/install.sh | bash
```

No need to clone — the script fetches everything it needs from GitHub automatically.

Or run locally if you've already cloned:

```bash
git clone https://github.com/mhdiiilham/sebash-duls && cd sebash-duls && bash install.sh
```

Already installed tools are automatically skipped — safe to run multiple times.

## How it works

The installer opens an interactive menu with two modes:

**Basic** — installs the original curated set (shell tools, Go, apps, dotfiles) in one shot.

**Custom** — steps through each category one page at a time. Toggle individual tools with `space`, then press `→` to move to the next category.

```
  ┌─────────────────────────────────────┐
  │      Terminal config installer      │
  └─────────────────────────────────────┘

  [b]  Basic   — original set (shell, go, apps, dotfiles)
  [c]  Custom  — pick tool by tool, category by category

  [q]  Quit
```

---

## What's available

### Shell Tools

| Tool | What it does |
|---|---|
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder — `Ctrl+R` history, `Ctrl+T` file picker |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart `cd` that learns your frequent directories |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Fish-like grey suggestions as you type |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Commands turn green (valid) or red (invalid) live |
| [direnv](https://direnv.net) | Auto-loads `.envrc` files per project directory |
| [btop](https://github.com/aristocratsaurus/btop) | Real-time system monitor |
| [gh](https://cli.github.com) | GitHub CLI — PRs, issues, cloning from terminal |
| [jq](https://github.com/jqlang/jq) | JSON processor |
| [eza](https://github.com/eza-community/eza) | Modern `ls` with colors, icons, git status |
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlighting |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Faster `grep` — `rg` |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |
| [httpie](https://httpie.io) | Human-friendly HTTP client — `http GET localhost:8080/` |
| [mkcert](https://github.com/FiloSottile/mkcert) | Local HTTPS certificates in one command |
| [ffmpeg](https://ffmpeg.org) | Audio/video processing |
| [imagemagick](https://imagemagick.org) | Image manipulation |

### Kubernetes & Infra

| Tool | What it does |
|---|---|
| [kubectl](https://kubernetes.io/docs/reference/kubectl/) | Kubernetes CLI |
| [helm](https://helm.sh) | Kubernetes package manager |
| [k9s](https://k9scli.io) | Terminal UI for Kubernetes clusters |
| [terraform](https://www.terraform.io) | Infrastructure as code |

### Cloud CLIs

| Tool | What it does |
|---|---|
| [awscli](https://aws.amazon.com/cli/) | AWS command line interface |
| [gcloud](https://cloud.google.com/sdk/gcloud) | Google Cloud CLI |

### Local Databases

| Tool | What it does |
|---|---|
| [postgresql](https://www.postgresql.org) | PostgreSQL database server |
| [redis](https://redis.io) | Redis in-memory data store |

### Version Managers

| Tool | What it does |
|---|---|
| [goenv](https://github.com/go-env/goenv) | Go version manager |
| nvm + Node LTS + pnpm | Node version manager, LTS Node, fast package manager |
| [uv](https://github.com/astral-sh/uv) | Fast Python package manager |

### Go Tools

| Tool | What it does |
|---|---|
| [golangci-lint](https://golangci-lint.run) | Runs 50+ Go linters at once |
| [gopls](https://pkg.go.dev/golang.org/x/tools/gopls) | Official Go language server (LSP) |
| [delve](https://github.com/go-delve/delve) | Go debugger |
| [air](https://github.com/air-verse/air) | Live reload for Go apps |
| [mockgen](https://github.com/uber-go/mock) | Go mock generator |
| [goose](https://github.com/pressly/goose) | Database migration tool |
| [evans](https://github.com/ktr0731/evans) | Interactive gRPC client |

### Apps

| App | What it does |
|---|---|
| [Ghostty](https://ghostty.org) | Terminal emulator |
| [Zed](https://zed.dev) | Editor |
| [Raycast](https://raycast.com) | App launcher, clipboard history, snippets |
| [Rectangle](https://rectangleapp.com) | Snap and resize windows with keyboard shortcuts |
| [OrbStack](https://orbstack.dev) | Lightweight Docker Desktop replacement |
| JetBrains Mono Nerd Font | Font used in Ghostty (includes icons for eza) |
| [Postman](https://www.postman.com) | API testing GUI |
| [TablePlus](https://tableplus.com) | DB GUI — Postgres, MySQL, Redis, and more |
| [Insomnia](https://insomnia.rest) | REST/GraphQL client |
| [Figma](https://figma.com) | Design tool |
| [Slack](https://slack.com) | Team messaging |
| [Discord](https://discord.com) | Community chat |
| [1Password](https://1password.com) | Password manager |
| [Notion](https://notion.so) | Notes and docs |

### Setup

| Item | What it does |
|---|---|
| [Oh My Zsh](https://ohmyzsh.sh) | zsh framework |
| Config: `.zshrc` | Shell config |
| Config: `.zprofile` | Login shell config |
| Config: `.zshenv` | Environment variables |
| Config: `ghostty` | Ghostty terminal config |
| [Claude CLI](https://github.com/anthropics/claude-code) | Claude AI in the terminal |

---

## Shell shortcuts

| Shortcut | Action |
|---|---|
| `→` or `Alt+Enter` | Accept autocomplete suggestion |
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy pick a file (inserts path) |
| `Ctrl+Right / Left` | Jump word by word |
| `Ctrl+Backspace` | Delete previous word |
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

---

## After install

```bash
# 1. Reload shell
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

Add a `.envrc` to any project and it auto-loads when you `cd` in:

```bash
# .envrc
export DATABASE_URL="postgres://localhost/mydb"
export API_KEY="dev-key-123"
```

```bash
direnv allow   # approve once
```

---

*Named after [@dmtrxw](https://github.com/dmtrxw)'s [sebats-duls](https://github.com/dmtrxw/sebats-duls). In his memory.*
