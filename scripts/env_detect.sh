#!/system/bin/sh

echo "================================"
echo "Root Environment"
echo "================================"
echo

if [ -d /data/adb/magisk ] || [ -n "$MAGISK_VER" ]; then
    echo "Root Type:"
    echo "Magisk"
elif [ -d /data/adb/ksu ] || [ -d /data/adb/ksud ]; then
    echo "Root Type:"
    echo "KernelSU"
elif [ -d /data/adb/ap ]; then
    echo "Root Type:"
    echo "APatch"
else
    echo "Root Type:"
    echo "Unknown"
fi

echo

if command -v resetprop >/dev/null 2>&1; then
    echo "resetprop:"
    echo "Available"
else
    echo "resetprop:"
    echo "Unavailable"
fi
