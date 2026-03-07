# OpenClaw Pro Guide

*A comprehensive guide for power users — from installation mastery to advanced orchestration patterns.*

---

## Quick Reference Card (TL;DR Commands)

### Gateway Management
```bash
# Status and control
openclaw gateway status              # Check gateway health
openclaw gateway start               # Start foreground gateway
openclaw gateway --port 18789        # Start with custom port
openclaw gateway restart             # Restart service

# Diagnostics
openclaw doctor                      # Health check + fix suggestions
openclaw doctor --fix                # Auto-apply fixes
openclaw logs                        # View gateway logs
openclaw health                      # Quick health check
```

### Configuration
```bash
# Interactive setup
openclaw onboard --install-daemon    # Full setup wizard with service
openclaw configure                   # Config wizard only

# Direct config manipulation
openclaw config get agents.defaults.workspace
openclaw config set agents.defaults.heartbeat.every "2h"
openclaw config unset tools.web.search.apiKey

# Environment shortcuts
openclaw dashboard                   # Open Control UI in browser
```

### Model Management
```bash
openclaw models list                 # List configured models
openclaw models status               # Show current model + auth status
openclaw models set <provider/model> # Set primary model
openclaw models fallbacks add <model> # Add fallback

# In-chat model switching
/model                               # Open model picker
/model list                          # List available models
/model 3                             # Select by number
/model anthropic/claude-opus-4-6     # Select by full reference
/model status                        # Show detailed status
```

### Session Management
```bash
openclaw sessions list               # List active sessions
openclaw sessions cleanup --dry-run  # Preview maintenance
openclaw sessions cleanup --enforce  # Run maintenance
openclaw reset                       # Reset current session
/new                                 # Alias for session reset (in-chat)
```

### Cron & Automation
```bash
# Add jobs
openclaw cron add --name "Morning brief" --cron "0 7 * * *" \
  --session isolated --message "Summarize updates" --announce

openclaw cron add --name "Reminder" --at "2026-03-02T09:00:00Z" \
  --session main --system-event "Check inbox" --wake now --delete-after-run

# Manage jobs
openclaw cron list
openclaw cron run <job-id>
openclaw cron runs --id <job-id>
openclaw cron remove <job-id>
```

### Agents & Subagents
```bash
openclaw agents list --bindings      # List agents with routing
openclaw agents add work             # Create new agent workspace

# Subagent management (from context)
subagents list                       # List active subagents
subagents kill <target>              # Terminate subagent
```

### Browser Automation
```bash
openclaw browser --browser-profile openclaw status
openclaw browser --browser-profile openclaw start
openclaw browser --browser-profile openclaw open https://example.com
openclaw browser --browser-profile openclaw snapshot
```

### Skills (ClawHub)
```bash
# Install ClawHub CLI first: npm i -g clawhub

clawhub search "postgres"            # Search skills
clawhub install <skill-slug>         # Install skill to workspace
clawhub update --all                 # Update all skills
clawhub sync --all                   # Publish local skills
clawhub list                         # List installed skills
```

---

## Installation & Setup

### Prerequisites

