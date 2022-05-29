#!/bin/bash

read -p "rig id : " RIG_NAME
WRAP="${RIG_NAME}"

sudo apt update -y && sudo apt upgrade -y && sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev tmux tor

RIG="xmrig"
if [ -d xmrig/build ]
then echo "${RIG} is already here but maybe an update here and there?... -\(-,-)/-  "
else sudo git clone https://github.com/xmrig/xmrig.git && sudo mkdir xmrig/build
fi

function QUICK_FIG(){
sudo cat << EOF > config.json
{
    "autosave": true,
    "cpu": true,
    "opencl": false,
    "cuda": false,
    "pools": [
        {
            "url": "pool.supportxmr.com:443",
            "user": "49CFiXAfeT4H8NAoaNxVPW3GGYvou7SEBYHJmypV5GSB7D3BrCAPqgMQJ372WKbK79aRUwQdQke3932oWUgCproBLLEGQ5i",
            "pass": "${WRAP}",
            "keepalive": true,
            "tls": true
        }
    ]
}
EOF

}

function SERV_IT(){
SERVICE_PATH=${PWD}/xmrig
sudo cat << EOF > /lib/systemd/system/rig.service
[Unit]
Description=rig
[Service]
User=root
Group=root
ExecStart=${SERVICE_PATH}
Restart=always
[Install]
WantedBy=multi-user.target
EOF

}
PS3="How would you like to complete rigging: "

OPT1="RUN IT NOW!!!"
OPT2="...a little service and then a peek, please."

select OPT in "${OPT1}" "${OPT2}"
do
        case ${OPT} in
                ${OPT1})
                        echo " "
                        echo "..but what about restarts and power-offs?.."
                        echo " "
                        sleep 1s
                        echo "You can always come back.."
                        sleep 1s
                        if [ ! -e xmrig/build/xmrig ]
                        then cd xmrig/build && sudo cmake .. && sudo make
                        else  cd xmrig/build
                        fi
                        QUICK_FIG
                        ./xmrig
                        exit
                        ;;
                ${OPT2})
                        echo " "
                        echo "Good choice! Restarts and power offs suck.."
                        sleep 1s
                        if [ ! -e xmrig/build/xmrig ]
                        then cd xmrig/build && sudo cmake .. && sudo make
                        else cd xmrig/build && SERV_IT
                        fi
                        QUICK_FIG
                        sudo systemctl daemon-reload && sudo systemctl start rig.service && sudo systemctl enable rig.service && sudo systemctl status rig.service
                        exit
                        ;;
                *) echo "..did I studder?.. -.- ...whats with the \"$REPLY\"?...";;
        esac
done
