#!/bin/bash
_cwd=$(pwd)
out="$(realpath "${@:$#}")"
coreboot_dir="$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")"/src/switch-coreboot/

[[ ! -d "${out}" ]] && \
	echo "${out} is not a valid directory! Exiting.." && exit 1

if [[ -n "${CPUS}" ]]; then
	if [[ ! "${CPUS}" =~ ^[0-9]{,2}$ || "${CPUS}" > $(nproc)  ]]; then
		echo "${CPUS} cores out of range or invalid, CPUS cores avalaible: $(nproc) ! Exiting..."
		exit 1
	fi
fi

cd "${coreboot_dir}"
git submodule update --init --recursive .

cd util/cbfstool/
make -j${CPUS}

cp cbfstool "$(dirname "${BASH_SOURCE[0]}")"
cd "${_cwd}"
