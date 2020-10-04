#!/bin/bash
set -e

# Use last argument as output directory
out="$(realpath "${@:$#}")"
_repo_dir="$(dirname "$(dirname "$(readlink -f $0)")")"
_script_dir="$(dirname "$(readlink -f $0)")"


[[ ! -d "${out}" ]] && \
	echo "${out} is not a valid directory! Exiting.." && exit 1

# Multiple variable check
[[ -z ${DISTRO} || -z "${HEKATE_ID}" || -z ${PARTNUM} ]] && \
	echo "Nothing set in DISTRO variable.. Exiting." && exit 1

if [[ -n "${CPUS}" ]]; then
	if [[ ! "${CPUS}" =~ ^[0-9]{,2}$ || "${CPUS}" > $(nproc)  ]]; then
		echo "${CPUS} cores out of range or invalid, CPUS cores avalaible: $(nproc) ! Exiting..."
		exit 1
	fi
fi

echo -e "\n\t\tBuilding U-Boot\n"
source "${_script_dir}/uboot/build_uboot.sh" "${out}"

echo -e "\n\t\tBuilding cbfstool\n"
source "${_script_dir}/coreboot/build_cbfstool.sh" "${out}"

echo -e "\n\t\tUpdating Coreboot\n"
source "${_script_dir}/coreboot/update-coreboot.sh" "${_repo_dir}/src/coreboot.rom" "${out}/u-boot.elf" "${out}"

echo -e "\n\t\tBuilding U-Boot scripts\n"
source "${_script_dir}/uboot/build_uboot_scripts.sh" "${out}"

echo -e "\n\t\tBuilding Initramfs\n"
source "${_script_dir}/initramfs/build_initramfs.sh" "${out}"

echo -e "\n\t\tCopying bootfiles to target directory\n"
mkdir -p "${out}/switchroot/${DISTRO}/overlays/" "${out}/bootloader/ini/"

# Copy hekate ini
cp "${_repo_dir}/src/hekate_ini/L4T-${DISTRO}.ini" "${out}/bootloader/ini/"

# Copy overlays, uenv.txt, uenv_readme.txt and coreboot.rom
cp -r "${_repo_dir}/src/uboot-scripts/overlays/" "${_repo_dir}/src/uboot-scripts/uenv.txt" "${_repo_dir}/src/uboot-scripts/uenv_readme.txt" "${_repo_dir}/src/coreboot.rom" "${out}/switchroot/${DISTRO}"

# Move builded files to switchroot distro directory
mv "${out}/initramfs" "${out}/boot.scr" "${out}/switchroot/${DISTRO}"

# Clean build files
rm "${out}/u-boot.elf"

echo -e "\n\t\tDone building !\n"
