#!/usr/bin/env bash
# Local Flutter dev with secrets from 1Password (CLI: `op`).
#
# Setup:
#   1. Install1Password CLI and sign in (`eval "$(op signin)"`).
#   2. Create a 1Password item with these field labels (exact match):
#        FIREBASE_WEB_API_KEY
#        SENTRY_DSN
#        MAPS_API_KEY
#        SUPABASE_URL
#        SUPABASE_ANON_KEY
#   3. chmod +x tool/run_dev.example.sh
#      Optional: use tool/run_dev.sh (gitignored) for a default OP_ITEM_REF.
#      Or: cp tool/run_dev.example.sh tool/run_dev.sh and edit OP_ITEM_REF there.
#
# Usage:
#   ./tool/run_dev.sh
#   ./tool/run_dev.sh -d chrome
#   OP_ITEM_REF='op://My Vault/My Item' ./tool/run_dev.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v op >/dev/null 2>&1; then
  echo "1Password CLI (op) not found. Install it and run: op signin" >&2
  exit 1
fi

: "${OP_ITEM_REF:?Set OP_ITEM_REF to your dev secrets item, e.g. op://BarberShop/Local Dev}"

read_secret() {
  local label="$1"
  op read "${OP_ITEM_REF}/${label}"
}

FIREBASE_WEB_API_KEY="$(read_secret FIREBASE_WEB_API_KEY)"
SENTRY_DSN="$(read_secret SENTRY_DSN)"
MAPS_API_KEY="$(read_secret MAPS_API_KEY)"
SUPABASE_URL="$(read_secret SUPABASE_URL)"
SUPABASE_ANON_KEY="$(read_secret SUPABASE_ANON_KEY)"

exec flutter run \
  --dart-define=FIREBASE_WEB_API_KEY="$FIREBASE_WEB_API_KEY" \
  --dart-define=SENTRY_DSN="$SENTRY_DSN" \
  --dart-define=MAPS_API_KEY="$MAPS_API_KEY" \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
  "$@"
