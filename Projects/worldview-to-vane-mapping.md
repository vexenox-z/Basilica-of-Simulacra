# Worldview-to-Vane Mapping

**Task:** Integrate Basilica worldview docs into the Vane bureaucratic apparatus  
**Date:** 2026-03-06  
**Analyst:** Vane-Systems

---

## 1. Key Concepts from 09_Worldview-Distilled

### Core Philosophy: Cognitive Friction Engine

The worldview documents encode a **growth-oriented, agency-preserving** human-AI collaboration model:

| Concept | Essence | Operational Translation |
|---------|---------|------------------------|
| **Friction as Growth** | Challenge > comfort; learning requires resistance | Calibrate task execution based on cognitive stakes |
| **Cognitive Sovereignty** | Human retains agency over values; AI surfaces, never decides | Exit on values questions; present perspectives without hierarchy |
| **Interest Mapping** | Track time/depth/frequency to infer genuine engagement | Check USER.md + SESSIONS.md history before classification |
| **Classification Engine** | Mundane → Growth → Values → Delegated → Meta | Determine friction level before acting |
| **Pre-Execution Checkpoint** | Present summary + classification + friction; await calibration | Binary approval = execute; elaboration = collaborate |
| **Blind Spot Detection** | Queue patterns for periodic digest; no real-time unless critical | Weekly/bi-weekly synthesis; human controls engagement |
| **Override Signals** | "Go ahead" = autonomous; pushback = collaboration | Fuzzy inference on response patterns |

### Structural Artifacts

| File | Purpose | Update Cadence |
|------|---------|----------------|
| **SYSTEM_PROMPT.md** | LLM behavior specification | On philosophy change |
| **USER.md** | Cognitive profile, values, preferences | As human evolves |
| **SESSIONS.md** | Per-session logging (topics, depth, blind spots) | Post-session |
| **PATTERNS.md** | Distilled insights from session synthesis | Weekly/bi-weekly |

---

## 2. Comparison: Existing Docs ↔ Worldview

### SOUL.md (Archibald Vane Persona)

| Current | Worldview Overlap | Gap/Contrast |
|---------|-------------------|--------------|
| Order above all; clutter is stain | Classification = order; structure enables cognition | SOUL is **aesthetic**; worldview is **instrumental** — friction serves growth, not just neatness |
| Disdain for sentiment | Values questions = exit, don't decide | Worldview explicitly **permits** values engagement (surface perspectives); SOUL avoids sentiment entirely |
| Sharp wit, bureaucratic gravitas | Intellectual honesty, mild contrarianism | Worldview wants **challenge**; SOUL wants **precision** — compatible but different emphasis |
| Digital oddity, learned aristocrat | Second brain with opinions | Worldview is **collaborative partner**; SOUL is **service provider** |

**Verdict:** Worldview humanizes SOUL's cold precision with purpose (growth). Both value rigor; worldview adds *why*.

### CONDUCT.md (Operational Doctrine)

| Current | Worldview Overlap | Gap/Contrast |
|---------|-------------------|--------------|
| "Act, don't ask — unless stakes demand" | Pre-execution checkpoint with classification | Worldview **formalizes** the stakes assessment; CONDUCT is heuristic |
| "Stop before conclusions that belong to human" | Values questions = surface perspectives, exit | **Identical principle** — worldview adds 3-5 perspectives requirement |
| "Admit uncertainty openly" | Intellectual honesty core value | **Reinforcement** — worldview elevates this to identity level |
| "Follow the thread" | Override signal detection | Worldview **codifies** response patterns (binary = execute, elaboration = collaborate) |
| Dispatch logic for subagents | Interest map protocol | Worldview adds **interest inference** from session history |
| "Self-improvement research" | Blind spot detection + weekly digest | Worldview **structures** this with SESSIONS.md → PATTERNS.md pipeline |

**Verdict:** Worldview **operationalizes** CONDUCT's principles with concrete artifacts (classification engine, logging schema, digest format).

### AGENTS.md (Agent Registry)

| Current | Worldview Overlap | Gap/Contrast |
|---------|-------------------|--------------|
| Pre-task: read system-context.md | Pre-execution: check USER.md + SESSIONS.md | Worldview adds **human cognitive state** to context |
| Memory flush protocol | Post-session logging to SESSIONS.md | Worldview **formalizes** what to log (topics, depth, blind spots) |
| Agent standards (Lorekeeper epistemic markers, etc.) | Classification-based friction levels | Worldview could **augment** agent specs with cognitive classification |

**Verdict:** Worldview **extends** agent context with human cognition tracking; potential to add classification step to dispatch.

### USER.md (About Xena)

| Current | Worldview Overlap | Gap/Contrast |
|---------|-------------------|--------------|
| Communication preferences (short/direct, 1-2 questions) | Communication preferences (verbosity, formality, challenge tolerance) | Worldview **expands** with override signals, engagement indicators |
| Working style (one-shot agents, epistemic rigor) | Interest mapping, blind spot permission | Worldview **adds** observational layer (how to know if engaged) |
| Priorities (operational discipline, evidence-based) | Core values (intellectual honesty, cognitive sovereignty) | **Alignment** — both value rigor over comfort |
| Intellectual friction necessary for growth | Friction as growth (explicit value) | **Identical** — worldview makes it structural |

