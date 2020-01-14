#!/usr/bin/bash
TEST=$1
if [ -z "$1" ]; then
	echo -e "\e[1;31mPlease specify the name of the test (Without the .s)\e[0m"
fi
/opt/riscv-software/bin/riscv32-unknown-elf-gcc -march=rv32im -O3 -MD -Wall -std=gnu99 -Wmisleading-indentation -c software/tools/crt.s -o software/obj/crt.s.o
/opt/riscv-software/bin/riscv32-unknown-elf-gcc -march=rv32im -O3 -MD -Wall -std=gnu99 -Wmisleading-indentation -c software/tests/$TEST.s -o software/obj/$TEST.s.o
/opt/riscv-software/bin/riscv32-unknown-elf-gcc -march=rv32im -O3 -MD -Wall -std=gnu99 -Wmisleading-indentation -c software/tests/$TEST.s -o software/obj/$TEST.s.o
/opt/riscv-software/bin/riscv32-unknown-elf-gcc -T software/tools/link.ld software/obj/crt.s.o software/obj/$TEST.s.o -o software/obj/$TEST.elf -march=rv32im -static -nostartfiles
/opt/riscv-software/bin/riscv32-unknown-elf-objcopy  -O binary software/obj/$TEST.elf software/obj/$TEST.bin
python software/tools/bin2mif.py software/obj/$TEST.bin 0x00 > software/obj/$TEST.mif
/opt/altera15.1/quartus/bin/mif2hex software/obj/$TEST.mif software/obj/$TEST.hex
cp software/obj/$TEST.hex software/mem.hex
