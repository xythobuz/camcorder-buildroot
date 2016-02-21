#!/bin/sh

if [ "$#" -ne 1 ] ; then
 	echo "Usage: $0 /dev/disk" >&2
	exit 1
fi

# Unmount mounted partitions
for fs in `grep $1 /proc/mounts|cut -d ' ' -f 1` ; do
	echo Unmounting $fs
	sudo umount $fs
done

echo Overwriting old partition table
sudo dd if=/dev/zero of=$1 bs=1024 count=1024

echo Recreating new partition table
sudo fdisk $1 << EOF
n
p
1

+16MB
t
53
n
p
2


w
EOF

if [ -e output/images/imx23_olinuxino_dev_linux.sb ] ; then
	echo Writing mxs-bootlet bootstream
	sudo dd if=output/images/imx23_olinuxino_dev_linux.sb bs=512 of="$1"1 seek=4
elif [ -e output/images/u-boot.sd ] ; then
	echo Writing U-Boot bootstream
	sudo dd if=output/images/u-boot.sd of="$1"1
elif [ -e output/images/ ] ; then
    echo Creaeting boot filesystem
    sudo mkfs.vfat -F 16 -n boot "$1"1

    echo Mounting boot filesystem
	sudo mkdir -p /media/boot
	sudo mount "$1"1 /media/boot

    echo Copying bootloader files
    sudo cp output/images/rpi-firmware/* /media/boot/
    sudo cp output/images/*.dtb /media/boot/

    echo Preparing and copying Kernel Image
    output/host/usr/bin/mkknlimg output/images/zImage /media/boot/zImage

    echo Synchronising changes to disk
	sudo sync

	echo Unmounting boot filesystem
	sudo umount /media/boot
	sudo rm -rf /media/boot
else
	echo Could not find a suitable bootstream!
fi

if [ -e output/images/rootfs.tar ] ; then
	echo Creating root filesystem
	sudo mkfs.ext4 "$1"2 -L rootfs

	echo Mounting root filesystem
	sudo mkdir -p /media/rootfs
	sudo mount "$1"2 /media/rootfs

	echo Copying root filesystem
	sudo tar xfp output/images/rootfs.tar -C /media/rootfs

	echo Synchronising changes to disk
	sudo sync

	echo Unmounting root filesystem
	sudo umount /media/rootfs
	sudo rm -rf /media/rootfs
elif [ -e output/images/rootfs.ext2 ] ; then
	echo Writing ext2 root filesystem
	sudo dd if=output/images/rootfs.ext2 of="$1"2 bs=512

	echo Synchronising changes to disk
	sudo sync
else
    echo Could not find a suitable root filesystem!
fi

