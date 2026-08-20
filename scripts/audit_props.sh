#!/system/bin/sh

CONF="$1"

while IFS= read -r line
do
    case "$line" in
        ""|\#*) continue ;;
    esac

    KEY="${line%%=*}"
    VALUE="${line#*=}"

    CURRENT=$(resetprop "$KEY" 2>/dev/null)

    echo "$KEY"
    echo "当前值：${CURRENT:-<not found>}"
    echo "配置值：$VALUE"
    echo

done < "$CONF"
