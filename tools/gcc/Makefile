
CC=/usr/bin/gcc-4.2
CXX=/usr/bin/g++-4.2
CPP=/usr/bin/cpp-4.2
LD=/usr/bin/ld

#HOST=$(shell gcc -v 2>&1 | grep ^Target: | sed 's/^Target: \(.*\)/\1/')
PREFIX=${PWD}/usr

all: usr/bin/m68k-elf-gcc

clean:
	rm -rf tmp

downloads/gcc-core-4.6.2.tar.gz:
	mkdir -p downloads
	wget --progress=bar:force http://www.multiprecision.org/mpc/download/mpc-0.8.2.tar.gz -O downloads/mpc-0.8.2.tar.gz
	wget --progress=bar:force http://www.mpfr.org/mpfr-current/mpfr-3.1.0.tar.gz -O downloads/mpfr-3.1.0.tar.gz
	wget --progress=bar:force ftp://ftp.gmplib.org/pub/gmp-5.0.3/gmp-5.0.3.tar.bz2 -O downloads/gmp-5.0.3.tar.bz2
	wget --progress=bar:force http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz -O downloads/libiconv-1.14.tar.gz
	wget --progress=bar:force http://ftp.gnu.org/gnu/binutils/binutils-2.22.tar.gz -O downloads/binutils-2.22.tar.gz
#	wget --progress=bar:force ftp://ftp.gnu.org/pub/gnu/gcc/gcc-4.6.2/gcc-4.6.2.tar.gz -O downloads/gcc-4.6.2.tar.gz
	wget --progress=bar:force ftp://ftp.gnu.org/pub/gnu/gcc/gcc-4.6.2/gcc-core-4.6.2.tar.gz -O downloads/gcc-core-4.6.2.tar.gz

tmp/gcc-4.6.2/README: downloads/gcc-core-4.6.2.tar.gz
	mkdir -p tmp
	cd tmp; tar -xjf ../downloads/gmp-5.0.3.tar.bz2 
	cd tmp; tar -xzf ../downloads/mpfr-3.1.0.tar.gz
	cd tmp; tar -xzf ../downloads/mpc-0.8.2.tar.gz
	cd tmp; tar -xzf ../downloads/gcc-core-4.6.2.tar.gz
	cd tmp; tar -xzf ../downloads/binutils-2.22.tar.gz
	cd tmp; tar -xzf ../downloads/libiconv-1.14.tar.gz
	touch tmp/gcc-4.6.2/README

tmp: tmp/gcc-4.6.2/README

#
# Build self hosted variants first.
#

usr/lib/libgmp.a: tmp
	cd tmp/gmp-5.0.3; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) ./configure --prefix=$(PREFIX)
	cd tmp/gmp-5.0.3; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make
	cd tmp/gmp-5.0.3; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make install

usr/lib/libmpfr.a: tmp
	cd tmp/mpfr-3.1.0; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) ./configure --prefix=$(PREFIX) --with-gmp=$(PREFIX)
	cd tmp/mpfr-3.1.0; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make
	cd tmp/mpfr-3.1.0; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make install

usr/lib/libmpc.a: usr/lib/libgmp.a usr/lib/libmpfr.a
	cd tmp/mpc-0.8.2; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) ./configure --prefix=$(PREFIX) --with-mpfr=$(PREFIX) --with-gmp=$(PREFIX)
	cd tmp/mpc-0.8.2; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make
	cd tmp/mpc-0.8.2; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make install

usr/bin/iconv: tmp
	cd tmp/libiconv-1.14; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) ./configure --prefix=$(PREFIX)
	cd tmp/libiconv-1.14; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make
	cd tmp/libiconv-1.14; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make install

#usr/bin/objdump: usr/lib/libmpc.a usr/bin/iconv
#	cd tmp/binutils-2.22; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) ./configure --prefix=$(PREFIX) --with-mpfr=$(PREFIX) --with-gmp=$(PREFIX) --with-mpc=$(PREFIX)
#	cd tmp/binutils-2.22; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make
#	cd tmp/binutils-2.22; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make install

#usr/bin/gcc: tmp usr/bin/objdump
#	mkdir tmp/gcc-darwin
#	cd tmp/gcc-darwin; PATH=$(PATH):$(PREFIX)/bin STRIP_FOR_TARGET=/usr/bin/strip CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) LDFLAGS=-L$(PREFIX)/lib ../gcc-4.6.2/configure --prefix=$(PREFIX) --enable-languages=c --with-gmp=$(PREFIX)
#	cd tmp/gcc-darwin; PATH=$(PATH):$(PREFIX)/bin STRIP_FOR_TARGET=/usr/bin/strip CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make
#	cd tmp/gcc-darwin; PATH=$(PATH):$(PREFIX)/bin STRIP_FOR_TARGET=/usr/bin/strip CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make install

#host: usr/bin/gcc
host: usr/lib/libmpc.a usr/bin/iconv

#
# Then build the cross toolchain
#

usr/bin/m68k-elf-as: host
	cd tmp/binutils-2.22; make distclean
	cd tmp/binutils-2.22; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) ./configure --prefix=$(PREFIX) --with-mpfr=$(PREFIX) --with-gmp=$(PREFIX) --with-mpc=$(PREFIX) --target=m68k-elf
	cd tmp/binutils-2.22; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make
	cd tmp/binutils-2.22; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make install
	cd tmp/binutils-2.22; CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make distclean

usr/bin/m68k-elf-gcc: usr/bin/m68k-elf-as
	mkdir tmp/gcc-m68k
	cd tmp/gcc-m68k; PATH=$(PATH):$(PREFIX)/bin STRIP_FOR_TARGET=/usr/bin/strip CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) LDFLAGS=-L$(PREFIX)/lib ../gcc-4.6.2/configure --prefix=$(PREFIX) --enable-languages=c --with-gmp=$(PREFIX) --target=m68k-elf --disable-libssp
	cd tmp/gcc-m68k; PATH=$(PATH):$(PREFIX)/bin STRIP_FOR_TARGET=/usr/bin/strip CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make
	cd tmp/gcc-m68k; PATH=$(PATH):$(PREFIX)/bin STRIP_FOR_TARGET=/usr/bin/strip CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make install
	cd tmp/gcc-m68k; PATH=$(PATH):$(PREFIX)/bin STRIP_FOR_TARGET=/usr/bin/strip CC=$(CC) LD=$(LD) CPP=$(CPP) CXX=$(CXX) make distclean
