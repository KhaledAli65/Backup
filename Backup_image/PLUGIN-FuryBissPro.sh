#!/bin/sh
# FuryBiss Installer Script
# Created by: Islam Salama

echo "Starting FuryBiss Installation..."
wget -q "--no-check-certificate" https://raw.githubusercontent.com/islam-2412/FuryBiss/refs/heads/main/fury/installer.sh -O - | /bin/sh

if [ $? -eq 0 ]; then
    echo "Installation command executed successfully."
else
    echo "Error: Installation failed. Check your internet connection."
fi

exit 0