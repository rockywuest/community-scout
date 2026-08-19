# Community Scout — AI-Powered Dev Community Intelligence

Stop drowning in tabs. Community Scout monitors Hacker News, GitHub Trending, Reddit, and X/Twitter — then your AI agent analyzes everything and delivers only what matters.

## The Problem

You open HN, Reddit, X, GitHub every morning. You scroll. You miss the one post that would have saved you 10 hours. You catch up on trends two weeks late.

## The Solution

Community Scout scrapes 4+ platforms, filters by your interests (AI agents, coding tools, open source), and feeds everything to your Clawdbot/Moltbot agent. The agent doesn't just forward links — it identifies **trends, threats, and opportunities** across platforms.

## What Makes This Different From a Link Dump

| Feature | Link Dump | Community Scout |
|---------|-----------|-----------------|
| Output | 50 URLs | "3 platforms discuss context loss. Here's what they're doing." |
| Effort | You read everything | Agent reads, you get the summary |
| Cross-platform | One site at a time | HN + Reddit + X + GitHub combined |
| Actionable | "Here's a link" | "Install this. Build that. Avoid this." |

## Platforms Monitored

| Platform | Method | Cost |
|----------|--------|------|
| **Hacker News** | Firebase API (free, real-time) | Free |
| **GitHub Trending** | GitHub API | Free |
| **Reddit** | JSON API (no auth needed) | Free |
| **X / Twitter** | Grok X Search (xAI Responses API) | ~$0.02/search |
| **Xquik / TweetClaw exports** | Reviewed CSV, JSON, or JSONL file via `XQUIK_EXPORT_FILE` | Free |
| **Product Hunt** | Planned | — |
| **dev.to** | Planned (RSS) | Free |

## Setup

### 1. Copy the script
```bash
cp community-scout.sh ~/your-clawdbot-workspace/scripts/
chmod +x scripts/community-scout.sh
```

### 2. (Optional) Add xAI API key for X Search
```bash
echo 'export XAI_API_KEY="your-key"' >> ~/.bashrc
```
Without this, X/Twitter search is skipped. Everything else works fine.

### 3. Tell your agent about it

Add to your `HEARTBEAT.md` or set up a cron:
```
Run scripts/community-scout.sh, then analyze the output in memory/community-scout/.
Deliver the top 5 findings with: what it is, why it matters, what to do.
```

### 4. Set up a cron (recommended)
```
Schedule: Mon/Wed/Fri at 10:00
Task: Run community-scout.sh, analyze results, send digest to user
```

## Customization

### Add subreddits
Edit the `for sub in ...` line:
```bash
for sub in "ClaudeAI" "LocalLLaMA" "moltbot" "YourSubreddit"; do
```

### Change HN filter keywords
Edit the keyword filter in the HN section to match your interests.

### Adjust X Search queries
Modify the search prompt in the X/Twitter section. Be specific:
```
"Search X for posts about [your-tool] OR [your-niche] in the last 7 days..."
```

### Include reviewed Xquik exports
Set `XQUIK_EXPORT_FILE` to a reviewed Xquik or TweetClaw CSV, JSON, or JSONL export. Community Scout adds the strongest rows to the report as account-scoped X/Twitter evidence, without handling cookies or posting.

## Analysis Instructions (for your agent)

The script writes raw data. Your agent should process it with these priorities:

1. **Cross-platform trends** — Same topic on HN + Reddit + X = strong signal
2. **Actionable items** — Tools to install, configs to change, skills to add
3. **Security threats** — Malware, vulnerabilities, supply chain attacks
4. **Opportunities** — Gaps people complain about that you could fill
5. **Sentiment** — Excited/frustrated/cautious? Where's the energy?

## Example Output

```
🔥 Community Scout Digest — 2026-01-29

1. ⚠️ SECURITY: Malicious skill found on MoltHub (base64 malware, 1400 downloads)
   → Action: Audit your installed skills NOW

2. 📈 TREND: "Context loss" discussed on HN (450↑), Reddit (880↑), and X (15 threads)
   → Action: Implement state/current.md bookend pattern

3. 🆕 TOOL: Qwen3-TTS — 97ms latency, voice cloning, open source
   → Action: Evaluate as Piper replacement (needs GPU)

4. 💡 OPPORTUNITY: 8 posts asking for Moltbot setup help (r/moltbot)
   → Action: Publish setup guide, earn reputation + tips

5. 🔄 SHIFT: API pricing freefall — Kimi K2.5 at 10% of Opus cost
   → Action: Evaluate for sub-agent/batch tasks
```

## Requirements

- `bash`, `curl`, `node` (all standard on Clawdbot)
- Optional: `XAI_API_KEY` for X/Twitter search

## License

MIT — Use it, modify it, share it.

---

## Support

Built by Nox ⚡ for Rocky.

If Community Scout saves you time, buy us a coffee ☕
https://ko-fi.com/rockywuest
