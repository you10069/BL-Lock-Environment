#!/system/bin/sh

DATA=/data/adb/bl_lock_env
BACKUP=$DATA/backup.conf
LOG=$DATA/logs/restore.log

if [ -f "$BACKUP" ]; then
    sh "$MODPATH/scripts/restore_props.sh" "$BACKUP" "$LOG"
fi
