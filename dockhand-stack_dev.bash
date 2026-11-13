#!/usr/bin/env bash
set -euo pipefail

# Create a Dockhand git stack for a cookbook, with sample.env preloaded as
# editable stack environment variables. Does NOT deploy unless --deploy.

show_help() {
  cat <<EOF
USAGE:
  $0 <stack-dir> [--name <stack-name>] [--deploy]

Creates a git stack in Dockhand from this repo:
  compose path  <stack-dir>/compose.yaml
  env file      <stack-dir>/sample.env
  variables     every KEY=VALUE in sample.env (edit them in Dockhand)

REQUIRED ENV:
  DOCKHAND_URL     e.g. https://dockhand.example.com
  DOCKHAND_TOKEN   API token (dh_...), Settings -> API Tokens

OPTIONAL ENV:
  DOCKHAND_REPO    git repository name in Dockhand (default: cookbooks, case-insensitive match)
  DOCKHAND_ENV     environment name to deploy to (default: the only/first environment)

EXAMPLE:
  DOCKHAND_URL=https://dockhand.example.com DOCKHAND_TOKEN=dh_xxx $0 metube
EOF
}

STACK_DIR="" ; STACK_NAME="" ; DEPLOY=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) show_help; exit 0 ;;
    --deploy) DEPLOY=true ;;
    --name) STACK_NAME="$2"; shift ;;
    *) STACK_DIR="${1%/}" ;;
  esac
  shift
done

[[ -z "$STACK_DIR" ]] && { show_help; exit 1; }
: "${DOCKHAND_URL:?set DOCKHAND_URL}" "${DOCKHAND_TOKEN:?set DOCKHAND_TOKEN}"
command -v jq >/dev/null || { echo "jq is required" >&2; exit 1; }

cd "$(dirname "$0")"
[[ -f "$STACK_DIR/compose.yaml" ]] || { echo "No $STACK_DIR/compose.yaml" >&2; exit 1; }
ENV_FILE="$STACK_DIR/sample.env"
STACK_NAME="${STACK_NAME:-$(echo "$STACK_DIR" | tr '[:upper:]' '[:lower:]')}"
DOCKHAND_URL="${DOCKHAND_URL%/}"

api() {
  curl -fsS -H "Authorization: Bearer $DOCKHAND_TOKEN" -H "Content-Type: application/json" "$@"
}

# Resolve repository id by name
REPO_NAME="${DOCKHAND_REPO:-cookbooks}"
REPO_ID=$(api "$DOCKHAND_URL/api/git/repositories" |
  jq -r --arg n "$REPO_NAME" 'map(select(.name | ascii_downcase | contains($n | ascii_downcase))) | .[0].id // empty')
[[ -n "$REPO_ID" ]] || { echo "No Dockhand git repository matching '$REPO_NAME'" >&2; exit 1; }

# Resolve environment id
ENV_ID=$(api "$DOCKHAND_URL/api/environments" |
  jq -r --arg n "${DOCKHAND_ENV:-}" 'if $n == "" then .[0].id else (map(select(.name == $n)) | .[0].id) end // empty')
[[ -n "$ENV_ID" ]] || { echo "No Dockhand environment '${DOCKHAND_ENV:-}'" >&2; exit 1; }

# sample.env -> [{key, value, isSecret}]; ChangeThisPassword values are marked secret
ENV_VARS='[]'
if [[ -f "$ENV_FILE" ]]; then
  ENV_VARS=$(grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$ENV_FILE" | jq -R -s '
    split("\n") | map(select(length > 0) | capture("^(?<key>[^=]+)=(?<value>.*)$")
      | .value |= (sub("^\"(?<v>.*)\"$"; "\(.v)"))
      | .isSecret = (.value == "ChangeThisPassword"))')
fi

BODY=$(jq -n \
  --arg name "$STACK_NAME" --argjson repo "$REPO_ID" --argjson env "$ENV_ID" \
  --arg compose "$STACK_DIR/compose.yaml" --arg envfile "$ENV_FILE" \
  --argjson vars "$ENV_VARS" --argjson deploy "$DEPLOY" \
  '{stackName: $name, repositoryId: $repo, environmentId: $env,
    composePath: $compose, envFilePath: $envfile, envVars: $vars, deployNow: $deploy}')

echo "Creating stack '$STACK_NAME' (repo $REPO_ID, env $ENV_ID, $(echo "$ENV_VARS" | jq length) vars)..."
api -X POST "$DOCKHAND_URL/api/git/stacks" -d "$BODY" >/dev/null
echo "Done. Review the variables in Dockhand, then deploy."
