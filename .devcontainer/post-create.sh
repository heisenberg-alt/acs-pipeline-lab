#!/usr/bin/env bash
# Post-create setup for the ACS Pipeline Lab Codespace.
set -euo pipefail

echo "🛠  Setting up the ACS Pipeline Lab..."

# Install sample app dependencies
if [ -f lab/sample-app/package.json ]; then
  (cd lab/sample-app && npm install --no-fund --no-audit)
fi

# Install PyYAML for the local manifest validator
pip install --quiet pyyaml 2>/dev/null || true

# Friendly banner on first terminal
cat >> ~/.bashrc <<'EOF'

echo ""
echo "🛡️  ACS Pipeline Lab — Build 2026"
echo "   Start here  : lab/README.md"
echo "   Validate    : bash lab/scripts/validate-acs.sh"
echo "   Run the app : cd lab/sample-app && npm start"
echo ""
EOF

echo "✅ Lab environment ready. Open lab/README.md to begin."
