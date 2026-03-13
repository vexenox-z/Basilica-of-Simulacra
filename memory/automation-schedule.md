# Automation Schedule — Steward via Cron

## Active Jobs

| Job | Schedule | Purpose | Agent |
|-----|----------|---------|-------|
| **Security audit** | Mondays 09:00 | Weekly healthcheck (read-only) | Steward |
| **Deep security audit** | First Monday monthly | Comprehensive security review | Steward |
| **Version check** | Fridays 18:00 | OpenClaw update status | Steward |
| **File organization** | Sundays 20:00 | Downloads/workspace hygiene | Steward |

## Pending Implementation

| Job | Proposed Schedule | Purpose | Status |
|-----|-------------------|---------|--------|
| **Daily to-do surfacing** | Daily 09:00 | Important/non-urgent task review | PENDING |

## Task Surfacing Requirements (from 2026-03-04)

- Sources: CalDAV calendars, structured `01_Daily/todo.md`, keyword detection
- Priority tiers: CRITICAL/HIGH/MEDIUM/LOW
- Overdue handling: extend deadline / mark complete / cancel
- Output: Markdown daily checklist with Steward-processable commands

---
*Last updated: 2026-03-07*
