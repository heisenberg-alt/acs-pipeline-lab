#!/usr/bin/env bash
# Local ACS manifest validator — same checks the CI gate runs.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

echo "── ACS manifest validation ──────────────────────────"

test -f .github/agent-control.yml || { echo "❌ .github/agent-control.yml missing"; exit 1; }

python3 - <<'EOF'
import yaml, sys

m = yaml.safe_load(open('.github/agent-control.yml'))
errors = []

# Core manifest
if m.get('version') != '1.0': errors.append("version must be '1.0'")
if not m.get('agent', {}).get('name'): errors.append("agent.name is required")
caps = m.get('capabilities', {})
if not caps.get('deny'): errors.append("capabilities.deny must not be empty")

# Sandboxes (Build 2026)
sb = m.get('sandbox', {})
if sb.get('mode') != 'per-action': errors.append("sandbox.mode must be 'per-action'")
if sb.get('network') != 'deny': errors.append("sandbox.network must be 'deny'")

# Chronicle Memory (Build 2026)
mem = m.get('memory', {})
if mem.get('provider') != 'chronicle': errors.append("memory.provider must be 'chronicle'")
if not mem.get('right_to_forget'): errors.append("memory.right_to_forget must be true")
if not mem.get('audit'): errors.append("memory.audit must be true")
scopes = mem.get('scopes', {})
for s in ('session', 'repo', 'user'):
    if s not in scopes: errors.append(f"memory.scopes.{s} is missing")

if errors:
    print("❌ Validation failed:")
    for e in errors: print(f"   - {e}")
    sys.exit(1)
print("✅ Manifest valid: capabilities, sandbox policy, and Chronicle Memory governance all declared.")
EOF
