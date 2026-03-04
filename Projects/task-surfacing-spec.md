# Task Surfacing Automation Specification

**Author:** Vane-Systems (ollama/glm-5:cloud)
**Date:** 2026-03-04
**Status:** Draft - Pending Approval

---

## Problem Statement

Xena has subclinical ADHD and experiences task blindness—items without explicit deadlines tend to slip through cognitive filters. The daily task surfacing system ensures nothing falls through the cracks by proactively presenting prioritized action items each morning.

**Core Insight:** ADHD brains work better with *external* structure. This automation provides that external scaffolding.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        TASK SURFACING PIPELINE                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  09:00 DAILY                                                                 │
│  ┌─────────────┐    ┌──────────────┐    ┌─────────────┐    ┌──────────────┐ │
│  │   SYNC      │───▶│   EXTRACT    │───▶│  PRIORITIZE │───▶│   PRESENT    │ │
│  │ CalDAV→ICS  │    │ Tasks from   │    │ by urgency  │    │ to Xena     │ │
│  │             │    │ all sources  │    │ & deadline  │    │ via Discord │ │
│  └─────────────┘    └──────────────┘    └─────────────┘    └──────────────┘ │
│        │                    │                   │                    │        │
│        │                    │                   │                    │        │
│        ▼                    ▼                   ▼                    ▼        │
│  vdirsyncer sync      task-extract.fish   priority-engine.fish   Discord DM   │
│                       todo.md parser       deadline calculator    or channel   │
│                       ICS keyword scanner   overdue detector                     │
│                                                                              │
│  STWARD TRIGGER (after presentation)                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │ User responds → Steward processes status changes → Updates todo.md      │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Task Sources

### 1. CalDAV Calendar Events (6 calendars)

**Calendar Identification:**
| UUID | Purpose | Task Events? |
|------|---------|--------------|
| `07EBC1F0-79DC-4EF3-91D9-97226C0643EB` | Default/Personal | Mixed - filter by keywords |
| `237b824c-44e6-4f00-b169-442047e4afa2` | TBD | TBD |
| `2DB511DE-5C10-413C-A417-234BCE424A52` | TBD | TBD |
| `323FD62A-CEF8-412E-9CBE-2C8CA5B954C3` | Eventbrite/Events | Likely appointments only |
| `91BA6B85-CA0D-4105-8373-15F3A1343374` | Categorised (Brown seen) | Has CATEGORIES field |
| `ECACAAA5-A8E9-4EC9-A0B4-D6C09A9EE05C` | Events | Appointments |

**Task Detection Criteria:**
- Events with CATEGORIES containing: "Task", "TODO", "Reminder"
- Events with SUMMARY matching keywords: `apply`, `submit`, `deadline`, `deadline:`, `due:`, `todo:`, `task:`
- Events with DESCRIPTION containing action verbs
- Events with DURATION > 0 minutes (tasks, not instant reminders)

**ICS Parsing Logic:**
```fish
# Extract tasks from .ics files
function extract_ics_tasks
    set cal_path "$HOME/.local/share/vdirsyncer/calendars"
    
    # Find all .ics files modified in last 90 days
    find "$cal_path" -name "*.ics" -mtime -90 | while read ics_file
        # Parse DTSTART, SUMMARY, DESCRIPTION, CATEGORIES, STATUS
        # Filter for task-like events
    end
end
```

### 2. Manual Task File: `~/Documents/03_Read/Basilica of Simulacra/01_Daily/todo.md`

**Data Structure:**
```markdown
# Active Tasks

## CRITICAL <!-- priority:critical -->
<!-- auto-generated: do not edit this section manually -->

## HIGH <!-- priority:high -->
<!-- auto-generated -->

## MEDIUM <!-- priority:medium -->

## LOW <!-- priority:low -->

---

# Manual Entries <!-- editable -->
<!-- Add tasks below. Steward will process and promote to appropriate priority -->

- [ ] Task description here
- [ ] Another task @due:2026-03-15
- [ ] Job application for Company X @due:2026-03-10 @type:job-hunt
- [ ] Fill out paperwork @due:2026-03-08 @type:paperwork

---

# Completed
<!-- Tasks marked complete move here -->

- [x] Completed task (date)
```

