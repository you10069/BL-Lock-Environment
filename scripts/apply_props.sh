#!/system/bin/sh

CONF="$1"
LOG="$2"

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

    if [ "$CURRENT" = "$VALUE" ]; then
        {
            echo "$KEY"
            echo "说明：${DESC:-无}"
            echo "原值：$CURRENT"
            echo "目标值：$VALUE"
            echo "结果：KEEP"
            echo
        } >> "$LOG"
        continue
    fi

    resetprop "$KEY" "$VALUE"

    AFTER=$(resetprop "$KEY" 2>/dev/null)

    {
        echo "$KEY"
        echo "说明：${DESC:-无}"
        echo "原值：${CURRENT:-<not found>}"
        echo "目标值：$VALUE"
        if [ "$AFTER" = "$VALUE" ]; then
            echo "结果：SUCCESS"
        else
            echo "结果：FAILED"
        fi
        echo
    } >> "$LOG"

done < "$CONF"
