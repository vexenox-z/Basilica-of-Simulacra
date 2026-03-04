# Lobster Workflow Conversion Audit

**Date:** 03.03.2026
**Author:** Vane-Systems
**Purpose:** Assess existing automations for Lobster workflow conversion

---

## Executive Summary

Of six reviewed automations, **three are strong candidates** for Lobster conversion. The primary drivers are: approval gates for file-modifying operations, resumability for interrupted workflows, and structured state management for multi-step processes.

---

## Automation Inventory

### 1. Weekly File Organization (Steward cron)

**Location:** Not found in crontab or `.automation/` — likely defined elsewhere or pending implementation  
**Schedule:** Sundays 20:00 (per system-context.md)  
**Scope:** Scans `~/Documents`, `~/Downloads`, `~/Desktop`  
**Status:** Definition exists in system-context but no script found

**Assessment:**

| Criterion | Score | Notes |
|-----------|-------|-------|
| Complexity | Medium | Multi-directory scan, file categorization rules |
| Approval needs | **High** | Moves/organizes files — destructive operation |
| Resumability | Moderate | Could pause mid-scan, resume without re-scanning |
| Determinism | Medium | Rules should be predictable, but file states change |
| Safety | **Critical** | Misfiling could lose work; approval gates essential |

**Lobster Suitability: HIGH**

**Rationale:** This is the poster child for Lobster conversion. File organization decisions should require human approval. A paused run should resume from last checkpoint. The workflow is inherently multi-step (scan → categorize → propose → approve → execute).

---

### 2. Daily Research Digest (cron)

**Location:** `~/.automation/daily-digest.fish`  
**Schedule:** Daily 08:00  
**Scope:** Scans Research folder, generates digest markdown  
**Status:** Active

**Assessment:**

| Criterion | Score | Notes |
|-----------|-------|-------|
| Complexity | Low | Single-pass scan, template output |
| Approval needs | None | Read-only operation, creates new file |
| Resumability | Low | Quick execution, trivial restart |
| Determinism | High | Same input → same output structure |
| Safety | Low | Non-destructive, idempotent |

**Lobster Suitability: LOW**

**Rationale:** Simple read-only operation with predictable output. No approval gates needed. Resumability offers no value for a 2-second script. Keep as cron job.

**Recommendation:** No conversion. Current implementation is optimal.

---

### 3. Weekly Tool Audit (cron)

**Location:** `~/.automation/weekly-audit.fish`  
**Schedule:** Mondays 09:00  
**Scope:** Runs `brew outdated`, `npm outdated -g`, `topgrade --dry-run`  
**Status:** Active

**Assessment:**

| Criterion | Score | Notes |
|-----------|-------|-------|
| Complexity | Low | Three commands, log output |
| Approval needs | None | Dry-run only, no modifications |
| Resumability | Low | Quick execution, stateless |
| Determinism | High | Output varies by available updates, but predictable flow |
| Safety | Low | Read-only, informational only |

**Lobster Suitability: LOW**

**Rationale:** This is a read-only audit. No modifications occur. The value of Lobster would come from a *follow-up* workflow that actually runs updates with approval gates — but that's a separate automation.

**Recommendation:** No conversion. Consider a *separate* Lobster workflow for "apply updates" with approval gates if desired.

---

### 4. Stale File Check (Fish prompt)

**Location:** `~/.config/fish/functions/stale_check.fish`  
**Trigger:** Terminal session start (interactive)  
**Scope:** Shows Inbox files >3 days old + uncommitted Basilica changes  
**Status:** Active

**Assessment:**

| Criterion | Score | Notes |
|-----------|-------|-------|
| Complexity | Low | Two `find`/`git` calls, formatted output |
| Approval needs | None | Read-only display |
| Resumability | N/A | Instant, transient display |
| Determinism | High | Same files → same output |
| Safety | None | Informational only |

**Lobster Suitability: NONE**

**Rationale:** This is a terminal prompt enhancement, not a workflow. It's informational, transient, and should remain in Fish config. Lobster is for pipelines, not UI elements.

