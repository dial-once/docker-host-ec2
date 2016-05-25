#!/bin/sh
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y dkms
wget "sourceforge.net/projects/e1000/files/ixgbevf stable/2.16.4/ixgbevf-2.16.4.tar.gz"
tar -xzf ixgbevf-2.16.4.tar.gz
sudo mv ixgbevf-2.16.4 /usr/src/

cat > /usr/src/ixgbevf-2.16.4/dkms.conf << EOL
PACKAGE_NAME="ixgbevf"
PACKAGE_VERSION="2.16.4"
CLEAN="cd src/; make clean"
MAKE="cd src/; make BUILD_KERNEL=${kernelver}"
BUILT_MODULE_LOCATION[0]="src/"
BUILT_MODULE_NAME[0]="ixgbevf"
DEST_MODULE_LOCATION[0]="/updates"
DEST_MODULE_NAME[0]="ixgbevf"
AUTOINSTALL="yes"
EOL

sudo dkms add -m ixgbevf -v 2.16.4
sudo dkms build -m ixgbevf -v 2.16.4
sudo dkms install -m ixgbevf -v 2.16.4
sudo update-initramfs -c -k all

modinfo ixgbevf