# System Context — Xena's Machine

**Last updated:** 03.03.2026

---

## Machine

| Property | Value |
|----------|-------|
| **Model** | MacBook Pro (MDE34LL/A) |
| **Chip** | Apple M5 (10-core CPU: 4P + 6E) |
| **Architecture** | ARM (Apple Silicon, 3nm TSMC) |
| **CPU Performance** | 15% faster multithreaded vs M4 |
| **GPU** | 10-core GPU with Neural Accelerator |
| **AI Compute** | 4x vs M4, 6x vs M1 |
| **Memory Bandwidth** | 153.6 GB/s unified memory |
| **Max Memory** | 32 GB LPDDR5X (installed: 24 GB) |
| **GPU Framework** | Metal (Apple's framework, NOT Vulkan) |
| **Memory** | 24 GB |
| **Storage** | 1 TB SSD (~500 GB available) |
| **Serial** | K69PVKQJ9R |
| **OS** | macOS (Darwin 25.4.0, arm64) |
| **Shell** | Fish + Starship (NOT bash/zsh) |
| **Terminal** | Ghostty |
| **Browser** | Brave (Chromium-based) |
| **Package Manager** | pnpm |
| **Node.js** | v25.6.1 |
| **Homebrew** | Yes (topgrade for updates) |

---

## Tools Available

| Tool | Function |
|------|----------|
| `exec` | Shell commands, scripts, CLI tools |
| `read/write/edit` | File operations |
| `browser` | Web automation, screenshots |
| `web_fetch` | Lightweight URL content extraction |
| `web_search` | Internet search via Brave Search API |
| `image` | Image analysis (Kimi vision) |
| `memory_search/get` | Memory file retrieval |
| `sessions_spawn` | Spawn subagents (one-shot) |
| `ollama_web_search` | Web search API |
| `nodes` | Paired device control |

## API Limits

| Service | Tier | Limit |
|---------|------|-------|
| **Brave Search** | Free | 1 req/sec, 2000/month |
| **Moonshot (Kimi)** | Default | Standard rate limits |
| **Ollama (MiniMax/GLM)** | Cloud free | Standard rate limits |

**Note:** If approaching Brave limit (1500+ searches), batch queries or use `browser` + `web_fetch` for verification instead.

---

## User Preferences

| Preference | Value |
|------------|-------|
| **Date format** | DD.MM.YYYY (EU) |
| **Time format** | 24-hour |
| **Communication** | Direct, minimal hedging, no fluff |
| **Agent style** | One-shot, quality-gated, no persistent sessions |

---

## Active Agents

| Agent | Model | Role |
|-------|-------|------|
| Vane-Architect | moonshot/kimi-k2.5 | Frontend/UX design |
| Vane-Lorekeeper | moonshot/kimi-k2.5 | Research, synthesis |
| Vane-Steward | ollama/minimax-m2.5:cloud | Admin, file ops, routine audits |
| Vane-Systems | ollama/glm-5:cloud | Infrastructure, architecture |

---

## Automation Schedule

| Job | Frequency | Agent |
|-----|-----------|-------|
| Security audit | Weekly (Mon 09:00) | Steward |
| Version check | Weekly (Fri 18:00) | Steward |
| File organization | Weekly (Sun 20:00) | Steward |

---

## Repositories

- **Basilica of Simulacra:** https://github.com/vexenox-z/Basilica-of-Simulacra
- **Local:** ~/Documents/03_Read/Basilica of Simulacra/
- **Ignored:** memory/, 03_Personal/, .obsidian/, .DS_Store

---

## Directory Structure

```
~/Documents/
├── 00_Inbox/      (Grey)
├── 01_Life/       (Blue)
├── 02_Play/       (Purple)
├── 03_Read/       (Orange)
├── 04_Archive/    (Green)
├── 05_Work/       (Red)
└── 06_Labs/       (Yellow) — VMs, UTM, experiments
```

---

## Key Locations

| Path | Purpose |
|------|---------|
| `~/.openclaw/workspace/` | OpenClaw MD files (AGENTS.md, SOUL.md, CONDUCT.md, USER.md, etc.) |
| `~/Documents/03_Read/Basilica of Simulacra/` | Knowledge base |
| `~/Documents/03_Read/Basilica of Simulacra/08_System/` | System context files |

## Virtualization

| Tool | Purpose |
|------|---------|
| **UTM** | Virtual machines on macOS (ARM/x86 emulation) |

*Note: Linux distro ISOs stored in 06_Labs/VMs — do not expose distro names or configurations publicly.*

## CLI Tools (Homebrew)

`fish`, `starship`, `neovim`, `bat`, `eza`, `fd`, `ripgrep`, `fzf`, `direnv`, `yt-dlp`, `gh`, `git`, `topgrade`, `memo`, `imsg`, `himalaya`, `obsidian-cli`, `gemini-cli`

## Key Files (Root)

- `AGENTS.md` — Agent registry and dispatch protocols
- `SOUL.md` — Core persona (Archibald Vane)
- `CONDUCT.md` — Operational doctrine
- `USER.md` — User profile and preferences
- `HEURISTICS.md` — Operational heuristics and decision patterns
- `IDENTITY.md` — Identity notes
- `HEARTBEAT.md` — Scheduled task registry

---

*Inject this context into agent prompts as needed.*
