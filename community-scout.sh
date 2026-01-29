#!/bin/bash
# Community Scout v2 — Multi-Platform Intelligence for AI Agent Builders
# Sources: Reddit, X/Twitter (via Grok), Hacker News, GitHub Trending
# Output: Structured markdown for AI analysis (not just links!)

OUTDIR="/home/piclawbot/clawd/memory/community-scout"
mkdir -p "$OUTDIR"
DATE=$(date +%Y-%m-%d)
OUTFILE="$OUTDIR/$DATE.md"

source ~/.bashrc 2>/dev/null
XAI_KEY="${XAI_API_KEY:-}"

echo "# Community Scout — $DATE" > "$OUTFILE"
echo "" >> "$OUTFILE"

# ============================================================
# 1. HACKER NEWS — Top Stories (Firebase API, free, real-time)
# ============================================================
echo "## Hacker News (Top Stories)" >> "$OUTFILE"
echo "" >> "$OUTFILE"

# Fetch top 30 story IDs, then get details for AI/agent related ones
curl -s "https://hacker-news.firebaseio.com/v0/topstories.json" 2>/dev/null | \
  node -e "
    const ids = JSON.parse(require('fs').readFileSync('/dev/stdin','utf8')).slice(0, 30);
    const https = require('https');
    let done = 0;
    const results = [];
    ids.forEach((id, i) => {
      https.get('https://hacker-news.firebaseio.com/v0/item/' + id + '.json', res => {
        let d = '';
        res.on('data', c => d += c);
        res.on('end', () => {
          try {
            const item = JSON.parse(d);
            if (item && item.title) {
              const t = item.title.toLowerCase();
              if (t.includes('ai') || t.includes('llm') || t.includes('claude') || t.includes('agent') ||
                  t.includes('gpt') || t.includes('openai') || t.includes('anthropic') || t.includes('model') ||
                  t.includes('automation') || t.includes('coding') || t.includes('open source') ||
                  t.includes('startup') || t.includes('saas') || item.score >= 200) {
                results.push({title: item.title, score: item.score, comments: item.descendants || 0, url: item.url || 'https://news.ycombinator.com/item?id=' + item.id, hn: 'https://news.ycombinator.com/item?id=' + item.id, pos: i});
              }
            }
          } catch(e) {}
          done++;
          if (done === ids.length) {
            results.sort((a,b) => a.pos - b.pos);
            results.forEach(r => {
              console.log('- **' + r.title.substring(0,120) + '** (' + r.score + '↑, ' + r.comments + ' comments)');
              console.log('  ' + r.url);
              console.log('  HN: ' + r.hn);
              console.log('');
            });
          }
        });
      }).on('error', () => { done++; });
    });
  " >> "$OUTFILE" 2>/dev/null

sleep 2
echo "" >> "$OUTFILE"

# ============================================================
# 2. GITHUB TRENDING — Today's trending repos
# ============================================================
echo "## GitHub Trending (Today)" >> "$OUTFILE"
echo "" >> "$OUTFILE"

curl -s "https://api.github.com/search/repositories?q=created:>$(date -d '-7 days' +%Y-%m-%d)+stars:>50&sort=stars&order=desc&per_page=15" \
  -H "Accept: application/vnd.github.v3+json" 2>/dev/null | \
  node -e "
    const data = JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));
    if (data.items) {
      data.items
        .filter(r => {
          const t = ((r.description || '') + ' ' + r.name + ' ' + (r.topics || []).join(' ')).toLowerCase();
          return t.includes('ai') || t.includes('llm') || t.includes('agent') || t.includes('claude') ||
                 t.includes('gpt') || t.includes('automation') || t.includes('mcp') || t.includes('tts') ||
                 t.includes('ocr') || t.includes('rag') || r.stargazers_count >= 500;
        })
        .forEach(r => {
          console.log('- **' + r.full_name + '** ⭐' + r.stargazers_count + ' (created ' + r.created_at.substring(0,10) + ')');
          console.log('  ' + (r.description || '').substring(0, 200));
          console.log('  ' + r.html_url);
          console.log('');
        });
    }
  " >> "$OUTFILE" 2>/dev/null
echo "" >> "$OUTFILE"

# ============================================================
# 3. REDDIT — Subreddit top posts + global search
# ============================================================
echo "## Reddit" >> "$OUTFILE"
echo "" >> "$OUTFILE"

