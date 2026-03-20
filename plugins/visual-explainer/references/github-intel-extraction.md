# Data Extraction Reference

All commands for extracting repository data. Every data point must record its source command.

## Tier 1: Git Commands (Authoritative)

These commands work on any local clone. Results are ground truth.

```bash
# Navigate to repo
cd ~/.agent/repos/{owner}/{repo}

# --- Identity ---
git remote -v                                          # Source: canonical URL
# Extract owner/repo from origin URL

# --- Commit History ---
git log --oneline | wc -l                              # Source: total commits
git log -1 --format="%ai"                              # Source: last commit date
git log --reverse --format="%ai" | head -1             # Source: first commit date
git log --format="%H" | tail -1                        # Source: initial commit hash

# --- Contributors ---
git log --format="%aN" | sort -u                       # Source: unique author names
git log --format="%aN <%aE>" | sort | uniq -c | sort -rn | head -10
                                                       # Source: top 10 contributors by commit count

# --- File Structure ---
git ls-files | head -30                                # Source: tracked files (first 30)
git ls-files | wc -l                                   # Source: total tracked files
git ls-files | sed 's|/.*||' | sort -u                # Source: top-level directories

# --- Languages (approximate) ---
git ls-files | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10
                                                       # Source: file extensions by count

# --- Recent Activity ---
git log --oneline -20                                  # Source: last 20 commits
git log --format="%ai %s" --since="30 days ago"        # Source: commits in last 30 days

# --- Branches and Tags ---
git branch -a                                          # Source: all branches
git tag -l                                             # Source: all tags
```

## Tier 2: GitHub API (via `gh` CLI)

Requires authenticated `gh` CLI. Provides metadata not available in git.

```bash
# --- Repo metadata ---
gh api repos/{owner}/{repo} --jq '{
  description: .description,
  stars: .stargazers_count,
  forks: .forks_count,
  watchers: .watchers_count,
  license: .license.spdx_id,
  language: .language,
  topics: .topics,
  visibility: (if .private then "private" else "public" end),
  is_fork: .fork,
  parent: .parent.full_name,
  created_at: .created_at,
  updated_at: .updated_at,
  pushed_at: .pushed_at,
  size_kb: .size,
  default_branch: .default_branch,
  has_issues: .has_issues,
  open_issues: .open_issues_count,
  has_wiki: .has_wiki,
  archived: .archived
}'

# --- Owner profile ---
gh api users/{owner} --jq '{
  name: .name,
  company: .company,
  blog: .blog,
  location: .location,
  bio: .bio,
  twitter: .twitter_username,
  public_repos: .public_repos,
  followers: .followers,
  following: .following,
  created_at: .created_at
}'

# --- Languages breakdown ---
gh api repos/{owner}/{repo}/languages
# Returns: {"JavaScript": 45000, "HTML": 12000, ...} (bytes per language)

# --- Contributors ---
gh api repos/{owner}/{repo}/contributors --jq '.[].login' 2>/dev/null
# May return 403 for repos with no contributors API access

# --- Releases ---
gh api repos/{owner}/{repo}/releases --jq '.[0] | {tag: .tag_name, date: .published_at, name: .name}' 2>/dev/null

# --- Open issues/PRs ---
gh api repos/{owner}/{repo}/issues --jq 'length' 2>/dev/null
```

## Tier 3: Web Search (Cached)

For maintainer social profiles and project mentions. Cache results with 30-day TTL.

```bash
# Check cache first
CACHE=~/.agent/cache/profiles/{username}.json
if [ -f "$CACHE" ]; then
  FETCHED=$(jq -r '.fetched_at' "$CACHE")
  # If < 30 days old, reuse
fi

# Search targets:
# - "{name}" site:linkedin.com → LinkedIn profile
# - "{name}" "{company}" servicenow → role verification
# - "{username}" site:youtube.com → YouTube channel
# - "{name}" conference talk → speaking engagements
# - "{repo-name}" site:dev.to OR site:medium.com → blog posts about the repo
```

### Cache Format

```json
{
  "username": "leojacinto",
  "fetched_at": "2026-03-20",
  "linkedin": "https://linkedin.com/in/...",
  "youtube": null,
  "twitter": null,
  "blog": null,
  "company": "ServiceNow",
  "role": "Senior Advisory Specialist Solution Consultant",
  "location": "Sydney, Australia",
  "notes": "Member of first cohort ServiceNow Certified Elite Executive Communicators"
}
```
