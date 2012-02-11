# Copyright (c) 2012 Patrick Hanevold.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

usr/config/aos68k: usr/bin/vc
	mv tmp/vbcc_target_m68k-amigaos/targets usr/
	mv tmp/config usr/
	touch usr/config/aos68k

