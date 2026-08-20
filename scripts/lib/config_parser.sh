#!/system/bin/sh

# Unified config parser helpers
# Usage: parse_config_line "property=value" ...

parse_config_entry(){
    line="$1"
    [ -z "$line" ] && return 1
    case "$line" in
        \#*) return 1 ;;
        *=*) ;;
        *) return 1 ;;
    esac
    PARSE_KEY="${line%%=*}"
    PARSE_VALUE="${line#*=}"
    return 0
}

