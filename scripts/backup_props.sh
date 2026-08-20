#!/system/bin/sh

CONF="$1"
BACKUP="$2"

[ -f "$BACKUP" ] && exit 0

while IFS= read -r line
do
    case "$line" in
        ""|\#*) continue ;;
    esac

    KEY="${line%%=*}"
    CURRENT=$(resetprop "$KEY" 2>/dev/null)

    echo "$KEY=$CURRENT" >> "$BACKUP"

done < "$CONF"
