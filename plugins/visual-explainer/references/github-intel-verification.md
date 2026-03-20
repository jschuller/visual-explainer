# Verification Protocol

## Purpose

Every GitHub Intel output must be backed by verifiable data. This protocol ensures zero fabrication by requiring a fact sheet before any HTML or Obsidian note is generated.

## Fact Sheet Format

Create a fact sheet at `~/.agent/cache/fact-sheets/{owner}-{repo}.md` before generating outputs.

```markdown
# Fact Sheet: {owner}/{repo}
Generated: YYYY-MM-DD

## Repository Identity
| Field | Value | Source |
|-------|-------|--------|
| URL | https://github.com/{owner}/{repo} | `git remote -v` |
| Description | "..." | `gh api repos/{owner}/{repo} --jq .description` |
| Visibility | public | `gh api repos/{owner}/{repo} --jq .private` |
| License | MIT | `gh api repos/{owner}/{repo} --jq .license.spdx_id` |
| Primary Language | JavaScript | `gh api repos/{owner}/{repo} --jq .language` |

## Activity
| Field | Value | Source |
|-------|-------|--------|
| Total Commits | 42 | `git log --oneline \| wc -l` |
| First Commit | 2026-01-15 | `git log --reverse --format="%ai" \| head -1` |
| Last Commit | 2026-03-20 | `git log -1 --format="%ai"` |
| Stars | 0 | `gh api repos/{owner}/{repo} --jq .stargazers_count` |
| Forks | 0 | `gh api repos/{owner}/{repo} --jq .forks_count` |

## Contributors
| Name | Commits | Source |
|------|---------|--------|
| {name} | 35 | `git log --format="%aN" \| sort \| uniq -c \| sort -rn` |

## Maintainer Profile
| Field | Value | Source |
|-------|-------|--------|
| Full Name | {name} | `gh api users/{owner} --jq .name` |
| Company | {company} | `gh api users/{owner} --jq .company` |
| LinkedIn | {url} | Web search (cached) |

## Architecture (from code analysis)
| Claim | Evidence | File |
|-------|----------|------|
| "Uses Express.js" | `require('express')` | `server.js:3` |
| "ServiceNow Fluent API" | `import { Fluent }` | `src/index.js:1` |

## Unverified Claims
- [UNVERIFIED] {any claim that couldn't be sourced — excluded from outputs}
```

## Rules

1. **Every cell in the Source column must contain a real command or file reference**
   - Not "from memory" or "commonly known"
   - If you ran a command, paste the exact command

2. **Cross-reference check** — before finalizing:
   - Does the URL match `git remote -v`? (not constructed)
   - Do star/fork counts match `gh api` output? (not recalled from plan)
   - Do contributor names match `git log` exactly? (not guessed)
   - Do dates match git history? (not approximated)

3. **Architecture claims need file:line evidence**
   - "Uses React" → show the import statement and file
   - "Microservices architecture" → show the service directories
   - Never claim a technology without finding it in the code

4. **Unverified section is mandatory**
   - If something can't be sourced, it goes here
   - Items in this section are EXCLUDED from HTML and Obsidian outputs
   - Better to omit than to fabricate

5. **Present to user before generating**
   - Show the fact sheet in the conversation
   - User approves or flags corrections
   - Only proceed to Phase 3 (Generate) after approval
