# ERRORS.md — Error Log

Captures command failures, exceptions, and unexpected behaviors.

---

## [ERR-20250313-001] openclaw-gateway-hook-crash

**Logged**: 2026-03-13T14:24:00Z
**Priority**: high
**Status**: resolved
**Area**: config

### Summary
Gateway dropped/restarted unexpectedly when enabling self-improving-agent skill hook.

### Error
No explicit error message in gateway logs. Gateway simply failed to restart after config patch enabling hooks.

### Context
- Command: `clawhub install self-improving-agent` (installed successfully)
- Config: Set `hooks.enabled: true`, `hooks.internal.entries.self-improvement.enabled: true`
- Result: Gateway restart failed, connection dropped
- Recovery: Set `hooks.enabled: false`, gateway stabilized

### Suggested Fix
Root cause: Hook handler uses CommonJS (`module.exports`) but OpenClaw requires ES modules.

Options:
1. Convert handler.js to ES module syntax
2. Remove hook, use skill documentation only
3. Wait for upstream skill update

### Metadata
- Reproducible: yes
- Related Files: ~/.openclaw/workspace/skills/self-improving-agent/hooks/openclaw/handler.js
- See Also: LRN-20250313-001

---
