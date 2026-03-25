#!/usr/bin/env bash

set -euo pipefail

# Default start date requested by user. You can override by passing YYYY-MM-DD.
START_DATE="${1:-2026-03-12}"
END_DATE="$(date +%F)"
LOG_FILE="daily-activity-log.txt"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: This script must be run inside a Git repository."
  exit 1
fi

if ! date -d "$START_DATE" +%F >/dev/null 2>&1; then
  echo "Error: Invalid start date '$START_DATE'. Use YYYY-MM-DD."
  exit 1
fi

if [[ "$START_DATE" > "$END_DATE" ]]; then
  echo "Error: Start date ($START_DATE) is after today ($END_DATE)."
  exit 1
fi

CURRENT_BRANCH="$(git branch --show-current)"
if [[ -z "$CURRENT_BRANCH" ]]; then
  echo "Error: Could not detect current branch."
  exit 1
fi

echo "Creating one commit per day from $START_DATE to $END_DATE on branch '$CURRENT_BRANCH'..."

current_date="$START_DATE"
while [[ "$current_date" < "$END_DATE" || "$current_date" == "$END_DATE" ]]; do
  commit_time="${current_date} 12:00:00"

  # Harmless change for the day; only this file is staged/committed.
  printf '%s - daily maintenance commit\n' "$current_date" >> "$LOG_FILE"

  git add -- "$LOG_FILE"

  GIT_AUTHOR_DATE="$commit_time" \
  GIT_COMMITTER_DATE="$commit_time" \
  git commit -m "chore: daily commit for $current_date"

  echo "Committed: $current_date"
  current_date="$(date -d "$current_date + 1 day" +%F)"
done

echo "Pushing commits to origin/$CURRENT_BRANCH..."
git push origin "$CURRENT_BRANCH"

echo "Done. Created daily commits through $END_DATE and pushed to remote."