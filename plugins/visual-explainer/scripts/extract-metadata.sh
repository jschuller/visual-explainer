#!/bin/bash
# Extract repository metadata to JSON
# Usage: extract-metadata.sh <repo-path> <owner> <repo>

set -euo pipefail

REPO_PATH="${1:?Usage: extract-metadata.sh <repo-path> <owner> <repo>}"
OWNER="${2:?Missing owner}"
REPO="${3:?Missing repo}"

cd "$REPO_PATH"

# Tier 1: Git data
TOTAL_COMMITS=$(git log --oneline 2>/dev/null | wc -l | tr -d ' ')
LAST_COMMIT=$(git log -1 --format="%ai" 2>/dev/null | cut -d' ' -f1)
FIRST_COMMIT=$(git log --reverse --format="%ai" 2>/dev/null | head -1 | cut -d' ' -f1)
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
AUTHORS=$(git log --format="%aN" 2>/dev/null | sort -u | head -20)
TOP_CONTRIBUTORS=$(git log --format="%aN" 2>/dev/null | sort | uniq -c | sort -rn | head -10)
TOTAL_FILES=$(git ls-files 2>/dev/null | wc -l | tr -d ' ')
TOP_DIRS=$(git ls-files 2>/dev/null | sed 's|/.*||' | sort -u | head -20)
FILE_EXTENSIONS=$(git ls-files 2>/dev/null | grep '\.' | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10)

# Tier 2: GitHub API (if gh available)
GH_DATA="{}"
LANGUAGES="{}"
OWNER_PROFILE="{}"
if command -v gh &>/dev/null; then
    GH_DATA=$(gh api "repos/${OWNER}/${REPO}" --jq '{
        description: .description,
        stars: .stargazers_count,
        forks: .forks_count,
        license: (.license.spdx_id // "None"),
        language: .language,
        topics: .topics,
        visibility: (if .private then "private" else "public" end),
        is_fork: .fork,
        parent: (.parent.full_name // null),
        size_kb: .size,
        default_branch: .default_branch,
        open_issues: .open_issues_count,
        archived: .archived,
        created_at: .created_at,
        pushed_at: .pushed_at
    }' 2>/dev/null || echo "{}")

    LANGUAGES=$(gh api "repos/${OWNER}/${REPO}/languages" 2>/dev/null || echo "{}")

    OWNER_PROFILE=$(gh api "users/${OWNER}" --jq '{
        name: .name,
        company: .company,
        blog: .blog,
        location: .location,
        bio: .bio,
        twitter: .twitter_username,
        public_repos: .public_repos,
        followers: .followers,
        created_at: .created_at
    }' 2>/dev/null || echo "{}")
fi

# Output
cat <<JSONEOF
{
  "repo": "${OWNER}/${REPO}",
  "remote_url": "${REMOTE_URL}",
  "git": {
    "total_commits": ${TOTAL_COMMITS},
    "first_commit": "${FIRST_COMMIT}",
    "last_commit": "${LAST_COMMIT}",
    "total_files": ${TOTAL_FILES}
  },
  "github_api": ${GH_DATA},
  "languages": ${LANGUAGES},
  "owner_profile": ${OWNER_PROFILE},
  "extracted_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
JSONEOF
