# Directory Architecture Audit
**Date:** 2026-03-03  
**Auditor:** Vane-Systems  
**Subject:** Xena's macOS Home Directory Structure

---

## Executive Summary

Xena's directory structure shows **strong intentional organization** in the Basilica of Simulacra knowledge base, with clear numbered-prefix conventions and purposeful hierarchy. However, several friction points exist:

1. **Security risk:** Unencrypted password CSV in `01_Life/`
2. **Storage imbalance:** 101GB (83% of Documents) consumed by `02_Play/` emulation content
3. **Abandoned locations:** Empty inbox, orphaned log directory, underutilized work folder
4. **Naming inconsistencies:** Spaces/apostrophes in file names, mixed conventions in gaming folders
5. **Git neglect:** Basilica of Simulacra is initialized but content is untracked

---

## Current State Map

### Home Directory (~)

```
~
├── .cache/                    # 9 app caches (fish, nvim, claude, etc.)
├── .config/                   # 14 config directories (fish, nvim, starship, etc.)
├── .local/                    # bin (symlinks), share, state
├── .openclaw/                 # OpenClaw daemon workspace (28 items)
├── .claude/                   # Claude CLI data (backups, cache, projects)
├── .nvm/                      # Node version manager
├── .cargo/                    # Rust toolchain
├── .npm/                      # npm cache
├── .ollama/                   # Ollama models
├── .lmstudio/                 # LM Studio configs
├── .docker/                   # Docker configs
├── Applications/              # User applications
├── Desktop/                   # (4 items)
├── Documents/                 # 122GB total
│   ├── 00_Inbox/              # EMPTY
│   ├── 01_Life/               # 21GB (Legal, Linux, Passwords.csv)
│   ├── 02_Play/               # 101GB (Games, ROMs, saves)
│   ├── 03_Read/               # 233MB (Basilica + papers)
│   ├── 04_Archive/            # 6.8MB (old resumes, code)
│   └── 05_Work/               # 1 PDF (underutilized)
├── Downloads/                 # (3 items)
├── Library/                   # macOS system library
├── Movies/
├── Music/
├── Pictures/
├── Public/
├── Calibre Library/           # E-book management
├── Zotero/                    # Reference manager
├── Portia/                    # ⚠️ Orphaned (Screenshot folder)
├── log/                       # ⚠️ Abandoned (single Jan file)
├── aseprite/                  # 2.3GB (dev repo, home-level)
├── openzl/                    # 668MB (dev repo, home-level)
├── zed/                       # 9.5GB (dev repo, home-level)
└── go/                        # Go package cache
```

**Dotfile Count:** 21 hidden directories in ~

### Documents Structure

```
Documents/
├── 00_Inbox/                  # Empty - intake folder unused
├── 01_Life/
│   ├── Legal/                 # Court documents, claims
│   ├── Linux/                 # ⚠️ 5GB+ in Linux ISOs (archboot, ubuntu)
│   └── Passwords.csv          # 🔴 SECURITY RISK: unencrypted passwords
├── 02_Play/
│   ├── Games/                 # ROMs by platform (3DS, DC, GBA, GC, NDS, PS2, PS3, PSP, PSX, SNES, WII)
│   ├── Darkest/               # Darkest Dungeon profiles (10 profiles)
│   ├── My Games/
│   ├── Portia/
│   ├── SaveGames/
│   ├── SavedGames/
│   └── wonderlang-demo-osx-all/
├── 03_Read/
│   ├── Academic_Papers/       # 2 PDFs (Sobel, Zhou)
│   ├── Basilica of Simulacra/ # Primary knowledge base (see below)
│   ├── Coursera Docs/         # Old Coursera code bundle
│   ├── Web-Clippings/         # 14 HTML files (saved articles)
│   └── [PDFs]                 # 4 standalone PDFs
├── 04_Archive/
│   ├── Code/                  # Development-Archive, gen-comm.jsx
│   ├── Images/                # Single large image
│   └── Resumes/               # 9 resume variants
└── 05_Work/
    └── [1 PDF]                # Design framework document
```

### Basilica of Simulacra Structure

