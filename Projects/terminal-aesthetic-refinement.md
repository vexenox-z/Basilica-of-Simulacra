# Terminal Aesthetic Refinement

**Stack:** Ghostty + Fish + Starship + JetBrains Mono  
**Current State:** Transparency + blur enabled, elaborate Starship config, minimal Fish setup  
**Goal:** Cohesive, lean, beautiful—without over-engineering

---

## 1. Ghostty Configuration (Create)

**File:** `~/.config/ghostty/config`

```ini
# Font
font-family = JetBrains Mono
font-size = 14
font-thicken = true
font-feature = -calt

# Transparency & Visuals
background-opacity = 0.92
background-blur-radius = 20
unfocused-split-opacity = 0.95

# Cursor
cursor-style = block
cursor-style-blink = false
cursor-color = #f5e0dc
cursor-text = #1e1e2e

# Selection
selection-background = #353749
selection-foreground = #cdd6f4

# Window
window-padding-x = 12
window-padding-y = 8
window-decoration = none
window-save-state = always
confirm-close-surface = false

# Colors (Catppuccin Mocha)
palette = 0=#45475a
palette = 1=#f38ba8
palette = 2=#a6e3a1
palette = 3=#f9e2af
palette = 4=#89b4fa
palette = 5=#f5c2e7
palette = 6=#94e2d5
palette = 7=#bac2de
palette = 8=#585b70
palette = 9=#f38ba8
palette = 10=#a6e3a1
palette = 11=#f9e2af
palette = 12=#89b4fa
palette = 13=#f5c2e7
palette = 14=#94e2d5
palette = 15=#a6adc8
background = #1e1e2e
foreground = #cdd6f4
```

**Visual Impact:** Solid 92% opacity (readable but atmospheric), subtle padding creates breathing room, block cursor in rose-pink against dark background. Catppuccin Mocha provides cohesive, muted tones across the stack.

**Rationale:** Ghostty defaults are functional but bland. These settings create a "designed" feel without gimmicks. The 8px padding prevents text from feeling cramped against window edges.

---

## 2. Starship Simplification Refinement

**File:** `~/.config/starship.toml` (Selective edits)

Your current config is symbol-dense. These targeted changes create visual hierarchy:

```toml
# Replace your current [format] section with this cleaner layout
format = """
$username$hostname$directory$git_branch$git_status$git_metrics
$character"""

right_format = """
$cmd_duration$nodejs$python$rust$golang$lua$time
"""

# Simplify character symbols for less visual noise
[character]
format = "$symbol "
success_symbol = "[›](bold bright-blue)"
error_symbol = "[›](bold red)"
vimcmd_symbol = "[‹](bold dimmed green)"

# Streamline directory - less symbol clutter
[directory]
home_symbol = "~"
truncation_length = 3
truncation_symbol = "…/"
read_only = " ro"
style = "bold blue"
repo_root_format = '[$repo_root]($repo_root_style)[$path]($style) [on](dimmed white) '

# Cleaner git - reduce bracket soup
[git_branch]
format = "[$symbol$branch]($style) "
symbol = ""
style = "italic bright-blue"
truncation_length = 20

[git_status]
style = "bold bright-blue"
format = "([$ahead_behind$staged$modified$untracked$stashed]($style)) "
ahead = "↑[$count](white) "
behind = "↓[$count](white) "
staged = "+[$count](white) "
modified = "~[$count](white) "
untracked = "?[$count](white) "
stashed = "≡[$count](white) "

# Refined cmd_duration - subtle when fast
[cmd_duration]
format = "[took $duration](italic dimmed white) "
min_time = 2000

# Node - simplified
[nodejs]
format = "[via](dimmed white) [node $version](bold bright-green) "
detect_files = ["package.json"]
detect_folders = ["node_modules"]

# Python - simplified
[python]
format = "[via](dimmed white) [py $version](bold bright-yellow) "
symbol = ""
python_binary = ["python3", "python"]
```

**Visual Impact:** Before: Dense geometric symbols (`◎ ○ △ □ ■ ▶ ◇`) competing for attention. After: Clean arrows, minimal prefix words ("via", "on", "took"), better use of whitespace and muted tones for metadata.

**Rationale:** Your current prompt is expressive but cluttered. These changes preserve personality while establishing clear hierarchy: location → git state → command input. Right-aligned context appears only when relevant.

---

## 3. Fish Greeting Function

**File:** `~/.config/fish/functions/fish_greeting.fish`

