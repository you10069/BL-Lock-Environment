#!/system/bin/sh
ui_print "================================"
ui_print " BL Lock Environment"
ui_print " Phase 3"
ui_print "================================"

sh "$MODPATH/scripts/audit_props.sh" "$MODPATH/config/bl_lock.conf"

exit 0
