#!/bin/sh

# ==================== إعدادات الروابط والمسارات ====================
# الرابط المباشر لملف الـ ZIP الخاص بمستودع القنوات
ZIP_URL="https://github.com/KhaledAli65/Channels/archive/refs/heads/main.zip"

# المسار المؤقت الافتراضي في النظام لتفادي الاعتماد على الـ HDD
TMP_HDD_DIR="/tmp/.tmp_channels"
# ===================================================================

echo "=================================================="
echo "    Starting Channels Update & Safe Extract       "
echo "=================================================="

# 1. إنشاء المجلد المؤقت في مسار tmp
mkdir -p "$TMP_HDD_DIR"

# 2. تحميل ملف القنوات المضغوط مباشرة إلى المسار المؤقت
echo "[*] Downloading Channels ZIP file from GitHub..."
wget -q --no-check-certificate "$ZIP_URL" -O "$TMP_HDD_DIR/channels_master.zip"

if [ $? -ne 0 ]; then
    echo "[-] Download failed! Please check your internet connection."
    rm -rf "$TMP_HDD_DIR"
    exit 1
fi

echo "[+] Download completed successfully."

# 3. فك الضغط داخل المجلد المؤقت
echo "[*] Extracting files in tmp..."
unzip -q -o "$TMP_HDD_DIR/channels_master.zip" -d "$TMP_HDD_DIR/"

# التقاط اسم المجلد الرئيسي الناتج عن جيتهاب تلقائياً (مثل Channels-main)
EXTRACTED_DIR=$(ls -d "$TMP_HDD_DIR"/Channels-*/ 2>/dev/null)

# التأكد من وجود مجلد etc المستهدف بالداخل
if [ -d "$EXTRACTED_DIR/etc" ]; then
    echo "[*] Copying channels to system structure..."
    
    # دمج ونقل محتويات مجلد etc المرفوع مباشرة إلى مسار /etc في الرسيفر
    cp -rf "$EXTRACTED_DIR/etc/"* /etc/
    
    # 4. تنظيف وحذف المجلد المؤقت بالكامل
    echo "[*] Cleaning up temporary directory from tmp..."
    rm -rf "$TMP_HDD_DIR"
    
    # 5. التحديث الصامت لقائمة القنوات أمام عينك على الشاشة
    echo "[*] Reloading Enigma2 services & userbouquets..."
    wget -qO - "http://127.0.0.1/web/servicelistreload?mode=0" > /dev/null 2>&1
    wget -qO - "http://127.0.0.1/web/servicelistreload?mode=4" > /dev/null 2>&1
    
    echo "=================================================="
    echo "  🎉 Done! Channels updated and reloaded safely. "
    echo "=================================================="
else
    echo "[-] Error: Could not find 'etc' directory structure inside the repository."
    rm -rf "$TMP_HDD_DIR"
    exit 1
fi

