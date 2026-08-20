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
ui_print "[0/6] Environment Check"
sh "$MODPATH/scripts/env_check.sh" "$MODPATH"

ui_print ""
ui_print "[1/6] Detect Environment"
sh "$MODPATH/scripts/audit_props.sh" "$CONF"

ui_print ""
ui_print "[2/6] Prepare Data Directory"
ui_print "Data directory ready"

ui_print ""
ui_print "[3/6] Backup Properties"
sh "$MODPATH/scripts/backup_props.sh" "$CONF" "$DATA/backup.conf"

ui_print ""
ui_print "[4/6] Apply Properties"
sh "$MODPATH/scripts/apply_props.sh" "$CONF" "$LOGDIR/apply.log"

ui_print ""
ui_print "[5/6] Verify Result"
sh "$MODPATH/scripts/verify_props.sh" "$CONF" "$LOGDIR/verify.log"

ui_print ""
ui_print "[6/6] Summary"
sh "$MODPATH/scripts/summary.sh" "$LOGDIR"
