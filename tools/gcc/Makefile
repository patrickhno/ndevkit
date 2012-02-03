
HOST=i686-apple-Darwin #$(shell gcc -v 2>&1 | grep ^Target: | sed 's/^Target: \(.*\)/\1/')
PREFIX=${PWD}/usr

downloads/binutils-2.22.tar.gz:
	mkdir -p downloads
	wget --progress=bar:force http://ftp.gnu.org/gnu/binutils/binutils-2.22.tar.gz -O downloads/binutils-2.22.tar.gz

#downloads/gcc-4.6.2.tar.gz:
#	mkdir -p downloads
#	wget --progress=bar:force ftp://ftp.gnu.org/pub/gnu/gcc/gcc-4.6.2/gcc-4.6.2.tar.gz -O downloads/gcc-4.6.2.tar.gz

downloads/gcc-core-4.6.2.tar.gz:
	mkdir -p downloads
	wget --progress=bar:force ftp://ftp.gnu.org/pub/gnu/gcc/gcc-4.6.2/gcc-core-4.6.2.tar.gz -O downloads/gcc-core-4.6.2.tar.gz

tmp/binutils-2.22: downloads/binutils-2.22.tar.gz
	mkdir -p tmp
	cd tmp; tar -xzf ../downloads/binutils-2.22.tar.gz

tmp/gcc-4.6.2/README: downloads/gcc-core-4.6.2.tar.gz
	mkdir -p tmp
	cd tmp; tar -xzf ../downloads/gcc-core-4.6.2.tar.gz

usr/bin/m68k-elf-as: tmp/binutils-2.22
	cd tmp/binutils-2.22; ./configure --prefix=$(PREFIX) --target=m68k-elf #--target=m68k-amigaos
	cd tmp/binutils-2.22; make
	cd tmp/binutils-2.22; make install

usr/bin/m68k-elf-gcc: tmp/gcc-4.6.2/README
	cd tmp/gcc-4.6.2; PATH=$(PATH):$(PREFIX)/bin ./configure --prefix=$(PREFIX) --target=m68k-elf --enable-languages=c --with-gmp=/sw
	cd tmp/gcc-4.6.2; PATH=$(PATH):$(PREFIX)/bin make
	cd tmp/gcc-4.6.2; PATH=$(PATH):$(PREFIX)/bin make install

all: usr/bin/m68k-elf-gcc
