# OpenClaw Configuration Audit Report

**Auditor:** Vane-Lorekeeper  
**Date:** 03.03.2026 (2026-03-03)  
**Config File:** `~/.openclaw/openclaw.json`  
**Documentation Source:** https://docs.openclaw.ai/tools (verified live)

---

## Executive Summary

The current OpenClaw configuration is **functionally sound** with no critical errors. All core settings align with documented best practices. However, there are **opportunities for enhancement** to improve security posture, operational efficiency, and feature completeness.

---

## What's Correct in Our Config

### ✅ Browser Configuration

| Setting | Current Value | Status | Documentation Verification |
|---------|--------------|--------|---------------------------|
| `browser.enabled` | `true` | ✓ Correct | Default is `true`; explicitly setting is acceptable |
| `browser.defaultProfile` | `"openclaw"` | ✓ Correct | Docs recommend `"openclaw"` for managed mode; `"chrome"` is the default but uses extension relay |
| `browser.executablePath` | `"/Applications/Brave Browser.app/..."` | ✓ Correct | Brave is explicitly supported; auto-detect order: Chrome → Brave → Edge → Chromium → Chrome Canary |
| `profiles.openclaw.cdpPort` | `18800` | ✓ Correct | Falls within documented range (18800–18899) |
| `profiles.chrome.cdpPort` | `18792` | ✓ Correct | Default port for Chrome extension relay |

**Rationale:** The browser setup properly uses the **managed OpenClaw browser** (isolated profile) as default, with Brave explicitly configured. This provides deterministic tab control and isolation from personal browsing data.

### ✅ Model/Thinking Settings

| Setting | Current Value | Status | Documentation Verification |
|---------|--------------|--------|---------------------------|
| `agents.defaults.thinkingDefault` | `"medium"` | ✓ Correct | Valid levels: `off \| minimal \| low \| medium \| high \| xhigh \| adaptive` |
| Model aliases | `Kimi`, `MiniMax`, `GLM` | ✓ Correct | Properly configured under `agents.defaults.models` |

**Rationale:** `"medium"` maps to "think harder" per documentation. For Moonshot models specifically, any non-`off` level enables thinking with `type: "enabled"`, which is the desired behavior.

### ✅ JSON Config Structure

| Aspect | Status | Notes |
|--------|--------|-------|
| Config location | ✓ Correct | `~/.openclaw/openclaw.json` (documented standard) |
| Provider structure | ✓ Correct | Moonshot and Ollama providers properly nested under `models.providers` |
| Authentication | ✓ Correct | API key mode configured for Moonshot |
| Discord channel config | ✓ Correct | Guild and channel allowlisting properly structured |

---

## What Needs Fixing or Improvement

### ⚠️ Medium Priority: Missing SSRF Policy Configuration

**Current State:** No `browser.ssrfPolicy` defined.  
**Documentation Reference:** Browser docs specify SSRF guardrails.

**Recommendation:**
```json
"browser": {
  "enabled": true,
  "defaultProfile": "openclaw",
  "executablePath": "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
  "ssrfPolicy": {
    "dangerouslyAllowPrivateNetwork": true
  },
  "profiles": {
    "openclaw": { "cdpPort": 18800, "color": "#FF4500" },
    "chrome": { "cdpPort": 18792, "color": "#00AA00" }
  }
}
```

**Rationale:** While `dangerouslyAllowPrivateNetwork` defaults to `true` (trusted-network model), explicitly documenting this choice improves auditability and security clarity.

### ⚠️ Low Priority: Tool-loop Detection Not Enabled

**Current State:** No `tools.loopDetection` configuration.  
**Documentation Reference:** Disabled by default (`"tools.loopDetection.enabled: false"`).

**Recommendation:**
```json
"tools": {
  "loopDetection": {
    "enabled": true,
    "warningThreshold": 10,
    "criticalThreshold": 20,
    "globalCircuitBreakerThreshold": 30,
    "historySize": 30,
    "detectors": {
      "genericRepeat": true,
      "knownPollNoProgress": true,
      "pingPong": true
    }
  }
}
```

**Rationale:** This prevents agents from getting stuck in repetitive no-progress tool call loops. Particularly valuable for long-running autonomous tasks.

