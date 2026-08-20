#!/system/bin/sh

CONF="$1"
LOG="$2"

{
echo "Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo
} >> "$LOG"

while IFS= read -r line
do
    case "$line" in
        ""|\#*) continue ;;
    esac

    KEY="${line%%=*}"
    VALUE="${line#*=}"

    CURRENT=$(resetprop "$KEY" 2>/dev/null)

    {
        echo "$KEY"
        echo "原值：${CURRENT:-<not found>}"
        echo "目标值：$VALUE"
    } >> "$LOG"

    if [ "$CURRENT" = "$VALUE" ]; then
        echo "结果：KEEP" >> "$LOG"
    else
        resetprop "$KEY" "$VALUE"
        AFTER=$(resetprop "$KEY" 2>/dev/null)
        if [ "$AFTER" = "$VALUE" ]; then
            echo "结果：SUCCESS" >> "$LOG"
        else
            echo "结果：FAILED" >> "$LOG"
        fi
    fi

    echo >> "$LOG"

done < "$CONF"