for sub in "ClaudeAI" "LocalLLaMA" "moltbot"; do
  echo "### r/$sub (top this week)" >> "$OUTFILE"
  curl -s -H "User-Agent: NoxBot/1.0" \
    "https://www.reddit.com/r/$sub/top.json?t=week&limit=15" 2>/dev/null | \
    node -e "
      const data = JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));
      if (data.data && data.data.children) {
        data.data.children
          .filter(p => {
            const t = (p.data.title + ' ' + p.data.selftext).toLowerCase();
            return t.includes('clawdbot') || t.includes('moltbot') || t.includes('claude code') || 
                   t.includes('claude agent') || t.includes('skill') || t.includes('automation') ||
                   t.includes('assistant') || t.includes('coding agent') || t.includes('self-improv') ||
                   t.includes('workflow') || t.includes('tool') || p.data.score >= 50;
          })
          .forEach(p => {
            const d = p.data;
            console.log('- **' + d.title.replace(/\|/g,'/').substring(0,120) + '** (' + d.score + '↑, ' + d.num_comments + ' comments)');
            console.log('  https://reddit.com' + d.permalink);
            if (d.selftext) console.log('  > ' + d.selftext.substring(0,250).replace(/\n/g,' '));
            console.log('');
          });
      }
    " >> "$OUTFILE" 2>/dev/null
  echo "" >> "$OUTFILE"
done

echo "### Reddit-wide search: clawdbot / moltbot / claude code agent" >> "$OUTFILE"
for query in "clawdbot" "moltbot" "claude+code+agent"; do
  curl -s -H "User-Agent: NoxBot/1.0" \
    "https://www.reddit.com/search.json?q=$query&sort=new&t=week&limit=10" 2>/dev/null | \
    node -e "
      const data = JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));
      if (data.data && data.data.children) {
        data.data.children.forEach(p => {
          const d = p.data;
          console.log('- **' + d.title.replace(/\|/g,'/').substring(0,120) + '** (r/' + d.subreddit + ', ' + d.score + '↑)');
          console.log('  https://reddit.com' + d.permalink);
          console.log('');
        });
      }
    " >> "$OUTFILE" 2>/dev/null
done
echo "" >> "$OUTFILE"

# ============================================================
# 4. X/TWITTER — via Grok X Search (Responses API)
# ============================================================
echo "## X / Twitter (via Grok X Search)" >> "$OUTFILE"
echo "" >> "$OUTFILE"

if [ -n "$XAI_KEY" ]; then
  TMPREQ=$(mktemp)
  cat > "$TMPREQ" << 'XEOF'
{
  "model": "grok-4-1-fast-non-reasoning",
  "tools": [{"type": "x_search"}],
  "input": "Search X for the most interesting recent posts (last 7 days) about: moltbot, clawdbot, AI personal agents, Claude Code automations. Give me the top 10 most actionable/interesting with author, quote, and link. Focus on real use cases, new tools, and practical workflows — skip hype-only posts."
}
XEOF
  curl -s "https://api.x.ai/v1/responses" \
    -H "Authorization: Bearer $XAI_KEY" \
    -H "Content-Type: application/json" \
    -d @"$TMPREQ" 2>/dev/null | \
    node -e "
      try {
        const d = JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));
        if (d.output) {
          d.output.filter(o => o.type === 'message').forEach(m => {
            m.content.forEach(c => { if (c.text) console.log(c.text); });
          });
        }
      } catch(e) { console.log('  (parse error)'); }
    " >> "$OUTFILE" 2>/dev/null
  rm -f "$TMPREQ"
else
  echo "  (XAI_API_KEY nicht gesetzt — X Search übersprungen)" >> "$OUTFILE"
fi
echo "" >> "$OUTFILE"

# ============================================================
# 5. PRODUCT HUNT — AI launches
# ============================================================
echo "## Product Hunt (Recent AI Launches)" >> "$OUTFILE"
echo "" >> "$OUTFILE"

curl -s "https://www.producthunt.com/topics/artificial-intelligence" \
  -H "User-Agent: NoxBot/1.0" 2>/dev/null | \
  node -e "
    // PH doesn't have a simple JSON API without auth, note this for Nox
    console.log('  (Product Hunt benötigt API-Key für strukturierte Daten — TODO)');
  " >> "$OUTFILE" 2>/dev/null
echo "" >> "$OUTFILE"

# ============================================================
# FOOTER
# ============================================================
echo "---" >> "$OUTFILE"
echo "" >> "$OUTFILE"
echo "## Analysis Instructions (for Nox)" >> "$OUTFILE"
echo "" >> "$OUTFILE"
cat >> "$OUTFILE" << 'INSTRUCTIONS'
When analyzing this data, focus on:
1. **Trends**: What topics appear across multiple platforms? (HN + Reddit + X = strong signal)
2. **Actionable**: What can we directly implement or learn from?
3. **Threats**: Security warnings, breaking changes, competitor moves
4. **Opportunities**: Gaps people complain about that we could fill
5. **Sentiment**: Is the community excited, frustrated, or cautious about a topic?

Deliver as: Top 5 findings with WHY it matters and WHAT to do about it.
INSTRUCTIONS

echo "" >> "$OUTFILE"
echo "*Scraped at $(date '+%H:%M %Z')*" >> "$OUTFILE"

echo "Done: $OUTFILE"
