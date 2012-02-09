
all: NUAE/src/PUAE.app/Contents/MacOS/uae tools/gcc/usr/bin/gcc

clean:
	cd NUAE; make clean
	cd tools/gcc; make clean

NUAE/src/PUAE.app/Contents/MacOS/uae:
	cd NUAE; sh build_macos_cocoa.sh

tools/gcc/usr/bin/gcc:
	cd tools/gcc; make
