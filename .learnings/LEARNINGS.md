# LEARNINGS.md — Pattern Log

Captures corrections, knowledge gaps, best practices, and workflow improvements.

---

## [LRN-20250313-001] openclaw-hook-module-format

**Logged**: 2026-03-13T14:24:00Z
**Priority**: high
**Status**: pending
**Area**: config

### Summary
OpenClaw 2026.3.12 hooks require ES module format (`export { handler as default }`), but ClawHub skills ship with CommonJS (`module.exports`). Enabling incompatible hooks crashes the gateway.

### Details
Attempted to enable self-improving-agent skill hook. Gateway dropped immediately on restart. Investigation revealed:

- Skill's `handler.js`: Uses `module.exports = handler; module.exports.default = handler;`
- OpenClaw bundled hooks: Use `export { handler as default };`
- Error: Gateway restart failure, no explicit error message in logs
- Fix: Convert handler to ES module syntax or keep hooks disabled

Bundled hooks (session-memory, bootstrap-extra-files) work because they're compiled to ES modules. User-installed hooks from ClawHub fail.

### Suggested Action
Before enabling any ClawHub skill hook:
1. Check handler.js format
2. Convert CommonJS → ES modules if needed:
   - Remove: `module.exports = handler;`
   - Add: `export { handler as default };`
3. Or wait for skill maintainer to update

### Metadata
- Source: error
- Related Files: ~/.openclaw/workspace/skills/self-improving-agent/hooks/openclaw/handler.js
- Tags: openclaw, hooks, es-modules, commonjs, clawhub
- Recurrence-Count: 1
- First-Seen: 2026-03-13

---

## [LRN-20250313-002] git-unrelated-histories-merge

**Logged**: 2026-03-13T14:24:00Z
**Priority**: medium
**Status**: resolved
**Area**: config

### Summary
When local git repo loses remote connection and diverges significantly, use `--allow-unrelated-histories` with strategic `--theirs`/`--ours` to merge without losing work.

### Details
Local Basilica repo had 2 commits, remote had 26. No common ancestor after remote re-added. Standard merge failed:

```
fatal: refusing to merge unrelated histories
```

Resolution:
```bash
git merge origin/main --allow-unrelated-histories
# Resolved 6 conflicts:
# - Accept theirs: Core docs (SOUL.md, CONDUCT.md, etc.)
# - Accept ours: Workspace state (.gitignore, workspace-state.json)
# - Manual review: AGENTS.md (model path differences)
```

### Suggested Action
For divergent repo recovery:
1. `git remote add origin <url>` if missing
2. `git fetch origin`
3. `git merge origin/main --allow-unrelated-histories`
4. For each conflict: decide canonical source (usually remote for docs, local for state)
5. Commit with descriptive message explaining merge strategy

### Metadata
- Source: conversation
- Related Files: ~/.openclaw/workspace/AGENTS.md
- Tags: git, merge, recovery, basilica

---
