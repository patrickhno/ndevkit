
CC=../tools/gcc/usr/bin/m68k-elf-gcc
LD=../tools/gcc/usr/bin/m68k-elf-ld
OBJCOPY=../tools/gcc/usr/bin/m68k-elf-objcopy

OBJS_ROM = main.o

all: rom.bin

%.o : %.s
	$(CC) -c $< -o $@

rom_objs.ld: $(OBJS_ROM)
	rm -f $@
	for file in $(OBJS_ROM); do \
		echo "$$file(.rodata .rodata.*)" >>$@; \
		echo "$$file(.text)" >>$@; \
	done

rom-reloc.elf: rom_objs.ld
	$(CC) -Wl,-r \
		-static -nostartfiles -nostdlib \
		-Wl,--defsym -Wl,start=0x0 \
		-Wl,--defsym -Wl,SysBase=0x4 \
		-Wl,--defsym -Wl,AbsExecBase=0x4 \
		-m68000 \
		-o $@ -Wl,-T -Wl,rom.ld

rom.elf: rom-reloc.elf
	$(LD) -o $@ --section-start .rom=0x0f80000 --section-start .stack=0x0000800 rom-reloc.elf

rom.bin: rom.elf
	#$(OBJCOPY) --output-target binary --only-section=.$* --gap-fill 0xff rom.elf $@
	$(OBJCOPY) --output-target binary --gap-fill 0xff rom.elf $@

