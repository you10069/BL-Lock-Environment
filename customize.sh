#!/system/bin/sh

ui_print "================================"
ui_print " BL Lock Environment"
ui_print " Universal Bootloader Locked Environment"
ui_print " Version 1.0"
ui_print "================================"

DATA=/data/adb/bl_lock_env
LOGDIR=$DATA/logs
CONF=$MODPATH/config/bl_lock.conf

mkdir -p "$LOGDIR"

ui_print ""
ui_print "[1/5] Detect Environment"
sh "$MODPATH/scripts/audit_props.sh" "$CONF"

ui_print ""
ui_print "[2/5] Prepare Data Directory"
ui_print "Data directory ready"

ui_print ""
ui_print "[3/5] Backup Properties"
sh "$MODPATH/scripts/backup_props.sh" "$CONF" "$DATA/backup.conf"

ui_print ""
ui_print "[4/5] Apply Properties"
sh "$MODPATH/scripts/apply_props.sh" "$CONF" "$LOGDIR/apply.log"

ui_print ""
ui_print "[5/5] Verify Result"
sh "$MODPATH/scripts/verify_props.sh" "$CONF" "$LOGDIR/verify.log"

sh "$MODPATH/scripts/summary.sh" "$LOGDIR"
