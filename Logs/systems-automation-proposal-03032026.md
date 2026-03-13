# Systems Automation Proposal: Stale Items Dashboard

**Date:** 03.03.2026
**Author:** Vane-Systems
**For:** Xena

---

## 1. The Problem It Solves

The `00_Inbox/` directory is where things go to be forgotten.

ADHD brains treat "out of sight" as "doesn't exist." When a file lands in Inbox, it's visible for a moment — then disappears into the folder, never to surface again unless actively remembered. The weekly Steward audit (Sundays 20:00) is too infrequent to catch things that need attention *this week*.

**Pattern observed:** Items enter Inbox, age silently, and require manual memory to retrieve. There is no mechanism that says "hey, this thing has been sitting here for 5 days."

This extends beyond Inbox:
- Project directories (`03_Read/Basilica of Simulacra/Projects/`) accumulate half-finished work
- Draft documents sit untouched
- Action items buried in notes never resurface

The core failure mode: **visibility is a one-time event, not a persistent state.**

---

## 2. Proposed Solution

**A Fish shell startup function that displays a "Stale Items Dashboard" every time a new terminal session opens.**

This turns terminal launches — which happen frequently throughout the day — into automatic reminders. The dashboard surfaces:
- Files in `00_Inbox/` older than N days
- Files in active project directories that haven't been modified in N days
- Optionally: memos (via `memo` CLI) older than N days

The dashboard is passive but persistent. It doesn't require Xena to remember to check anything — it simply appears, every time, until the items are addressed.

---

## 3. Technical Outline

### 3.1 Fish Function Location

Create a function in `~/.config/fish/functions/stale_items.fish`:

```fish
function stale_items --description "Display stale items dashboard"
    # Configuration
    set inbox_path ~/Documents/00_Inbox
    set projects_path ~/Documents/03_Read/Basilica_of_Simulacra/Projects
    set stale_days 3
    set stale_seconds (math "$stale_days * 24 * 60 * 60")
    
    set has_stale false
    
    # Check Inbox
    if test -d $inbox_path
        set stale_files (fd --type f --max-depth 1 --changed-before "$stale_days days" . $inbox_path 2>/dev/null)
        if test -n "$stale_files"
            set has_stale true
            echo "📥 INBOX (stale > $stale_days days):"
            for f in $stale_files
                echo "  "(basename $f)
            end
        end
    end
    
    # Check Projects (files not modified in N days)
    if test -d $projects_path
        set stale_projects (fd --type f --changed-before "$stale_days days" . $projects_path 2>/dev/null | head -10)
        if test -n "$stale_projects"
            set has_stale true
            echo ""
            echo "📁 PROJECTS (inactive > $stale_days days):"
            for f in $stale_projects
                echo "  "(string replace $projects_path/ "" $f)
            end
        end
    end
    
    # Summary line if nothing stale
    if test "$has_stale" = false
        echo "✓ No stale items"
    end
end
```

### 3.2 Integration Point

Add to `~/.config/fish/config.fish`:

```fish
# Run stale items dashboard on interactive shell startup
if status is-interactive
    stale_items
end
```

### 3.3 Tools Required

All already present in Xena's stack:
- `fish` — Shell
- `fd` — File finder with time filters
- `eza` — Optional: use for better listing output

### 3.4 Optional Enhancements

**A.** Add `memo` integration to surface stale notes:
```fish
# Check for stale memos (if memo CLI supports listing by date)
set stale_memos (memo list --older-than $stale_days 2>/dev/null)
if test -n "$stale_memos"
    echo ""
    echo "📝 MEMOS (stale):"
    echo $stale_memos
end
```

**B.** Color-coded output via `set_color`:
```fish
echo (set_color yellow)"📥 INBOX (stale):"(set_color normal)
```

**C.** Config file at `~/.config/stale_items.conf` for custom thresholds per directory.

---

## 4. Why This Is High-Value for ADHD Brain

| ADHD Challenge | How This Helps |
|----------------|----------------|
| **Object permanence** | Items remain visible every terminal launch until addressed |
| **Forgetting to check** | No active check required — passive display on shell start |
| **"I'll deal with it later"** | Repeated exposure creates gentle pressure to act |
| **Mental overhead** | Zero configuration after setup; works automatically |
| **Overwhelming backlogs** | Can tune `stale_days` threshold to surface only relevant items |

**Key insight:** The terminal is already a frequent touchpoint. Turning it into a passive reminder system costs nothing and gains persistent visibility.

This is not a new tool to learn or a habit to build. It hijacks an existing habit (opening terminal sessions) and injects useful information into that moment.

---

## 5. Implementation Steps

1. Create `~/.config/fish/functions/stale_items.fish` with the function above
2. Add the `stale_items` call to `config.fish`
3. Open a new terminal to test
4. Tune `stale_days` threshold as needed (start with 3, adjust)

---

## 6. Rollback

Remove the function file and the `stale_items` call from `config.fish`. No persistent state is created.

---

*End of proposal.*