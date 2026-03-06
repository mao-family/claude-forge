#!/usr/bin/env bash
#
# Run workflow tests outside of Claude Code session
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly PROJECT_ROOT

# Ensure we're not in a Claude Code session
if [[ -n "${CLAUDECODE:-}" ]]; then
  echo "[ERROR] Cannot run tests inside Claude Code session."
  echo "Please run this script from a regular terminal."
  exit 1
fi

# Check dependencies
if ! command -v bats &> /dev/null; then
  echo "[ERROR] bats not found. Install with: brew install bats-core"
  exit 1
fi

if ! command -v claude &> /dev/null; then
  echo "[ERROR] claude CLI not found."
  exit 1
fi

cd "${PROJECT_ROOT}"

echo "Running workflow tests..."
echo "========================="
echo ""

# Run with optional filter
if [[ $# -gt 0 ]]; then
  echo "Filter: $*"
  bats tests/workflow.bats --filter "$@"
else
  bats tests/workflow.bats --tap
fi
