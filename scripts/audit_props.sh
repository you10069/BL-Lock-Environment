#!/system/bin/sh

CONF="$1"

get_desc()
{
    local file="$1"
    local key="$2"
    awk -v key="$key" '
    $0 ~ "^"key"=" {
        found=1
        next
    }
    found && /^#/ {
        sub(/^# ?/, "")
        if ($0 != "") {
            print $0
            exit
        }
    }
    found && !/^#/ {
        exit
    }
    ' "$file"
}

while IFS= read -r line
do
    case "$line" in
        ""|\#*) continue ;;
    esac

    KEY="${line%%=*}"
    VALUE="${line#*=}"

    DESC=$(get_desc "$CONF" "$KEY")
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
    echo "说明：${DESC:-无}"
    echo "当前值：$CURRENT"
    echo "配置值：$VALUE"
    echo "动作：$ACTION"
    echo

done < "$CONF"
