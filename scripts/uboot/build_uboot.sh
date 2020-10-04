#!/bin/bash
out="$(realpath "${@:$#}")"
uboot_dir="$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"/src/switch-uboot/

[[ -z ${DISTRO} ]] && \
	echo "Nothing set for DISTRO variable..Exiting." && exit 1

[[ ! -d "${out}" ]] && \
	echo "${out} is not a valid directory! Exiting.." && exit 1


if [[ -n "${CPUS}" ]]; then
	if [[ ! "${CPUS}" =~ ^[0-9]{,2}$ || "${CPUS}" > $(nproc)  ]]; then
		echo "${CPUS} cores out of range or invalid, CPUS cores avalaible: $(nproc) ! Exiting..."
		exit 1
	fi
fi

cd "${uboot_dir}"
git submodule update --init --recursive .

sed -i 's/boot_prefixes=\/ \/switchroot\/.*\/\\0/boot_prefixes=\/ \/switchroot\/'${DISTRO}'\/\\0/' "${uboot_dir}/include/config_distro_bootcmd.h"

make nintendo-switch_defconfig
make -j"${CPUS}"

cp u-boot.elf "${out}"