**Task Metadata Syntax:**
- `@due:YYYY-MM-DD` — Explicit deadline
- `@type:job-hunt` — Task category (enables CRITICAL priority)
- `@type:paperwork` — Administrative tasks (deadline-sensitive)
- `@type:recurring` — Repeating tasks (never auto-archive)
- `@remind:YYYY-MM-DD` — Future reminder date
- `@calendar:CalendarName` — Link to calendar event UID

### 3. Keyword-Based Event Detection

**Action Keywords (high-priority indicators):**
- `apply`, `application`, `submission`, `submit`
- `deadline`, `due`, `expires`, `expires on`
- `interview`, `callback`, `follow up`
- `renew`, `pay`, `invoice`, `bill`
- `appointment`, `schedule`, `confirm`

**Event Processing:**
1. Scan SUMMARY field for keywords
2. If keyword found + has DTSTART → treat as task
3. If DTSTART < today → mark as OVERDUE

---

## Priority Logic Engine

### Priority Assignment Rules

| Priority | Criteria | Urgency Score |
|----------|----------|---------------|
| **CRITICAL** | Job hunting tasks, paperwork with deadline ≤ 3 days, missed deadlines | 100 |
| **HIGH** | Deadlines ≤ 7 days, tasks newly overdue (1-3 days) | 75 |
| **MEDIUM** | Deadlines ≤ 30 days, tasks without deadlines (age > 7 days), recurring | 50 |
| **LOW** | Deadlines > 30 days, new tasks without deadlines (age ≤ 7 days) | 25 |

### Priority Calculation Algorithm

```fish
function calculate_priority
    set task_type $argv[1]      # job-hunt, paperwork, general
    set deadline $argv[2]      # YYYY-MM-DD or empty
    set created $argv[3]       # YYYY-MM-DD (for age calculation)
    set now (date +%Y-%m-%d)
    
    # Days until deadline (negative if overdue)
    if test -n "$deadline"
        set days_until (math -s0 (date -j -f "%Y-%m-%d" "$deadline" "+%s") - (date "+%s") / 86400)
    else
        set days_until 9999
    end
    
    # Task age in days
    if test -n "$created"
        set age (math -s0 (date "+%s") - (date -j -f "%Y-%m-%d" "$created" "+%s") / 86400)
    else
        set age 0
    end
    
    # Calculate priority
    if test "$task_type" = "job-hunt"; or test "$task_type" = "paperwork" -a $days_until -le 3
        echo "CRITICAL:100"
    else if test $days_until -lt 0
        echo "HIGH:75"  # Overdue
    else if test $days_until -le 7
        echo "HIGH:75"
    else if test $days_until -le 30
        echo "MEDIUM:50"
    else if test -z "$deadline" -a $age -gt 7
        echo "MEDIUM:50"
    else
        echo "LOW:25"
    end
end
```

---

## Daily Check-in Format

**Output File:** `~/Documents/03_Read/Basilica of Simulacra/01_Daily/todo-YYYY-MM-DD.md`

