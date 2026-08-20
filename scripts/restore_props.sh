#!/system/bin/sh

BACKUP="$1"

while IFS= read -r line
do
    KEY="${line%%=*}"
    VALUE="${line#*=}"

    resetprop "$KEY" "$VALUE"

done < "$BACKUP"
