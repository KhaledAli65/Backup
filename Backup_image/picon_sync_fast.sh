#!/bin/sh

# ==================== إعدادات Cloud & More ====================
# المسار المستهدف النهائي للبيكونات على الـ HDD
LOCAL_PICON="/media/hdd/picon"

# المسار الافتراضي للنظام للربط الرمزي (Symlink)
LINK_TARGET="/usr/share/enigma2/picon"

# رابط الـ Release المباشر لملف tar.gz
ARCHIVE_URL="https://github.com/KhaledAli65/books/releases/download/Picon/picon.tar.gz"

# المجلد المؤقت الآمن على الـ HDD لفك الضغط
TMP_EXTRACT_DIR="/media/hdd/.tmp_picon_extract"
# ==============================================================

echo "********************************************"
echo "*    Picon Sync Tool by Cloud & More       *"
echo "********************************************"

# 1. التنظيف الشامل للمجلدات القديمة والمؤقتة
echo ">> جاري تنظيف المجلدات القديمة والمؤقتة..."
rm -rf "$LOCAL_PICON"
rm -rf "$TMP_EXTRACT_DIR"

mkdir -p "$LOCAL_PICON"
mkdir -p "$TMP_EXTRACT_DIR"

# 2. التنزيل وفك الضغط داخل المجلد المؤقت على الـ HDD
echo ">> جاري تحميل وحل حزمة البيكونات (tar.gz)..."
wget --show-progress --no-check-certificate --timeout=15 -qO- "$ARCHIVE_URL" | tar -xz -C "$TMP_EXTRACT_DIR/"

if [ $? -ne 0 ]; then
    echo "[-] خطأ: فشل التحميل أو الأرشيف تالف! يرجى التحقق من الاتصال بالإنترنت."
    rm -rf "$TMP_EXTRACT_DIR"
    exit 1
fi

# 3. نقل كل ملفات الـ PNG مباشرة لتسطيح الهيكل الشجري وتفادي المسارات المتداخلة
echo ">> جاري تجميع ونقل صور البيكونات إلى المسار النهائي..."
find "$TMP_EXTRACT_DIR" -type f -iname "*.png" -exec mv -f {} "$LOCAL_PICON/" \;

# تنظيف المجلد المؤقت بالكامل
rm -rf "$TMP_EXTRACT_DIR"

# 4. إنشاء/التحقق من الربط الرمزي (Symlink) مع الفلاشة الداخلية
echo ">> جاري التحقق من الربط الرمزي (Symlink)..."
if [ ! -L "$LINK_TARGET" ]; then
    rm -rf "$LINK_TARGET"
    ln -s "$LOCAL_PICON" "$LINK_TARGET"
    echo ">> تم إنشاء Symlink بنجاح: $LINK_TARGET -> $LOCAL_PICON"
fi

# 5. إنهاء العملية وإعادة تشغيل الواجهة
echo "=================================================="
echo ">> تمت عملية التحديث بنجاح بواسطة Cloud & More!"
echo ">> جاري إعادة تشغيل الواجهة (Enigma2) لتفعيل البيكونات..."
echo "=================================================="
sleep 2
killall -9 enigma2

