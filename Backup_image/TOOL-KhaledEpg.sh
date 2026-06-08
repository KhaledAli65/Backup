#!/bin/sh
# --- KHALED TOOLS SYSTEM ---
# EPG Update Script

# 1. Configuration
URL="https://github.com/KhaledAli65/novaler/raw/main/epg.tar.gz"
EPG_TMP="/tmp/epg.tar.gz"

echo ">>> Starting EPG Update..."

# 2. Cleanup old temporary files
rm -f /tmp/*.tar.gz

# 3. Download with progress check
echo ">>> Downloading EPG data..."
wget -O "$EPG_TMP" "$URL"

if [ $? -ne 0 ]; then
    echo "ERROR: Download failed! Please check your internet connection."
    exit 1
fi

# 4. Extraction
echo ">>> Extracting EPG files to system..."
# We use -C / because your original script targets the root directory
tar -xzf "$EPG_TMP" -C /

if [ $? -eq 0 ]; then
    echo "------------------------------------------"
    echo "   EPG Updated Successfully!             "
    echo "------------------------------------------"
else
    echo "ERROR: Extraction failed. The file might be corrupted."
    rm -f "$EPG_TMP"
    exit 1
fi

# 5. Final Cleanup
rm -f "$EPG_TMP"

exit 0

