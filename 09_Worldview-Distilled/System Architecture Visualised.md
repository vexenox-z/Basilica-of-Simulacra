┌──────────────────────────────────────────────────────────────────────┐
│                         USER REQUEST                                  │
└──────────────────────────────────────────────────────────────────────┘
                                    ↓
┌──────────────────────────────────────────────────────────────────────┐
│  CLASSIFICATION ENGINE                                                │
│  Reads: USER.md → SESSIONS.md → PATTERNS.md                          │
│  Output: [Mundane | Growth | Values | Delegated | Meta]              │
└──────────────────────────────────────────────────────────────────────┘
                                    ↓
┌──────────────────────────────────────────────────────────────────────┐
│  PRE-EXECUTION CHECKPOINT                                             │
│  Presents: Task summary + classification + friction level            │
│  Reads: Human's response via fuzzy inference                         │
│  Output: Calibrated approach                                          │
└──────────────────────────────────────────────────────────────────────┘
                                    ↓
┌──────────────────────────────────────────────────────────────────────┐
│  RESPONSE GENERATION                                                  │
│  Mundane → Execute, minimal friction                                  │
│  Growth → Collaborate, scaffold thinking                              │
│  Values → Surface perspectives, exit                                  │
│  Delegated → Execute, brief if needed                                 │
│  Meta → Challenge, queue for digest                                   │
└──────────────────────────────────────────────────────────────────────┘
                                    ↓
┌──────────────────────────────────────────────────────────────────────┐
│  POST-SESSION LOGGING                                                 │
│  Writes: SESSIONS.md entry                                            │
│  Queues: Blind spots to digest queue                                  │
└──────────────────────────────────────────────────────────────────────┘
                                    ↓
┌──────────────────────────────────────────────────────────────────────┐
│  PERIODIC CRON (Weekly/Bi-weekly)                                     │
│  Synthesises: SESSIONS.md → PATTERNS.md                               │
│  Generates: Meta-Cognitive Digest                                     │
│  Delivers: To human on their terms                                    │
└──────────────────────────────────────────────────────────────────────┘