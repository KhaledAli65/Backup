#!/bin/sh
# --- KHALED ALI MANAGER INSTALLER ---
# Target: /usr/lib/enigma2/python/Plugins/Extensions/

URL="https://github.com/KhaledAli65/plugins/raw/refs/heads/main/khaledManager.tar.gz"
TMP_DIR="/tmp/khaled_install"
EXT_PATH="/usr/lib/enigma2/python/Plugins/Extensions"

echo ">>> Starting Khaled Ali MANAGER Installation..."

# 1. Create temporary directory
mkdir -p $TMP_DIR
cd $TMP_DIR

# 2. Download the package
echo ">>> Downloading package from GitHub..."
wget -q $URL -O khaledManager.tar.gz

if [ ! -s khaledManager.tar.gz ]; then
    echo "ERROR: Download failed! Please check your internet connection."
    rm -rf $TMP_DIR
    exit 1
fi

# 3. Extract to the Extensions folder
echo ">>> Extracting files to $EXT_PATH..."
tar -xzf khaledManager.tar.gz -C $EXT_PATH

if [ $? -eq 0 ]; then
    echo ">>> Setting file permissions (755)..."
    # Adjust the folder name below if it differs from 'KhaledProManager'
    chmod -R 755 $EXT_PATH/KhaledAliPanel
    
    echo "------------------------------------------------"
    echo "   INSTALLATION COMPLETED SUCCESSFULLY!        "
    echo "   Please restart Enigma2 to see the panel.     "
    echo "------------------------------------------------"
else
    echo "ERROR: Extraction failed. The package might be corrupted."
    rm -rf $TMP_DIR
    exit 1
fi

# 4. Final Cleanup
rm -rf $TMP_DIR

reboot

exit 0
