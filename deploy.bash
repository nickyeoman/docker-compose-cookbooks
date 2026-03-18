#!/usr/bin/env bash
set -euo pipefail

# --- CONFIG ---
BASE_DIR="$(pwd)"
WEBSITES_DIR=""

# --- HELP ---
show_help() {
  cat <<EOF
Dockhand CLI Emulator 🚢

Deploy Docker Compose stacks from the CLI using a Dockhand-like model.

USAGE:
  $0 [stack-name] [domain-name]

EXAMPLES:
  $0
      Interactive mode (fzf picker)

  $0 archivebox com-nickyeoman-archive
      Deploy 'archivebox' stack to 'com-nickyeoman-archive'

BEHAVIOR:
  - Uses compose.yaml from: ./<stack-name>/
  - Uses env files:
      - sample.env (default, optional)
      - <data-dir>/<domain-name>/.env (override, optional)

REQUIREMENTS:
  - docker + docker compose
  - fzf (for interactive mode)

EOF
}

# --- PROMPTS ---
prompt_websites_dir() {
  local default="/var/websites"
  read -rp "Where is your container data directory? [$default]: " input
  WEBSITES_DIR="${input:-$default}"
}

# --- PICKERS ---
pick_stack() {
  find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d \
    ! -name '*_*' ! -name '.git' \
    -printf '%f\n' | sort | fzf --prompt="Select stack: "
}

pick_domain() {
  find "$WEBSITES_DIR" -mindepth 1 -maxdepth 1 -type d \
    -printf '%f\n' | sort | fzf --prompt="Select domain: "
}

# --- INPUT HANDLING ---
parse_args() {
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    show_help
    exit 0
  fi

  STACK_NAME="${1:-}"
  DOMAIN_NAME="${2:-}"
}

interactive_select() {
  # Ask for base data dir first (only if needed)
  if [[ -z "$WEBSITES_DIR" ]]; then
    prompt_websites_dir
  fi

  if [[ -z "$STACK_NAME" ]]; then
    STACK_NAME="$(pick_stack)"
  fi

  if [[ -z "$DOMAIN_NAME" ]]; then
    DOMAIN_NAME="$(pick_domain)"
  fi
}

validate_input() {
  if [[ -z "$STACK_NAME" || -z "$DOMAIN_NAME" ]]; then
    echo "Error: stack or domain not selected"
    exit 1
  fi
}

# --- PATH SETUP ---
set_paths() {
  STACK_DIR="$BASE_DIR/$STACK_NAME"
  COMPOSE_FILE="$STACK_DIR/compose.yaml"
  ENV_FILE_DEFAULT="$STACK_DIR/sample.env"
  ENV_FILE_OVERRIDE="$WEBSITES_DIR/$DOMAIN_NAME/.env"
}

validate_files() {
  if [[ ! -f "$COMPOSE_FILE" ]]; then
    echo "Error: compose file not found: $COMPOSE_FILE"
    exit 1
  fi
}

build_compose_args() {
  COMPOSE_ARGS=(-f "$COMPOSE_FILE")

  [[ -f "$ENV_FILE_DEFAULT" ]] && COMPOSE_ARGS+=(--env-file "$ENV_FILE_DEFAULT")
  [[ -f "$ENV_FILE_OVERRIDE" ]] && COMPOSE_ARGS+=(--env-file "$ENV_FILE_OVERRIDE")
}

# --- DEPLOY ---
print_info() {
  echo "========================================"
  echo "Deploying stack: $STACK_NAME"
  echo "Domain: $DOMAIN_NAME"
  echo "Data dir: $WEBSITES_DIR"
  echo "========================================"
  echo "Using compose: $COMPOSE_FILE"

  [[ -f "$ENV_FILE_DEFAULT" ]] && echo "Using default env: $ENV_FILE_DEFAULT"
  [[ -f "$ENV_FILE_OVERRIDE" ]] && echo "Using override env: $ENV_FILE_OVERRIDE"
}

pull_images() {
  echo "Pulling images..."
  docker compose "${COMPOSE_ARGS[@]}" pull
}

start_containers() {
  echo "Starting containers..."
  docker compose "${COMPOSE_ARGS[@]}" up -d --force-recreate
}

# --- MAIN ---
main() {
  parse_args "$@"
  interactive_select
  validate_input

  set_paths
  validate_files
  build_compose_args

  print_info
  pull_images
  start_containers

  echo "Done."
}

main "$@"