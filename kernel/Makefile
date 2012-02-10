
CC=../tools/vbcc/usr/bin/vc +aos68k -m68000
LD=../tools/vbcc/usr/bin/vlink

OBJS_ROM = main.o

all: rom.bin

clean:
	rm -f rom.bin
	rm -f $(OBJS_ROM)
	rm -f rom_objs.ld
	rm -f rom-reloc.elf
	rm -f rom.elf

%.o : %.s
	$(CC) -c $< -o $@

rom.bin: $(OBJS_ROM)
	$(LD) -b rawbin1 -T rom.ld -o $@ $<
