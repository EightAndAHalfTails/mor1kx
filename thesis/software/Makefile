CROSSCOMPILE=/comelec/softs/opt/gnu_tools_for_or1k/bin/or1k-elf-
LD=$(CROSSCOMPILE)ld
AS=$(CROSSCOMPILE)as
CC=$(CROSSCOMPILE)gcc

CFLAGS = -nostdinc -g -Wall -O0
ASFLAGS = -g

EXE = hello
OBJS = hello.o crt0.o

all: $(EXE) $(EXE).lst $(EXE).map

$(EXE) $(EXE).map: $(OBJS) ldscript.lds
	$(LD) -T ldscript.lds $(OBJS) -o $@ --cref --print-map > $(EXE).map

%.lst: %
	$(CROSSCOMPILE)objdump -S $< > $@

clean:
	rm -f $(OBJS) $(EXE) $(EXE).lst $(EXE).map *~
