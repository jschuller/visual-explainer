---
description: Analyze a GitHub repository — verified visual HTML + Obsidian vault note
---

Load the visual-explainer skill, then analyze the GitHub repository at: $@

Follow the visual-explainer skill workflow. Read the reference template at `./templates/intel-page.html`, CSS patterns at `./references/css-patterns.md`, and responsive nav at `./references/responsive-nav.md` before generating.

## Execution Steps

### 1. Resolve Input

Determine if `$1` is a URL or local path:
- **URL**: clone to `~/.agent/repos/{owner}/{repo}/` (skip if already cloned). Extract owner/repo from the URL.
- **Local path**: use directly, extract owner/repo from `git remote -v`.

### 2. Extract Data

Run tiered extraction. Read `./references/github-intel-extraction.md` for all commands.

- **Tier 1 (Git)**: commits, dates, contributors, file structure, recent activity — ground truth from the local clone.
- **Tier 2 (GitHub API)**: stars, forks, languages, owner profile, topics, license — via `gh` CLI.
- **Tier 3 (Web Search)**: maintainer LinkedIn, blog, YouTube. Cache at `~/.agent/cache/profiles/{username}.json` with 30-day TTL.
- **Code Analysis**: read 10-15 key files — entry points, config, dependencies, README, core domain files.

Record the source of every data point.

### 3. Build Fact Sheet — Mandatory Verification Checkpoint

Read `./references/github-intel-verification.md` for fact sheet format.

- Create fact sheet at `~/.agent/cache/fact-sheets/{owner}-{repo}.md`
- Every claim cites its source command or `file:line`
- Cross-reference: URL from `git remote`, stars from `gh api`, contributor names from `git log`, dates from git history
- Architecture claims need `file:line` evidence
- Unverified claims go in a mandatory "Unverified" section and are excluded from outputs
- **Present fact sheet to user for review before proceeding**
- User approves or flags corrections — only proceed to generation after approval

### 4. Generate Visual HTML

Follow the visual-explainer workflow: Think → Structure → Style → Deliver.

- Read `./templates/intel-page.html` for the 8-section structure with expandable deep-dive `<details>` blocks
- Read `./templates/mermaid-flowchart.html` for the diagram-shell zoom/pan/touch/fit JS module (~200 lines) — copy it wholesale
- Read `./references/responsive-nav.md` for sticky sidebar TOC on desktop + horizontal scrollable bar on mobile

**8 overview sections (always visible):**
1. Repository Overview — stats row, language breakdown bar, repo details table
2. Engines/Components — grid cards with colored top borders
3. System Architecture — Mermaid `graph TD` in diagram-shell with zoom/pan/touch/fit controls
4. Technology Stack — table with evidence column (file:line references)
5. Key Files & Entry Points — table
6. Maintainer Profile — avatar, name, role, company, LinkedIn, bio
7. Activity Timeline — visual timeline with dots and connector line
8. Assessment & Takeaways — callout cards

**Expandable deep-dive `<details>` sections (collapsed by default):**
- Under Architecture: pipeline visualization (CSS step boxes with arrows), architecture intelligence stack bar
- Under Tech Stack: dependency details, configuration specifics
- Under Key Files: code snippets, data models
- Under Assessment: strategic depth, deploy comparison

**Baked-in infrastructure:**
- Diagram-shell JS (zoom/pan/touch/fit) from `mermaid-flowchart.html`
- ESM import of Mermaid + ELK layout
- Responsive sticky TOC
- CSS custom properties with light/dark themes
- fadeUp animations with reduced-motion support
- Editorial aesthetic: Instrument Serif + JetBrains Mono + DM Sans, navy + gold palette

**Optional hero image** — check `which gemini-image 2>/dev/null || which surf 2>/dev/null`. If available, generate a hero banner via `gemini-image "prompt" --generate-image /tmp/file.png --aspect-ratio 16:9`. Embed as base64 data URI.

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
