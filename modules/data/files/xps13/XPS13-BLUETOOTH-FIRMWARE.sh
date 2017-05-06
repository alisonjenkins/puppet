#!/bin/bash
set -euo pipefail

WINDOWS_DRIVER_URL="$1"
TMPDIR="$(mktemp -d)"

WIN_DRIVER_FILE="${TMPDIR}/bluetooth_win_driver.exe"
HEX_FIRMWARE_PATH="${TMPDIR}/Win32/BCM4350C5_003.006.007.0095.1703.hex"
HCD_FIRMWARE_PATH="/lib/firmware/brcm/BCM-0a5c-6412.hcd"

cd "$TMPDIR"

curl "$WINDOWS_DRIVER_URL" -o "$WIN_DRIVER_FILE"
7z x "$WIN_DRIVER_FILE"
hex2hcd "$HEX_FIRMWARE_PATH" -o "$HCD_FIRMWARE_PATH"
rm -Rf "$TMPDIR"
