#!/system/bin/sh

CONF="$1"
LOG="$2"

[ -z "$CONF" ] && exit 1

while IFS= read -r line
do
    case "$line" in
        ""|\#*) continue ;;
    esac

    KEY="${line%%=*}"
    VALUE="${line#*=}"

    CURRENT=$(resetprop "$KEY" 2>/dev/null)

    if [ "$CURRENT" = "$VALUE" ]; then
        echo "$KEY|KEEP|$CURRENT|$VALUE" >> "$LOG"
        continue
    fi

    resetprop "$KEY" "$VALUE"

    AFTER=$(resetprop "$KEY" 2>/dev/null)

    if [ "$AFTER" = "$VALUE" ]; then
        echo "$KEY|MODIFY|$CURRENT|$VALUE" >> "$LOG"
    else
        echo "$KEY|FAILED|$CURRENT|$VALUE" >> "$LOG"
    fi

done < "$CONF"
