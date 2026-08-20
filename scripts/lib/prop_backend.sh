#!/system/bin/sh

PROP_BACKEND=""

prop_init()
{
    if [ -n "$MODPATH" ] && [ -x "$MODPATH/bin/resetprop-rs" ]; then
        PROP_BACKEND="$MODPATH/bin/resetprop-rs"
    elif command -v resetprop >/dev/null 2>&1; then
        PROP_BACKEND="resetprop"
    fi
}

prop_get(){ $PROP_BACKEND "$1" 2>/dev/null; }
prop_set(){ $PROP_BACKEND -n "$1" "$2"; }
prop_delete(){ $PROP_BACKEND -d "$1"; }
prop_clear(){ $PROP_BACKEND -c; }
