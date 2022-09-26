#!/bin/bash

set -e

# helper functions
info()
{
  echo '[INFO] ' "$@"
}
warn()
{
  echo '[WARN] ' "$@" >&2
}
fatal()
{
  echo '[ERROR] ' "$@" >&2
  exit 1
}

source conf

WORK_DIR=`pwd`
BUILD_DIR=$WORK_DIR/build
INITRD_TOOL_DIR=/etc/initramfs-tools
GRUB_DIR=/etc/default

update_initrd()
{
  for module in $*
  do
    found=$(grep "^$module" $INITRD_TOOL_DIR/modules 2> /dev/null | wc -l)
    if [[ $found -eq 0 ]]
    then
      echo $module >> $INITRD_TOOL_DIR/modules
    fi
  done
  $SUDO update-initramfs -u -k "all"
}

update_grub_cmdline()
{
  sed -i "s/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"$*\"/g" $GRUB_DIR/grub
}

update_grub_default()
{
  sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT='Advanced options for Ubuntu>Ubuntu, with Linux $*'/g" $GRUB_DIR/grub
}

persist_grub_update()
{
  update-grub2
}

SUDO=sudo
if [[ $(id -u) -eq 0 ]]; then
  SUDO=
fi

# install kernel deb files
files=$(ls $BUILD_DIR/*.deb 2> /dev/null | wc -l)
if [[ $files -eq 0 ]]; then
  fatal "Kernel packages not found. Installation aborted"
  exit 1
fi

dpkg -i $BUILD_DIR/*.deb

# update grub
kernel_file_version=$(ls $BUILD_DIR/linux-headers*.deb | grep -Po 'linux-headers-\K[^_]*')
if [[ -z $kernel_file_version ]]; then
  fatal "Fail to retrive kernel file version"
  exit 1
fi

update_grub_default $kernel_file_version

if [[ -z $GRUB_CMDLINE ]]; then
  fatal "$GRUB_CMDLINE param not set"
  exit 1
fi

update_grub_cmdline $GRUB_CMDLINE
persist_grub_update

# update initrd
if [[ ! -z $LOAD_MODULES ]]; then
  update_initrd $LOAD_MODULES
fi

echo "Please reboot the system for change to take effect"