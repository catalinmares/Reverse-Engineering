CC=gcc
CFLAGS=-m32 -fno-stack-protector -nostartfiles -nostdlib -nodefaultlibs
SPEED_O=mystery.o mystery_speed.o
SIZE_O=mystery.o mystery_size.o
SPEED=mystery_speed
SIZE=mystery_size
TARGETS=$(SPEED) $(SIZE)

all: $(TARGETS)

%.o: %.asm
	nasm -f elf32 $<

$(SPEED): $(SPEED_O)
$(SIZE): $(SIZE_O)

$(SPEED) $(SIZE):
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f mystery_speed mystery_speed.o mystery_size mystery_size.o
