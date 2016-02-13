# CamCorder-Buildroot

This is a [buildroot](https://buildroot.org) project creating a bootable SD card Image for the Olimex [iMX233-OLinuXino-Micro](https://www.olimex.com/Products/OLinuXino/iMX233/iMX233-OLinuXino-MICRO/open-source-hardware) (and all other boards of this series).

U-Boot is used instead of the MXS-Bootlets to support SDHC cards. The current mainline Linux Kernel (4.4.1) has been used.

## Getting started

To build, first load the configuration, edit it if neccessary, and run the build:

    ./build.sh olinuxino_defconfig
    ./build.sh menuconfig
    ./build.sh

If this succeeds, insert your SD card, find out it’s identifier, and run this (replace sdc with your disk!):

    ./flash.sh /dev/sdc

Then eject the card, insert it into the OLinuXino, apply power and watch the boot console on the Debug Serial port.

## Working with Git Submodules

To clone this repository, enter the following:

    git clone https://xythobuz.de/git/CaseLights.git
    git submodule init
    git submodule update

When pulling changes from this repository, you may need to update the submodule:

    git submodule update

## Sources

This is mostly based on the olinuxino_defconfig included with buildroot. To get U-Boot to compile for the OLinuXino, I included [this patch](https://rcn-ee.com/repos/git/u-boot-patches/v2016.01/0001-mx23_olinuxino-uEnv.txt-bootz-n-fixes.patch) from [here](https://www.eewiki.net/display/linuxonarm/iMX233-OLinuXino#iMX233-OLinuXino-Bootloader:U-Boot).

