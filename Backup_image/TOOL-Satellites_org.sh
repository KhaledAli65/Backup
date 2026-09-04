#!/bin/sh
# --- KHALED TOOLS SYSTEM ---
# Satellites.xml (Transponder) Updater

URL="https://raw.githubusercontent.com/OpenPLi/tuxbox-xml/refs/heads/master/xml/satellites.xml"
DEST="/etc/tuxbox/satellites.xml"

echo ">>> Updating Satellite Transponders..."

# 1. Backup current file
if [ -f $DEST ]; then
    cp $DEST $DEST.bak
    echo ">>> Current satellites.xml backed up to .bak"
fi

# 2. Download and Replace
echo ">>> Fetching latest data from OE-Alliance..."
wget -q $URL -O $DEST.new

if [ -s $DEST.new ]; then
    mv $DEST.new $DEST
    chmod 644 $DEST
    echo "------------------------------------------"
    echo "   Satellite Data Updated!               "
    echo "------------------------------------------"
else
    echo "ERROR: Update failed. Restoring backup..."
    [ -f $DEST.bak ] && cp $DEST.bak $DEST
    rm -f $DEST.new
    exit 1
fi

exit 0

