#!/system/bin/sh
MODPATH=${MODPATH:-${0%/*}/..}
CONF="$1"
OUT="$2"
. "$MODPATH/scripts/lib/prop_backend.sh"
init_prop_backend
mkdir -p "$(dirname "$OUT")"
: > "$OUT"
while IFS= read -r line; do
    case "$line" in ''|\#*) continue;; esac
    case "$line" in *=*) ;; *) continue;; esac
    key="${line%%=*}"
    value="$(prop_get "$key")"
    echo "$key=$value" >> "$OUT"
done < "$CONF"
