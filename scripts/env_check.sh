#!/system/bin/sh

MODDIR="$1"
DATA="/data/adb/bl_lock_env"

echo "================================"
echo "Environment Check"
echo "================================"
echo

if command -v resetprop >/dev/null 2>&1; then
    echo "resetprop"
    echo "状态：PASS"
else
    echo "resetprop"
    echo "状态：FAILED"
fi

echo

if [ -f "$MODDIR/config/bl_lock.conf" ]; then
    echo "Config"
    echo "状态：PASS"
else
    echo "Config"
    echo "状态：FAILED"
fi

echo

if [ -d "/data/adb" ]; then
    echo "Data Directory"
    echo "状态：PASS"
else
    echo "Data Directory"
    echo "状态：FAILED"
fi
