#!/system/bin/sh

BACKUP="$1"
LOG="$2"

mkdir -p "$(dirname "$LOG")"

echo "Time: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"
echo >> "$LOG"

if [ ! -f "$BACKUP" ]; then
    echo "No backup found. Skip restore." >> "$LOG"
    exit 0
fi

while IFS= read -r line
do
    KEY="${line%%=*}"
    VALUE="${line#*=}"

    [ "$VALUE" = "<not_found>" ] && continue

    resetprop "$KEY" "$VALUE"

    AFTER=$(resetprop "$KEY" 2>/dev/null)

    echo "$KEY" >> "$LOG"
    echo "恢复值：$VALUE" >> "$LOG"

    if [ "$AFTER" = "$VALUE" ]; then
        echo "结果：SUCCESS" >> "$LOG"
    else
        echo "结果：FAILED" >> "$LOG"
    fi

    echo >> "$LOG"

done < "$BACKUP"
