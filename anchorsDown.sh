#!/bin/bash


# RUNNING WINDOWS??
# DOCKER STUFF

#change to home directory
echo "Installing to Home Directory..."
sleep 2s
cd

# name displayed on https://moneroocean.stream/
read -p "rig id to be displayed at https://moneroocean.stream/  : " RIG_NAME

# WALLET ADDRESS?
read -p "Enter your wallet address: " WALLET_ADDRESS
while [ ${#WALLET_ADDRESS} -ne 95 -o ${#WALLET_ADDRESS} -ne 106 ]
do
        echo "...something isnt right, its a very specific length...you should try again.."
        read -p "Enter your wallet address: " WALLET_ADDRESS
        
done

#for readability
echo " "

# donation amount?
DEFAULT_DONATION="5"
DONATION_SELECTION="Select amount 1-99"
PS3="Enter donation % to developer(default 5%) : "
select DON in "${DEFAULT_DONATION}" "${DONATION_SELECTION}"
do
        case ${DON} in
                ${DEFAULT_DONATION})
                        DONATION_SELECTION="${DEFAULT_DONATION}"
                        echo " "
                        echo "..much appreciated!..dont forget to tell your friends!!  ^.^ "
                        sleep 2s
                        echo " "
                        break;;
                ${DONATION_SELECTION})
                        read -p "Enter donation % for developer : " DONATION_CHOICE
                        while [ ${DONATION_CHOICE} -lt 0 ] && [ ${DONATION_CHOICE} -gt 99 ]
                        do
                                echo "...its any number 1-99..my love for you increases each % <3 "
                                read -p "Enter donation % for developer : " DONATION_CHOICE
                                if [ ${DONATION_CHOICE} -gt 0 ] && [ ${DONATION_CHOICE} -lt 100 ]
                                then
                                        echo " "
                                        echo "DONT FORGET TO TELL YOUR FRIENDS!! ^o^ "
                                        echo " "
                                        sleep 2s
                                        break
                                else    
                                        continue
                                fi
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
                *) echo "..look...if you want to do this you get four options...\"${REPLY}\" doesnt make sense..." ;;
        esac
done

function ANDROID_INSTALL(){
        pkg update -y && pkg upgrade -y && pkg install -y wget git cmake clang libuv automake libtool autoconf
}
function UBUNTU_INSTALL(){
        sudo apt update -y && sudo apt upgrade -y && sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
}


echo " "
echo "..checking OS and then installing dependencies THIS device needs...  #.#  "
echo " "
sleep 3s
# CHECK OS AND CD BACK TO HOME
cd ../..
if [ -d etc/ ]; then
cd && UBUNTU_INSTALL
elif [ -d files/ ]; then
cd && ANDROID_INSTALL
ANDROID=true
elif [ ! -d etc/ ] && [ ! -d files/ ]; then
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
    "autosave": false,
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


if [ ANDROID = true ]; then
cd xmrig/build && cmake .. -DWITH_HWLOC=OFF && make
QUICK_FIG
./xmrig
exit
else
continue
fi


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
                        if [ ! -e xmrig/build/xmrig ]
                        then mkdir xmrig/build && cd xmrig/build && cmake .. && make
                        else cd xmrig/build
                        fi
                        QUICK_FIG
                        ./xmrig
                        break
                        ;;
                ${OPT2})
                        echo " "
                        echo "Good choice! Restarts and power offs suck.."
                        sleep 1s
                        if [ ! -e xmrig/build/xmrig ]
                        then mkdir xmrig/build && cd xmrig/build && cmake .. && make
                        else cd xmrig/build && SERV_IT
                        fi
                        QUICK_FIG
                        systemctl daemon-reload && systemctl start rig.service && systemctl enable rig.service && systemctl status rig.service
                        break
                        ;;
                *) echo "..did I studder?.. =.= ...whats with the \"${REPLY}\"?..." ;;
        esac
done
