#!/system/bin/sh
. "$(dirname "$0")/lib/config_parser.sh"
MODPATH=${MODPATH:-${0%/*}/..}
FILE="$1"
. "$MODPATH/scripts/lib/prop_backend.sh"
init_prop_backend
while IFS='=' read -r key value; do
    [ -z "$key" ] && continue
    prop_set "$key" "$value"
done < "$FILE"
