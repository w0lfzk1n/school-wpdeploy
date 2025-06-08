#!/bin/bash

# Script to set up VMware shared folder mount to /mnt/drive on Ubuntu 24.04
# Tested with open-vm-tools and VMWare Workstation

SHARED_FOLDER_NAME="vm-drive"
MOUNT_POINT="/mnt/drive"
FSTAB_LINE=".host:/${SHARED_FOLDER_NAME}   ${MOUNT_POINT}   fuse.vmhgfs-fuse   allow_other,defaults   0   0"

echo "[+] Installing open-vm-tools..."
sudo apt update
sudo apt install -y open-vm-tools open-vm-tools-desktop

echo "[+] Creating required directories..."
sudo mkdir -p /mnt/hgfs
sudo mkdir -p ${MOUNT_POINT}

echo "[+] Adding VMware shared folder mount to /etc/fstab if not already present..."
grep -qF "${FSTAB_LINE}" /etc/fstab || echo "${FSTAB_LINE}" | sudo tee -a /etc/fstab

echo "[+] Setup complete. The system will now reboot to apply changes..."
sleep 2
sudo reboot
