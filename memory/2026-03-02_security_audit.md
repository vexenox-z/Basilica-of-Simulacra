# Security Audit — 2026-03-02

**Auditor:** Vane-Steward (automated cron)
**Host:** Mac.local (macOS 26.4, Apple Silicon)
**OpenClaw:** Update available (2026.3.1)

## Summary
| Category | Status |
|----------|--------|
| Critical Issues | 0 |
| Warnings | 2 |
| Info | 1 |
| Posture | ACCEPTABLE |

## OpenClaw Findings

### WARN — Reverse Proxy Headers
- `gateway.trustedProxies` is empty
- **Risk:** Low (gateway bound to loopback, Control UI local-only)
- **Action:** None required unless exposing Control UI through reverse proxy

### WARN — Multi-User Heuristic
- Discord group allowlist configured (`groupPolicy="allowlist"`)
- Runtime tools exposed without full sandboxing in `agents.defaults`
- **Risk:** Context-dependent — acceptable for personal-assistant trust model
- **Mitigation:** Current posture aligns with single-operator boundary. For shared/multi-user scenarios, enable sandbox mode and restrict tool access.

### INFO — Attack Surface
- Groups: 0 open, 1 allowlist
- Elevated tools: enabled
- Webhooks: disabled
- Browser control: enabled
- Trust model: personal assistant (single trusted operator)

## Host Security

| Control | Status |
|---------|--------|
| Firewall | ✅ ON (stealth mode enabled) |
| FileVault | ✅ ON |
| Time Machine | Idle (not actively backing up) |
| Listening Ports | Unable to enumerate (lsof unavailable in PATH) |

## Recommendations

1. **Update OpenClaw** — Version 2026.3.1 available
2. **Review Time Machine** — Verify backup destination and last completion
3. **Consider sandboxing** — If expanding to multi-user access, tighten `agents.defaults.sandbox.mode`

## Actions Taken
- None — all findings within acceptable risk tolerance for personal workstation

---
*Next audit: Scheduled weekly (Mondays 09:00)*
