#!/opt/homebrew/bin/fish

# Phase 1: manual todo.md based task surfacing (no calendar integration yet)
# Reads manual tasks from 01_Daily/todo.md and generates a daily check-in file
# 01_Daily/todo-YYYY-MM-DD.md with simple priority bucketing.

set todo_root "$HOME/Documents/03_Read/Basilica of Simulacra/01_Daily"
set todo_file "$todo_root/todo.md"
# Fallback: support existing todo-list.md if todo.md does not yet exist
if not test -f "$todo_file"
    if test -f "$todo_root/todo-list.md"
        set todo_file "$todo_root/todo-list.md"
    end
end

set today (date +%Y-%m-%d)
set timestamp (date '+%Y-%m-%d %H:%M:%S')
set checkin_file "$todo_root/todo-$today.md"

set -l crit_tasks
set -l high_tasks
set -l med_tasks
set -l low_tasks

if test -f "$todo_file"
    # Extract manual tasks: any unchecked checklist item "- [ ] ..."
    for line in (grep '^- \[ \]' "$todo_file")
        set type ""

        for token in $line
            if string match -q -- '@type:job-hunt' $token
                set type "job-hunt"
            else if string match -q -- '@type:paperwork' $token
                set type "paperwork"
            end
        end

        # Strip metadata tags for display
        set display (string replace -r '@type:[^[:space:]]+' '' -- $line)

        # Minimal Phase 1 priority:
        # - job-hunt / paperwork → CRITICAL
        # - everything else → LOW (we can refine with dates later)
        if test "$type" = "job-hunt" -o "$type" = "paperwork"
            set crit_tasks $crit_tasks $display
        else
            set low_tasks $low_tasks $display
        end
    end
end

# Count surfaced tasks
set surfaced_count (math (count $crit_tasks) + (count $high_tasks) + (count $med_tasks) + (count $low_tasks))

mkdir -p "$todo_root"

# Write header
printf "# Daily Task Check-in — %s\n\n" $today > "$checkin_file"
printf "> Generated: %s | Tasks surfaced: %s\n\n" $timestamp $surfaced_count >> "$checkin_file"

# Sections
printf "## CRITICAL\n\n" >> "$checkin_file"
for t in $crit_tasks
    echo $t >> "$checkin_file"
end

printf "\n## HIGH\n\n" >> "$checkin_file"
for t in $high_tasks
    echo $t >> "$checkin_file"
end

printf "\n## MEDIUM\n\n" >> "$checkin_file"
for t in $med_tasks
    echo $t >> "$checkin_file"
end

printf "\n## LOW\n\n" >> "$checkin_file"
for t in $low_tasks
    echo $t >> "$checkin_file"
end

printf "\n---\n\n# Notes\n\n- Phase 1: priorities are minimal (job-hunt/paperwork → CRITICAL; everything else → LOW).\n- Calendar/ICS integration and richer priority logic will come in a later phase.\n" >> "$checkin_file"
