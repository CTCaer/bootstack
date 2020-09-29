uenv.txt configuration :

Overlays options:
Add the overlays you want to use here (refer to overlays/overlays_readme.txt
for avalaible overlays and what they do)

tegra210-icosa_emmc-overlay
Enables eMMC booting

tegra210-icosa-UART-B-overlay
Enables UARTB logging.

usb_logging
Overlay options for usb logging.

nfs
Enables Network driver booting, more infos here :
https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
Parameters are set in overlays/nfs.txt

rootdev
- String, default: mmcblk0p2
Override rootdev set in boot.scr (sdX, mmcblk0/1pX)

rootlabel_retries
- Int, default: 1
How many times to retry and search rootdev.
Each iteration is 200ms. Useful when booting via USB.

skip_extract
- Bool, default: 0 (false)
Skip modules.tar.gz and update.tar.gz extraction.

auto_rootdev_disable
- Bool, default: 0 (false)
Disable rootdev search done by initramfs

Extra uenv parameters:
hekate_id
Override hekate_id set in boot.scr.

uartb
Overlay options for UART-B.

run_kernelcmd
Set environment for kernel command line arguments.
