#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

source conf

WORK_DIR=`pwd`
BUILD_DIR=$WORK_DIR/build
INITRD_TOOL_DIR=/etc/initramfs-tools
GRUB_DIR=/etc/default

function update_initrd()
{
  for module in $*
  do
    found=$(grep "^$module" $INITRD_TOOL_DIR/modules 2> /dev/null | wc -l)
    if [[ $found -eq 0 ]]
    then
      echo $module >> $INITRD_TOOL_DIR/modules
    fi
  done
  sudo update-initramfs -u -k "all"
}

function update_grub_cmdline()
{
  sed -i "s/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"$*\"/g" $GRUB_DIR/grub
}

function update_grub_default()
{
  sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT=\"$*\"/g" $GRUB_DIR/grub
}

function persist_grub_update()
{
  update-grub2
}

# check for sudo 
if [[ $EUID -ne 0 ]]
then
    echo -e "${RED}Run script as superuser"
    exit 1
fi

# update initrd
if [[ -z $LOAD_MODULES ]]
then 
  echo -e "${YELLOW}\$LOAD_MODULES param is not set"
else
  update_initrd $LOAD_MODULES
fi

# install kernel deb files
files=$(ls $BUILD_DIR/*.deb 2> /dev/null | wc -l)
if [[ $files -eq 0 ]]
then
    echo -e "${RED}Kernel packages not found. Installation aborted"
    exit 1
else
    dpkg -i $BUILD_DIR/*.deb
fi

# update grub
if [[ -z $GRUB_CMDLINE || -z $GRUB_DEFAULT ]]
then 
  echo -e "${YELLOW}Either one or more GRUB params are not set"
else
  update_grub_cmdline $GRUB_CMDLINE
  update_grub_default $GRUB_DEFAULT
  persist_grub_update
fi

echo -e "${GREEN}Installation completed"
