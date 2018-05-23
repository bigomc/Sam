PRJ_NAME = program

ASF_PATH = asf

CROSS_COMPILE = arm-none-eabi-
CC		= $(CROSS_COMPILE)gcc
AR		= $(CROSS_COMPILE)ar
AS		= $(CROSS_COMPILE)as
CPP		= $(CROSS_COMPILE)gcc -E
CXX		= $(CROSS_COMPILE)g++
LD		= $(CROSS_COMPILE)ld
NM		= $(CROSS_COMPILE)nm
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump
SIZE		= $(CROSS_COMPILE)size
GDB		= $(CROSS_COMPILE)gdb

# Path relative to top level directory pointing to a linker script.
LINKER_SCRIPT_FLASH = $(ASF_PATH)/sam0/utils/linker_scripts/samc21/gcc/samc21j18a_flash.ld
LINKER_SCRIPT_SRAM  = $(ASF_PATH)/sam0/utils/linker_scripts/samc21/gcc/samc21j18a_sram.ld

CFLAGS = -Wall -I$(IDIR)
LDFLAGS = -Map $(TDIR)/$(PRJ_NAME).map -N

SDIR = source
IDIR = include
ODIR = obj
LDIR = lib
TDIR = debug

LIBS = -lm

_DEPS = test.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

_OBJ = test.o main.o 
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

linux: $(OBJ)
	$(shell test -d $(TDIR) || (mkdir -p $(TDIR)))
	$(LD) -o $(TDIR)/$(PRJ_NAME) $^ $(LDFLAGS)

arm: $(OBJ)
	$(shell test -d $(TDIR) || (mkdir -p $(TDIR)))
	$(LD) -o $(TDIR)/$(PRJ_NAME) $^ $(LDFLAGS) -T $(LINKER_SCRIPT_FLASH)

$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
	$(shell test -d $(ODIR) || (mkdir -p $(ODIR)))
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean

clean:
	rm -rf $(TDIR)/ $(ODIR)/ *~ core $(IDIR)/*~