```
Basilica of Simulacra/
├── .git/                      # Initialized but content untracked
├── .obsidian/                 # Obsidian vault config
├── .openclaw/                 # OpenClaw integration
├── 00_Meta/                   # AGENTS.md, SOUL.md, USER.md, IDENTITY.md, TOOLS.md, HEARTBEAT.md, Welcome.md
├── 01_Daily/                  # daily-checkins.md, exploration-prompts.md, todo-list.md
├── 02_Learning/               # 3 guides (Agentic Workflows, German, Learning How to Learn)
├── 03_Personal/
│   ├── Employment History.md
│   ├── N's Texts.md
│   ├── Trajectory.md
│   └── Reflections/           # Single evening reckoning file
├── 04_Work/                   # SXSW cover letter, resume
├── 05_Creative/               # Single sample chapter
├── 06_Research/               # Cryptography, secret societies primers
├── 07_Guides/                 # Context engineering, vibe coding guides
├── Projects/                  # ⚠️ Single file (terminal-aesthetic-refinement.md)
├── Research/
│   ├── 2026-02-26/           # mycology-psychedelic, simulacra-philosophy, virtue-of-wandering
│   ├── 2026-03-01/           # ai-assistant-optimizations, openclaw-pro-guide
│   └── Claude-Guidance/      # Claude skill-building PDF
├── memory/                    # Date-stamped memory files (5 files)
├── AGENTS.md                  # Duplicated from 00_Meta?
├── Claude's Notes.md          # ⚠️ Apostrophe in filename
├── HEARTBEAT.md               # Empty (intentional)
├── IDENTITY.md
├── SOUL.md
├── TOOLS.md
├── USER.md
└── neon-life.html            # Orphaned creative artifact?
```

### Config Directory (~/.config)

```
.config/
├── fish/                      # ✓ Well-configured shell
│   ├── config.fish            # Aliases, abbreviations, OpenClaw integration
│   ├── functions/             # clock.fish, fish_greeting.fish
│   ├── completions/
│   └── conf.d/
├── nvim/                      # ✓ Git-tracked LazyVim config
├── starship.toml              # ✓ Clean prompt customization
├── topgrade.toml              # System update automation
├── topgrade.d/
├── iterm2/
├── joplin-desktop/
├── raycast/
├── StardewValley/
└── ppsspp/
```

### Application Support (~/Library/Application Support)

- **121 application directories**
- **Estimated 135GB** total
- Notable: Obsidian (active), Claude, Bitwarden, Brave, Steam, multiple game platforms

---

## Working Patterns (Keep)

### ✓ Numbered Directory Hierarchy (Documents)

The `00_` through `05_` prefix system in Documents provides:
- Clear semantic ordering (Inbox → Life → Play → Read → Archive → Work)
- Predictable navigation via tab-completion
- Separation of concerns (Play vs. Life vs. Work)

**Recommendation:** Maintain and extend this pattern.

### ✓ Basilica Numbered Sections

The `00_Meta` through `07_Guides` structure in Basilica of Simulacra:
- Follows same logical numbering as Documents
- Keeps meta-documents separate from content
- Clear categorical boundaries

### ✓ Date-Stamped Research Directories

`Research/2026-02-26/`, `Research/2026-03-01/` pattern:
- Chronological organization
- Subdirectories for distinct topics
- Easy to archive older research

### ✓ Fish + Starship Configuration

- Clean config.fish with abbreviations
- Starship prompt with minimal visual noise
- Editor shortcuts (`vifish`, `vighost`, `vistar`)

### ✓ Git-Tracked nvim Config

- LazyVim setup with git history
- Clean lua/ structure

### ✓ ROM Organization by Platform

`02_Play/Games/PLATFORM/` convention:
- Clear separation by console
- Standard abbreviations (PSX, NDS, GBA)

### ✓ OpenClaw Workspace Integration

- Well-structured `~/.openclaw/` with workspace, agents, cron
- Completions properly sourced in fish

---

## Problem Areas (Fix)

### 🔴 HIGH PRIORITY

#### 1. Unencrypted Password File

**Location:** `~/Documents/01_Life/Passwords.csv`  
**Risk:** CSV containing passwords in plaintext  
**Recommendation:** 
- Delete immediately after migrating to Bitwarden (already installed)
- Verify Bitwarden import, then secure-delete the CSV

```
# Priority: HIGH
# Action: Delete Passwords.csv after Bitwarden migration
# Rationale: Security risk - plaintext credentials
```

#### 2. Git-Neglected Knowledge Base

**Location:** `~/Documents/03_Read/Basilica of Simulacra/`  
**Issue:** `.git` initialized but all content untracked  
**Impact:** No version history for knowledge base

