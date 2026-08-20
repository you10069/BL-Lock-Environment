#!/system/bin/sh

CONF="$1"
LOG="$2"

mkdir -p "$(dirname "$LOG")"

echo "Time: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"
echo >> "$LOG"

while IFS= read -r line
do
    case "$line" in
        ""|\#*) continue ;;
    esac

    KEY="${line%%=*}"
    VALUE="${line#*=}"

    CURRENT=$(resetprop "$KEY" 2>/dev/null)

    echo "$KEY" >> "$LOG"
    echo "目标值：$VALUE" >> "$LOG"
    echo "当前值：${CURRENT:-<not found>}" >> "$LOG"

    if [ "$CURRENT" = "$VALUE" ]; then
        echo "结果：PASS" >> "$LOG"
    else
        echo "结果：FAILED" >> "$LOG"
    fi

    echo >> "$LOG"

done < "$CONF"
