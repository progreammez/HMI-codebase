#!/bin/bash

set -e

echo "Building EV_HMI..."

mkdir -p build
cd build

cmake ..
make -j$(nproc)

echo "Build Complete"
