
#CC=/usr/bin/gcc-4.2
#CXX=/usr/bin/g++-4.2
#CPP=/usr/bin/cpp-4.2
#LD=/usr/bin/ld

PREFIX=${PWD}/usr

all: usr/config/aos68k

clean:
	rm -rf tmp

downloads/vbcc.tar.gz:
	mkdir -p downloads
	wget --progress=bar:force http://mail.pb-owl.de/~frank/vbcc/2011-08-05/vbcc_target_m68k-amigaos.lha -O downloads/vbcc_target_m68k-amigaos.lha
	wget --progress=bar:force http://mail.pb-owl.de/~frank/vbcc/2011-08-05/vbcc_unix_config.zip -O downloads/vbcc_unix_config.zip
	wget --progress=bar:force http://sun.hasenbraten.de/vasm/release/vasm.tar.gz -O downloads/vasm.tar.gz
	wget --progress=bar:force http://sun.hasenbraten.de/vlink/release/vlink.tar.gz -O downloads/vlink.tar.gz
	wget --progress=bar:force http://www.ibaug.de/vbcc/vbcc.tar.gz -O downloads/vbcc.tar.gz

tmp/vasm/Makefile: downloads/vbcc.tar.gz
	mkdir -p tmp
	cd tmp; tar -xjf ../downloads/vasm.tar.gz
	touch tmp/vasm/Makefile

tmp/vlink/Makefile: downloads/vbcc.tar.gz
	mkdir -p tmp
	cd tmp; tar -xjf ../downloads/vlink.tar.gz
	touch tmp/vlink/Makefile

tmp/vbcc/Makefile: downloads/vbcc.tar.gz
	mkdir -p tmp
	cd tmp; tar -xjf ../downloads/vbcc.tar.gz
	touch tmp/vbcc/Makefile

tmp/vbcc_target_m68k-amigaos.info: downloads/vbcc_target_m68k-amigaos.lha
	mkdir -p tmp
	cd tmp; lha x ../downloads/vbcc_target_m68k-amigaos.lha
	touch tmp/vbcc_target_m68k-amigaos.info

tmp/config/aos68k: downloads/vbcc_unix_config.zip
	mkdir -p tmp
	cd tmp; unzip ../downloads/vbcc_unix_config.zip
	touch tmp/config/aos68k


tmp: tmp/vasm/Makefile tmp/vlink/Makefile tmp/vbcc/Makefile tmp/vbcc_target_m68k-amigaos.info tmp/config/aos68k

usr/bin/vasm68k_mot: tmp
	cd tmp/vasm; make CPU=m68k SYNTAX=mot
	mkdir -p usr/bin
	cp tmp/vasm/vasmm68k_mot tmp/vasm/vobjdump usr/bin

usr/bin/vlink: usr/bin/vasm68k_mot
	mkdir -p tmp/vlink/objects
	cd tmp/vlink; make
	mkdir -p usr/bin
	cp tmp/vlink/vlink usr/bin

usr/bin/vc: usr/bin/vlink
	mkdir -p tmp/vbcc/bin
	cd tmp/vbcc; make TARGET=m68k
	cd tmp/vbcc; make TARGET=m68ks
	mkdir -p usr/bin
	cp tmp/vbcc/bin/vbcc* tmp/vbcc/bin/vc tmp/vbcc/bin/vprof usr/bin
	#mv usr/m68k-amigaos usr/targets/

usr/config/aos68k: usr/bin/vc
	mv tmp/vbcc_target_m68k-amigaos/targets usr/
	mv tmp/config usr/
	touch usr/config/aos68k

