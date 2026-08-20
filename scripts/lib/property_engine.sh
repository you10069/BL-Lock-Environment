#!/system/bin/sh

verify_property(){
    key="$1"
    target="$2"
    current="$(prop_get "$key")"
    if [ -z "$current" ]; then
        ACTION="SKIP"
    elif [ "$current" = "$target" ]; then
        ACTION="KEEP"
    else
        prop_set "$key" "$target"
        ACTION="MODIFY"
    fi
}

create_property(){
    key="$1"
    target="$2"
    current="$(prop_get "$key")"
    if [ -z "$current" ]; then
        prop_set "$key" "$target"
        ACTION="CREATE"
    else
        ACTION="KEEP"
    fi
}

match_property(){
    key="$1"
    match="$2"
    target="$3"
    current="$(prop_get "$key")"
    case "$current" in
        *"$match"*)
            prop_set "$key" "$target"
            ACTION="MODIFY"
            ;;
        *)
            ACTION="KEEP"
            ;;
    esac
}
