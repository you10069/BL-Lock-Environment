#!/system/bin/sh
MODPATH=${MODPATH:-${0%/*}/..}
CONF="$1"
. "$MODPATH/scripts/lib/prop_backend.sh"
init_prop_backend || exit 1

while IFS= read -r line; do
    case "$line" in ''|\#*) continue;; esac
    case "$line" in *"="*) ;; *) continue;; esac
    key="${line%%=*}"
    value="${line#*=}"
    IFS= read -r strategy_line || true
    strategy="${strategy_line#\#策略：}"
    case "$strategy" in
        VERIFY)
            current="$(prop_get "$key")"
            [ "$current" = "$value" ] && echo "PASS VERIFY $key" || echo "FAIL VERIFY $key current=$current target=$value"
            ;;
        CREATE)
            current="$(prop_get "$key")"
            [ -n "$current" ] && echo "PASS CREATE $key" || echo "FAIL CREATE $key missing"
            ;;
        MATCH)
            match="${value%%=>*}"
            current="$(prop_get "$key")"
            case "$current" in *"$match"*) echo "PASS MATCH $key";; *) echo "FAIL MATCH $key current=$current";; esac
            ;;
    esac
done < "$CONF"
