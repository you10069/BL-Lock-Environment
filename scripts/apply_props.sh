#!/system/bin/sh
. "$(dirname "$0")/lib/config_parser.sh"

CONF="$1"
LOG="$2"
MODPATH=${MODPATH:-${0%/*}/..}

. "$MODPATH/scripts/lib/prop_backend.sh"
. "$MODPATH/scripts/lib/property_engine.sh"
init_prop_backend

strategy="VERIFY"
key=""
value=""
desc=""

process(){
    [ -z "$key" ] && return
    case "$strategy" in
        VERIFY)
            verify_property "$key" "$value" ;;
        CREATE)
            create_property "$key" "$value" ;;
        MATCH)
            match_property "$key" "${value%%=>*}" "${value#*=>}" ;;
    esac
    {
        echo "$key"
        [ -n "$desc" ] && echo "说明：$desc"
        echo "当前值：$(prop_get "$key")"
        echo "配置值：$value"
        echo "策略：$strategy"
        echo "动作：$ACTION"
        echo
    } >> "$LOG"
    key=""; value=""; desc=""; strategy="VERIFY"
}

while IFS= read -r line; do
    case "$line" in
        ""|\#*)
            case "$line" in
                \#策略：*) strategy="${line#\#策略：}";;
                \#说明：*) desc="${line#\#说明：}";;
            esac
            continue
            ;;
    esac
    process
    key="${line%%=*}"
    value="${line#*=}"
done < "$CONF"
process
prop_clear >/dev/null 2>&1
