#!/usr/bin/env bash


WORKING_HERE="${PWD}"
ANDROID=false
WINDOWS=false
cd
cd ../..
if [ $(uname -a | grep -oci 'android') == 1 ] ; then
        ANDROID=true
        export ANDROID
        :
elif [ -f WinRing0x64.sys ]; then
        WINDOWS=true
        WIN_INSTALL_YES="Yes! I'm READY!! ^,^ "
        WIN_INSTALL_NO="Not yet! Thanks for the link! *.* "
        PS3="Have you installed Monero Ocean win64 from https://github.com/MoneroOcean/xmrig/releases yet? : "
        select WINSTALL in "${WINDOWS_INSTALL_YES}" "${WINDOWS_INSTALL_NO}"
        do
                case ${WINSTALL} in
                        ${WINDOWS_INSTALL_YES})
                        break
                        ;;
                        ${WINDOWS_INSTALL_NO})
                        echo "git clone ahoy into your Monero Ocean miner and run me again to quick config! ^.^ "
                        sleep 5s
                        exit
                        ;;
                esac
        done
        :
elif [ $(uname -a | grep -oci 'linux') == 1 && $(id -u) != 0 ]; then
        echo " "
        echo "You need to run as root.  \"sudo ./anchorsDown.sh\"."
        echo " "
        exit
fi
cd ${WORKING_HERE}

# name displayed on https://moneroocean.stream/
read -p "rig id to be displayed at https://moneroocean.stream/  : " RIG_NAME

# WALLET ADDRESS?
WALLET_ADDRESS=""
while [ ${#WALLET_ADDRESS} -ne 95 -o ${#WALLET_ADDRESS} -ne 106 ]; do
echo " "
echo "Get an XMR wallet from..."
echo "Monero at https://www.getmonero.org/ "
echo "CakeWallet app https://play.google.com/store/apps/dev?id=4613572273941486879 "
echo "Exodus app https://play.google.com/store/apps/details?id=exodusmovement.exodus "
echo " "
read -p "enter a Monero address: " WALLET_ADDRESS
if [ ${#WALLET_ADDRESS} == 95 -o ${#WALLET_ADDRESS} == 106 ]; then
break
else
continue
fi
done


#for readability
echo " "

# donation amount?
DEFAULT_DONATION="Default is 5%"
DONATION_SELECTION="Select amount 1-99%"
PS3="Donation % for developer : "
select DON in "${DEFAULT_DONATION}" "${DONATION_SELECTION}"
do
        case ${DON} in
                ${DEFAULT_DONATION})
                        DONATION_SELECTION="5"
                        echo " "
                        echo "..much appreciated!..dont forget to tell your friends!!  ^.^ "
                        sleep 2s
                        echo " "
                        break;;
                ${DONATION_SELECTION})
                        read -p "Choose single integer 1-99. My love for you increases with each % <3 : " DONATION_SELECTION
                        until [ ${DONATION_SELECTION} -gt 0 -a ${DONATION_SELECTION} -lt 100 ]; do
                        echo " "
                        echo "Choose single integer 1-99. My love for you increases with each % <3 : "
                        echo " "
                        read -p "Enter donation % for developer : " DONATION_SELECTION
                        done
                        break;;
                *) echo "..dont you feel like you have good enough choices already?..";;
        esac
done

#for readability
echo " "


function ANDROID_INSTALL(){
        pkg update -yf && pkg upgrade -yf && echo 'y' | pkg install wget git cmake clang libuv automake libtool autoconf
}

function UBUNTU_INSTALL(){
        apt update -y && apt upgrade -y && echo 'y' | apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
}

function CLOUD_INSTALL(){
        apt update -y && apt upgrade -y && echo 'y' | apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
}

function QUICK_FIG(){
cat << EOF > config.json
{
    "autosave": true,
    "cpu": true,
    "opencl": false,
    "cuda": false,
    "pools": [
        {
            "coin": null,
            "algo": null,
            "url": "gulf.moneroocean.stream:443",
            "user": "${WALLET_ADDRESS}%${DONATION_SELECTION}%49CFiXAfeT4H8NAoaNxVPW3GGYvou7SEBYHJmypV5GSB7D3BrCAPqgMQJ372WKbK79aRUwQdQke3932oWUgCproBLLEGQ5i",
            "pass": "${RIG_NAME}",
            "tls": true,
            "keepalive": true,
            "nicehash": false
        }
    ]
}
EOF

}


echo " "
echo "..checking OS and then installing dependencies THIS device needs...  #.#  "
echo " "
sleep 4s

# CHECK OS AND CD BACK TO WORKING DIRECTORY
if [ WINDOWS == true ]; then
QUICK_FIG && ./xmrig.exe
exit
fi
WORKING_HERE="${PWD}"
cd
cd ../..
if [ -d etc/ ]; then
cd ${WORKING_HERE} && UBUNTU_INSTALL
elif [ ANDROID=true ]; then
cd ${WORKING_HERE} && ANDROID_INSTALL
fi


echo " "
echo "Checking if Xmrig is installed, otherwise we will reconfig next time you run me!  ^.^ "
echo " "
sleep 4s
RIG="xmrig"
if [ -d xmrig/build ]
then echo "${RIG} is already here, so lets do a re-config!  ^.^ "
else git clone https://github.com/moneroocean/xmrig.git && mkdir xmrig/build
fi


# TODO create service without for cloud and root users
function SERV_IT(){
SERVICE_PATH=${PWD}/xmrig
cat << EOF > /lib/systemd/system/rig.service
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

function DROID_RIG_BOOT(){
cat << EOF > /data/data/com.termux/files/home/.termux/boot/bootRig.sh
!#/bin/bash
cd
./xmrig/build/xmrig
EOF

chmod +x /data/data/com.termux/files/home/.termux/boot/bootRig.sh
}

#for readability
echo " "

if [ ANDROID == true ]; then
PS3="Running your mobile rig as : "
DROID_RUN="Standard install and run."
DROID_RUN_AND_SERVICE="Install and run BUT with a service on next boot."
        select DROID_CHOICE in "${DROID_RUN}" "${DROID_RUN_AND_SERVICE}"
        do
                case ${DROID_CHOICE} in
                        ${DROID_RUN})
                                if [ ! -e xmrig/build/xmrig ]; then
                                cd xmrig/build && cmake .. -DWITH_HWLOC=OFF && make
                                else cd xmrig/build
                                fi
                                break
                                ;;
                        ${DROID_RUN_AND_SERVICE})
                                if [ ! -e /data/data/com.termux/files/home/.termux/boot/bootRig.sh ]; then
                                        DROID_RIG_BOOT
                                fi
                                echo " "
                                echo "Download Termux Boot at https://f-droid.org/packages/com.termux.boot/"
                                echo " "
                                sleep 4s
                                if [ ! -e xmrig/build/xmrig ]; then
                                cd xmrig/build && cmake .. -DWITH_HWLOC=OFF && make
                                else cd xmrig/build
                                fi
                                DROID_RIG_BOOT
                                ./xmrig
                                break
                                ;;
                        *)
                                echo " "
                                echo "...things are pretty good so far, but \"${REPLY}\" wont get us farther..."
                                echo " "
                esac
        done
        QUICK_FIG
        termux-wake-lock
        ./xmrig
        exit
