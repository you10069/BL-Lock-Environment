#!/system/bin/sh

DATA=/data/adb/bl_lock_env

if [ -f "$DATA/backup.conf" ]; then
    echo "Backup found. Restore requires boot service."
fi
