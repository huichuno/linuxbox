#!/bin/bash

trap 'rm -rf "$tempdir"' EXIT

download_firmware(){
    wget -N https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/adlp_dmc_ver2_12.bin
    wget -N https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/adlp_dmc_ver2_14.bin
    wget -N https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/adlp_dmc_ver2_16.bin
    wget -N https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/adls_dmc_ver2_01.bin
    wget -N https://github.com/intel/intel-linux-firmware/raw/main/adlp_guc_70.0.3.bin
    wget -N https://github.com/intel/intel-linux-firmware/raw/main/tgl_guc_70.0.3.bin
    wget -N https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/tgl_huc_7.9.3.bin
}

tempdir=$(mktemp -d)
pushd $tempdir
download_firmware
pushd
sudo mv $tempdir/* abc
rm -rf $tempdir