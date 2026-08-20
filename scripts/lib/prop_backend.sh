#!/system/bin/sh

# Property backend abstraction

PROP_BACKEND=""

init_prop_backend(){
    if [ -n "$MODPATH" ] && [ -x "$MODPATH/bin/resetprop-rs" ]; then
        PROP_BACKEND="$MODPATH/bin/resetprop-rs"
    elif command -v resetprop >/dev/null 2>&1; then
        PROP_BACKEND="$(command -v resetprop)"
    fi
}

prop_get(){
    [ -z "$PROP_BACKEND" ] && return 1
    "$PROP_BACKEND" "$1" 2>/dev/null
}

prop_set(){
    [ -z "$PROP_BACKEND" ] && return 1
    "$PROP_BACKEND" -n "$1" "$2"
}

prop_delete(){
    [ -z "$PROP_BACKEND" ] && return 1
    "$PROP_BACKEND" -d "$1"
}

prop_clear(){
    [ -z "$PROP_BACKEND" ] && return 1
    "$PROP_BACKEND" -c
}
