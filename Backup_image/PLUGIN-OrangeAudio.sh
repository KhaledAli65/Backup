#!/bin/sh
# OrangeAudio Plugin Installer
# Version: 1.3
# Author: MNASR

echo "Starting installation..."

sleep 3

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/OrangeAudio ]; then
    echo "> Removing previous installation..."
    rm -rf /usr/lib/enigma2/python/Plugins/Extensions/OrangeAudio
fi

status_file='/var/lib/opkg/status'
package_name='enigma2-plugin-extensions-orangeaudio'

if [ -f "$status_file" ] && grep -q "$package_name" "$status_file"; then
    echo "> Removing old opkg package..."
    opkg remove "$package_name"
fi

sleep 2

echo "> Downloading OrangeAudio..."
wget -q -O /tmp/OrangeAudio.tar.gz "https://github.com/popking159/OrangeAudio/raw/refs/heads/main/OrangeAudio.tar.gz"

if [ $? -ne 0 ]; then
    echo "ERROR: Download failed!"
    exit 1
fi

echo "> Installing..."
tar -xzf /tmp/OrangeAudio.tar.gz -C /
if [ $? -ne 0 ]; then
    echo "ERROR: Extraction failed!"
    exit 1
fi

rm -f /tmp/OrangeAudio.tar.gz
sleep 2

sync
echo "========================================================="
echo "===                      FINISHED                     ==="
echo "===                       MNASR                       ==="
echo "========================================================="
echo "       Orange Audio installed successfully!              "
echo "========================================================="

exit 0
