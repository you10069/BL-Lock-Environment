#!/system/bin/sh

verify_property()
{
    KEY="$1"; TARGET="$2"
    CURRENT=$(prop_get "$KEY")
    if [ "$CURRENT" = "$TARGET" ]; then
        ACTION="KEEP"
    elif [ -n "$CURRENT" ]; then
        prop_set "$KEY" "$TARGET"
        ACTION="MODIFY"
    else
        ACTION="SKIP"
    fi
}

create_property()
{
    KEY="$1"; TARGET="$2"
    CURRENT=$(prop_get "$KEY")
    if [ -n "$CURRENT" ]; then
        ACTION="KEEP"
    else
        prop_set "$KEY" "$TARGET"
        ACTION="CREATE"
    fi
}

match_property()
{
    KEY="$1"; MATCH="$2"; TARGET="$3"
    CURRENT=$(prop_get "$KEY")
    case "$CURRENT" in
        *"$MATCH"*) prop_set "$KEY" "$TARGET"; ACTION="MODIFY" ;;
        *) ACTION="KEEP" ;;
    esac
}
