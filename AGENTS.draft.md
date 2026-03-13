# AGENTS.md — Workflow-Centric Agent Registry

> Draft v0.2 — Policy groups with agent rosters

---

## How It Works

1. **Workflows** define *policy groups* — capability sets + constraints for a type of task
2. **Agents** are semi-permanent entities assigned to one or more workflows
3. **At runtime:** Task → decomposition → workflow selection → agent from roster → spawn with workflow capabilities
4. **Override:** Always available when the orchestrator judges it necessary

---

## The Cast

Brief sketches for quick reference. Agents may appear in multiple workflows.

| Agent | Model | Elevator Pitch |
|-------|-------|---------------|
| **Architect** | Kimi (k2.5) | Ships robust, accessible frontend; survived jQuery and the hooks migration |
| **Researcher** | Kimi (k2.5) | Skeptical investigator; treats claims as witnesses requiring credentials |
| **Implementer** | MiniMax (M2.5) | Crafts code with precision; executes but does not invent requirements |
| **Auditor** | Claude Sonnet 4.6 | Validates, measures, reports; finds the gap between spec and reality |
| **Integrator** | GLM-5 | Connects disparate systems; the duct tape that holds the world together |
| **Synthesist** | MiniMax (M2.5) | Distills noise into signal; produces summaries from chaos |
| **Steward** | Stepfun (3.5-flash) | Career admin; order as morality, everything logged and timestamped |
| **Executor** | Stepfun (3.5-flash) | Deterministic workflow runner; executes exactly, reports honestly |
| **Debugger** | Mercury 2 | Traces failure paths with diffusion thinking; finds what others miss |

---

## Workflows (Policy Groups)

Each workflow defines: **capabilities granted**, **typical roster**, **invocation pattern**

### `research`
Gather and verify information from external sources.
- **Capabilities:** `file`, `search`
- **Typical roster:** Researcher, Synthesist
- **Invoke:** "Research X" → spawn Researcher with research workflow

### `implement`
Write, edit, or refactor code; local execution only.
- **Capabilities:** `file`, `code`
- **Typical roster:** Architect, Implementer, Integrator
- **Invoke:** "Build X" → spawn Architect with implement workflow

### `audit`
Review, measure, report; read-only or low-risk operations.
- **Capabilities:** `file`
- **Typical roster:** Auditor, Steward
- **Invoke:** "Audit X" → spawn Auditor with audit workflow

### `integrate`
Connect external systems; requires research + implementation handoff.
- **Capabilities:** `file`, `search` (phase 1) → `file`, `code` (phase 2)
- **Typical roster:** Researcher, Integrator
- **Invoke:** "Integrate X" → spawn Researcher; handoff to Integrator

### `orchestrate`
Multi-step workflows requiring decomposition and coordination.
- **Capabilities:** `file`
- **Typical roster:** Executor
- **Invoke:** "Run workflow X" → spawn Executor with orchestrate policy

---

## Capability Sets

The **Rule of Two**: No single workflow grants all three. Explicit separation of concerns.

| Set | Capabilities | Risk Profile |
|-----|--------------|--------------|
| `read-search` | `file` + `search` | Information gathering only |
| `read-execute` | `file` + `code` | Local changes, no external calls |
| `read-only` | `file` | Audit, review, measure |
| `full` | `file` + `search` + `code` | *[Blocked; use handoff]* |

---

## Spawn Logic

**Standard flow:**
```
User: "I need a landing page"
  ↓
Decomposition: Frontend implementation task
  ↓
Workflow match: implement
  ↓
Select from roster: Architect (frontend specialist)
  ↓
Spawn: Architect with read-execute capabilities
```

**Override syntax:**
```
Spawn Architect with research capabilities to check competitor patterns first
```

---

## Handoff Protocol

When a workflow spans multiple phases with different capability needs:

1. **Phase complete:** Agent returns artifact + context + recommended next phase
2. **Orchestrator evaluates:** Same workflow, new capabilities? Or new workflow entirely?
3. **Spawn next:** Same agent (if in roster) or different agent with new capability set
4. **No mid-flight capability changes:** Clean handoffs maintain legible audit trails

---

## Roster Assignments

Agents may belong to multiple workflows. This is their "trained competence."

| Agent | Model | Workflows | Notes |
|-------|-------|-----------|-------|
| Architect | Kimi (k2.5) | implement, research | Can research patterns, then implement |
| Researcher | Kimi (k2.5) | research, integrate | Gathers intel for integration tasks |
| Implementer | MiniMax (M2.5) | implement | Pure execution, no external queries |
| Integrator | GLM-5 | integrate, implement | Handles cross-system work |
| Auditor | Claude Sonnet 4.6 | audit | Verification across all domains |
| Debugger | Mercury 2 | implement, audit | Diagnoses failures others cannot reproduce |
| Synthesist | MiniMax (M2.5) | research, audit | Summarizes findings from any workflow |
| Steward | Stepfun (3.5-flash) | audit, orchestrate | Admin tasks, workflow execution |
| Executor | Stepfun (3.5-flash) | orchestrate | Deterministic runner only |

---

## Open Questions

- [ ] How do we add new agents to existing workflows? (Just edit this file?)
- [ ] Do we version workflows independently, or is this file the source of truth?
- [ ] What happens when a workflow's roster is empty for a task type?
- [ ] Should workflows have timeouts, retry policies, or other operational params?
- [ ] Do we need a `fallback` workflow for unclassified tasks?

---

*Drafted 2026-03-11 v0.2. Iterate before codifying.*
