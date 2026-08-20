#!/system/bin/sh

prop_get()
{
    resetprop "$1" 2>/dev/null
}

prop_set()
{
    resetprop "$1" "$2"
}

prop_exists()
{
    VALUE=$(resetprop "$1" 2>/dev/null)
    [ -n "$VALUE" ]
}
