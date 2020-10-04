#!/bin/bash
out=$(realpath "${@:$#}")
overlays_dir="$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"/src/uboot-scripts/overlays/

[[ ! -d "${out}" ]] && \
	echo "${out} is not a valid directory! Exiting.." && exit 1

mkdir -p "${out}/overlays"
dtc -I dts -O dtb -o "${overlays}/tegra210-icosa_emmc-overlay.dtbo" "${out}/overlays/emmc_overlay.dts"
dtc -I dts -O dtb -o "${overlays}/tegra210-icosa-UART-B-overlay.dtbo" "${out}/overlays/uart_b_debug.dts"
