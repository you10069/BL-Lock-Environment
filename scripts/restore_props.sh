#!/system/bin/sh

BACKUP="$1"

[ ! -f "$BACKUP" ] && exit 0

while IFS= read -r line
do
    KEY="${line%%=*}"
    VALUE="${line#*=}"

    [ "$VALUE" = "<not_found>" ] && continue

    resetprop "$KEY" "$VALUE"

done < "$BACKUP"
