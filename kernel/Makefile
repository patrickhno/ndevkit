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

CC=../tools/vbcc/usr/bin/vc +aos68k -m68000 -Fhunk
LD=../tools/vbcc/usr/bin/vlink

LIBS = exec
LIB_OBJECTS = $(foreach lib,$(LIBS),libs/$(lib)/$(lib)_library.o)

OBJS_ROM = main.o $(LIB_OBJECTS)

all: rom.bin

clean:
	-for d in $(LIBS); do (cd libs/$$d; $(MAKE) clean ); done
	rm -f rom.bin
	rm -f $(OBJS_ROM)
	rm -f rom.o

libs/%.o: FORCE
	cd $(@D); make

%.o : %.s
	$(CC) -I/Users/patrick/develop/ndevkit/include -c $< -o $@

rom.o: $(OBJS_ROM)
	$(LD) -bamigahunk -r -o $@ $(OBJS_ROM)

rom.bin: rom.o
	$(LD) -brawbin1 -T rom.ld -o $@ rom.o

FORCE:
	true
