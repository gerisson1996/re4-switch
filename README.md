# re4-switch

Experimental Nintendo Switch porting project based on the reconstructed C/C++ code of Resident Evil 4 (GameCube).

## Goal

Keep the game logic in C/C++ and replace GameCube-specific platform services with Switch implementations. Graphics will target **Vulkan through Mesa NVK**, not deko3d.

Planned graphics path:

```
RE4 game code -> Nintendo GX API calls -> GXVK compatibility layer -> Vulkan -> Mesa NVK -> Tegra X1
```

## Current milestone: M0

The first milestone establishes a clean libnx homebrew executable and the GXVK/platform scaffolding. NVK integration is intentionally isolated behind `source/gxvk`.

Next milestones:

- M1: link the Switch NVK static stack and run a Vulkan device/compute smoke test.
- M2: create the VI/nwindow Vulkan surface and swapchain.
- M3: render and present the first Vulkan triangle.
- M4: implement the minimum GX state/draw subset required by RE4.
- M5: begin integrating reconstructed RE4 game code.

## Requirements

- devkitPro / devkitA64
- libnx
- GNU Make
- For Vulkan milestones: a locally built Switch NVK stack from HayatoG/switch-nvk

The NVK project currently uses a custom Mesa/NVK cross-build and static link stack. It is not treated as a normal devkitPro package, so this repository keeps that dependency external.

## Build

With `DEVKITPRO` and `DEVKITA64` configured:

```sh
make
```

The output will be `re4-switch.nro`.

## Legal

This repository does not contain Resident Evil 4 game assets, disc images, Nintendo SDK files, or other proprietary game data. Users are responsible for supplying legally obtained game data when asset extraction is implemented.

## Status

Early bring-up / research. Not playable.