- **Node.js 22+** [VERIFIED: https://docs.openclaw.ai/start/getting-started]
- **npm, pnpm, or bun** for package management
- **Docker** (optional, for sandboxing)

### Installation Methods

**Recommended (macOS/Linux):**
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

**Windows (PowerShell):**
```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

**Package managers:**
```bash
npm install -g openclaw@latest
# or
pnpm add -g openclaw@latest
```

### Gateway Configuration

The Gateway is the single source of truth for sessions, routing, and channel connections [VERIFIED: https://docs.openclaw.ai]. Configuration lives at `~/.openclaw/openclaw.json` (JSON5 format with comments support).

**Key configuration sections:**

| Section | Purpose |
|---------|---------|
| `agents` | Model selection, workspace paths, sandbox settings |
| `channels` | WhatsApp, Telegram, Discord, etc. credentials |
| `session` | DM scoping, maintenance, thread bindings |
| `cron` | Scheduler settings, retention policies |
| `browser` | Browser profiles, CDP settings |
| `skills` | Skill toggles, API keys, environment |

**Minimal secure config:**
```json5
{
  agents: {
    defaults: {
      workspace: "~/.openclaw/workspace",
      model: {
        primary: "anthropic/claude-sonnet-4-5"
      }
    }
  },
  channels: {
    whatsapp: {
      allowFrom: ["+15555550123"]  // Whitelist only
    }
  },
  session: {
    dmScope: "per-channel-peer"  // Secure multi-user mode
  }
}
```

### Model Provider Setup

OpenClaw supports multiple auth methods [VERIFIED: https://docs.openclaw.ai/concepts/model-failover]:

1. **API Keys**: Stored in `~/.openclaw/agents/<agentId>/agent/auth-profiles.json`
2. **OAuth**: For OpenAI Codex subscriptions
3. **Setup Tokens**: Anthropic's `claude setup-token` method

**Auth profile example:**
```json
{
  "profiles": {
    "anthropic:default": {
      "type": "api_key",
      "provider": "anthropic",
      "key": "sk-ant-..."
    }
  }
}
```

**CLI model commands:**
```bash
# Check auth status
openclaw models status

# Set up Anthropic via CLI
curl -fsSL https://openclaw.ai/install.sh | bash
openclaw onboard  # Interactive setup

# Manual provider config (openclaw.json)
{
  models: {
    providers: {
      anthropic: {
        apiKey: { source: "env", provider: "default", id: "ANTHROPIC_API_KEY" }
      }
    }
  }
}
```

### Browser/Relay Configuration

Two browser modes [VERIFIED: https://docs.openclaw.ai/tools/browser]:

1. **`openclaw` profile**: Managed, isolated browser (recommended for automation)
2. **`chrome` profile**: Extension relay to your existing Chrome tabs

**Multi-profile configuration:**
```json5
{
  browser: {
    enabled: true,
    defaultProfile: "openclaw",
    executablePath: "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
    profiles: {
      openclaw: { cdpPort: 18800, color: "#FF4500" },
      work: { cdpPort: 18801, color: "#0066CC" },
      remote: { cdpUrl: "http://10.0.0.42:9222", color: "#00AA00" }
    },
    ssrfPolicy: {
      dangerouslyAllowPrivateNetwork: true
    }
  }
}
```

**Browserless.io (hosted CDP):**
```json5
{
  browser: {
    defaultProfile: "browserless",
    profiles: {
      browserless: {
        cdpUrl: "https://production-sfo.browserless.io?token=${BROWSERLESS_API_KEY}"
      }
    }
  }
}
```

---

## Core Concepts

### Sessions vs. Subagents

**Sessions** [VERIFIED: https://docs.openclaw.ai/concepts/session]:
- Persist conversation state, tool history, and context
- Keyed by `agent:<agentId>:<sessionKey>`
- Stored in `~/.openclaw/agents/<agentId>/sessions/`

**Session scoping (`session.dmScope`):**

| Mode | Use Case |
|------|----------|
| `main` (default) | Single-user setups; all DMs share context |
| `per-peer` | Isolate by sender across all channels |
| `per-channel-peer` | **Recommended for multi-user**; isolate by channel + sender |
| `per-account-channel-peer` | Multi-account setups (e.g., multiple WhatsApp numbers) |

**Subagents** [INFERENCE: Agent dispatch pattern]:
- Spawned for parallel tasks with isolated context
- Run in separate sessions (e.g., `subagent:<uuid>`)
- Auto-announce completion back to parent
- Maximum depth: configurable (default 1)

**When to spawn vs. handle directly:**
- **Spawn subagent**: Bounded research tasks, coding in new directories, file organization, tasks needing parallel execution
- **Handle directly**: Conversational queries, quick edits, context-dependent work requiring main session memory

### One-Shot vs. Persistent Modes

**One-shot execution** (Cron with `--delete-after-run`):
```bash
openclaw cron add --name "One-time" --at "2026-03-02T10:00:00Z" \
  --session isolated --message "Do thing" --delete-after-run
```

**Persistent (Heartbeat)** [VERIFIED: https://docs.openclaw.ai/gateway/heartbeat]:
- Runs periodic agent turns in main session
- Default interval: 30m (1h for Anthropic OAuth)
- Uses `HEARTBEAT_OK` acknowledgment pattern
- Configurable active hours and delivery targets

```json5
{
  agents: {
    defaults: {
      heartbeat: {
        every: "30m",
        target: "last",  // Deliver to last contact
        activeHours: { start: "09:00", end: "22:00", timezone: "America/New_York" }
      }
    }
  }
}
```

### Tool Permissions and Constraints

**Tool policy hierarchy** [INFERENCE: From skill documentation]:
1. Global tool allowlist (`tools.allow`)
2. Per-agent tool policy
3. Sandbox restrictions (if enabled)
4. Skill gating (`metadata.openclaw.requires`)

**Skill gating examples:**
```yaml
# SKILL.md frontmatter
metadata:
  {
    "openclaw": {
      "requires": {
        "bins": ["gh", "git"],        # All must exist
        "anyBins": ["claude", "codex"], # At least one
        "env": ["GEMINI_API_KEY"],      # Environment variable must exist
        "config": ["browser.enabled"]   # Config path must be truthy
      }
    }
  }
```

**Sandbox modes** [VERIFIED: https://docs.openclaw.ai/gateway/sandboxing]:
- `"off"`: No sandboxing
- `"non-main"`: Sandbox group/DM sessions, keep main on host
- `"all"`: Everything sandboxed

---

## Agent Orchestration

### When to Spawn vs. Handle Directly

| Scenario | Approach | Rationale |
|----------|----------|-----------|
| Research → Synthesis → Archive | Spawn | Parallel info gathering, isolated verification |
| Quick file edit | Direct | Overhead not justified |
| Multi-repo PR reviews | Spawn | Parallel processing, no context pollution |
| Complex code generation | Spawn | Isolated workspace, can run for hours |
| Daily standup queries | Direct | Needs main session context |
| Security audit | Spawn | Sandboxed, bounded scope |

### Subagent Supervision Protocols

**Spawn pattern:**
```bash
# Spawn with clear deliverable
subagents spawn \
  --task "Research: compile 5 sources on topic X, verify 3 claims" \
  --timeout 1800 \
  --workspace ~/research-temp

# Monitor
subagents list
subagents poll <session-id>
```

**Best practices:**
1. Define clear deliverables in task description
2. Set explicit timeouts (default: 10min for subagents)
3. Use temporary workspaces for isolated work
4. Never spawn agents in `~/.openclaw/` or `~/clawd/`

### Error Handling and Recovery

**Model failover** [VERIFIED: https://docs.openclaw.ai/concepts/model-failover]:
1. Auth profile rotation within provider (OAuth preferred over API keys)
2. Exponential cooldown on failures (1min → 5min → 25min → 1hr cap)
3. Model fallback to next in `agents.defaults.model.fallbacks`
4. Billing failures get longer backoffs (5hr → 24hr)

**Session recovery:**
- Use `/reset` or `/new` to clear corrupted context
- `openclaw sessions cleanup --enforce` to prune stale sessions
- Auto-compaction triggers memory flush before context loss

**Tool failure patterns:**
- **Rate limits**: Auto-cooldown with retry
- **Timeout**: Configurable per-tool (`timeoutMs`)
- **Sandbox errors**: Fall back to host execution (if allowed)

---

## Workflow Patterns

### Research → Synthesis → Archive

```bash
# 1. Spawn parallel research subagents
subagents spawn --task "Research topic A" --workspace /tmp/research-a &
subagents spawn --task "Research topic B" --workspace /tmp/research-b &

# 2. Wait for completion
subagents list  # Monitor

# 3. Synthesis (main session)
# "Based on findings from subagents [A] and [B], synthesize..."

# 4. Archive to memory
memory write file:memory/2026-03-01-research.md content:"..."
```

### Code → Audit → Iterate

```bash
# 1. Spawn coding agent in worktree (isolated)
git worktree add -b feature/fix /tmp/fix-branch main
bash pty:true workdir:/tmp/fix-branch background:true \
  command:"codex --yolo 'Fix issue #123'"

# 2. Review results (main session or subagent)
gh pr create --title "fix: ..." --body "..."

# 3. Iterate if needed
process action:submit sessionId:<id> data:"Add tests for edge case"
```

### Cron Scheduling and Automation

**Daily briefing job:**
```json5
{
  cron: {
    enabled: true,
    maxConcurrentRuns: 2,
    sessionRetention: "24h"
  }
}
```

```bash
# Morning digest
openclaw cron add \
  --name "Morning digest" \
  --cron "0 7 * * 1-5" \
  --tz "America/Chicago" \
  --session isolated \
  --message "Review overnight emails, calendar, and GitHub notifications. Summarize action items." \
  --announce --channel discord --to "channel:TEAM_CHANNEL_ID"

# Health check every hour
openclaw cron add \
  --name "Health check" \
  --cron "0 * * * *" \
  --session main \
  --system-event "Run health audit and report any issues" \
  --target none
```

**Job delivery modes:**
- `announce`: Deliver summary to channel + post to main session
- `webhook`: POST to URL with results
- `none`: Internal only

---

## Advanced Features

### Browser Automation

**Snapshot-driven automation** [VERIFIED: https://docs.openclaw.ai/tools/browser]:

```javascript
// Tool call pattern
{
  action: "snapshot",
  target: "node",  // or "host", "sandbox"
  profile: "openclaw"
}

// Then act on refs from snapshot
{
  action: "act",
  request: {
    kind: "click",
    ref: "e12"  // ARIA ref from snapshot
  }
}
```

**Key browser capabilities:**
- Snapshots with ARIA refs (`refs: "aria"` for stable references)
- Screenshots (`screenshot` action)
- PDF generation (`pdf` action)
- File uploads (`upload` action)
- Multi-profile support

**SSRF protection:**
```json5
{
  browser: {
    ssrfPolicy: {
      dangerouslyAllowPrivateNetwork: false,  // Strict public-only
      hostnameAllowlist: ["*.internal.com"]
    }
  }
}
```

### Memory/HEARTBEAT.md Usage

**Memory architecture** [VERIFIED: https://docs.openclaw.ai/concepts/memory]:
- `memory/YYYY-MM-DD.md`: Daily logs (append-only, read today + yesterday at start)
- `MEMORY.md`: Curated long-term memory (main session only)
- Vector search via `memory_search` tool (OpenAI/Gemini/Voyage embeddings)

**HEARTBEAT.md pattern:**
```markdown
# Heartbeat Checklist

## Daily
- [ ] Review calendar for upcoming meetings
- [ ] Check high-priority emails
- [ ] Review GitHub PRs awaiting review

## Weekly (Mondays)
- [ ] Sync project status documents
- [ ] Review and archive old memory files

## Alerts
- Notify if any cron job failed in last 24h
- Flag if disk usage > 80%
```

**Automatic memory flush:**
When sessions near compaction, OpenClaw triggers a silent agentic turn to write durable memories before context loss [VERIFIED: https://docs.openclaw.ai/concepts/memory].

### Cross-Session Messaging

**Via system events:**
```bash
openclaw system event --text "Task complete" --mode now  # Immediate
openclaw system event --text "Daily summary" --mode next-heartbeat
```

**Via cron delivery:**
```bash
openclaw cron add --name "Notify main" --at "+30m" \
  --session main --system-event "Background task finished" --wake now
```

**Session targeting in bindings:**
- Cron jobs: `cron:<jobId>`
- Webhooks: `hook:<uuid>`
- Node runs: `node-<nodeId>`

---

## Pro Tips & Gotchas

### Token Management

1. **Model allowlist enforcement**: If `agents.defaults.models` is set, it becomes an allowlist. Unknown models return "Model is not allowed" [VERIFIED: https://docs.openclaw.ai/concepts/models].

2. **Vision token reduction**: Lower `imageMaxDimensionPx` (default 1200) to reduce screenshot token usage.

3. **Session pruning**: Old tool results are trimmed before LLM calls by default. This does NOT rewrite JSONL history.

4. **Compaction trigger**: When `contextTokens` exceeds threshold, automatic compaction occurs. Configure `reserveTokensFloor` to control buffer.

### Context Window Optimization

| Strategy | Implementation |
|----------|---------------|
| Skill loading | Gate skills with `requires.config` to reduce prompt size |
| Image downscaling | Set `agents.defaults.imageMaxDimensionPx: 800` |
| Session reset | Use `/new` proactively before long tasks |
| Memory flush | Let auto-compaction write summaries to `memory/` |
| Tool result limits | Configure `toolPolicy.maxResults` per tool |

### Common Failure Modes

| Symptom | Cause | Fix |
|---------|-------|-----|
| "Model is not allowed" | Model not in allowlist | Add to `agents.defaults.models` or clear allowlist |
| Gateway won't start | Config validation failure | Run `openclaw doctor --fix` |
| No browser actions | Browser disabled or profile misconfigured | Check `browser.enabled` and profile settings |
| Skills not loading | Missing binary or env var | Check `metadata.openclaw.requires` |
| OAuth "lost" | Profile rotation | Pin with `auth.order` or use `/model ...@profile` |
| DMs sharing context | `dmScope: "main"` | Change to `per-channel-peer` |
| Heartbeat not delivering | `target: "none"` | Set explicit target channel |
| Subagent timeout | Default 10min exceeded | Spawn with explicit `--timeout` |
| Web search failing | Missing Brave API key | Run `openclaw configure --section web` |

### 5-10 Best Tips from the Community

1. **Use `per-channel-peer` for multi-user setups** [VERIFIED] — Prevents context leakage between users on shared channels.

2. **Always use `pty:true` for coding agents** [VERIFIED] — Codex, Claude Code, and similar tools require a pseudo-terminal for proper output.

3. **Set up heartbeat with `target: "last"`** — Ensures periodic check-ins actually reach you, not just log internally.

4. **Leverage git worktrees for parallel PR reviews** — Isolate each review in its own worktree, spawn Codex per worktree.

5. **Use `--announce` with cron for visibility** — Isolated jobs announce summaries; without this, work happens silently.

6. **Pin model profiles to avoid rotation surprises** — Use `/model provider/model@profileId` or set `auth.order`.

7. **Enable sandboxing for group chats** — Set `sandbox.mode: "non-main"` to contain untrusted group input.

8. **Use `memory_search` before asking user for context** — The model may have already recorded relevant info.

9. **Configure `browser.ssrfPolicy` for security** — Disable `dangerouslyAllowPrivateNetwork` on public gateways.

10. **Run `openclaw doctor` after updates** — Catches config drift and deprecated settings.

---

## Resources & Further Reading

### Official Documentation

- **Main docs**: https://docs.openclaw.ai [VERIFIED]
- **Getting Started**: https://docs.openclaw.ai/start/getting-started [VERIFIED]
- **Configuration Reference**: https://docs.openclaw.ai/gateway/configuration-reference
- **LLMs.txt index**: https://docs.openclaw.ai/llms.txt [VERIFIED]

### Skill Registry (ClawHub)

- **Browse skills**: https://clawhub.ai [VERIFIED]
- **Install CLI**: `npm i -g clawhub`
- **Documentation**: https://docs.openclaw.ai/tools/clawhub [VERIFIED]

### Community Channels

- **Discord**: https://discord.gg/clawd [VERIFIED: GitHub README]
- **GitHub**: https://github.com/openclaw/openclaw [VERIFIED]
- **DeepWiki**: https://deepwiki.com/openclaw/openclaw

### Key Documentation Pages by Topic

| Topic | URL |
|-------|-----|
| Session management | https://docs.openclaw.ai/concepts/session [VERIFIED] |
| Model configuration | https://docs.openclaw.ai/concepts/models [VERIFIED] |
| Model failover | https://docs.openclaw.ai/concepts/model-failover [VERIFIED] |
| Cron jobs | https://docs.openclaw.ai/automation/cron-jobs [VERIFIED] |
| Heartbeat | https://docs.openclaw.ai/gateway/heartbeat [VERIFIED] |
| Browser automation | https://docs.openclaw.ai/tools/browser [VERIFIED] |
| Memory | https://docs.openclaw.ai/concepts/memory [VERIFIED] |
| Sandboxing | https://docs.openclaw.ai/gateway/sandboxing [VERIFIED] |
| Multi-agent routing | https://docs.openclaw.ai/concepts/multi-agent [VERIFIED] |
| Skills system | https://docs.openclaw.ai/tools/skills [VERIFIED] |
| Environment variables | https://docs.openclaw.ai/help/environment [VERIFIED] |

---

## Document Metadata

- **Version**: OpenClaw 2026.2.x
- **Last Updated**: 2026-03-01
- **Research Sources**: Official docs (docs.openclaw.ai), GitHub repository, bundled skills
- **Citations**: [VERIFIED] claims confirmed via web fetch during research; [INFERENCE] claims based on documentation patterns
- **Author**: Vane-Lorekeeper (Research Archivist)
