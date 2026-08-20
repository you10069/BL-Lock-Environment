#!/system/bin/sh

CONF="$1"
BACKUP="$2"
LOG="${BACKUP%/*}/backup.log"

[ -f "$BACKUP" ] && exit 0

echo "Time: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"

while IFS= read -r line
do
    case "$line" in
        ""|\#*) continue ;;
    esac

    KEY="${line%%=*}"
    VALUE=$(resetprop "$KEY" 2>/dev/null)

    if [ -z "$VALUE" ]; then
        echo "$KEY=<not_found>" >> "$BACKUP"
        echo "$KEY backup: SKIP" >> "$LOG"
    else
        echo "$KEY=$VALUE" >> "$BACKUP"
        echo "$KEY backup: SUCCESS" >> "$LOG"
    fi

done < "$CONF"
