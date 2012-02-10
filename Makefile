
all: NUAE/src/PUAE.app/Contents/MacOS/uae kernel/rom.bin

clean:
	cd NUAE; make clean
	cd tools/gcc; make clean
	cd kernel; make clean

kernel/rom.bin: tools/vbcc/usr/bin/vc FORCE
	cd kernel; make

run: all
	./NUAE/src/PUAE.app/Contents/MacOS/uae -s kickstart_rom_file=kernel/rom.bin

NUAE/src/PUAE.app/Contents/MacOS/uae:
	cd NUAE; sh build_macos_cocoa.sh

tools/vbcc/usr/bin/vc:
	cd tools/vbcc; make

FORCE:
	true
