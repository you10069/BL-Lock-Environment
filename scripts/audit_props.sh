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

    if [ -z "$CURRENT" ]; then
        CURRENT="<not found>"
        ACTION="SKIP"
    elif [ "$CURRENT" = "$VALUE" ]; then
        ACTION="KEEP"
    else
        ACTION="MODIFY"
    fi

    echo "$KEY"
    echo "当前值：$CURRENT"
    echo "配置值：$VALUE"
    echo "动作：$ACTION"
    echo

done < "$CONF"
