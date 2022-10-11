#!/usr/bin/env bash
echo "Scope your rigs status at https://moneroocean.stream"
echo " "
sleep 5s
echo "run anchorsDown.sh again to reconfigure! ^.^ "
echo " "
sleep 4s
echo "...otherwise ARRRR hashrate BOOTY!..."
sleep 3s
if [ $ANDROID = true ]; then
termux-wake-lock
fi
./xmrig/build/xmrig
