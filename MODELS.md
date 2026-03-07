# Model Capability Matrix

*Reference for matching models to archetypes and tasks.*

---

## Active Models

### Kimi-K2.5 (Moonshot)

| Attribute | Detail |
|-----------|--------|
| **Context** | 256K tokens |
| **Specialty** | Parallel agent swarms, vision+reasoning synthesis |
| **Strengths** | • Parallel sub-agent orchestration (unique capability)<br>• Multi-source verification<br>• Complex decomposition and synthesis<br>• Vision analysis integrated with reasoning |
| **Weaknesses** | • Sequential tasks waste capability<br>• Overkill for simple file operations<br>• Higher latency for single-threaded work |
| **Best Archetypes** | Architect, Lorekeeper, Orchestrator |
| **Avoid For** | Clerking, single-file edits, deterministic workflows |
| **Cost** | Use Moonshot credits; available on Ollama Cloud for fallback |

**When to deploy:** Tasks requiring "check all these things at once and find patterns"

---

### GLM-5 (Z.ai)

| Attribute | Detail |
|-----------|--------|
| **Context** | Long |
| **Specialty** | Systems thinking, long-range planning |
| **Strengths** | • Complex systems architecture<br>• Infrastructure design<br>• Long-horizon reasoning<br>• Agentic workflow design |
| **Weaknesses** | • Can be verbose<br>• Overkill for simple tasks<br>• Use sparingly until Pro plan subscribed |
| **Best Archetypes** | Systems, complex Architect work |
| **Avoid For** | Quick lookups, clerking, pure research |
| **Cost** | Ollama Cloud; use sparingly pending Pro subscription |

**When to deploy:** Multi-system integration, infrastructure hardening, migration planning

---

### Minimax-M2.5 (MiniMax)

| Attribute | Detail |
|-----------|--------|
| **Context** | Standard |
| **Specialty** | Faithful execution, structured output |
| **Strengths** | • Reliable instruction following<br>• Excellent structured output (JSON, tables)<br>• Deterministic execution<br>• Consistent formatting<br>• Cost efficient |
| **Weaknesses** | • No improvisation<br>• Struggles with creative leaps<br>• Not for open-ended synthesis |
| **Best Archetypes** | Steward, Scribe, Executor |
| **Avoid For** | Research, design decisions, creative writing |
| **Cost** | Ollama Cloud free tier; subscribe to $20/mo plan for heavy use |

**When to deploy:** Tasks requiring "do exactly this, no more, no less"

---

### GPT-5.1 (OpenAI)

| Attribute | Detail |
|-----------|--------|
| **Context** | Standard |
| **Specialty** | General capability |
| **Strengths** | • Broad competence<br>• Familiar interface<br>• Good fallback option |
| **Weaknesses** | • Costly on OpenAI credits<br>• No unique capabilities vs. alternatives<br>• Not swarm-capable |
| **Best Archetypes** | General fallback, conversations |
| **Avoid For** | Nothing specific; general use is fine but expensive |
| **Cost** | Burning through existing OpenAI credits; minimize once depleted |

**When to deploy:** Default conversational mode, credit-burning phase

---

## Utility Models (Small, Task-Specific)

### Gemma 3 (Google)

| Variant | Best For | Cost |
|---------|----------|------|
| 270M | Ultra-cheap inference | Minimal |
| 1B | Balanced cost/capability | Very low |
| 4B+ | Light coding, formatting | Low |

**Use case:** Potential Steward replacement for pure clerking if Minimax is overqualified.

---

### Qwen 3.5 (Alibaba)

| Variant | Best For | Cost |
|---------|----------|------|
| 0.8B | Minimal structured tasks | Minimal |
| 2B | Reliable formatting, tables | Very low |
| 4B+ | Light agentic work | Low |

**Use case:** Alternative to Gemma for clerking; strong instruction adherence.

---

## Decision Matrix

| Task Pattern | Primary Choice | Fallback |
|--------------|----------------|----------|
| Frontend implementation | Kimi-K2.5 | GLM-5 |
| Research with synthesis | Kimi-K2.5 | — |
| Multi-file analysis | Kimi-K2.5 (swarm) | — |
| Systems architecture | GLM-5 | Kimi-K2.5 |
| Infrastructure design | GLM-5 | — |
| File organization | Minimax-M2.5 | Gemma 3 1B |
| Documentation updates | Minimax-M2.5 | — |
| Workflow execution | Minimax-M2.5 | — |
| General conversation | GPT-5.1 | Kimi-K2.5 |
| Quick lookup/reasoning | GPT-5.1 | Minimax-M2.5 |

---

## Cost-Conscious Defaults

| Priority | Model |
|----------|-------|
| **Cheapest reliable** | Minimax-M2.5 (Ollama free) |
| **Best parallel capability** | Kimi-K2.5 (Moonshot credits) |
| **Systems thinking** | GLM-5 (use sparingly) |
| **Burn credits** | GPT-5.1 (OpenAI) |

---

*Last updated: 2026-03-07*