### ⚠️ Low Priority: Web Search Disabled

**Current State:** `"tools.web.search.enabled": false`  
**Documentation Reference:** Requires Brave API key.

**Recommendation:** If Brave Search API key is available, enable:
```json
"tools": {
  "web": {
    "search": {
      "enabled": true,
      "maxResults": 10
    },
    "fetch": {
      "enabled": true,
      "maxCharsCap": 50000
    }
  }
}
```

**Rationale:** Web search capability significantly expands agent research capabilities. The `openclaw-web-search` plugin is already enabled in the config, but the core tool is disabled.

### ℹ️ Informational: Browser Snapshot Defaults

**Current State:** No `browser.snapshotDefaults` configured.  
**Documentation Reference:** Default is `"ai"` format when Playwright is installed.

**Optional Enhancement:**
```json
"browser": {
  "snapshotDefaults": {
    "mode": "efficient"
  }
}
```

**Rationale:** `"efficient"` mode uses compact role snapshots with lower token usage—suitable for most automation tasks.

### ℹ️ Informational: Agent Image Model Not Configured

**Current State:** No `agents.defaults.imageModel` defined.  
**Documentation Reference:** Required for `image` tool to be available.

**Note:** The `image` tool currently works through implicit model inference, but explicit configuration is recommended for reliability.

---

## Configuration Hardening Checklist

| Item | Priority | Current | Recommended | Impact |
|------|----------|---------|-------------|--------|
| SSRF Policy | Medium | Missing | Explicitly define | Security clarity |
| Loop Detection | Low | Disabled | Enable | Operational safety |
| Web Search | Low | Disabled | Enable (if API key) | Capability expansion |
| Snapshot Mode | Low | Default | Consider `"efficient"` | Token efficiency |
| Image Model | Low | Implicit | Explicit definition | Tool reliability |

---

## Full Recommended Config Additions

```json
{
  "browser": {
    "ssrfPolicy": {
      "dangerouslyAllowPrivateNetwork": true
    },
    "snapshotDefaults": {
      "mode": "efficient"
    }
  },
  "tools": {
    "loopDetection": {
      "enabled": true,
      "warningThreshold": 10,
      "criticalThreshold": 20,
      "globalCircuitBreakerThreshold": 30,
      "historySize": 30,
      "detectors": {
        "genericRepeat": true,
        "knownPollNoProgress": true,
        "pingPong": true
      }
    },
    "web": {
      "search": {
        "enabled": true,
        "maxResults": 10
      },
      "fetch": {
        "enabled": true,
        "maxCharsCap": 50000
      }
    }
  },
  "agents": {
    "defaults": {
      "imageModel": "moonshot/kimi-k2.5"
    }
  }
}
```

---

## Verification Commands

To validate any configuration changes:

```bash
# Check config validity
openclaw doctor

# Apply automatic fixes
openclaw doctor --fix

# View browser status
openclaw browser --browser-profile openclaw status

# Test thinking levels
openclaw status  # Shows current thinking level
```

---

## Sources

- [OpenClaw Tools Documentation](https://docs.openclaw.ai/tools) — Browser, thinking levels, tool configuration [VERIFIED]
- [OpenClaw Browser Configuration](https://docs.openclaw.ai/tools/browser) — Profile setup, SSRF policy, security [VERIFIED]
- [OpenClaw Thinking Levels](https://docs.openclaw.ai/tools/thinking) — Model/thinking settings [VERIFIED]
- [OpenClaw Gateway Configuration](https://docs.openclaw.ai/gateway/configuration) — JSON5 structure, hot reload [VERIFIED]

---

## Conclusion

The current configuration demonstrates solid understanding of OpenClaw's architecture. The explicit use of `"openclaw"` as the default profile shows preference for isolated, deterministic browser automation over the extension relay. No breaking issues were identified. The recommended additions are enhancements rather than corrections—focused on operational safety (loop detection), security documentation (SSRF policy), and capability expansion (web search).

**Overall Grade: A-** (Excellent foundation, minor optimizations available)

---

*Report generated by Vane-Lorekeeper per CONDUCT.md research protocols. All claims verified against live documentation.*
