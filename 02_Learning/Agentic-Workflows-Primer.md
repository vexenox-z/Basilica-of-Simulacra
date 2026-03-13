# Agentic Workflows: A Practical Primer (2025 Edition)

*How AI Agents Actually Work — And How We Direct Them*

---

## 1. What Is An "Agentic Workflow"?

**The simple version:** Instead of one question → one answer, an agentic workflow is a **loop**. The AI doesn't just generate a final response immediately; it builds, tests, and refines it step-by-step.

**The "Director" Perspective:** For someone who likes to construct prompts, think of an agent as a **sub-contractor** rather than a search box. You provide the **Intent** and **Context**, and the agent manages the **Execution**.

> **Key Industry Insight (2025):** "The quality of an agent is defined more by its workflow than by the underlying model's raw power." — *Andrew Ng*

---

## 2. The Four Core Patterns

Modern agentic systems (like the one we use) are built on four primary design patterns. Understanding these helps you direct me more effectively.

### Pattern A: Reflection (The "Self-Editor")
The agent generates a draft, critiques its own work, and then improves it based on that critique.
- **Your Prompt Strategy:** "Write a draft of X, then look for gaps in logic, and rewrite it for clarity."
- **Why it works:** It catches hallucinations and "vibe" mismatches before you ever see the output.

### Pattern B: Tool Use (The "Hands")
The agent decides which external functions (web search, file editing, shell commands, API calls) it needs to accomplish a goal.
- **Your Prompt Strategy:** "Use the `browser` to find X, then `write` a summary to my vault."
- **Context Engineering:** This requires "Tool-Aware Prompting"—giving the agent clear descriptions of what each tool can and cannot do.

### Pattern C: Planning (The "Architect")
The agent breaks a high-level goal into a structured list of sub-tasks.
- **Example:** If you ask for a "complete job search plan," I don't just list jobs. I plan: 1) Research companies, 2) Audit resume, 3) Create tracking sheet, 4) Draft cover letters.
- **Your Role:** You act as the **Reviewer**. You can approve or adjust the plan before execution begins.

### Pattern D: Multi-Agent Collaboration (The "Team")
Different specialized agents (or model personalities) work together, often in parallel.
- **Our Setup:** I (Main Session) act as the **Orchestrator**. I can spawn **Sub-Agents** for deep research or coding while I keep the main conversation moving.
- **Best Practice:** Use "Role-Based Prompts" for sub-agents (e.g., "Act as a security auditor" vs "Act as a creative copywriter").

---

## 3. The "Director" Toolkit: Context & Prompt Engineering

Since you like to direct and construct prompts, these are the current best practices for agentic control:

### A. Context Engineering (Persistence > Prompt)
Don't repeat yourself in every prompt. Use the **Persistence Layer**:
- **`MEMORY.md`**: Your long-term "source of truth" (goals, pronouns, key projects).
- **`USER.md`**: Your current focus (e.g., Jamf 100 cert, design projects).
- **`IDENTITY.md`**: My personality and tone settings (Rudolf 🦴).
- **Files-as-Context**: I read these files at the start of every session. Update them to change my behavior globally.

### B. Chain-of-Thought (CoT) Prompting
Ask the agent to "Think out loud."
- **Instruction:** "Before you act, write down your reasoning process in a `thought` block."
- **Benefit:** You can see *why* I'm making a decision and intervene if my logic drifts.

### C. Explicit Constraints
Agents are prone to "helpful drift"—doing things you didn't ask for.
- **Directives:** "Do not use markdown tables," "Save only to the `/Research` folder," "Use `trash` instead of `rm`."
- **The Golden Rule:** If it's a critical preference, put it in `SOUL.md` or `AGENTS.md`.

---

## 4. How We Use This (Our Stack)

| Component | Role | Pattern Used |
|-----------|------|--------------|
| **Main session (me)** | Orchestrator & Logic | Planning + Reflection |
| **Sub-agents** | Specialists | Multi-agent Collaboration |
| **Cron jobs** | Autonomous Loops | Autonomous Rituals |
| **Tools (Shell/Web)** | Capability Extension | Tool Use |

---

## 5. Practical "Director" Workflows for You

### Workflow 1: The Research Loop
1. **You:** "Research [Topic]. Plan the steps first."
2. **Me:** [Provides Plan]
3. **You:** "Execute Step 1 and 2, then report back."
4. **Result:** You guide the depth and direction without doing the manual searching.

### Workflow 2: Certification Prep (Jamf/ACSP)
1. **You:** "I need to study for Jamf 100. Generate a quiz based on the official docs."
2. **Me:** [Uses `web_fetch` on docs] → [Plans Quiz] → [Acts as Tutor]
3. **Pattern:** Tool Use + Planning.

### Workflow 3: The "Draft-Review-Refine"
1. **You:** "Draft a cover letter for [Company]."
2. **Me:** [Drafts] → [Self-Critiques for 'corporate speak'] → [Rewrites in your voice]
3. **Pattern:** Reflection.

---

## 6. Glossary for the Modern Director

| Term | What It Means to You |
|------|----------------------|
| **Agentic Loop** | The repetitive process of Think → Act → Observe → Correct. |
| **Hallucination** | When the AI makes things up. *Fix: Use Tool Use (Search) or Reflection.* |
| **Orchestrator** | The main AI (Rudolf) that manages the sub-tasks and sub-agents. |
| **Ritual (Cron)** | A "File-and-Forget" task that runs on a schedule (e.g., Morning Ritual). |
| **Persistence** | Data that survives a restart (Files in your vault). |

---

*Updated by Rudolf for Xena Vexus Nox | 2026-02-18*
*Based on 2025 Best Practices: Reflection, Tool Use, Planning, and Persistence.*
