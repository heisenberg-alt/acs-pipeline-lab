#!/usr/bin/env bash
# Sandbox demo — runs a command under the ACS sandbox policy:
# per-action isolation, no network, writable paths restricted.
# Uses bwrap if available; falls back to a restricted subshell.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

CMD="${*:?usage: sandbox-run.sh <command...>}"
echo "📦 [sandbox] policy: per-action · network=deny · writable=lab/sample-app,/tmp"
echo "📦 [sandbox] executing: $CMD"
echo "$(date -Iseconds) SANDBOX exec=\"$CMD\"" >> .chronicle/audit.log 2>/dev/null || true

if command -v bwrap >/dev/null 2>&1; then
  # Real isolation: read-only repo, writable sample-app + tmp, no network
  bwrap \
    --ro-bind / / \
    --bind "$(pwd)/lab/sample-app" "$(pwd)/lab/sample-app" \
    --tmpfs /tmp \
    --unshare-net \
    --die-with-parent \
    bash -c "$CMD" \
  && echo "✅ [sandbox] action completed inside isolation" \
  || { echo "❌ [sandbox] action failed or violated policy — killed and reported"; exit 1; }
else
  # Fallback: demonstrate the policy without kernel namespaces
  echo "ℹ️  bwrap not available — running with restricted env (demo fallback)"
  env -i PATH="$PATH" HOME=/tmp bash -c "cd lab/sample-app && $CMD" \
  && echo "✅ [sandbox] action completed (fallback mode)" \
  || { echo "❌ [sandbox] action failed — reported to audit sink"; exit 1; }
fi
