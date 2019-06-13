PRJ_NAME = program

ASF_PATH = /Users/bigomc/Downloads/xdk-asf-3.46.0

#CROSS_COMPILE = arm-none-eabi-
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

# Strings for beautifying output
MSG_CLEAN_FILES         = "RM      *.o *.d"
MSG_CLEAN_DIRS          = "RMDIR   $(strip $(clean-dirs))"
MSG_CLEAN_DOC           = "RMDIR   $(docdir)"
MSG_MKDIR               = "MKDIR   $(dir $@)"

MSG_INFO                = "INFO    "
MSG_PREBUILD            = "PREBUILD  $(PREBUILD_CMD)"
MSG_POSTBUILD           = "POSTBUILD $(POSTBUILD_CMD)"

MSG_ARCHIVING           = "AR      $@"
MSG_ASSEMBLING          = "AS      $@"
MSG_BINARY_IMAGE        = "OBJCOPY $@"
MSG_COMPILING           = "CC      $@"
MSG_COMPILING_CXX       = "CXX     $@"
MSG_EXTENDED_LISTING    = "OBJDUMP $@"
MSG_IHEX_IMAGE          = "OBJCOPY $@"
MSG_LINKING             = "LN      $@"
MSG_PREPROCESSING       = "CPP     $@"
MSG_SIZE                = "SIZE    $@"
MSG_SYMBOL_TABLE        = "NM      $@"

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

linux: CONF ?= $@
	
arm: CONF ?= $@
	
linux: $(OBJ)
	@echo "Compiling for $(CONF)"
	$(shell test -d $(TDIR) || (mkdir -p $(TDIR)))
	$(CC) -o $(TDIR)/$(PRJ_NAME) $^ $(CFLAGS) $($LIBS)

arm: $(OBJ)
	@echo "Compiling for $(CONF)"
	@$(shell test -d $(TDIR) || (mkdir -p $(TDIR)))
	@echo $(MSG_LINKING)
	$(LD) -o $(TDIR)/$(PRJ_NAME) $^ $(LDFLAGS) -T $(LINKER_SCRIPT_FLASH)
	@echo $(MSG_SIZE)
	@$(SIZE) -Ax $(TDIR)/$(PRJ_NAME)
	@$(SIZE) -Bx $(TDIR)/$(PRJ_NAME)

$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
	$(shell test -d $(ODIR) || (mkdir -p $(ODIR)))
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean
clean:
	rm -rf $(TDIR)/ $(ODIR)/ *~ core $(IDIR)/*~