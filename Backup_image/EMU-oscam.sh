#!/bin/sh
# Master Universal Installer - Professional Final Edition
# Modified: Fixed URL & No Internet Check

# --- الإعدادات ---
# ضع الرابط الخاص بك بين علامتي التنصيص بالأسفل
MANUAL_URL="https://github.com/KhaledAli65/emu/raw/refs/heads/main/enigma2-plugin-softcams-oscam-emu.ipk"

# إذا تم تمرير رابط كمتغير أول من البلجن، سيتم استخدامه بدلاً من الرابط اليدوي
URL=${1:-$MANUAL_URL}
TARGET=$2 
TMP_FILE="/tmp/master_pkg"
LOG="/tmp/khaled_master.log"

log_msg() {
    echo "[$(date +%T)] $1" | tee -a $LOG
}

# START: 10% Progress
echo "PROGRESS:10"
log_msg "Installation Started..."

# 1. Dependency Check (Unzip)
if echo "$URL" | grep -q ".zip" && ! command -v unzip > /dev/null 2>&1; then
    log_msg "Action: Installing dependencies..."
    opkg update > /dev/null && opkg install unzip
fi

# 2. التحقق من الإنترنت (تم الإلغاء بناءً على طلبك)
# log_msg "Checking Connectivity..."
# (تم حذف كود الـ ping)

# 3. Download: 30% Progress
echo "PROGRESS:30"
log_msg "Action: Downloading package from: $URL"
wget -q --no-check-certificate -O "$TMP_FILE" "$URL"
[ $? -ne 0 ] && { log_msg "ERROR: Download failed."; exit 1; }

# 4. Extraction: 60% Progress
echo "PROGRESS:60"
case "$URL" in
    *.ipk)
        log_msg "Action: Installing IPK via Opkg..."
        opkg install "$TMP_FILE"
        RESULT=$?
        ;;
    *.zip)
        log_msg "Action: Extracting ZIP to $TARGET..."
        [ ! -d "$TARGET" ] && mkdir -p "$TARGET"
        unzip -o "$TMP_FILE" -d "$TARGET" > /dev/null
        RESULT=$?
        ;;
    *.tar.gz)
        if [ -n "$TARGET" ] && [ "$TARGET" != "/" ]; then
            log_msg "Action: Extracting Tar.gz to $TARGET..."
            [ ! -d "$TARGET" ] && mkdir -p "$TARGET"
            tar -xzf "$TMP_FILE" -C "$TARGET"
        else
            log_msg "Action: Extracting Tar.gz to System Root..."
            tar -xzf "$TMP_FILE" -C /
        fi
        RESULT=$?
        ;;
    *)
        log_msg "ERROR: Unsupported Format."
        exit 1
        ;;
esac

# 5. Permissions: 80% Progress
echo "PROGRESS:80"
if [ $RESULT -eq 0 ] && [ -n "$TARGET" ] && [ "$TARGET" != "/" ]; then
    log_msg "Action: Fixing permissions (755)..."
    find "$TARGET" -type f -exec chmod 755 {} +
    find "$TARGET" -type d -exec chmod 755 {} +
fi

# 6. Finalize: 100% Progress
echo "PROGRESS:100"
if [ $RESULT -eq 0 ]; then
    log_msg "SUCCESS: Installation Finished."
    rm -f "$TMP_FILE"
else
    log_msg "ERROR: Installation Failed."
fi

