#!/system/bin/sh
MODDIR=${0%/*}
mkdir -p "$MODDIR/sim/workspace" "$MODDIR/sim/system" "$MODDIR/sim/data"
echo "started $(date)" > "$MODDIR/sim/workspace/alive.log"
id >> "$MODDIR/sim/workspace/alive.log"
RATE_FILE=/data/local/tmp/supported_rates.txt

# Path ng APK mo sa loob ng module
# ⚠️ PALITAN ito kung iba ang package name / path mo
APK_PATH="$MODDIR/system/app/ToastApp/ToastApp.apk"
APK_PACKAGE="com.yourname.magisktoast"

# Wait for the boot process to complete
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

# ============================================
# AUTO-INSTALL APK SECTION
# ============================================
# Dagdag na hintay para siguradong handa na ang Package Manager
sleep 5

if [ -f "$APK_PATH" ]; then
    # Check kung naka-install na — para hindi mag-reinstall every boot
    if pm list packages | grep -q "$APK_PACKAGE"; then
        log -t SmoothModule "APK already installed: $APK_PACKAGE"
    else
        log -t SmoothModule "Installing APK from $APK_PATH"
        pm install -r "$APK_PATH" >> /dev/null 2>&1
        if [ $? -eq 0 ]; then
            log -t SmoothModule "APK installed successfully"
        else
            log -t SmoothModule "APK install FAILED — check SELinux / signature"
        fi
    fi
else
    log -t SmoothModule "APK not found at $APK_PATH"
fi
# ============================================

# ============================================
# REFRESH RATE SECTION (original mo)
# ============================================
if [ -f "$RATE_FILE" ]; then
    # Find the maximum and minimum supported rates from the file
    MAX_RATE=$(sort -n "$RATE_FILE" | tail -n 1)
    MIN_RATE=$(sort -n "$RATE_FILE" | head -n 1)

    if [ -n "$MAX_RATE" ] && [ -n "$MIN_RATE" ]; then
        # Apply the rates to the system settings
        settings put system peak_refresh_rate "$MAX_RATE"
        settings put system min_refresh_rate "$MIN_RATE"
        settings put system user_refresh_rate "$MAX_RATE"
        log -t SmoothModule "Applied peak rate: ${MAX_RATE}Hz, min rate: ${MIN_RATE}Hz"
    fi
fi
