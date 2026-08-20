#!/system/bin/sh
MODPATH=${MODPATH:-${0%/*}/..}
CONF="$1"
. "$MODPATH/scripts/lib/prop_backend.sh"
init_prop_backend || exit 1

get_desc(){
 awk -v key="$1" '$0 ~ "^"key"=" {getline; if ($0 ~ /^#说明：/) {sub(/^#说明：/,"");print}; exit}' "$2"
}

while IFS= read -r line; do
 case "$line" in ''|\#*) continue;; esac
 case "$line" in *"="*) ;; *) continue;; esac
 KEY="${line%%=*}"
 VALUE="${line#*=}"
 IFS= read -r strategy_line || true
 STRATEGY="${strategy_line#\#策略：}"
 DESC=$(get_desc "$KEY" "$CONF")
 CURRENT=$(prop_get "$KEY")

 echo "$KEY"
 echo "说明：${DESC:-无}"
 echo "策略：${STRATEGY:-VERIFY}"
 echo "当前值：${CURRENT:-<not found>}"
 echo "配置值：$VALUE"
 echo
 done < "$CONF"
