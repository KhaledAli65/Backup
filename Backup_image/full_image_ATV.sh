#!/bin/sh
# MASTER ONLINE BACKUP & INSTALLATION SCRIPT (IMAGE SPECIFIC)
# Developed by KhaledAli65 - 2026
# Designed to block ALL types of restarts and fetch image-specific resources from GitHub

# ==================================================
# [قائمة الروابط] روابط GitHub الخام (Raw) الخاصة بك
# ==================================================
# 1. رابط ملف باكاب الإعدادات (AJPanel Settings)
URL_AJPANEL_BACKUP="https://raw.githubusercontent.com/KhaledAli65/Backup/main/Backup_image/backup.tar.gz"

# 2. روابط السكربتات الفرعية المتوافقة مع هذه الصورة
URL_SCRIPT_1="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/Cloud_More_Panel.sh"
URL_SCRIPT_2="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/EMU-ncam.sh"
URL_SCRIPT_3="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/EMU-oscam.sh"
URL_SCRIPT_4="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/Khaled_Uninstaller.sh"
URL_SCRIPT_5="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PANEL-Ajpanel.sh"
URL_SCRIPT_6="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Arabicsavior.sh"
URL_SCRIPT_7="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-AutoDcwKeyAdd.sh"
URL_SCRIPT_8="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-ClouringServer.sh"
URL_SCRIPT_9="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-E2BissKeyEditor.sh"
URL_SCRIPT_10="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Epggrabber.sh"
URL_SCRIPT_11="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Estalker.sh"
URL_SCRIPT_12="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Footonsat.sh"
URL_SCRIPT_13="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-FuryBissPro.sh"
URL_SCRIPT_14="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Ipaudio_nasr.sh"
URL_SCRIPT_15="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Iptosat.sh"
URL_SCRIPT_16="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-IptvAdder.sh"
URL_SCRIPT_17="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Jedimakerxtream.sh"
URL_SCRIPT_18="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Keyadder.sh"
URL_SCRIPT_19="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-MultiCamAdd.sh"
URL_SCRIPT_20="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-OrangeAudio.sh"
URL_SCRIPT_21="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Raedquicksignal.sh"
URL_SCRIPT_22="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Setpicon.sh"
URL_SCRIPT_23="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-SimplySports.sh"
URL_SCRIPT_24="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Supssupport.sh"
URL_SCRIPT_25="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-XKlass.sh"
URL_SCRIPT_26="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/TOOL-KhaledEpg.sh"
URL_SCRIPT_27="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/TOOL-Khaled_Channels_fullsat.sh"
URL_SCRIPT_28="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/install_khaled_manager.sh"
URL_SCRIPT_29="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-XmlSatellitesUpdates.sh"
URL_SCRIPT_30="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Xstreamity.sh"
URL_SCRIPT_31="https://raw.githubusercontent.com/KhaledAli65/Backup/refs/heads/main/Backup_image/PLUGIN-Youtube.sh"
# ==================================================

TMP_DIR="/tmp/master_online"
mkdir -p "$TMP_DIR"

echo "=================================================="
echo " Starting Dedicated Installation & Restore Process"
echo "=================================================="

# --------------------------------------------------
# جدار الحماية: حظر أوامر الريستارت وقتل الواجهة على مستوى النظام
# --------------------------------------------------
echo "[INFO] Intercepting reboot and killall commands..."

if [ -f /usr/bin/killall ]; then
    mv /usr/bin/killall /usr/bin/killall.real
    echo '#!/bin/sh
    if echo "$*" | grep -q "enigma2"; then
        echo "[PROTECTION] Blocked killall for enigma2"
    else
        /usr/bin/killall.real "$@"
    fi' > /usr/bin/killall
    chmod +x /usr/bin/killall
fi

if [ -f /sbin/init ]; then
    mv /sbin/init /sbin/init.real
    echo '#!/bin/sh
    if [ "$1" = "3" ] || [ "$1" = "4" ] || [ "$1" = "6" ]; then
        echo "[PROTECTION] Blocked init $1"
    else
        /sbin/init.real "$@"
    fi' > /sbin/init
    chmod +x /sbin/init
