# FEATURE_REQUESTS.md — Capability Log

Captures user-requested features and missing capabilities.

---

## [FEAT-20250313-001] working-self-improvement-hook

**Logged**: 2026-03-13T14:24:00Z
**Priority**: medium
**Status**: pending
**Area**: config

### Requested Capability
Functional self-improvement hook that auto-injects logging reminders at session start without crashing gateway.

### User Context
Want automatic prompts to log learnings/errors without manual trigger. Current skill documentation works but requires explicit user request or agent self-detection.

### Complexity Estimate
simple (if skill maintainer updates), medium (if needs custom implementation)

### Suggested Implementation
Option 1: Upstream fix
- Skill maintainer converts `handler.js` from CommonJS to ES modules
- Test with OpenClaw 2026.3.12+

Option 2: Custom workaround
- Create ES module wrapper that imports CommonJS handler
- Or manually convert and maintain fork

Option 3: Alternative approach
- Skip hook, add reminder to `BOOTSTRAP.md` or `HEARTBEAT.md`
- Less intrusive, no hook overhead

### Metadata
- Frequency: first_time
- Related Features: session-memory hook (working), bootstrap-extra-files hook (working)

---
