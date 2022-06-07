#!/bin/bash


# RUNNING WINDOWS??
# DOCKER STUFF

#change to home directory
echo " "
echo "Installing to Home Directory..."
echo " "
cd

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

# CPU usage?
CPU_USE="75"
PS3="What percent CPU use would you like?(default is 75) : "
select CPU in "25%" "50%" "75%" "100%"
do
        case ${CPU} in
                25%)
                        CPU_USE="25"
                        break;;
                50%)
                        CPU_USE="50"
                        break;;
                75%)
                        CPU_USE="75"
                        break;;
                100%)
                        CPU_USE="100" 
                        break;;
                *) 
                        echo " "
                        echo "..look...if you want to do this you get four options...\"${REPLY}\" doesnt make sense..."
                        echo " "
                        ;;
        esac
done

function ANDROID_INSTALL(){
        pkg update -y && pkg upgrade -y && pkg install -y wget git cmake clang libuv automake libtool autoconf
}

function UBUNTU_INSTALL(){
        sudo apt update -y && sudo apt upgrade -y && sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
}

function CLOUD_INSTALL(){
        apt update -y && apt upgrade -y && apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
}


echo " "
echo "..checking OS and then installing dependencies THIS device needs...  #.#  "
echo " "
sleep 2s
# CHECK OS AND CD BACK TO HOME
cd ../..
ANDROID=false
if [ -d etc/ ]; then
cd && UBUNTU_INSTALL
elif [ -d files/ ]; then
cd && ANDROID_INSTALL
ANDROID=true
elif [ ! -d etc/ -a ! -d files/ ]; then
docker run --rm -it ubuntu && UBUNTU_INSTALL
else
echo "You need to install Docker Desktop at https://docs.docker.com/desktop/windows/install/ if you're a Windows user.."
echo " "
echo "...then go here https://docs.microsoft.com/en-us/windows/wsl/install and install Windows Subsystem for Linux."
echo " "
echo "Come back and try again after installing Docker Desktop and WSL"
exit
fi



echo " "
echo "Checking if Xmrig is installed, otherwise we will reconfig next time you run me!  ^.^ "
echo " "
sleep 3s
RIG="xmrig"
if [ -d xmrig/build ]
then echo "${RIG} is already here, so lets do a re-config!  ^.^ "
else git clone https://github.com/moneroocean/xmrig.git && mkdir xmrig/build
fi


function QUICK_FIG(){
cat << EOF > config.json
{
    "autosave": true,
    "cpu": {
            "max-threads-hint": ${CPU_USE},
            },
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
echo "Download Termux Boot at https://f-droid.org/packages/com.termux.boot/"
}

#for readability
echo " "

if [ ${ANDROID} = true ]; then
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
                                if [ ! -e xmrig/build/xmrig ]; then
                                cd xmrig/build && cmake .. -DWITH_HWLOC=OFF && make
                                else cd xmrig/build
                                fi
                                DROID_RIG_BOOT
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

#for readability
echo " "

PS3="Are you installing this on a Ubuntu cloud instance? : "
CLOUD_YES="Yes (theres free trials!)  *,*"
CLOUD_NO="...no...(you said free?)..."
select CLOUD in "${CLOUD_YES}" "${CLOUD_NO}"
do
        case ${CLOUD} in
                ${CLOUD_YES})
                        CLOUD_CHOICE="yes"
                        break
                        ;;
                ${CLOUD_NO})
                        CLOUD_CHOICE="no"
                        break
                        ;;
                *)
                        echo "\"${REPLY}\" wasnt a choice lol"
        esac
done


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
                        case ${CLOUD_CHOICE} in
                                yes)
                                        if [ ! -e xmrig/build/xmrig ]; then
                                        cd xmrig/build && cmake .. -DWITH_HWLOC=OFF && make
                                        else
                                        cd xmrig/build
                                        fi
                                        break
                                        ;;
                                no)
                                        if [ ! -e xmrig/build/xmrig ]; then
                                        cd xmrig/build && cmake .. && make
                                        else
                                        cd xmrig/build
                                        fi
                                        break
                                        ;;
                        esac
                        QUICK_FIG
                        ./xmrig
                        exit
                        ;;
                ${OPT2})
                        echo " "
                        echo "Good choice! Restarts and power offs suck.."
                        sleep 1s
                        if [ ! -e xmrig/build/xmrig ]; then
                        cd xmrig/build && cmake .. && make
                        else
                        cd xmrig/build
                        fi
                        SERV_IT
                        QUICK_FIG
                        sudo systemctl daemon-reload && sudo systemctl start rig.service && sudo systemctl enable rig.service && sudo systemctl status rig.service
                        exit
                        ;;
                *)
                        echo " "
                        echo "..did I studder?.. =.= ...whats with the \"${REPLY}\"?..."
                        echo " "
                        ;;
        esac
done
