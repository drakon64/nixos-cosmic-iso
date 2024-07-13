# nixos-cosmic-iso

Daily builds of a NixOS Unstable Live ISO with the [COSMIC Desktop Environment](https://github.com/lilyinstarlight/nixos-cosmic) enabled.

Downloads are available at [GitHub Actions](https://github.com/drakon64/nixos-cosmic-iso/actions/workflows/cosmic.yml) for x86_64 and AArch64.

These ISO's are built from the NixOS Graphical Installer Base with the following modifications:
* The latest Linux kernel is used rather than the latest LTS
* memtest86+ is not included
* ZFS is disabled
* PulseAudio is disabled in favour of PipeWire
