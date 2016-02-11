#!/bin/sh

if [ "$#" -ne 1 ] || ! [ -d "$1" ]; then
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

echo Writing bootstream
sudo dd if=output/images/imx23_olinuxino_dev_linux.sb bs=512 of="$1"1 seek=4

echo Writing root filesystem
sudo dd if=output/images/rootfs.ext2 of="$1"2 bs=512

echo Synchronising changes to disk
sudo sync

