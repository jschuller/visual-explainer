---
description: Analyze a GitHub repository — verified visual HTML + Obsidian vault note
---

Load the visual-explainer skill, then analyze the GitHub repository at: $@

This command has two phases: **prescriptive extraction** (Steps 1-3) followed by **creative generation** using the full visual-explainer workflow (Steps 4-5).

## Phase 1 — Extract & Verify (prescriptive)

### 1. Resolve Input

Determine if `$1` is a URL or local path:
- **URL**: clone to `~/.agent/repos/{owner}/{repo}/` (skip if already cloned). Extract owner/repo from the URL.
- **Local path**: use directly, extract owner/repo from `git remote -v`.

### 2. Extract Data

Run tiered extraction. Read `./references/github-intel-extraction.md` for all commands.

- **Tier 1 (Git)**: commits, dates, contributors, file structure, recent activity — ground truth from the local clone.
- **Tier 2 (GitHub API)**: stars, forks, languages, owner profile, topics, license — via `gh` CLI.
- **Tier 3 (Web Search)**: maintainer LinkedIn, blog, YouTube. Cache at `~/.agent/cache/profiles/{username}.json` with 30-day TTL.
- **Code Analysis**: read 10-15 key files — entry points, config, dependencies, README, core domain files. Go deep: read service internals, data models, config schemas, rule definitions, deployment scripts. Extract code patterns worth showing.

Record the source of every data point.

### 3. Build Fact Sheet — Mandatory Verification Checkpoint

Read `./references/github-intel-verification.md` for fact sheet format.

- Create fact sheet at `~/.agent/cache/fact-sheets/{owner}-{repo}.md`
- Every claim cites its source command or `file:line`
- Cross-reference: URL from `git remote`, stars from `gh api`, contributor names from `git log`, dates from git history
- Architecture claims need `file:line` evidence
- Unverified claims go in a mandatory "Unverified" section and are excluded from outputs
- **Present fact sheet to user for review before proceeding**
- User approves or flags corrections — only proceed to Phase 2 after approval

## Phase 2 — Generate (creative, visual-explainer workflow)

### 4. Generate Visual HTML

**Follow the full visual-explainer skill workflow: Think → Structure → Style → Deliver.**

Read the SKILL.md design principles, then read ALL of these before generating:
- `./templates/architecture.html` — for card layouts, pipeline steps, flow arrows, depth tiers, inner grids
- `./templates/mermaid-flowchart.html` — for the full diagram-shell JS module (zoom/pan/touch/fit, ~200 lines) AND the ESM import of `@mermaid-js/layout-elk` for better node positioning. Copy both the JS module and the ELK import wholesale.
- `./templates/intel-page.html` — for GitHub-specific components (stats row, language bar, profile card, timeline, assessment callouts, expandable `<details>` pattern)
- `./references/css-patterns.md` — for shared patterns (overflow protection, code blocks, collapsibles, hero images, prose elements)
- `./references/responsive-nav.md` — for sticky sidebar TOC on desktop + horizontal scrollable bar on mobile
- `./references/libraries.md` — for Mermaid theming, Chart.js, font pairings

**Think step — commit to a direction:**
- Pick an aesthetic that fits this repo (Editorial, Blueprint, Paper/ink, or IDE-inspired). Vary from recent pages.
- Pick a font pairing from the SKILL.md list. Don't default to the same one every time.
- Design a palette with CSS custom properties. At minimum: `--bg`, `--surface`, `--border`, `--text`, `--text-dim`, and 3-5 accent colors.
- Decide visual hierarchy: what sections deserve hero treatment (architecture, key insight) vs. compact treatment (file lists, metadata).

**Structure step — design the page from the data, not from a rigid template:**

The page must cover these content areas (but YOU decide the section names, ordering, depth, and visual treatment based on what's interesting about this specific repo):

- **Repository identity** — stats, languages, metadata. Use the stats row + language bar patterns from intel-page.html.
- **What it does** — the system's components/engines/modules. Use engine cards from intel-page.html or architecture cards from architecture.html — whichever fits better.
- **How it works** — architecture diagram (Mermaid in diagram-shell with full zoom/pan/touch controls) PLUS pipeline visualizations for any multi-stage processing flows found in the code. Use the pipeline step pattern from architecture.html. Show actual code flow, not just boxes.
- **Technology stack** — table with `file:line` evidence. Include dependency details, config schemas, and interesting technical choices in an expandable `<details>`.
- **Key files** — table PLUS expandable deep-dive with actual code snippets (5-15 lines each) for the most illuminating files. Show data models, DSL examples, config schemas — anything that reveals how the system really works. Use `white-space: pre-wrap` code blocks.
- **Maintainer** — profile card with avatar, links, bio. Use the profile pattern from intel-page.html.
- **Activity** — timeline with gold dot markers.
- **Assessment** — key takeaways + competitive intelligence. Include a technical maturity table. Use expandable `<details>` for strategic depth, deployment comparisons, lessons learned (if found in CHANGELOG/commits).

**Use expandable `<details>` sections generously** — collapsed by default — for deep dives under Architecture, Tech Stack, Key Files, and Assessment. The surface page should be scannable; the depth should be there for those who want it.

**Style step — apply visual-explainer design principles:**
- Both light and dark themes must work (CSS custom properties with media query)
- Staggered fadeUp animations with reduced-motion support
- Surface depth tiers: hero (elevated) for primary sections, default for body, recessed for reference material
- Mermaid with custom `themeVariables` matching your palette
- Status/severity badges where appropriate (colored spans, not emoji)
- No AI slop (no Inter font, no gradient text, no glowing shadows, no emoji headers)

**Optional hero image** — check `which gemini-image 2>/dev/null || which surf 2>/dev/null`. If available, generate a hero banner that captures the project's domain. Embed as base64 data URI.

**Output**: `~/.agent/diagrams/intel-github/{owner}/{repo}.html` — open in browser.

### 5. Generate Obsidian Note

Load the obsidian-markdown skill, then:

- Read `./references/github-intel-obsidian.md` for frontmatter schema and body structure
- Output to vault `intel-github/` folder
- Vault root: check `~/.agent/vault-path` or use default (`/Users/jschulle/Library/CloudStorage/GoogleDrive-joshua.schuller@gmail.com/My Drive/Applications/vault-obsidian/`)
- All wikilinks, callouts, and frontmatter must be valid Obsidian syntax
- Mermaid: fenced code blocks, `graph TD`, short labels, no HTML

### 6. Report

Show user what was created with file paths:
- HTML page path
- Obsidian note path
- Fact sheet path

Ultrathink.
