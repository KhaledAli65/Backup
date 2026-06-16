#!/bin/sh

# ==================== إعدادات الروابط والمسارات ====================
# الرابط المباشر لملف الـ ZIP الخاص بمستودعك من جيتهاب
ZIP_URL="https://github.com/KhaledAli65/picon/archive/refs/heads/main.zip"

# المسار المستهدف النهائي للبيكونات
TARGET_DIR="/media/hdd/picon"

# المسار المؤقت المؤمن بالكامل على الـ HDD لتفادي امتلاء الفلاشة أو الـ RAM
TMP_HDD_DIR="/media/hdd/.tmp_picons"
# ===================================================================

echo "=================================================="
echo "      Starting Picons Download & Extract (Safe Mode) "
echo "=================================================="

# 1. إنشاء المجلدات المستهدفة والمؤقتة على الـ HDD
mkdir -p "$TARGET_DIR"
mkdir -p "$TMP_HDD_DIR"

# 2. تحميل ملف الـ ZIP مباشرة إلى الـ HDD
echo "[*] Downloading Picons ZIP file directly to HDD..."
wget -q --no-check-certificate "$ZIP_URL" -O "$TMP_HDD_DIR/picon_master.zip"

if [ $? -ne 0 ]; then
    echo "[-] Download failed! Please check internet connection."
    rm -rf "$TMP_HDD_DIR"
    exit 1
fi

echo "[+] Download completed successfully."

# 3. فك الضغط داخل المجلد المؤقت على الـ HDD
echo "[*] Extracting files on HDD..."
unzip -q -o "$TMP_HDD_DIR/picon_master.zip" -d "$TMP_HDD_DIR/"

# التقاط اسم الفولدر الناتج تلقائياً (مثل picon-main)
EXTRACTED_DIR=$(ls -d "$TMP_HDD_DIR"/picon-*/ 2>/dev/null)

if [ -d "$EXTRACTED_DIR" ]; then
    # 4. نقل المحتويات إلى المجلد النهائي
    echo "[*] Moving Picons to target destination: $TARGET_DIR"
    cp -r "$EXTRACTED_DIR"* "$TARGET_DIR/"
    
    # 5. تنظيف وحذف المجلد المؤقت بالكامل من الـ HDD لعدم ترك مخلفات
    echo "[*] Cleaning up temporary directory from HDD..."
    rm -rf "$TMP_HDD_DIR"
    
    echo "=================================================="
    echo "  🎉 Done! Picons updated safely on HDD.        "
    echo "=================================================="
else
    echo "[-] Error: Could not find the extracted directory structure."
    rm -rf "$TMP_HDD_DIR"
    exit 1
fi

