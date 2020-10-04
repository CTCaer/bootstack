#!/bin/bash
out=$(realpath "${@:$#}")
initramfs_dir="$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"/src/

[[ ! -d "${out}" ]] && \
	echo "${out} is not a valid directory! Exiting.." && exit 1

[[ -z ${DISTRO} ]] && \
	echo "Nothing set in DISTRO variable.. Exiting." && exit 1

tar xf "${initramfs_dir}"/initramfs_files.tar.gz
sh -c 'cd initramfs_files/ && find . | cpio -H newc -o' | gzip -9 > new_initramfs.cpio.gz
mkimage -A arm64 -O linux -T ramdisk -C gzip -d new_initramfs.cpio.gz "${out}"/initramfs

rm -rf new_initramfs.cpio.gz initramfs_files/
