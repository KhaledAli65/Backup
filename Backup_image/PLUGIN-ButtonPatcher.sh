#!/bin/sh

# wget -qO - https://raw.githubusercontent.com/popking159/buttonpatcher/refs/heads/main/myinstaller.sh | /bin/sh
# =========================================================================
# CONFIGURATION (Change these for different repositories)
# =========================================================================
PLUGIN_NAME="Button Patcher"
USERNAME="popking159"
REPO="buttonpatcher"

# Dependencies are empty as buttonpatcher does not require any
PY_DEPENDS=""
SYS_DEPENDS=""
# =========================================================================

# Workspace paths
TMP_DIR="/var/volatile/tmp"
[ -d "$TMP_DIR" ] || TMP_DIR="/tmp"
TMP_FILE="$TMP_DIR/main_install.tar.gz"

PKG_MANAGER=""
PYTHON_BIN="python"
PY_VER_SUFFIX=""
FINAL_DEPENDS=""

log() {
    echo "$1"
}

has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

is_pkg_installed() {
    pkg="$1"
    if [ "$PKG_MANAGER" = "opkg" ]; then
        if [ -f /var/lib/opkg/status ]; then
            grep -q "^Package: $pkg$" /var/lib/opkg/status && return 0
        fi
        opkg list-installed 2>/dev/null | grep -q "^$pkg[[:space:]-]" && return 0
        return 1
    fi

    if [ "$PKG_MANAGER" = "apt" ]; then
        dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed" && return 0
        return 1
    fi
    return 1
}

restart_enigma2() {
    log "[INFO] Restarting Enigma2 UI..."
    sleep 2
    if [ -f /usr/bin/systemctl ]; then
        systemctl restart enigma2
    else
        init 4 && sleep 2 && init 3 || killall -9 enigma2 >/dev/null 2>&1
    fi
}

echo "===================================================="
echo "         $PLUGIN_NAME INSTALLER UTILITY            "
echo "===================================================="

# 1. Detect Package Manager Environment
if has_cmd opkg; then
    PKG_MANAGER="opkg"
elif has_cmd apt-get; then
    PKG_MANAGER="apt"
fi
log "[INFO] Package manager detected: ${PKG_MANAGER:-None}"

# 2. Detect Exact Python Version (e.g., extracts '313' from 3.13.x)
if has_cmd python3; then
    PYTHON_BIN="python3"
    PY_PREFIX="python3-"
    PY_VER_SUFFIX=$($PYTHON_BIN -c "import sys; print('%d%d' % (sys.version_info.major, sys.version_info.minor))")
elif has_cmd python; then
    PYTHON_BIN="python"
    PY_PREFIX="python-"
    PY_VER_SUFFIX=$($PYTHON_BIN -c "import sys; print('%d%d' % (sys.version_info.major, sys.version_info.minor))")
fi
log "[INFO] Detected Python Version Suffix: $PY_VER_SUFFIX"

# 3. Dynamically Construct URL based on detected Python Version
PLUGIN_URL="https://github.com/${USERNAME}/${REPO}/raw/refs/heads/main/main_${PY_VER_SUFFIX}.tar.gz"

# 4. Build the Final Dependency List
for dep in $PY_DEPENDS; do
    FINAL_DEPENDS="$FINAL_DEPENDS ${PY_PREFIX}${dep}"
done
for dep in $SYS_DEPENDS; do
    FINAL_DEPENDS="$FINAL_DEPENDS $dep"
done

# 5. Update Package Feeds (Skipped if no dependencies)
if [ -n "$FINAL_DEPENDS" ] && [ -n "$PKG_MANAGER" ]; then
    if [ "$PKG_MANAGER" = "opkg" ]; then
        log "[INFO] Updating opkg feeds..."
        opkg update >/dev/null 2>&1 || log "[WARN] opkg update failed, continuing..."
    elif [ "$PKG_MANAGER" = "apt" ]; then
        log "[INFO] Updating apt feeds..."
        apt-get update >/dev/null 2>&1 || log "[WARN] apt update failed, continuing..."
    fi
fi

# 6. Check and Download Dependencies
if [ -n "$FINAL_DEPENDS" ]; then
    log "[INFO] Verifying required dependencies..."
    for pkg in $FINAL_DEPENDS; do
        if is_pkg_installed "$pkg"; then
            log "[OK] Already installed: $pkg"
        else
            log "[INFO] Downloading and installing: $pkg"
            if [ "$PKG_MANAGER" = "opkg" ]; then
                opkg install "$pkg" >/dev/null 2>&1
            elif [ "$PKG_MANAGER" = "apt" ]; then
                DEBIAN_FRONTEND=noninteractive apt-get install -y "$pkg" >/dev/null 2>&1
            fi
            
            if is_pkg_installed "$pkg"; then
                log "[OK] Successfully installed: $pkg"
            else
                log "[ERROR] Required dependency '$pkg' could not be installed! Aborting setup."
                exit 1
            fi
        fi
    done
else
    log "[INFO] No dependencies specified in configuration. Skipping dependency phase."
fi

# 7. Download Version-Specific Plugin Archive
log "[INFO] Fetching target archive: main_${PY_VER_SUFFIX}.tar.gz"
rm -f "$TMP_FILE"
wget -q --no-check-certificate "$PLUGIN_URL" -O "$TMP_FILE"

if [ ! -s "$TMP_FILE" ]; then
    log "[ERROR] Download failed! Archive 'main_${PY_VER_SUFFIX}.tar.gz' does not exist on the repository for this Python version."
    rm -f "$TMP_FILE"
    exit 1
fi

# 8. Extract directly to ROOT (/)
log "[INFO] Extracting payload contents to system paths..."
tar -xzf "$TMP_FILE" -C /
if [ $? -ne 0 ]; then
    log "[ERROR] Extraction failed!"
    rm -f "$TMP_FILE"
    exit 1
fi

rm -f "$TMP_FILE"
sync

echo "===================================================="
echo "          $PLUGIN_NAME INSTALLATION COMPLETE        "
echo "===================================================="

restart_enigma2
exit 0
