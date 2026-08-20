#!/system/bin/sh
MODDIR=${0%/*}
LOG=/data/adb/bl_lock_env.log
echo "BL Lock Environment started" >> "$LOG"
# Property application will be added after source verification pass.
