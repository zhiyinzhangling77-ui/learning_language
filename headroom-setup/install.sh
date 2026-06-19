#!/usr/bin/env bash
set -euo pipefail

# Headroom MCP installer
# - Verifies Python 3.10+
# - Installs headroom-ai[all] via pipx when available, otherwise pip --user
# - Registers the Headroom MCP server with Claude Code

PYTHON_BIN="${PYTHON:-python3}"

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "ERROR: python3 not found in PATH" >&2
  exit 1
fi

PY_VERSION="$("$PYTHON_BIN" -c 'import sys; print("%d.%d" % sys.version_info[:2])')"
PY_OK="$("$PYTHON_BIN" -c 'import sys; print(1 if sys.version_info >= (3, 10) else 0)')"

if [ "$PY_OK" != "1" ]; then
  echo "ERROR: Python 3.10+ required, found ${PY_VERSION} at $(command -v "$PYTHON_BIN")" >&2
  exit 1
fi

echo "Using Python ${PY_VERSION} ($(command -v "$PYTHON_BIN"))"

if command -v pipx >/dev/null 2>&1; then
  echo "Installing headroom-ai[all] with pipx..."
  pipx install --force --python "$(command -v "$PYTHON_BIN")" "headroom-ai[all]"
else
  echo "pipx not found; falling back to pip --user"
  "$PYTHON_BIN" -m pip install --user --upgrade "headroom-ai[all]"
fi

if ! command -v headroom >/dev/null 2>&1; then
  echo "WARNING: 'headroom' command not found in PATH after install." >&2
  echo "You may need to add the install location (e.g. ~/.local/bin) to PATH." >&2
fi

echo "Registering Headroom MCP server with Claude Code..."
headroom mcp install

echo "Done. Run 'claude mcp list' to verify."
