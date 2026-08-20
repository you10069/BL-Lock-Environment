#!/system/bin/sh

CONF="$1"
LOG="$2"

while IFS= read -r line
do
    case "$line" in
        ""|\#*) continue ;;
    esac

    KEY="${line%%=*}"
    VALUE="${line#*=}"

    CURRENT=$(resetprop "$KEY" 2>/dev/null)

    if [ "$CURRENT" = "$VALUE" ]; then
        echo "$KEY KEEP $CURRENT" >> "$LOG"
        continue
    fi

    resetprop "$KEY" "$VALUE"

    AFTER=$(resetprop "$KEY" 2>/dev/null)

    echo "$KEY $CURRENT -> $VALUE ($AFTER)" >> "$LOG"

done < "$CONF"
