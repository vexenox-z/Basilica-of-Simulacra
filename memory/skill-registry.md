# Skill Registry — Available Capabilities

## Installed Skills

### System & Infrastructure
| Skill | Purpose | Trigger |
|-------|---------|---------|
| **healthcheck** | Security audits, hardening, risk assessment | User requests security audit |
| **agent-template-designer** | Design agent architectures, roles, lifecycles | Spawning agents, designing workflows |
| **json-integrity** | Validate JSON, schema checking, repair | JSON validation failures, broken configs |

### Development & Coding
| Skill | Purpose | Trigger |
|-------|---------|---------|
| **coding-agent** | Delegate to Codex/Claude Code/Pi agents | Building features, code review, refactoring |
| **github** | GitHub CLI operations (issues, PRs, CI) | PR status, CI checks, issue management |
| **gh-issues** | Auto-fix GitHub issues with sub-agents | `/gh-issues` command, issue automation |
| **lobster** | Typed workflow runtime with approval gates | Complex multi-step automations |

### Productivity & Information
| Skill | Purpose | Trigger |
|-------|---------|---------|
| **weather** | Current weather and forecasts (no API key) | Weather queries |
| **summarize** | Extract/transcribe from URLs, podcasts, files | Summarization requests |
| **web-search-quality** | Source credibility evaluation | Before citing web search results |
| **tavily** | AI-optimized web search | Research tasks |

### Memory & Learning
| Skill | Purpose | Trigger |
|-------|---------|---------|
| **proactive-agent** | Self-improving agent architecture | Continuous improvement, WAL protocol |
| **self-improvement** | Capture learnings, errors, corrections | Mistakes, corrections, pattern discoveries |
| **session-logs** | Search and analyze session transcripts | Session history analysis |

### External Integrations
| Skill | Purpose | Trigger |
|-------|---------|---------|
| **apple-notes** | Manage Apple Notes via `memo` CLI | Note creation, search, management |
| **apple-reminders** | Manage Apple Reminders via `remindctl` | Task lists, reminders |
| **things-mac** | Manage Things 3 tasks/projects | Task management |
| **imsg** | iMessage/SMS CLI | Messaging via Messages.app |
| **himalaya** | Email via IMAP/SMTP | Email management |
| **gog** | Google Workspace (Gmail, Calendar, Drive, etc.) | Google services integration |

### Content & Media
| Skill | Purpose | Trigger |
|-------|---------|---------|
| **video-frames** | Extract frames/clips from videos | Video analysis |
| **pdf** | PDF analysis with models | Document analysis |
| **nano-pdf** | Edit PDFs with natural language | PDF modification |
| **image** | Image analysis with vision models | Visual analysis |

### Communication Channels
| Skill | Purpose | Trigger |
|-------|---------|---------|
| **discord** | Discord operations | Channel management |
| **blogwatcher** | Monitor RSS/Atom feeds | Feed monitoring |

## Usage Patterns

### Skill Invocation
- Mention skill name → automatic trigger per skill's description
- User-invocable skills: `/skill-name` commands
- Automatic: Triggered by task classification

### Skill Dependencies
Some skills require external binaries:
- `gh` (GitHub CLI) → github, gh-issues
- `fish`, `starship` → shell operations
- `memo` → apple-notes
- `himalaya` → email

### Environment Variables
Skills may rely on:
- `GH_TOKEN` → gh-issues
- API keys in `.env` → various integrations

---
*Last updated: 2026-03-07*
