#!/usr/bin/env bash

set -euo pipefail

ROOTDIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
CWD="$(pwd)"
CLEANUP=true

function clean_file() {
    if $CLEANUP; then
        for filename in "$@"; do
            echo "Cleaning: ${filename}"
            rm -rf "${filename}"
        done
    fi
}

function show_help() {
    echo "Usage: $(basename "$0") [--nocleanup | -nc] [--help | -h] \n
    Supported environment variables:
    \`WINDOWS_TOOLCHAIN_PATH\` Path to the folder containing 'crt' and 'sdk' from xwin"
}

function fetch_toolchain() {
    mkdir -p "${CWD}/build/windows_toolchain"

    xwin_rel="https://github.com/Jake-Shadle/xwin/releases/download/0.6.7/xwin-0.6.7-x86_64-unknown-linux-musl.tar.gz"
    xwin_sha="https://github.com/Jake-Shadle/xwin/releases/download/0.6.7/xwin-0.6.7-x86_64-unknown-linux-musl.tar.gz.sha256"
    cd "${CWD}/build/windows_toolchain"

    curl -sSL --connect-timeout 10 "${xwin_rel}" -o xwin.tar.gz
    curl -sSL --connect-timeout 10 "${xwin_sha}" -o xwin.sha256

    sha_expected="$(cut -d ' ' -f1 xwin.sha256)"
    sha_actual="$(sha256sum xwin.tar.gz | cut -d ' ' -f1)"
    if [[ "${sha_expected}" != "${sha_actual}" ]]; then
        echo "Checksum mismatch!"
        exit 1
    fi

    echo "Checksum OK: ${sha_actual}"
    tar -xzf "xwin.tar.gz"
    "xwin-0.6.7-x86_64-unknown-linux-musl/xwin" --accept-license --arch x86 --cache-dir ./xwin_cache --manifest-version 17 splat --output .
    WINDOWS_TOOLCHAIN_PATH="$(pwd)"
    export WINDOWS_TOOLCHAIN_PATH
    clean_file "xwin.tar.gz" "xwin.sha256" "xwin_cache" "xwin-0.6.7-x86_64-unknown-linux-musl"
}

for arg in "$@"; do
    case "$arg" in
        --nocleanup|-nc)
            CLEANUP=false
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo "[WARN] Unknown option: $arg"
            show_help
            exit 1
            ;;
    esac
done

if [[ -z "${WINDOWS_TOOLCHAIN_PATH:-}" ]]; then
    if [[ ! -f "build/windows_toolchain/xwin.tar.gz"
            && ! -f "build/windows_toolchain/xwin.sha256" ]];
    then
        echo "Toolchain not found, installing."
        fetch_toolchain
    fi
else
    echo "[INFO] Using toolchain at ${WINDOWS_TOOLCHAIN_PATH}"
fi

mkdir -p "${CWD}/build/cross"
cd "${CWD}/build/cross"

cmake   -DCMAKE_TOOLCHAIN_FILE="${ROOTDIR}/gunz-toolchain.cmake" \
        -DCMAKE_C_FLAGS="-msse2" -DCMAKE_CXX_FLAGS="-msse2" \
        -DZLIB_LIBRARY="${ROOTDIR}/src/sdk/zlib/lib/zlibstatic.lib" \
        -DBUILD_SHARED_LIBS=OFF \
        -DCMAKE_BUILD_TYPE=Release \
        "${ROOTDIR}/src/"

cmake --build . --config Release --target install -j$(nproc)
