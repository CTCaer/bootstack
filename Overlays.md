# l4t-platform-t210-icosa-overlays

Overlays for Tegra210

## eMMC overlay

```sh
dtc -I dts -O dtb -o tegra210-icosa_emmc-overlay.dtbo emmc_overlay.dts
```

## UART-B overlay

```sh
dtc -I dts -O dtb -o tegra210-icosa-UART-B-overlay.dtbo uart_b_debug.dts
```
