# ahoy

If your low cpu device crashes after the miner starts you might have to swap to a dingy https://github.com/K3NW48/dingy

## Get a Monero (XMR) wallet address at either of these..

Monero at https://www.getmonero.org/ 

CakeWallet app https://play.google.com/store/apps/dev?id=4613572273941486879 

Exodus app https://play.google.com/store/apps/details?id=exodusmovement.exodus


## Windows

Windows users will want to download and extract the Monero Ocean miner https://github.com/MoneroOcean/xmrig/releases

Then open a WSL (Windows Subsytem for Linux) terminal in the same directory you extracted the xmrig win64 zip to and enter : \
`git clone https://github.com/K3NW48/ahoy.git && ./ahoy/anchorsDown.sh`

## Linux and Android Termux

Should be ran in the $HOME directory for Linux and Termux. Windows users will be fine.
Detects OS of Android, Linux, or Windows and installs individual dependencies automagically.

Android users will want Termux from FDroid https://f-droid.org/en/packages/com.termux/

Termux Github suggests that fdroid is used if you want to keep it working with fdroid termux extensions, like Termux Boot and Termux Tasker.

Heres is a quick tutorial on install, setup, starting and stopping on Android Termux.
https://youtu.be/x99l71_iG4I
