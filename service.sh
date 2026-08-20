#!/system/bin/sh

MODDIR=${0%/*}
DATA=/data/adb/bl_lock_env
LOG=$DATA/apply.log

mkdir -p "$DATA"

CONF="$MODDIR/config/bl_lock.conf"

sh "$MODDIR/scripts/backup_props.sh" "$CONF" "$DATA/backup.conf"

sh "$MODDIR/scripts/apply_props.sh" "$CONF" "$LOG"
