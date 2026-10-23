# Yocto ARM64 Lab

A reproducible starting point for building a Yocto/OpenEmbedded image for an
ARM64 QEMU target using the modern `bitbake-setup` workflow.

The repository intentionally contains only the bootstrap script and documentation:
BitBake, Poky, downloads, and build outputs are generated locally and ignored by
Git.

## What the script does

1. Clones `bitbake` if `bitbake/bin/bitbake-setup` is not available.
2. Initializes a non-interactive Poky setup for `qemuarm64` if no setup exists.
3. Refuses to continue when more than one build setup is present.
4. Sources the generated `init-build-env`, enables the `machine/qemuarm64`
   configuration fragment, and lists the active fragments.

## Prerequisites

- Linux host (tested on Ubuntu)
- Python 3, Git, and the usual Yocto host packages
  ([Yocto Project host requirements](https://docs.yoctoproject.org/ref-manual/system-requirements.html))
- Enough disk space for a Poky build (tens of GB)

## Usage

```bash
git clone https://github.com/khalil-lab/yocto-arm64-lab.git
cd yocto-arm64-lab
./setup-arm64.sh
```

After the script finishes, the build environment is loaded in the current shell:

```bash
bitbake core-image-minimal
```

Run the resulting image:

```bash
runqemu qemuarm64 nographic
```

## Layout

```text
yocto-arm64-lab/
├── setup-arm64.sh    # bootstrap and configuration
└── README.md
```

Generated paths (not tracked):

- `bitbake/` - BitBake checkout
- `bitbake-builds/` - build setup, downloads, and sstate cache

## Notes

- The setup uses the Poky `wrynose` release and `machine/qemuarm64`.
- Builds are reproducible from the setup configuration, not from committed
  binaries.
- For a custom layer, add it under a new `meta-*` directory, register it in
  `bblayers.conf`, and keep the layer in this repository.

## License

MIT. See [LICENSE](LICENSE).
