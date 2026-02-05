#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract current directory and model from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model // "unknown"')

# Get just the directory name (like %c in zsh)
dir_name=$(basename "$cwd")

# --- Context Window (free %) ---
CTX_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
USAGE=$(echo "$input" | jq '.context_window.current_usage')

if [ "$USAGE" != "null" ]; then
    IN=$(echo "$USAGE" | jq '.input_tokens // 0')
    CACHE_CREATE=$(echo "$USAGE" | jq '.cache_creation_input_tokens // 0')
    CACHE_READ=$(echo "$USAGE" | jq '.cache_read_input_tokens // 0')
    TOTAL=$((IN + CACHE_CREATE + CACHE_READ))
    FREE_PCT=$((100 - (TOTAL * 100 / CTX_SIZE)))
else
    FREE_PCT=100
fi
ctx_info="$(printf '\033[0;32m')${FREE_PCT}%$(printf '\033[0m')"

# Check if we're in a git repo and get branch info
# Using --no-optional-locks to avoid lock issues
if git_branch=$(cd "$cwd" && git --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null); then
    # Get file counts
    STAGED=$(cd "$cwd" && git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(cd "$cwd" && git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    UNTRACKED=$(cd "$cwd" && git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

    # Build counts string (only show non-zero)
    counts=""
    [ "$STAGED" -gt 0 ] && counts="${counts}$(printf '\033[0;32m')S:${STAGED}$(printf '\033[0m') "
    [ "$MODIFIED" -gt 0 ] && counts="${counts}$(printf '\033[0;33m')M:${MODIFIED}$(printf '\033[0m') "
    [ "$UNTRACKED" -gt 0 ] && counts="${counts}$(printf '\033[0;31m')U:${UNTRACKED}$(printf '\033[0m') "
    counts=$(echo "$counts" | sed 's/ $//')

    if [ -n "$counts" ]; then
        git_info=" $(printf '\033[1;34m')git:$(printf '\033[0;31m')$git_branch$(printf '\033[0m') $counts"
    else
        git_info=" $(printf '\033[1;34m')git:$(printf '\033[0;31m')$git_branch$(printf '\033[0m')"
    fi
else
    git_info=""
fi

# Format model name (extract short version like "sonnet", "opus", "haiku")
if [[ "$model" =~ sonnet ]]; then
    model_short="sonnet"
elif [[ "$model" =~ opus ]]; then
    model_short="opus"
elif [[ "$model" =~ haiku ]]; then
    model_short="haiku"
else
    model_short="$model"
fi

# Always show green arrow (success state) since we're in a new context
# Directory name in cyan, model in magenta, context % in green
printf "$(printf '\033[1;32m')➜$(printf '\033[0m')  $(printf '\033[0;36m')%s$(printf '\033[0m')%s $(printf '\033[0;35m')[%s]$(printf '\033[0m') %s" "$dir_name" "$git_info" "$model_short" "$ctx_info"
