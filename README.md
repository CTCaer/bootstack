# L4T Bootstack

This repository contains our L4T initramfs, u-boot and u-boot scripts, our latest coreboot.romm and a script to update it.

## Automated build

Rebuilds initramfs and uboot script.
For Ubuntu Focal Bootfiles on partition 2 with Hekate ID SWR-FOC:

Pull the docker image :
```sh
docker pull alizkan/l4t-bootfiles-misc:latest
```

Create a directory to store build files and kernel files.
```sh
mkdir -p "${PWD}"/out
```

Run the docker contaainer to trigger the actuall build :
```sh
docker run -it --rm -e DISTRO=focal -e PARTNUM=mmcblk0p2 -e HEKATE_ID=SWR-FOC -v "${PWD}"/out:/out alizkan/l4t-bootfiles-misc:latest
```

## Manual build

### Building u-boot scripts

```sh
sudo apt-get install u-boot-tools
```

For GNU/Linux:

```sh
mkimage -A arm -T script -O linux -d linux_boot_sdemmc.txt boot.scr
```

For Android:

```sh
mkimage -A arm -T script -O linux -d android_boot_sdemmc.txt boot.scr
mkimage -A arm -T script -O linux -d android_common_sdemmc.txt common.scr
```

### Initramfs

```sh
sudo apt-get install cpio
```

To rebuild initramfs :
```sh
sh -c 'cd initramfs_files/ && find . | cpio -H newc -o' | gzip -9 > new_initramfs.cpio.gz && mkimage -A arm64 -O linux -T ramdisk -C gzip -d new_initramfs.cpio.gz initramfs
```

To extract initramfs :

```sh
tail -c+65 < initramfs | gunzip > out
```

```sh
mkdir initramfs_files
```

```sh
mv out initramfs_files
```

```sh
cd initramfs_files
```

```sh
cpio -i < out
```

```sh
rm out
```

### l4t-platform-t210-icosa-overlays

Overlays for Tegra210

- eMMC overlay
```sh
dtc -I dts -O dtb -o tegra210-icosa_emmc-overlay.dtbo emmc_overlay.dts
```

- UART-B overlay

```sh
dtc -I dts -O dtb -o tegra210-icosa-UART-B-overlay.dtbo uart_b_debug.dts
```

### More infos

Rebuild Dockerfile:

```sh
./scripts/docker/build_image.sh
```