**Git Status Output:**
```
?? .DS_Store
?? .obsidian/
?? .openclaw/
?? 00_Meta/
?? 01_Daily/
[...all content untracked...]
```

**Recommendation:**
- Add `.gitignore` with proper patterns
- Stage and commit core documents
- Consider `.gitattributes` for line endings

```
# Priority: HIGH
# Action: Configure .gitignore, stage content
# Rationale: Knowledge base needs version control
```

#### 3. Storage Imbalance

**Location:** `~/Documents/02_Play/`  
**Impact:** 101GB (83% of Documents) consumed by games/ROMs  
**Issue:** Backup and sync inefficiency

**Recommendation:**
- Consider relocating `Games/` to external drive or dedicated volume
- Or move to `~/Library/Application Support/[Emulator]/` convention
- Document in TOOLS.md for reference

```
# Priority: MEDIUM
# Action: Relocate ROM library
# Rationale: Reduces backup burden, separates entertainment from documents
```

### 🟡 MEDIUM PRIORITY

#### 4. Orphaned/Abandoned Directories

| Location | Issue | Recommendation |
|----------|-------|----------------|
| `~/log/` | Single Jan 25 log file | Delete directory |
| `~/Portia/` | Screenshot folder, misnamed | Move to `~/Pictures/Portia/` or delete |
| `~/Documents/00_Inbox/` | Empty, unused | Repurpose or document intent |
| `~/Documents/05_Work/` | Single PDF, underutilized | Merge into Basilica `04_Work/` or expand |

#### 5. Naming Inconsistencies

| Current | Issue | Suggested Fix |
|---------|-------|---------------|
| `Basilica of Simulacra` | Spaces in path | Accept as-is (established), avoid new spaces |
| `Claude's Notes.md` | Apostrophe in filename | Rename to `claude-notes.md` or `session-notes.md` |
| `My Games/` | Inconsistent with `Games/` | Consolidate into `Games/` or rename |
| `SaveGames/` + `SavedGames/` | Duplicate conventions | Consolidate to `Saves/` |
| `Coursera Docs/` | Space, underutilized | Move code to `04_Archive/Code/Coursera/` |

#### 6. Development Repositories at Home Level

**Locations:** `~/zed/`, `~/openzl/`, `~/aseprite/`  
**Issue:** Large repos (12.5GB combined) at home level  
**Recommendation:**
- Create `~/Development/` or `~/Projects/` directory
- Move repos there for organization
- Or document intentional placement in TOOLS.md

```
# Priority: MEDIUM
# Action: Create Development folder or document in TOOLS.md
# Rationale: Home directory cluttered with dev repos
```

#### 7. Duplicated Meta Files in Basilica

**Issue:** `AGENTS.md`, `SOUL.md`, `USER.md`, `IDENTITY.md`, `HEARTBEAT.md`, `TOOLS.md` exist at root AND in `00_Meta/`  
**Status:** Root versions appear to be the originals; `00_Meta/` copies may be outdated  
**Recommendation:**
- Symlink from root to `00_Meta/` OR
- Keep single source of truth in `00_Meta/` and symlink root to it

### 🟢 LOW PRIORITY

#### 8. Unused Inbox Folder

`~/Documents/00_Inbox/` is empty. The numbered prefix system suggests intent, but it's unused.

**Options:**
- Document as "intake folder for sorting"
- Remove if no longer needed
- Use for temporary staging

#### 9. Single-Item Directories

| Location | Contents | Recommendation |
|----------|----------|----------------|
| `Projects/` | 1 file (terminal-aesthetic-refinement.md) | Move to `02_Learning/` or `07_Guides/` |
| `05_Creative/` | 1 file (Red-State-Blue-Heart-Sample-Chapter.md) | Accept as workspace starter |
| `05_Work/` (Documents) | 1 PDF | Merge into Basilica `04_Work/` |

#### 10. Large ISO Files in Wrong Location

**Location:** `~/Documents/01_Life/Linux/`  
**Contents:** Ubuntu ISO (5GB), Archboot ISO (300MB), Parrot Security UTM  
**Issue:** ISO files in "Life" category  
**Recommendation:** Move to `~/ISO/` or `~/Downloads/ISO/` or delete after use

#### 11. Web-Clippings Could Be Integrated

**Location:** `~/Documents/03_Read/Web-Clippings/`  
**Contents:** 14 HTML files (design frameworks, guides)  
**Issue:** Separate from Basilica knowledge base  
**Recommendation:** Convert to Markdown and file in appropriate Basilica section

