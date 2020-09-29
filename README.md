# L4T Bootstack

This repository contains our L4T initramfs, u-boot and u-boot scripts, our latest coreboot.romm and a script to update it.

## Automated build

Rebuilds initramfs and uboot script.
For ubuntu bootfiles on partition 2 with Hekate ID SWR-UBU:

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
docker run -it --rm -e DISTRO=ubuntu -e PARTNUM=2 -e HKT_ID=SWR-UBU -v "${PWD}"/out:/out alizkan/l4t-bootfiles-misc:latest
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

### More infos

Rebuild Dockerfile:

```sh
docker image build -t alizkan/l4t-bootfiles-misc:latest .
```
