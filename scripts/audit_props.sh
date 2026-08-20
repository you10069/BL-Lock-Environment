#!/system/bin/sh

CONF="$1"

get_desc()
{
    awk -v key="$1" '
    $0 ~ "^"key"=" {
        found=1
        next
    }
    found && /^#/ {
        sub(/^# ?/, "")
        if ($0 != "") {
            print $0
            exit
        }
    }
    found && !/^#/ {
        exit
    }
    ' "$2"
}

get_section()
{
    awk '
    /^#################################################$/ {
        getline
        if ($0 ~ /^# [0-9]+\./) {
            sub(/^# /, "")
            print
        }
    }
    ' "$1"
}

CURRENT_SECTION=""

while IFS= read -r line
do
    case "$line" in
        "" ) continue ;;
        \#\ \[0-9\].* )
            CURRENT_SECTION="${line#\# }"
            echo "================================"
            echo "$CURRENT_SECTION"
            echo "================================"
            echo
            continue
            ;;
        \#*) continue ;;
    esac

    KEY="${line%%=*}"
    VALUE="${line#*=}"

    DESC=$(get_desc "$KEY" "$CONF")
    CURRENT=$(resetprop "$KEY" 2>/dev/null)

    if [ -z "$CURRENT" ]; then
        CURRENT="<not found>"
        ACTION="SKIP"
    elif [ "$CURRENT" = "$VALUE" ]; then
        ACTION="KEEP"
    else
        ACTION="MODIFY"
    fi

    echo "$KEY"
    echo "说明：${DESC:-无}"
    echo "当前值：$CURRENT"
    echo "配置值：$VALUE"
    echo "动作：$ACTION"
    echo

done < "$CONF"
