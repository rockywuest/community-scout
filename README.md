# 🔍 Community Scout

**AI-powered dev community intelligence for your agent.**

Monitors Reddit, Hacker News, GitHub Trending, and X/Twitter — your AI agent analyzes the results and delivers what matters to you.

## What It Does

Community Scout is a bash script that scrapes dev communities and feeds the results to your AI assistant for intelligent filtering:

- **Reddit** — r/ClaudeAI, r/LocalLLaMA, r/moltbot (configurable)
- **X/Twitter** — Via Grok API X Search  
- **GitHub Trending** — New hot repos
- **Hacker News** — Top stories

Your agent reads the raw data, filters by relevance, and delivers a concise briefing.

## Usage

```bash
# Run manually
./community-scout.sh

# Or schedule via cron (e.g., Mon/Wed/Fri at 10:00)
0 10 * * 1,3,5 /path/to/community-scout.sh
```

## Built For

- [Clawdbot](https://github.com/clawdbot/clawdbot) / [Moltbot](https://moltbot.com) agents
- Any AI assistant with file access

## Requirements

- `curl`, `bash`
- Optional: Grok API key for X/Twitter search

## License

MIT

---

☕ [Support on Ko-fi](https://ko-fi.com/rockywuest)

