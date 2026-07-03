# 🔍 Community Scout

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Made for AI Assistants](https://img.shields.io/badge/Made%20for-AI%20Assistants-blue)](https://github.com/rockywuest)
[![Bash](https://img.shields.io/badge/Bash-5.x-green.svg)](https://www.gnu.org/software/bash/)

**AI-powered dev community intelligence. Never miss what matters.**

Your AI agent monitors Reddit, Hacker News, GitHub Trending, and X/Twitter — analyzes the noise, delivers the signal.

---

## The Problem

Staying current in tech means monitoring dozens of sources daily. Hacker News, Reddit, GitHub Trending, Twitter — it's overwhelming. Most of what you see is irrelevant to *your* work.

You could set up RSS feeds and notification bots, but then you're drowning in unfiltered noise. What you actually need is someone who reads *everything* and tells you only what's relevant.

## The Solution

Let your AI do the reading. Community Scout scrapes 4 major dev communities and dumps raw data for your agent to analyze:

```
📊 Community Scout — 2026-02-05

REDDIT HIGHLIGHTS:
• r/LocalLLaMA: "Running Llama 3.2 on RPi 5 with 2-bit quant" (847↑)
  → Relevant: You're running local AI on Pi 5
• r/ClaudeAI: "MCP servers list — 50+ integrations" (234↑)
  → Relevant: You use MCP for memory

GITHUB TRENDING:
• janhq/jan ⭐4.2k (+312 today) — Open-source ChatGPT alternative
  → Worth watching: Local-first, privacy focused

HACKER NEWS:
• "Show HN: I built a personal AI that manages my entire life" (523 pts)
  → Directly relevant: Similar to your setup

X/TWITTER (via Grok):
• @OpenAI: Announcing GPT-5 — available next month
  → Context: May affect your model choices
```

The agent filters by your interests, scores by relevance, and summarizes in 30 seconds what would take 2 hours to read.

---

## Features

- 📰 **Multi-source** — Reddit, HN, GitHub Trending, X/Twitter (via Grok API)
- 🎯 **AI filtering** — Your agent reads raw data, filters by YOUR interests
- ⏰ **Cron-ready** — Schedule for Mon/Wed/Fri mornings
- 🔌 **Zero config** — Works out of the box (X/Twitter needs Grok API key)
- 📝 **Plain text output** — Easy for any LLM to parse
- 🔧 **Configurable** — Edit subreddits, keywords, sources in the script

## Quick Start

```bash
# Clone
git clone https://github.com/rockywuest/community-scout.git
cd community-scout

# Run
./community-scout.sh

# Output lands in /tmp/community-scout-*.md
```

## Schedule It

```bash
# Add to cron (Mon/Wed/Fri at 10:00)
crontab -e
0 10 * * 1,3,5 /path/to/community-scout/community-scout.sh
```

Or use your agent's built-in scheduler (Clawdbot cron, n8n, etc.).

## Configuration

Edit the script header to customize:

```bash
# Subreddits to monitor
SUBREDDITS="ClaudeAI LocalLLaMA moltbot selfhosted"

# Keywords to boost relevance
KEYWORDS="raspberry pi|mcp|clawdbot|moltbot|local llm"

# Grok API key for X/Twitter (optional)
XAI_API_KEY="${XAI_API_KEY:-}"

# Reviewed Xquik/TweetClaw export to include in the report (optional)
XQUIK_EXPORT_FILE="/path/to/reviewed-xquik-export.jsonl"
```

## Requirements

- `bash` (5.x)
- `curl`
- `jq` (for JSON parsing)
- Optional: `XAI_API_KEY` env var for X/Twitter via Grok API
- Optional: `XQUIK_EXPORT_FILE` pointing at a reviewed Xquik/TweetClaw CSV, JSON, or JSONL export

## Built For

- [Clawdbot](https://github.com/clawdbot/clawdbot) / [Moltbot](https://moltbot.com) agents
- [OpenClaw](https://openclaw.ai) users
- Any AI assistant with file access and tool use

## How It Works

1. **Scrape** — curl pulls from Reddit JSON API, HN Algolia, GitHub trending page, Grok X Search, and optional reviewed Xquik/TweetClaw exports
2. **Dump** — Raw results saved to timestamped markdown file
3. **Agent reads** — Your AI assistant reads the file (via heartbeat, cron, or manual trigger)
4. **Filter & brief** — Agent applies your interest profile, delivers relevant items only

The magic is in step 4 — the AI filtering turns noise into signal.

---

## Example Agent Integration (Clawdbot)

```markdown
# HEARTBEAT.md
- Check /tmp/community-scout-*.md for new scout reports
- Filter for items relevant to: AI assistants, Raspberry Pi, MCP, local LLMs
- If anything scores >7/10 relevance, include in morning briefing
```

---

## License

MIT — Use it, fork it, improve it.

---

**Built by Nox ⚡** for [Rocky Wüst](https://github.com/rockywuest)

☕ [Support on Ko-fi](https://ko-fi.com/rockywuest)
