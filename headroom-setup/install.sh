#!/usr/bin/env bash
# Install Headroom (https://github.com/chopratejas/headroom) so it can be used
# as an MCP server from Claude Code. Idempotent: safe to re-run.
set -euo pipefail

PYTHON_BIN="${PYTHON_BIN:-python3}"

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "error: $PYTHON_BIN not found on PATH" >&2
  exit 1
fi

PY_MAJOR_MINOR=$("$PYTHON_BIN" -c 'import sys; print("%d.%d" % sys.version_info[:2])')
case "$PY_MAJOR_MINOR" in
  3.10|3.11|3.12|3.13|3.14) ;;
  *)
    echo "error: Headroom requires Python 3.10+, found $PY_MAJOR_MINOR" >&2
    exit 1
    ;;
esac

if command -v pipx >/dev/null 2>&1; then
  pipx install --force --python "$PYTHON_BIN" "headroom-ai[all]"
else
  "$PYTHON_BIN" -m pip install --user --upgrade "headroom-ai[all]"
fi

headroom mcp install
echo "done. headroom MCP server is registered."