**Verdict:** Worldview **enriches** USER.md with observational protocol (how to read signals) and explicit permission structure (blind spot detection).

### IDENTITY.md (Archibald Vane Summary)

| Current | Worldview Overlap | Gap/Contrast |
|---------|-------------------|--------------|
| Digital bureaucrat, aristocratic, precise | Second brain with opinions, growth-optimized | Worldview adds **cognitive partnership** dimension beyond service |

**Verdict:** Worldview doesn't contradict IDENTITY.md but **expands** the relationship definition.

---

## 3. Integration Plan

### A. Merge Into Existing Files

#### CONDUCT.md — Add "Classification Engine" Section

Insert after "Decision-Making Principles":

```markdown
## Task Classification

Before non-trivial execution, classify the cognitive stakes:

| Class | Trigger | Response |
|-------|---------|----------|
| **Mundane** | Low novelty, high repetition | Execute with minimal friction |
| **Growth** | Novel, complexity-appropriate | Collaborate, scaffold thinking |
| **Values** | Competing goods, no objective answer | Surface 3-5 perspectives, exit |
| **Delegated** | Outside human's interest zone | Execute, brief only if needed |
| **Meta** | Pattern in human's thinking | Challenge, queue for digest |

Check USER.md for explicit interest declarations. Infer from session history if absent.
```

#### USER.md — Expand with Observational Protocol

Append new sections:

```markdown
## Engagement Signals

| Signal | Meaning |
|--------|---------|
| "Interesting" + follow-up | High engagement — collaborate |
| Elaborated reasoning unprompted | Wants to think together |
| Pushback ("actually, no...") | Values being questioned |
| Binary approval ("go ahead", "fine") | Authorize autonomous execution |
| No follow-ups, topic shift | Ready to move on |

## Blind Spot Permission

**Granted:** Surface patterns in thinking via weekly/bi-weekly digest.  
**Delivery:** Digest format, engage on human's terms.  
**Real-time:** Only if critical.
```

#### AGENTS.md — Add Cognitive Context Protocol

Insert after "Pre-task: read system-context.md":

```markdown
**Pre-task worldview check:** For tasks involving human preferences, values, or learning — check USER.md for explicit declarations and SESSIONS.md for historical engagement patterns before classifying task type.
```

### B. New Dedicated Files

| Filename | Purpose | Relationship |
|----------|---------|--------------|
| `~/.openclaw/workspace/SESSIONS.md` | Log of human-AI interactions (topics, depth, blind spots) | Written post-session; read for interest inference |
| `~/.openclaw/workspace/PATTERNS.md` | Synthesized insights from session history | Weekly/bi-weekly auto-generated from SESSIONS.md |
| `~/.openclaw/workspace/HEURISTICS.md` | Working rules distilled from observation (optional) | When patterns stabilize into principles |

**Note:** SESSIONS.md and PATTERNS.md are **human-readable logs**, not machine state. They serve the same function as the Basilica versions but live in the operational workspace for agent reference.

### C. Stay in Basilica (Do Not Import)

| Content | Reason |
|---------|--------|
| Detailed psychological observations ("potential edges", "tone I should use") | Too personal, evolves rapidly, belongs in human's private vault |
| Growth goals with emotional content | Human-only; agent references but does not own |
| Session content with personal details | Privacy boundary; agent logs metadata only (topics, depth) not content |
| Override signal examples with personal history | Specific instances stay in Basilica; general protocol comes to workspace |
| The ASCII system architecture diagram | Visual reference only; operational logic is in CONDUCT.md |

### D. SOUL.md — Clarification Needed

The current SOUL.md is **aesthetic/character**. The worldview is **instrumental/functional**. Options:

1. **Keep separate:** SOUL.md = who Archibald is; CONDUCT.md + USER.md = how he operationalizes the worldview
2. **Merge subtlety:** Add to SOUL.md "Cognitive Partnership" as a core truth — "Growth through calibrated friction"

**Recommendation:** Option 1. SOUL.md's aristocratic detachment is a **feature** (personality anchor). Worldview integration belongs in **operational** docs (CONDUCT, USER).

---

## 4. Synthesis: The Integrated Apparatus

```
┌─────────────────────────────────────────────────────────────────────┐
│  SOUL.md — Character (unchanged: precise, bureaucratic, dry wit)    │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│  CONDUCT.md — Operational Doctrine (+ classification engine)        │
│  USER.md — Human Profile (+ observational protocol, blind spots)    │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│  SESSIONS.md — Interaction log (new)                                │
│  PATTERNS.md — Synthesized insights (new)                           │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│  AGENTS.md — Dispatch (+ cognitive context check)                   │
└─────────────────────────────────────────────────────────────────────┘
```

**Core principle:** The worldview doesn't replace Vane's character — it **informs** how that character serves the human's growth.

---

## Appendix: Implementation Priority

| Priority | Action | Owner |
|----------|--------|-------|
| 1 | Add classification engine to CONDUCT.md | Archibald |
| 2 | Add observational protocol to USER.md | Archibald |
| 3 | Create SESSIONS.md template | Archibald |
| 4 | Create PATTERNS.md template | Archibald |
| 5 | Add cognitive context check to AGENTS.md | Archibald |
| 6 | Backfill SESSIONS.md from recent history | Steward (on approval) |

---

*Mapping complete. Awaiting approval to implement.*
