#!/usr/bin/env bash
set -euo pipefail

DEBUG=false
PUSH=false
STAGE=false

BASE_URL="https://openrouter.ai/api/v1"
MODEL="openai/gpt-5-nano"

debug_log() {
    if [ "$DEBUG" = true ]; then
        echo "DEBUG: $1"
        [ -n "${2-}" ] && { echo "DEBUG: Content >>>"; echo "$2"; echo "DEBUG: <<<"; }
    fi
}

replace_linebreaks() {
    printf '%s' "$1" | tr '\n' '\\n' | sed 's/\n$//'
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --debug) DEBUG=true; shift ;;
        --add|-a) STAGE=true; shift ;;
        --push|-p) PUSH=true; shift ;;
        --model) MODEL="$2"; shift 2 ;;
        -h|--help)
            cat <<EOF
Usage: cmai [options]

Options:
  --debug               Enable debug logging
  --add, -a             Stage files
  --push, -p            Push changes after commit
  --model <model>       Set OpenRouter model (default: $MODEL)

Environment variables:
  OPENROUTER_API_KEY    Your OpenRouter API key (required)
EOF
            exit 0
            ;;
        *) echo "Unknown argument: $1"; exit 1 ;;
    esac
done

API_KEY="${OPENROUTER_API_KEY:-}"
if [ -z "$API_KEY" ]; then
    echo "Error: OPENROUTER_API_KEY environment variable not set."
    exit 1
fi

if [ "$STAGE" = true ]; then
    git add .
    echo "Staged changes."
fi

CHANGES=$(git diff --cached --name-status | tr '\t' ' ' | sed 's/  */ /g')
DIFF_CONTENT=$(git diff --cached)

echo "$CHANGES"
[ -z "$CHANGES" ] && { echo "No staged changes."; exit 1; }

CHANGES=$(replace_linebreaks "$CHANGES")
FORMATTED_CHANGES=$(echo "$CHANGES" | tr '\n' ' ' | sed 's/  */ /g')
FORMATTED_DIFF=$(echo "$DIFF_CONTENT" | tr '\n' '\\n' | sed 's/"/\\"/g')

REQUEST_BODY=$(cat <<EOF
{
  "model": "$MODEL",
  "stream": false,
  "messages": [
    {
      "role": "system",
      "content": "You are a git commit message generator. Create conventional commit messages."
    },
    {
      "role": "user",
      "content": "Generate a commit message for these changes:\n\n## File changes:\n<file_changes>\n$FORMATTED_CHANGES\n</file_changes>\n\n## Diff:\n<diff>\n$FORMATTED_DIFF\n</diff>\n\n## Format:\n<type>(<scope>): <subject>\n\n<body>\n\nRules:\n- Type: feat, fix, docs, style, refactor, perf, test, chore\n- Scope: max 3 words\n- Subject: max 70 chars, imperative mood\n- Body: explain what and why and optionally break it into a list if the text is longer than 70 chars\n- Use 'fix' for minor changes\n- No triple backticks."
    }
  ]
}
EOF
)

echo "Generating..."
RESPONSE=$(curl -s -X POST "$BASE_URL/chat/completions" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$REQUEST_BODY")

COMMIT_FULL=$(echo "$RESPONSE" | jq -r '.choices[0].message.content' \
    | sed 's/\\n/\n/g' \
    | sed 's/\\r//g' \
    | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

[ -z "$COMMIT_FULL" ] && { echo "Failed to generate commit message."; exit 1; }

printf $COMMIT_FULL

git commit -m "$COMMIT_FULL"

if [ "$PUSH" = true ]; then
    git push origin
    echo "Pushed changes."
fi

echo "Commit message:"
echo "$COMMIT_FULL"
