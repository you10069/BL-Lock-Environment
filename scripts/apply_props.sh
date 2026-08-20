#!/system/bin/sh
CONF="$1"
LOG="$2"
ENGINE_DIR="$(dirname "$0")/lib"
. "$ENGINE_DIR/prop_backend.sh"
. "$ENGINE_DIR/property_engine.sh"
prop_init

echo "Time: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"
POLICY="VERIFY"
while IFS= read -r line; do
case "$line" in
#策略:*) POLICY="${line#*：}";;
""|#*) continue;;
*)
KEY="${line%%=*}"; VALUE="${line#*=}"
case "$POLICY" in
VERIFY) verify_property "$KEY" "$VALUE";;
CREATE) create_property "$KEY" "$VALUE";;
MATCH) :;;
esac
{ echo "$KEY"; echo "策略：$POLICY"; echo "动作：$ACTION"; echo; } >> "$LOG"
POLICY="VERIFY";;
esac
done < "$CONF"
