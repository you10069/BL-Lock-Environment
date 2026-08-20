#!/system/bin/sh
MODPATH=${MODPATH:-${0%/*}/..}
. "$MODPATH/scripts/lib/prop_backend.sh"
if init_prop_backend; then
 echo "Property Backend: OK"
else
 echo "Property Backend: FAILED"
 exit 1
fi