---

## Proposed Changes (Numbered)

### High Priority

1. **Delete Passwords.csv** after verifying Bitwarden migration
   - Location: `~/Documents/01_Life/Passwords.csv`
   - Risk: Security breach
   - Implementation: `rm ~/Documents/01_Life/Passwords.csv`

2. **Initialize Git tracking in Basilica**
   - Create proper `.gitignore`:
     ```
     .DS_Store
     .obsidian/
     .openclaw/
     neon-life.html
     ```
   - Stage core documents: `git add 00_Meta/ 01_Daily/ 02_Learning/ 03_Personal/ 04_Work/ 05_Creative/ 06_Research/ 07_Guides/`
   - Initial commit with message documenting intent

3. **Consolidate meta files in Basilica**
   - Determine canonical location (root vs `00_Meta/`)
   - Symlink or remove duplicates
   - Update AGENTS.md reference if needed

### Medium Priority

4. **Create Development directory**
   - Create `~/Development/`
   - Move `~/zed/`, `~/openzl/`, `~/aseprite/` into it
   - Update TOOLS.md with location note

5. **Clean up Play directory naming**
   - Consolidate `My Games/` into `Games/` or rename to match
   - Merge `SaveGames/` and `SavedGames/` into single `Saves/`
   - Document convention in TOOLS.md

6. **Relocate Linux ISOs**
   - Create `~/ISO/` or move to `~/Downloads/ISO/`
   - Or delete if no longer needed

7. **Remove abandoned directories**
   - Delete `~/log/` (single Jan file)
   - Move or delete `~/Portia/` screenshot folder

8. **Rename files with special characters**
   - `Claude's Notes.md` → `claude-notes.md` or `session-notes.md`

### Low Priority

9. **Document or remove empty Inbox**
   - Add README to `~/Documents/00_Inbox/` explaining purpose
   - Or remove if unnecessary

10. **Relocate Web-Clippings into Basilica**
    - Convert HTML to Markdown
    - File under appropriate `07_Guides/` subdirectories

11. **Merge isolated single files**
    - `Projects/terminal-aesthetic-refinement.md` → `02_Learning/` or `07_Guides/`
    - `Documents/05_Work/` content → Basilica `04_Work/`

---

## Implementation Priority Matrix

| Priority | Count | Est. Time |
|----------|-------|-----------|
| HIGH | 3 | 30 min |
| MEDIUM | 5 | 1 hour |
| LOW | 3 | 30 min |

**Total Estimated Implementation:** 2 hours

---

## Recommendations for TOOLS.md

Add the following documentation:

```markdown
### Development Projects
- Location: ~/Development/ (or specify current location)
- Active repos: zed, openzl, aseprite

### ROM Library
- Location: ~/Documents/02_Play/Games/
- Convention: Platform abbreviations (PSX, NDS, GBA, etc.)
- Size: ~100GB - excluded from standard backup

### ISO Files
- Location: ~/ISO/ (create if needed)
- Purpose: Linux distros, installer images

### Password Management
- Tool: Bitwarden (installed)
- NO plaintext password files
```

---

## Notes

### Color Tags / Emoji Usage
- No Finder color tags observed in scanned directories
- No emoji usage in directory names
- Basilica uses lowercase filenames with hyphens (good practice)

### Git Depth
- Basilica: Untracked content, needs initialization
- nvim: Properly tracked with git
- zed, openzl, aseprite: External repos with their own git

### Maximum Depth Observed
- `Research/2026-02-26/mycology-psychedelic/raw/` = 3 levels (acceptable)
- `Games/PLATFORM/[roms]/` = 3 levels (acceptable)

---

## Appendix: Storage Summary

| Location | Size |
|----------|------|
| ~/Documents/ | 122 GB |
| └─ 02_Play/ | 101 GB (83%) |
| └─ 01_Life/ | 21 GB (17%) |
| └─ 03_Read/ | 233 MB |
| └─ 04_Archive/ | 6.8 MB |
| └─ 05_Work/ | 1.3 MB |
| ~/Library/Application Support/ | 135 GB |
| ~/zed/ | 9.5 GB |
| ~/aseprite/ | 2.3 GB |
| ~/openzl/ | 668 MB |

---

**Audit Complete.**  
**Next Steps:** Await Archibald's review before Steward implementation.