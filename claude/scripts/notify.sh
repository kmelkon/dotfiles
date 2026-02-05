#!/bin/bash
INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.message // "Claude needs your attention"')

terminal-notifier -title "Claude Code" -message "$MESSAGE" -activate dev.warp.Warp-Stable
