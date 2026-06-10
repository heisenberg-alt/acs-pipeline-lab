#!/usr/bin/env bash
# Chronicle Memory demo — simulates the durable agent memory store
# launched at Build 2026. Writes/reads/purges governed memory entries.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

STORE=".chronicle"
CMD="${1:-help}"

case "$CMD" in
  write)
    SCOPE="${2:?usage: chronicle.sh write <session|repo|user> \"<note>\"}"
    NOTE="${3:?usage: chronicle.sh write <scope> \"<note>\"}"
    mkdir -p "$STORE/$SCOPE"
    FILE="$STORE/$SCOPE/$(date +%s).md"
    printf '%s\n' "$NOTE" > "$FILE"
    echo "🧠 [chronicle] wrote $SCOPE memory: $FILE"
    echo "$(date -Iseconds) WRITE scope=$SCOPE file=$FILE" >> "$STORE/audit.log"
    ;;
  read)
    SCOPE="${2:-}"
    echo "🧠 [chronicle] memory contents${SCOPE:+ (scope: $SCOPE)}:"
    find "$STORE/${SCOPE:-}" -name '*.md' -type f 2>/dev/null | while read -r f; do
      echo "── $f"; cat "$f"
    done || echo "(empty)"
    echo "$(date -Iseconds) READ scope=${SCOPE:-all}" >> "$STORE/audit.log"
    ;;
  forget)
    # Right-to-forget: purge user-scoped memory entirely
    rm -rf "$STORE/user"
    echo "🗑️  [chronicle] user memory purged (right_to_forget)"
    echo "$(date -Iseconds) FORGET scope=user" >> "$STORE/audit.log"
    ;;
  audit)
    echo "📜 [chronicle] audit log:"; cat "$STORE/audit.log" 2>/dev/null || echo "(no entries yet)"
    ;;
  *)
    echo "Chronicle Memory demo (Build 2026)"
    echo "Usage:"
    echo "  bash lab/scripts/chronicle.sh write <session|repo|user> \"note\""
    echo "  bash lab/scripts/chronicle.sh read [scope]"
    echo "  bash lab/scripts/chronicle.sh forget        # purge user scope"
    echo "  bash lab/scripts/chronicle.sh audit         # view access log"
    ;;
esac
