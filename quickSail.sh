#!/bin/bash
echo " "
echo "run anchorsDown.sh again to reconfigure! ^.^ "
echo " "
sleep 2s
echo "...otherwise ARRRR hashrate BOOTY!..."
sleep 3s
if [ $ANDROID = true ]; then
termux-wake-lock
fi
./xmrig/build/xmrig
