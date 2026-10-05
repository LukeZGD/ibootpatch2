#!/bin/sh
set -e

# Generate the ARM64 payload binaries and embed them into payload.c.
#
# This script is intended to be run on macOS, where Apple's ARM64
# assembler/toolchain is available.

CC="${CC:-cc}"
AS="${AS:-as}"
CFLAGS="${CFLAGS:--arch arm64 -nostdlib -static -ffreestanding}"

echo "[*] Building vmacho..."
"$CC" -fcommon -o vmacho vmacho.c

echo "[*] Assembling payloads..."

"$AS" $CFLAGS a10_a11rxw.S -o a10_a11rxw.o
"$AS" $CFLAGS go_cmd_hook.S -o go_cmd_hook.o
"$AS" $CFLAGS tram.S -o tram.o

echo "[*] Converting payloads to binary..."

./vmacho -f a10_a11rxw.o a10_a11rxw.bin
./vmacho -f go_cmd_hook.o go_cmd_hook.bin
./vmacho -f tram.o tram.bin

echo "[*] Generating payload.c..."

rm -f payload.c

xxd -iC a10_a11rxw.bin >> payload.c
xxd -iC go_cmd_hook.bin >> payload.c
xxd -iC tram.bin >> payload.c

echo "[+] Generated payload.c"
