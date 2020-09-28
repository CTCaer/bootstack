FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

RUN chmod 1777 /tmp

RUN apt update -y && apt install -y u-boot-tools cpio gzip device-tree-compiler

WORKDIR /build
VOLUME /out
COPY . /build
RUN cp /build/coreboot/cbfstool /usr/bin
RUN chmod +x /usr/bin/cbfstool

ARG DISTRO
ENV DISTRO=${DISTRO}
ARG PARTNUM
ENV PARTNUM=${PARTNUM}
ARG HEKATE_ID
ENV HEKATE_ID=${HEKATE_ID}

CMD mkdir -p /out/bootloader/ini/ /out/switchroot/${DISTRO} && \
sed -i 's/^setenv hkt_idx .*$/setenv hkt_idx '${HEKATE_ID}'/' /build/uboot-scripts/linux_boot.txt && \
sed -i 's/^setenv part_idx .*$/setenv part_idx '${PARTNUM}'/' /build/uboot-scripts/linux_boot.txt && \
sed -i 's/^setenv linux_dir .*$/setenv linux_dir '${DISTRO}'/' /build/uboot-scripts/linux_boot.txt && \
mkimage -V && mkimage -A arm -T script -O linux -d /build/uboot-scripts/linux_boot.txt /out/switchroot/${DISTRO}/boot.scr && \
tar xf initramfs_files.tar.gz && \
sh -c 'cd initramfs_files/ && find . | cpio -H newc -o' | gzip -9 > new_initramfs.cpio.gz && \
mkimage -A arm64 -O linux -T ramdisk -C gzip -d new_initramfs.cpio.gz /out/switchroot/${DISTRO}/initramfs && \
dtc -I dts -O dtb -o /build/uboot-scripts/overlays/tegra210-icosa_emmc-overlay.dtbo /build/uboot-scripts/overlays/emmc_overlay.dts && \
dtc -I dts -O dtb -o /build/uboot-scripts/overlays/tegra210-icosa-UART-B-overlay.dtbo /build/uboot-scripts/overlays/uart_b_debug.dts && \
cp -r /build/uboot-scripts/uenv.txt /build/uboot-scripts/uenv_readme.txt /build/uboot-scripts/overlays /build/coreboot/coreboot.rom /out/switchroot/${DISTRO} && \
cp /build/hekate_ini/L4T-${DISTRO}.ini /out/bootloader/ini/ && \
/build/coreboot/update-coreboot.sh /out/switchroot/${DISTRO}/coreboot.rom /out/u-boot.elf && \
rm /out/switchroot/${DISTRO}/overlays/uart_b_debug.dts /out/switchroot/${DISTRO}/overlays/emmc_overlay.dts /out/u-boot.elf
