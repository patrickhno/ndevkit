
CC=../tools/vbcc/usr/bin/vc +aos68k -m68000 -Fhunk
LD=../tools/vbcc/usr/bin/vlink

OBJS_ROM = main.o exec_lib.o

all: rom.bin

clean:
	rm -f rom.bin
	rm -f $(OBJS_ROM)
	rm -f rom.o

%.o : %.s
	$(CC) -c $< -o $@

rom.o: $(OBJS_ROM)
	$(LD) -bamigahunk -r -o $@ $(OBJS_ROM)

rom.bin: rom.o
	$(LD) -brawbin1 -T rom.ld -o $@ rom.o