fi

if [ -f /sbin/reboot ]; then
    mv /sbin/reboot /sbin/reboot.real
    echo '#!/bin/sh
    echo "[PROTECTION] Blocked reboot command"' > /sbin/reboot
    chmod +x /sbin/reboot
fi

restore_system_commands() {
    echo "----------------------------------------"
    echo "[INFO] Restoring original system commands..."
    echo "----------------------------------------"
    [ -f /usr/bin/killall.real ] && mv -f /usr/bin/killall.real /usr/bin/killall
    [ -f /sbin/init.real ] && mv -f /sbin/init.real /sbin/init
    [ -f /sbin/reboot.real ] && mv -f /sbin/reboot.real /sbin/reboot
    rm -rf "$TMP_DIR"
}

trap restore_system_commands EXIT INT TERM

# دالة التحميل
download_file() {
    local url="$1"
    local output="$2"
    if command -v wget >/dev/null 2>&1; then
        wget --no-check-certificate -q -O "$output" "$url"
    elif command -v curl >/dev/null 2>&1; then
        curl -s -k -L -o "$output" "$url"
    else
        echo "[ERROR] Neither wget nor curl found!"
        return 1
    fi
}

# --------------------------------------------------
# الخطوة الأولى: استعادة إعدادات AJPanel المحددة مسبقاً
# --------------------------------------------------
echo "--> [1/2] Downloading AJPanel settings backup from GitHub..."
AJPANEL_LOCAL_TAR="$TMP_DIR/backup.tar.gz"

if download_file "$URL_AJPANEL_BACKUP" "$AJPANEL_LOCAL_TAR" && [ -s "$AJPANEL_LOCAL_TAR" ]; then
    echo "[INFO] Restoring AJPanel settings backup..."
    tar -xzf "$AJPANEL_LOCAL_TAR" -C /
    echo "[SUCCESS] AJPanel backup extracted."
else
    echo "[WARNING] Failed to download AJPanel backup file from GitHub or URL is invalid."
    echo "[INFO] Proceeding with plugin installation only..."
fi

sleep 2

# --------------------------------------------------
# الخطوة الثانية: تحميل وتشغيل اسكريبتات الإضافات تتابعياً (ديناميكي)
# --------------------------------------------------
echo "--> [2/2] Downloading and executing installation scripts sequentially..."

# جلب كافة المتغيرات المبدؤة بـ URL_SCRIPT_ وترتيبها رقمياً لتنفيذها بالتتابع
# هذه الطريقة تضمن تشغيل كل السكريبتات الـ 31 تلقائياً دون الحاجة لكتابة اسمائها هنا يدويًا
for script_var in $(set | grep '^URL_SCRIPT_' | sort -V | cut -d'=' -f1); do
    eval script_url=\$$script_var
    [ -z "$script_url" ] && continue
    
    local_script_name=$(basename "$script_url")
    local_script_path="$TMP_DIR/$local_script_name"
    
    echo "----------------------------------------"
    echo "[DOWNLOADING] Fetching $script_var: $local_script_name"
    echo "----------------------------------------"
    
    if download_file "$script_url" "$local_script_path" && [ -s "$local_script_path" ]; then
        echo "[RUNNING] Executing: $local_script_name"
        chmod +x "$local_script_path"
        sh "$local_script_path"
        
        echo "[WAIT] Short pause to ensure stability..."
        sleep 3
    else
        echo "[ERROR] Failed to download script: $local_script_name"
    fi
done

echo "=================================================="
echo " All Installations Completed Successfully! "
echo "=================================================="

restore_system_commands
trap - EXIT INT TERM

# --------------------------------------------------
# الخطوة الأخيرة: ريستارت نظيف وآمن للـ GUI لتطبيق التغييرات
# --------------------------------------------------
echo "[FINAL] Restarting Enigma2 GUI to apply all changes..."
sleep 2
killall -9 enigma2

exit 0

