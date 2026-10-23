#!/usr/bin/env bash
set -e

# Ensure BitBake setup is available
if [ ! -x bitbake/bin/bitbake-setup ]; then
    git clone https://git.openembedded.org/bitbake bitbake
fi

# Find any existing Yocto build setup
mapfile -t configs < <(
    find "$PWD" -mindepth 1 -maxdepth 5 \
        -type f -path '*/build/conf/toolcfg.conf' -print
)

# Initialize an ARM64 setup if none exists
if [ "${#configs[@]}" -eq 0 ]; then
    ./bitbake/bin/bitbake-setup init \
        --non-interactive \
        poky-wrynose \
        poky \
        distro/poky \
        machine/qemuarm64

    mapfile -t configs < <(
        find "$PWD" -mindepth 1 -maxdepth 5 \
            -type f -path '*/build/conf/toolcfg.conf' -print
    )
fi

# Avoid modifying an ambiguous setup
if [ "${#configs[@]}" -ne 1 ]; then
    printf 'Expected one Yocto setup; found %s:\n' "${#configs[@]}"
    printf '%s\n' "${configs[@]}"
    exit 1
fi

setup_dir="${configs[0]%/build/conf/toolcfg.conf}"

# Load the Yocto build environment
source "$setup_dir/build/init-build-env"

# Select the ARM64 QEMU machine
bitbake-config-build enable-fragment machine/qemuarm64

# Display active configuration fragments
bitbake-config-build list-fragments
