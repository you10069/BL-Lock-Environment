#!/system/bin/sh

LOGDIR="$1"

APPLY="$LOGDIR/apply.log"
VERIFY="$LOGDIR/verify.log"

MODIFY=$(grep -c "SUCCESS" "$APPLY" 2>/dev/null)
KEEP=$(grep -c "KEEP" "$APPLY" 2>/dev/null)
FAILED=$(grep -c "FAILED" "$APPLY" 2>/dev/null)
PASS=$(grep -c "PASS" "$VERIFY" 2>/dev/null)

echo "================================"
echo " Installation Summary"
echo "================================"
echo
echo "MODIFY : ${MODIFY:-0}"
echo "KEEP   : ${KEEP:-0}"
echo "FAILED : ${FAILED:-0}"
echo
echo "Verification PASS : ${PASS:-0}"