**Recommendation:** No conversion. Keep as Fish function.

---

### 5. Downloads → Inbox Automation (launchd)

**Location:** `~/.automation/com.xena.move-to-inbox.plist` + `move-to-inbox.scpt`  
**Trigger:** Folder action on `~/Downloads/` (WatchPaths)  
**Scope:** Moves new downloads to `~/Documents/00_Inbox/`  
**Status:** Active (`launchctl list` shows `com.xena.move-to-inbox`)

**Assessment:**

| Criterion | Score | Notes |
|-----------|-------|-------|
| Complexity | Low | Single operation: move file |
| Approval needs | Moderate | Modifies files, but destination is staging area |
| Resumability | Low | Instant operation |
| Determinism | High | Same file → same destination |
| Safety | Moderate | Could misfile important downloads; no undo |

**Lobster Suitability: MODERATE**

**Rationale:** This is a real-time automation triggered by filesystem events. Lobster workflows are typically invoked explicitly, not by WatchPaths. Converting would require a polling loop or explicit trigger, which adds complexity.

However, there's a case for a *manual* "process inbox" workflow that reviews what landed in Inbox and proposes categorization — that's a separate automation (see #1).

**Recommendation:** Keep launchd automation for real-time moves. Consider a separate Lobster workflow for "process inbox" with approval gates.

---

### 6. Git Basilica Check (Fish prompt)

**Location:** `~/.config/fish/functions/stale_check.fish` (combined with #4)  
**Trigger:** Terminal session start  
**Scope:** Shows uncommitted changes in Basilica repo  
**Status:** Active (part of stale_check)

**Assessment:**

| Criterion | Score | Notes |
|-----------|-------|-------|
| Complexity | Low | `git status --short` |
| Approval needs | None | Read-only display |
| Resumability | N/A | Instant, transient |
| Determinism | High | Same repo state → same output |
| Safety | None | Informational only |

**Lobster Suitability: NONE**

**Rationale:** Same as #4 — this is a prompt enhancement, not a workflow.

**Recommendation:** No conversion. Keep as Fish function.

---

## Conversion Matrix

| Automation | Convert? | Priority | Rationale |
|------------|----------|----------|-----------|
| Weekly file organization | **YES** | P1 | Approval gates essential, multi-step, resumability valuable |
| Daily research digest | No | — | Simple, read-only, cron-optimal |
| Weekly tool audit | No | — | Read-only audit; consider separate "apply updates" workflow |
| Stale file check | No | — | UI element, not a workflow |
| Downloads → Inbox | Partial | P2 | Keep launchd; add Lobster for "process inbox" |
| Git Basilica check | No | — | UI element, not a workflow |

---

## Proposed Lobster Workflows

### P1: `file-organization.lobster`

**Purpose:** Weekly file organization with approval gates and resumability

**Workflow Design:**

```yaml
# file-organization.lobster
name: weekly-file-organization
description: Scan directories, propose organization, require approval

steps:
  - name: scan_documents
    exec: find ~/Documents -type f -mtime -7 -not -path "*/.*" | json
    state: recent_files
    
  - name: scan_downloads
    exec: find ~/Downloads -type f -mtime -7 | json
    state: downloads
    
  - name: scan_desktop
    exec: find ~/Desktop -type f -mtime -7 | json
    state: desktop
    
  - name: categorize
    exec: |
      # Categorization logic (could invoke AI or rule engine)
      # Output: proposed moves as JSON
    state: proposals
    
  - name: review_proposals
    approve:
      prompt: "Review proposed file organization"
      preview_from_state: proposals
      limit: 20
      
  - name: execute_moves
    exec: |
      # Execute approved moves
      # Each move logged for rollback
    state: completed_moves
    
  - name: report
    exec: echo "Organized {completed_moves | length} files"
```

**Key Features:**
- State preserved between steps (resumable)
- Approval gate before any file moves
- Audit trail of completed moves
- Can be resumed with `lobster resume --token <token>`

---

### P2: `inbox-processor.lobster`

**Purpose:** Process Inbox contents with categorization proposals

**Workflow Design:**

```yaml
# inbox-processor.lobster
name: inbox-processor
description: Review Inbox, propose destinations, require approval

steps:
  - name: scan_inbox
    exec: find ~/Documents/00_Inbox -type f | json
    state: inbox_files
    
  - name: check_empty
    where: inbox_files | length > 0
    on_false:
      exec: echo "Inbox is empty"
      exit: 0
      
  - name: categorize
    exec: |
      # For each file, propose destination based on:
      # - File type
      # - Content analysis (optional AI)
      # - User patterns
    state: proposals
    
  - name: review
    approve:
      prompt: "Process these Inbox files?"
      preview_from_state: proposals
      
  - name: move_files
    exec: |
      # Move approved files to destinations
    state: moved
    
  - name: report
    exec: echo "Moved {moved | length} files from Inbox"
```

**Key Features:**
- Conditional execution (skip if empty)
- Batch approval for multiple files
- Clear audit trail
- Resumable if interrupted mid-move

---

### Optional: `apply-updates.lobster`

**Purpose:** Apply system updates with approval gates (follow-up to weekly audit)

**Workflow Design:**

```yaml
# apply-updates.lobster
name: apply-system-updates
description: Apply pending updates with approval gates

steps:
  - name: check_brew
    exec: brew outdated --json | json
    state: brew_updates
    
  - name: review_brew
    where: brew_updates | length > 0
    approve:
      prompt: "Update these Homebrew packages?"
      preview_from_state: brew_updates
      
  - name: apply_brew
    exec: brew upgrade
    state: brew_result
    
  - name: check_npm
    exec: npm outdated -g --json | json
    state: npm_updates
    
  - name: review_npm
    where: npm_updates | length > 0
    approve:
      prompt: "Update these NPM packages?"
      preview_from_state: npm_updates
      
  - name: apply_npm
    exec: npm update -g
    state: npm_result
    
  - name: final_report
    exec: |
      echo "Brew: {brew_result}"
      echo "NPM: {npm_result}"
```

**Key Features:**
- Separate approval for each package manager
- State preserved between steps
- Can resume after partial completion
- Explicit approval before any changes

---

## Implementation Recommendations

### Phase 1: Foundation (Week 1)

1. **Create workflow directory:**
   ```
   ~/.lobster/workflows/
   ├── file-organization.lobster
   └── inbox-processor.lobster
   ```

2. **Implement file-organization.lobster first:**
   - Highest complexity
   - Highest risk without approval gates
   - Best demonstrates Lobster value

3. **Test with dry-run mode:**
   - All steps up to approval gate
   - Verify categorization logic
   - Validate state management

### Phase 2: Integration (Week 2)

1. **Replace cron entry:**
   - Update crontab to invoke Lobster workflow
   - `0 20 * * 0 /usr/local/bin/lobster run --file ~/.lobster/workflows/file-organization.lobster`

2. **Add inbox-processor:**
   - Keep launchd for real-time moves
   - Add manual Lobster workflow for batch processing

3. **Document in system-context.md:**
   - Update automation schedule
   - Note Lobster workflow locations

### Phase 3: Monitoring (Week 3)

1. **Add logging:**
   - Lobster runs logged to `~/.automation/logs/lobster/`
   - Include approval decisions in logs

2. **Steward integration:**
   - Steward can invoke Lobster workflows
   - `lobster run` commands in Steward's toolkit

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Workflow syntax errors | Medium | Low | Test in dry-run; Lobster validates before execution |
| Approval gate bypass | Low | High | Never run with `--approve yes` in automation |
| State corruption | Low | Medium | Lobster manages state; implement rollback for file moves |
| Performance overhead | Low | Low | Lobster is lightweight; workflows are short |

---

## Conclusion

**Convert:** 2 automations (file organization, inbox processor)  
**Keep as-is:** 4 automations (digest, tool audit, stale check, git check)  
**Add:** 1 new workflow (apply updates, optional)

The Lobster conversion focuses on automations that modify files and benefit from approval gates. Simple read-only operations remain in their current optimal form.

---

*Audit complete. Deliver to main agent for review.*