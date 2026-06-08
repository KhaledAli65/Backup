#!/bin/sh
# --- KHALED TOOLS SYSTEM ---
# Channel List Auto-Updater

URL="https://github.com/KhaledAli65/novaler/raw/refs/heads/main/khaled_fullsat.tar.gz"
BACKUP_DIR="/media/hdd/channels_backup"
TMP_FILE="/tmp/khaled_fullsat.tar.gz"

echo ">>> Starting Channel Update..."

# 1. Mount Check
if [ ! -d "/media/hdd" ]; then
    echo "ERROR: HDD not found. Cannot create backup!"
    exit 1
fi

# 2. Safety Backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
echo ">>> Backing up current settings to $BACKUP_DIR..."
tar -czf $BACKUP_DIR/channels_before_$TIMESTAMP.tar.gz /etc/enigma2/*.tv /etc/enigma2/*.radio /etc/enigma2/lamedb

# 3. Download
echo ">>> Downloading latest channel list..."
wget -q $URL -O $TMP_FILE
if [ ! -s $TMP_FILE ]; then
    echo "ERROR: Download failed!"
    exit 1
fi

# 4. Clean Installation
echo ">>> Refreshing system files..."
# Use init 4 to stop Enigma2 safely if deep modification is needed, 
# but for simple tar extraction to /etc/enigma2, we can just extract and then reload.
tar -xzf $TMP_FILE -C /

# 5. Reload Settings (Essential for Enigma2 to see new channels without reboot)
wget -qO - http://127.0.0.1/web/servicelistreload?mode=0 > /dev/null 2>&1
wget -qO - http://127.0.0.1/web/servicelistreload?mode=1 > /dev/null 2>&1

echo "------------------------------------------"
echo "   Channels Updated Successfully!        "
echo "------------------------------------------"
rm -f $TMP_FILE
exit 0

