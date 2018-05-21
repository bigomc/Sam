PRJ_NAME = program

CROSS_COMPILE = arm-none-eabi-
CC		= $(CROSS_COMPILE)gcc
AR		= $(CROSS_COMPILE)ar
AS		= $(CROSS_COMPILE)as
CPP		= $(CROSS_COMPILE)gcc -E
CXX		= $(CROSS_COMPILE)g++
LD		= $(CROSS_COMPILE)g++
NM		= $(CROSS_COMPILE)nm
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump
SIZE		= $(CROSS_COMPILE)size
GDB		= $(CROSS_COMPILE)gdb

CFLAGS = -Wall -I$(IDIR)
LDFLAGS = -Map $(PRJ_NAME).map -T viperlite.ld -N

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

all: $(OBJ)
	$(shell test -d $(TDIR) || (mkdir -p $(TDIR)))
	$(CC) -o $(TDIR)/$(PRJ_NAME) $^ $(CFLAGS) $(LIBS)

arm: $(OBJ)
	$(shell test -d $(TDIR) || (mkdir -p $(TDIR)))
	$(LD) -o $(TDIR)/$(PRJ_NAME) $^ $(CFLAGS) $(LIBS)

$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
	$(shell test -d $(ODIR) || (mkdir -p $(ODIR)))
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean

clean:
	rm -rf $(TDIR)/ $(ODIR)/ *~ core $(IDIR)/*~
