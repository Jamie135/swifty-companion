#!/usr/bin/env bash
# Usage: scripts/test_api.sh <login>
# Reads CLIENT_ID / CLIENT_SECRET from .env and fetches a user from the 42 API.
set -euo pipefail
cd "$(dirname "$0")/.."
set -a; source .env; set +a

login="${1:?usage: $0 <login>}"

token=$(curl -s -X POST https://api.intra.42.fr/oauth/token \
  -d grant_type=client_credentials \
  -d client_id="$CLIENT_ID" \
  -d client_secret="$CLIENT_SECRET" \
  | python3 -c 'import sys, json; d = json.load(sys.stdin); print(d.get("access_token") or sys.exit(f"token error: {d}"))')

echo "Got token: ${token:0:8}..."
curl -s -H "Authorization: Bearer $token" "https://api.intra.42.fr/v2/users/$login" > "user_$login.json"
echo "Saved user_$login.json"
