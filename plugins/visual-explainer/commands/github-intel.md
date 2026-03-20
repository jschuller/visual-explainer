---
description: Analyze a GitHub repository — visual intelligence dashboard + Obsidian vault note
---
Load the visual-explainer skill, then build an intelligence dashboard for: $@

The first argument is the repo URL or local path. Additional text is user guidance
(e.g., "focus on competitive intel", "compare with project-basanos").

Follow the visual-explainer skill workflow. Read the reference templates, CSS patterns,
responsive nav, and libraries references before generating.

**Data gathering** — run in parallel where possible:

1. **Clone/resolve.** URL → `~/.agent/repos/{owner}/{repo}/` (skip if exists, git pull).
   Local path → use directly, extract owner/repo from `git remote -v`.

2. **Git data.** Read `./references/github-intel-extraction.md` for all Tier 1 commands.
   Commits, dates, contributors, file structure, recent activity, branches, tags.

3. **GitHub API.** Tier 2: stars, forks, languages, owner profile, topics, license, releases.

4. **Web intelligence.** Tier 3: search for maintainer LinkedIn, blog, YouTube, conference talks.
   Use web search tools (Perplexity, WebSearch) if available — richer results than cache alone.
   Cache at `~/.agent/cache/profiles/{username}.json` with 30-day TTL.

5. **README assessment.** Read the README fully. Score each area as COVERED / PARTIAL / ABSENT:
   purpose, components, architecture, tech stack, deployment, usage, testing.
   This drives how deep to go — don't rehash what the README already explains well.

6. **Deep code analysis.** Read 10-20 key files — entry points, config, core domain,
   data models, DSL/rule definitions, deployment scripts, test files (if any).
   Look for: architectural patterns, interesting abstractions, code the README doesn't mention,
   discrepancies between README claims and actual code.

**Verification** — build a fact sheet at `~/.agent/cache/fact-sheets/{owner}-{repo}.md`.
Read `./references/github-intel-verification.md` for format.
Every claim cites source command or file:line. Architecture claims need file:line evidence.
Cross-reference README claims against code — note discrepancies.
Unverified claims excluded from outputs. Do not present for approval — just be rigorous.

**Generate visual HTML** — follow Think → Structure → Style → Deliver.

Read ALL templates and references before generating (architecture.html for card/pipeline/grid
patterns, mermaid-flowchart.html for diagram-shell JS + ELK import, intel-page.html for
stats/language/profile/timeline patterns, css-patterns.md, responsive-nav.md, libraries.md).

Think: pick aesthetic, font pairing, palette. Vary from recent pages.
Decide page posture — if README is thorough, lean intel-focused; if sparse, more explanatory.

Structure: section names tell a story, not catalog content.
"Signal Processing Chain" > "Architecture". "What the YAML Rules Actually Look Like" > "Key Files".

**The page is an intelligence dashboard that does what GitHub markdown cannot:**

- **README fidelity panel** — hero-level. Cross-reference README claims vs code.
  "README says 53 rules, code has 45." Green/amber/red verification badges per claim.
  This is the first unique thing the reader sees.

- **Interactive architecture** — Mermaid diagram the agent designed from reading code,
  NOT rehashed from README. Diagram-shell with zoom/pan/touch/fit. Use ELK layout.
  If code architecture differs from README description, show both and highlight divergence.
  Consider multiple diagrams: system overview + data flow + deployment topology.

- **Code deep dives** — 3-5 illuminating code excerpts (5-15 lines) that reveal how the
  system actually works. Rule DSL syntax, config schemas, pipeline orchestration, data models.
  Things the README can't show. Use styled code blocks with file path headers.

- **Pipeline/flow visualizations** — CSS animated step boxes with directional arrows
  for any multi-stage processing found in code. Animate flow direction.
  This is impossible in markdown and communicates architecture 10x better.

- **Commit activity** — visual heatmap or sparkline of development rhythm from git log dates.
  Burst patterns, quiet periods, velocity trends. Chart.js or inline SVG.

- **Maturity signals** — test coverage (any test files?), CI/CD (Actions?), dependency
  freshness, commit patterns, branch strategy, documentation quality. Rated badges.

- **Maintainer intelligence** — profile card with web-sourced social data, background, network.
  Position early, not at bottom — this is intelligence, not metadata.

- **Repository identity** — stats row, language bar. Keep compact — quantitative data
  in a visual format the README doesn't provide.

- **Technology evidence** — table with file:line citations. Compact — the value is in
  the verification, not the list. Expand depth only where README is ABSENT.

- **Assessment** — key takeaways, competitive intelligence, strategic positioning.
  What this repo means in context. This is analysis, not summary.

**All sections visible** — no collapsed `<details>` for primary content. The sticky
sidebar TOC handles navigation. Use depth tiers (hero/default/recessed) for visual
hierarchy instead. `<details>` only for optional supplementary material within a section.

**Style** — light/dark themes, staggered animations with reduced-motion, Mermaid
themeVariables matching palette, status badges (colored spans not emoji), no AI slop.

**Hero image** — check `which gemini-image 2>/dev/null || which surf 2>/dev/null`.
If available, generate a banner matching the page aesthetic. Skip gracefully if not.

**Output**: `~/.agent/diagrams/intel-github/{owner}/{repo}.html` — open in browser.

**Generate Obsidian note** — load obsidian-markdown skill.
Read `./references/github-intel-obsidian.md` for frontmatter + body structure.
Output to vault `intel-github/` folder. Mermaid: fenced blocks, `graph TD`, no HTML.

**Report** — show file paths: HTML page, Obsidian note, fact sheet.

Ultrathink.
