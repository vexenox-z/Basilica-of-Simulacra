# TOOLS.md - Local Notes

Environment-specific details for Xena's setup. Skills define _how_ tools work. This is _what_ tools are available and their quirks.

---

## Browser

**Brave Browser** (Chromium-based)
- **Path:** `/Applications/Brave Browser.app/Contents/MacOS/Brave Browser`
- **Profiles:**
  - `openclaw` — Isolated profile for automation (CDP port 18800)
  - `chrome` — Extension relay profile (CDP port 18793)
- **Default:** `openclaw` profile for web automation
- **SSRF Policy:** Private network access enabled for local development

**Usage:** Always use `profile: "openclaw"` for browser automation tasks.

---

## Shell & Terminal

**Shell:** fish + starship prompt
**Terminal:** Ghostty

**Key differences from bash/zsh:**
- Variable syntax: `$VAR` works, but prefer `(command)` for subshells
- No `&&` — use `; and` instead
- No `||` — use `; or` instead
- No `[[ ]]` — use `[ ]` or `test`
- Universal variables persist: `set -Ux VAR value`

---

## Package Management

**Primary:** pnpm (Node.js v25.6.1)
**Global bin:** `~/Library/pnpm/`
**Config location:** `~/.config/fish/config.fish` (PATH already includes pnpm)

**Common commands:**
```bash
pnpm install          # Install deps
pnpm dlx <pkg>        # Run package without install
pnpm list -g          # List global packages
```

---

## CLI Tools (Homebrew)

**Core:** fish, starship, neovim, bat, eza, fd, ripgrep, fzf, direnv
**Media:** yt-dlp
**Git:** gh (GitHub CLI)
**Comms:** memo (Apple Notes), imsg (iMessage), himalaya (email)
**Notes:** obsidian-cli
**AI:** gemini-cli

**Gotchas:**
- `eza` replaces `ls` — use `ls` alias for icons
- `bat` replaces `cat` — use `cat` alias for plain output
- `gh` requires `GH_TOKEN` for some operations

---

## Directory Structure

**Color code (~/Documents/):**
| Path | Color | Purpose |
|------|-------|---------|
| `00_Inbox/` | Grey | Unprocessed |
| `01_Life/` | Blue | Personal admin |
| `02_Play/` | Purple | Entertainment |
| `03_Read/` | Orange | Knowledge base |
| `04_Archive/` | Green | Completed |
| `05_Work/` | Red | Active projects |
| `06_Labs/` | Yellow | VMs, experiments |

---

## OpenClaw Specifics

**Workspace:** `~/.openclaw/workspace/`
**Config:** `~/.openclaw/openclaw.json`
**Skills:** `~/.openclaw/workspace/skills/` (ClawHub install target)
**Logs:** `~/.openclaw/logs/`

**Important paths:**
- `SOUL.md`, `IDENTITY.md`, `CONDUCT.md` — Character kernels
- `AGENTS.md` — Agent dispatch rules
- `MEMORY.md` — Long-term memory
- `.learnings/` — Error/pattern logs

**Current state:**
- Hooks: Disabled (incompatible with ES modules)
- Cron: All removed (clean slate)
- Skills: `self-improving-agent`, `apple-reminders`

---

## Git

**Identity:** Auto-configured as `Leonor Lux <gl0bal.netizen@Mac.local>`
**Remote:** `github.com/vexenox-z/Basilica-of-Simulacra`
**Default branch:** `main`

**Note:** Set explicit git identity if preferred:
```bash
git config --global user.name "Name"
git config --global user.email "email@example.com"
```

---

## Machine Specs

**MacBook Pro M5**
- 10-core (4P + 6E)
- 24 GB LPDDR5X / 1 TB SSD (~500 GB available)
- macOS Darwin 25.4.0 (arm64)
- AI Compute: 4x vs M4, 6x vs M1 (Neural Accelerator)

---

## TTS / Voice

**Not currently configured.** Add when TTS use cases emerge.

---

*Last updated: 2026-03-13*