```fish
function fish_greeting
    set -l hour (date +%H)
    set -l greeting
    
    if test $hour -ge 5 -a $hour -lt 12
        set greeting "morning"
    else if test $hour -ge 12 -a $hour -lt 18
        set greeting "afternoon"
    else if test $hour -ge 18 -a $hour -lt 22
        set greeting "evening"
    else
        set greeting "night"
    end
    
    # Only show on interactive shells in terminal
    if status is-interactive; and test -n "$TERM"
        set -l term_width (stty size 2>/dev/null | cut -d' ' -f2)
        
        # Subtle separator line
        echo
        set_color brblack
        printf "  %s\n" (string repeat -n (math min $term_width - 4 60) "─")
        set_color normal
        
        # Time-based greeting
        set_color brblue
        printf "  good %s.\n" $greeting
        set_color normal
        
        # Quick context (optional - remove if too busy)
        if command -q fortune; and test (random) -lt 1638  # ~25% chance
            set_color brblack
            printf "  %s\n" (fortune -s 2>/dev/null | string replace -r '\n' ' ')
            set_color normal
        end
        
        echo
    end
end
```

**Add to** `~/.config/fish/config.fish`:
```fish
# Aesthetic greeting
set -g fish_greeting
```

**Visual Impact:** Subtle horizontal rule, time-aware greeting, optional fortune quote 25% of the time. Adds warmth without animation bloat.

**Rationale:** Fish's default greeting is nil. This creates a moment of presence when opening terminal—acknowledgment of time, brief pause before productivity. The separator visually "frames" the session start.

---

## 4. Fish Abbreviations & Aliases (Aesthetic Utility)

**File:** `~/.config/fish/config.fish` (append)

```fish
# Aesthetic ls with eza (install: brew install eza)
if command -q eza
    alias ls="eza --icons=auto --group-directories-first"
    alias ll="eza -la --icons=auto --group-directories-first --git"
    alias lt="eza --tree --icons=auto --level=2"
end

# Cat with syntax highlighting (install: brew install bat)
if command -q bat
    alias cat="bat --paging=never --style=plain"
    alias less="bat --paging=always"
end

# Directory navigation abbreviations
abbr -a .. "cd .."
abbr -a ... "cd ../.."
abbr -a .... "cd ../../.."
abbr -a -- - "cd -"

# Git abbreviations (cleaner than aliases)
abbr -a g "git"
abbr -a gs "git status -sb"
abbr -a ga "git add"
abbr -a gc "git commit -m"
abbr -a gp "git push"
abbr -a gl "git log --oneline --graph -10"

# Quick config edits
abbr -a vifish "$EDITOR ~/.config/fish/config.fish"
abbr -a vighost "$EDITOR ~/.config/ghostty/config"
abbr -a vistar "$EDITOR ~/.config/starship.toml"
```

**Visual Impact:** `ls` shows icons and git status, `cat` has syntax highlighting. Git commands are 2-3 keystrokes. Terminal feels responsive and purpose-built.

**Rationale:** Fish abbreviations expand inline (unlike aliases), so you see the full command. eza+bat modernize core utilities with visual polish that matches your aesthetic investment.

---

## 5. TTY Clock (Optional Aesthetic Accent)

**Install:** `brew install tty-clock`

**File:** `~/.config/fish/functions/clock.fish`

```fish
function clock
    tty-clock -c -C 4 -b -B -D
end
```

**Usage:** Type `clock` in an empty terminal for a centered, block-style clock with Catppuccin blue accents.

**Visual Impact:** Full-screen, minimalist block clock. Useful for pomodoro breaks or ambient workspace presence.

---

## Summary of Changes

| Change | Effort | Impact | File |
|--------|--------|--------|------|
| 1. Ghostty config | Low | High | Create `~/.config/ghostty/config` |
| 2. Starship simplify | Low | Medium | Edit `~/.config/starship.toml` |
| 3. Fish greeting | Low | Low-Medium | Create `fish_greeting.fish` |
| 4. eza/bat + abbrs | Medium | Medium | Edit `config.fish` |
| 5. tty-clock | Low | Low | Optional accent |

---

## Before → After

**Before:** Default Ghostty + symbol-heavy Starship + minimal Fish
**After:** Cohesive Catppuccin theming across all components, breathing room via padding, cleaner prompt hierarchy, utility-enhanced shell experience.

**Core Principle:** Each component should feel intentionally designed, not merely configured. The result is a terminal that welcomes rather than merely accepts input.

---

*Document generated for aesthetic refinement of terminal stack.*