fi

echo " "
CLOUD_CHOICE=""
PS3="Are you installing this on a Ubuntu cloud instance? : "
CLOUD_YES="Yes (theres free trials!)  *,*"
CLOUD_NO="...no...(you said free?)..."
select CLOUD in "${CLOUD_YES}" "${CLOUD_NO}"
do
        case ${CLOUD} in
                ${CLOUD_YES})
                        CLOUD_CHOICE=true
                        break
                        ;;
                ${CLOUD_NO})
                        CLOUD_CHOICE=false
                        break
                        ;;
                *)
                        echo "\"${REPLY}\" wasnt a choice lol"
        esac
done


#for readability
echo " "

PS3="Arr and such, how would you like to complete rigging: "
OPT1="RUN IT NOW!!!"
OPT2="Service, then a peek at its status."
# LINUX
# CLOUD -DWITH_HWLOC=OFF
select OPT in "${OPT1}" "${OPT2}"
do
        case ${OPT} in
                ${OPT1})
                        echo " "
                        echo "..but what about restarts and power-offs?.."
                        echo " "
                        sleep 1s
                        echo "You can always come back.."
                        sleep 2s
                        if [ ${CLOUD_CHOICE} == true ]; then
                                if [ ! -e xmrig/build/xmrig ]; then
                                        cd xmrig/build && cmake .. -DWITH_HWLOC=OFF && make
                                        else
                                        cd xmrig/build
                                fi
                        fi
                        if [ ! -e xmrig/build/xmrig ]; then
                                        cd xmrig/build && cmake .. && make
                                        else
                                        cd xmrig/build
                        fi
                        QUICK_FIG
                        ./xmrig
                        exit
                        ;;
                ${OPT2})
                        echo " "
                        echo "Good choice! Restarts and power offs suck.."
                        sleep 1s
                        if [ ${CLOUD_CHOICE} == true ]; then
                                if [ ! -e xmrig/build/xmrig ]; then
                                        cd xmrig/build && cmake .. -DWITH_HWLOC=OFF && make
                                        else
                                        cd xmrig/build
                                fi
                        fi
                        if [ ! -e xmrig/build/xmrig ]; then
                        cd xmrig/build && cmake .. && make
                        else
                        cd xmrig/build
                        fi
                        SERV_IT
                        QUICK_FIG
                        systemctl daemon-reload && systemctl start rig.service && systemctl enable rig.service && systemctl status rig.service
                        exit
                        ;;
                *)
                        echo " "
                        echo "..did I studder?.. =.= ...whats with the \"${REPLY}\"?..."
                        echo " "
                        ;;
        esac
done
