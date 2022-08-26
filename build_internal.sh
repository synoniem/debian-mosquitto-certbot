#!/bin/sh
# Build script for s6-overlay with processor architecture detection
apkArch=`dpkg --print-architecture`
if [ $apkArch = "arm64" ]
then
    apkArch="aarch64"
fi
if [ $apkArch = "armel" ]
then
    apkArch="armhf"
fi
if [ $apkArch = "i386" ]
then
    apkArch="x86"
fi

mkdir /root/tmp
wget https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-$apkArch-installer -P /root/tmp
chmod +x /root/tmp/s6-overlay-$apkArch-installer && /root/tmp/s6-overlay-$apkArch-installer / 
rm /root/tmp/s6-overlay-$apkArch-installer
