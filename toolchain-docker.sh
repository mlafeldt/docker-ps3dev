#!/bin/bash
# A simpler toolchain script that cleans up after each build script to not fill
# up the host's Docker volume.

set -e
set -o pipefail

for script in depends/*; do
    "$script"
done

mkdir -p build
cd build

for script in ../scripts/*; do
    "$script"
    rm -rf *
done
