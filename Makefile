CC = cc
CC_FOR_BUILD = cc

SOURCE = patch.c offsetfinder.c payload.c

UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
ARCH = -arch x86_64 -arch arm64
else
ARCH =
endif

CFLAGS = -fcommon

BIN = iBootpatch2

VERSION = $(shell git rev-parse HEAD | tr -d '\n')-$(shell git rev-list --count HEAD | tr -d '\n')

.PHONY: all clean

all: $(BIN)

$(BIN): $(SOURCE)
	$(CC) $(SOURCE) $(ARCH) $(CFLAGS) -DVERSION=\"$(VERSION)\" -o $(BIN)

vmacho:
	$(CC_FOR_BUILD) -o vmacho vmacho.c

clean:
	-$(RM) $(BIN) *.o *.bin vmacho
