wget -O /tmp/youchie.ipk "https://github.com/KhaledAli65/skins/raw/refs/heads/main/Youchie.ipk"

wait

opkg install --force-overwrite /tmp/*.ipk

wait



rm -r /tmp/youchie.ipk

exit