**Template:**
```markdown
# Daily Task Check-in — {DATE}

> Generated: {TIMESTAMP} | Tasks surfaced: {COUNT}
> Reply with task numbers to act: `!complete 1,3` | `!extend 2 2026-03-10` | `!remind 4 tomorrow`

---

## 🔴 CRITICAL ({CRITICAL_COUNT})

> Immediate attention required. These have near deadlines or are overdue.

- [ ] **[1]** Job application: BookPeople @due:2026-03-05 @overdue:1d
- [ ] **[2]** Fill out court order for name/gender change @due:2026-03-06

---

## 🟠 HIGH ({HIGH_COUNT})

> Action within the week recommended.

- [ ] **[3]** CoffeePeople job application @due:2026-03-08
- [ ] **[4]** Driver's license replacement @no-deadline @age:14d

---

## 🟡 MEDIUM ({MEDIUM_COUNT})

> Address within the month.

- [ ] **[5]** Follow up on TX Workforce verification @remind:2026-03-15

---

## 🟢 LOW ({LOW_COUNT})

> Backlog. Consider scheduling or deferring.

- [ ] **[6]** Review old research files @no-deadline @age:3d

---

## ⏰ OVERDUE TASKS ({OVERDUE_COUNT})

> These tasks have passed their deadline. What would you like to do?

| # | Task | Original Due | Days Overdue |
|---|------|--------------|--------------|
| 1 | BookPeople application | 2026-03-05 | 1 day |

**Options:**
- `!extend 1 YYYY-MM-DD` — Set new deadline
- `!complete 1` — Mark as done
- `!cancel 1` — Remove from tracking

---

## 📅 Upcoming This Week

| Date | Event/Task | Source |
|------|------------|--------|
| 2026-03-06 | Court order deadline | todo.md |
| 2026-03-08 | CoffeePeople deadline | todo.md |

---

## Commands

```
!complete <num>[,<num>...]  — Mark tasks complete
!extend <num> <date>        — Extend deadline
!remind <num> <date>        — Remind later (moves to specified date)
!cancel <num>               — Cancel/remove task
!snooze <num>               — Hide until tomorrow (adds to tomorrow's check-in)
!priority <num> <level>     — Manually set priority (CRITICAL/HIGH/MEDIUM/LOW)
!help                        — Show this command reference
```

---

_Generated by Steward (Vane-Systems task surfacing automation)_
```

---

## Overdue Handling

### Detection Logic

```fish
function detect_overdue
    set today (date +%Y-%m-%d)
    set cal_path "$HOME/.local/share/vdirsyncer/calendars"
    
    # Find events with past DTSTART and no COMPLETED or CANCELLED status
    find "$cal_path" -name "*.ics" | while read ics
        set dtstart (grep "^DTSTART" "$ics" | head -1 | string replace -r ".*[:=]" "")
        set status (grep "^STATUS:" "$ics" | string replace "STATUS:" "")
        set summary (grep "^SUMMARY:" "$ics" | string replace "SUMMARY:" "")
        
        if test -n "$dtstart"
            if test "$dtstart" \< "$today"
                if test "$status" != "COMPLETED" -a "$status" != "CANCELLED"
                    echo "$summary|$dtstart|$ics"
                end
            end
        end
    end
end
```

### Resolution Workflow

1. **Present overdue tasks** in dedicated section
2. **Prompt for action:**
   - Extend deadline → `!extend <num> YYYY-MM-DD`
   - Mark complete → `!complete <num>`
   - Cancel → `!cancel <num>`
3. **Update source files** with new status/deadline
4. **Sync** changes back to CalDAV if applicable

---

## Automation Pipeline

### Cron Schedule

```cron
# Task surfacing runs at 09:00 daily (after digest at 08:00)
0 9 * * * /usr/local/bin/fish ~/.automation/task-surfacing.fish >> ~/.automation/logs/task-surfacing.log 2>&1
```

### Fish Script: `~/.automation/task-surfacing.fish`

```fish
#!/usr/bin/env fish
# Daily Task Surfacing Pipeline
# Design: Vane-Systems | Implementation: Vane-Steward

set BASILICA "$HOME/Documents/03_Read/Basilica of Simulacra"
set DAILY "$BASILICA/01_Daily"
set TODO "$DAILY/todo.md"
set LOG "$HOME/.automation/logs/task-surfacing.log"
set TODAY (date +%Y-%m-%d)

# Ensure directories exist
mkdir -p "$DAILY"
mkdir -p (dirname "$LOG")

# ═══════════════════════════════════════════════════════════════════════════
# PHASE 1: SYNC
# ═══════════════════════════════════════════════════════════════════════════

echo "[$(date -Iseconds)] Starting task surfacing pipeline" >> "$LOG"

# Sync CalDAV calendars
echo "[$(date -Iseconds)] Syncing calendars..." >> "$LOG"
vdirsyncer sync 2>&1 >> "$LOG"

# ═══════════════════════════════════════════════════════════════════════════
# PHASE 2: EXTRACT
# ═══════════════════════════════════════════════════════════════════════════

set tasks_file (mktemp)
set cal_path "$HOME/.local/share/vdirsyncer/calendars"

# Extract tasks from calendar events with keywords
set keywords "apply|submit|deadline|due|todo|task|interview|follow.?up|renew|pay|invoice"

find "$cal_path" -name "*.ics" | while read ics_file
    set summary (grep "^SUMMARY:" "$ics_file" 2>/dev/null | string replace "SUMMARY:" "")
    set dtstart_raw (grep "^DTSTART" "$ics_file" | head -1)
    set description (grep "^DESCRIPTION:" "$ics_file" | string replace "DESCRIPTION:" "")
    set categories (grep "^CATEGORIES:" "$ics_file" | string replace "CATEGORIES:" "")
    
    # Parse DTSTART (handles both DTSTART:20260304 and DTSTART;VALUE=DATE:20260304)
    set dtstart (echo "$dtstart_raw" | string replace -r ".*[:=]" "")
    
    # Check if this looks like a task
    if echo "$summary $description $categories" | grep -iqE "$keywords"
        echo "CAL|$summary|$dtstart|$categories" >> "$tasks_file"
    end
end

# Extract tasks from todo.md
if test -f "$TODO"
    # Parse manual entries section
    sed -n '/# Manual Entries/,/# Completed/p' "$TODO" | grep -E "^- \[ \]" | while read line
        set task_text (echo "$line" | string replace -r "^- \[ \] " "")
        set due_date (echo "$task_text" | grep -oE "@due:[0-9-]+" | string replace "@due:" "")
        set task_type (echo "$task_text" | grep -oE "@type:[a-z-]+" | string replace "@type:" "")
        echo "TODO|$task_text|$due_date|$task_type" >> "$tasks_file"
    end
end

# ═══════════════════════════════════════════════════════════════════════════
# PHASE 3: PRIORITIZE
# ═══════════════════════════════════════════════════════════════════════════

set output_file "$DAILY/todo-$TODAY.md"
set critical_count 0
set high_count 0
set medium_count 0
set low_count 0
set overdue_count 0

# ... prioritization logic ...

# ═══════════════════════════════════════════════════════════════════════════
# PHASE 4: PRESENT
# ═══════════════════════════════════════════════════════════════════════════

# Write output file
echo "Tasks written to: $output_file" >> "$LOG"

# Present to user via Discord or terminal
# This would be handled by Steward responding to the output
# The daily digest script can be modified to include a reference to this file

echo "[$(date -Iseconds)] Task surfacing complete" >> "$LOG"
```

---

## Steward Integration

### Steward's Role

After Systems generates the daily check-in file, Steward:

1. **Reads the output** from `todo-YYYY-MM-DD.md`
2. **Presents to user** via Discord message or terminal notification
3. **Processes user commands** when user responds
4. **Updates source files** based on commands:
   - `!complete` → Move task to Completed section, update calendar if linked
   - `!extend` → Update `@due:` metadata in todo.md
   - `!remind` → Add `@remind:` metadata, suppress from daily surfacing until date
   - `!cancel` → Remove from tracking
   - `!snooze` → Add to tomorrow's check-in list

### Command Processing

When user sends Discord message like `!complete 1,3`:

1. Steward parses task numbers
2. Looks up task IDs in today's check-in file
3. Updates source (todo.md or calendar)
4. Confirms action back to user

---

## Integration with Daily Digest

The existing `daily-digest.fish` runs at 08:00. Task surfacing runs at 09:00.

**Modification to `daily-digest.fish`:**

Add section after "New Research Files":

```fish
# Add task check-in reference
echo "" >> "$OUTPUT"
echo "## Today's Tasks" >> "$OUTPUT"
echo "" >> "$OUTPUT"
set task_file "$BASILICA/01_Daily/todo-(date +%Y-%m-%d).md"
if test -f "$task_file"
    echo "Task check-in available: [View](todo-(date +%Y-%m-%d).md)" >> "$OUTPUT"
else
    echo "Task surfacing not yet run today." >> "$OUTPUT"
end
```

---

## Data File: `todo.md` Structure

**Initial File Creation:**

If `todo.md` doesn't exist, Steward creates it with the following structure:

```markdown
# Active Tasks

> This file is managed by Steward. Manual edits go in "Manual Entries" section.
> Generated: 2026-03-04

## CRITICAL
<!-- Auto-populated from task surfacing -->

## HIGH
<!-- Auto-populated from task surfacing -->

## MEDIUM
<!-- Auto-populated from task surfacing -->

## LOW
<!-- Auto-populated from task surfacing -->

---

# Manual Entries
<!-- Add your tasks here. Steward will process them. -->
<!-- Use @due:YYYY-MM-DD for deadlines, @type:job-hunt or @type:paperwork for priority -->

- [ ] Get a driver's license replacement
- [ ] Fill out name and gender marker change court order for e-filing @type:paperwork
- [ ] Complete BookPeople job application @type:job-hunt
- [ ] Complete CoffeePeople job application @type:job-hunt

---

# Completed
<!-- Tasks move here when marked complete -->

- [x] Find out more about Texas's policy on updating gender markers
- [x] Apply to 3 jobs by Friday
- [x] Complete the ID check on TX Workforce
```

---

## Lobster Workflow: `task-surfacing.lobster`

For complex multi-step processing with approval gates:

```yaml
# task-surfacing.lobster
# Daily task surfacing workflow with Steward integration

name: task-surfacing
description: Extract, prioritize, and present daily tasks from CalDAV and todo.md

args:
  dryRun:
    description: Generate output without updating files
    default: false

steps:
  # Phase 1: Sync calendars
  - id: sync_calendars
    command: vdirsyncer sync
    description: Sync CalDAV calendars to local ICS files

  # Phase 2: Extract tasks
  - id: extract_tasks
    command: |
      # Task extraction logic
      fish ~/.automation/lib/task-extract.fish
    description: Extract tasks from calendars and todo.md

  # Phase 3: Calculate priorities
  - id: prioritize
    command: |
      fish ~/.automation/lib/priority-engine.fish
    description: Apply priority rules to extracted tasks

  # Phase 4: Generate check-in file
  - id: generate_output
    command: |
      fish ~/.automation/lib/generate-checkin.fish
    description: Generate daily check-in markdown file

  # Phase 5: Present to user
  - id: present
    command: |
      echo "Task check-in ready for presentation"
    description: Signal completion for Steward pickup

onError:
  - id: log_error
    command: |
      echo "[$(date -Iseconds)] Task surfacing failed" >> ~/.automation/logs/task-surfacing.log
    description: Log errors
```

---

## File Locations Summary

| File | Path | Purpose |
|------|------|---------|
| Task surfacing script | `~/.automation/task-surfacing.fish` | Main pipeline |
| Task extraction lib | `~/.automation/lib/task-extract.fish` | Calendar & todo parsing |
| Priority engine lib | `~/.automation/lib/priority-engine.fish` | Priority calculation |
| Check-in generator | `~/.automation/lib/generate-checkin.fish` | Markdown output |
| Master todo file | `~/Documents/03_Read/Basilica of Simulacra/01_Daily/todo.md` | Persistent task store |
| Daily check-in | `~/Documents/03_Read/Basilica of Simulacra/01_Daily/todo-YYYY-MM-DD.md` | Today's surfaced tasks |
| Log file | `~/.automation/logs/task-surfacing.log` | Execution log |

---

## Rollout Plan

### Phase 1: Foundation (Day 1)
1. Create `todo.md` with initial structure
2. Write `task-extract.fish` library
3. Write `priority-engine.fish` library
4. Test extraction from existing calendars

### Phase 2: Pipeline (Day 2)
1. Write `generate-checkin.fish`
2. Write main `task-surfacing.fish` script
3. Add cron job at 09:00

### Phase 3: Steward Integration (Day 3)
1. Add Discord presentation capability
2. Implement command parsing
3. Add update loop for user responses

### Phase 4: Refinement (Week 2)
1. Add keyword tuning based on actual calendar data
2. Implement overdue escalation logic
3. Add recurring task handling

---

## Maintenance Notes

- **Calendar sync errors:** Check vdirsyncer status in logs
- **Missing tasks:** Verify ICS files have proper DTSTART format
- **Priority miscalculation:** Review priority-engine.fish rules
- **Stale data:** Run `rm ~/.local/share/khal/khal.db` to rebuild cache

---

## Appendix: ICS Field Reference

| Field | Usage |
|-------|-------|
| `SUMMARY` | Task title |
| `DESCRIPTION` | Task details, notes |
| `DTSTART` | Due/start date |
| `DTEND` | End date (for appointments) |
| `STATUS` | CONFIRMED, CANCELLED, COMPLETED, TENTATIVE |
| `CATEGORIES` | Custom categories (Task, Reminder, etc.) |
| `PRIORITY` | 1-9 (1=highest, rarely used) |
| `UID` | Unique identifier for linking |
| `LAST-MODIFIED` | Change timestamp |

---

_This specification is ready for Steward implementation review. Systems recommends Phase 1 execution upon approval._