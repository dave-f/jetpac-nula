# Makefile for BBC Micro B JetPac NuLA Version
# 14 July 2020
#

BEEBEM       := C:/Dave/b2/b2_Debug
PNG2BBC      := ../png2bbc/Release/png2bbc.exe
EMACS        := c:/Emacs/emacs-27.pretest/bin/emacs.exe
SNAP         := ../snap/Release/snap.exe
BEEBEM_FLAGS := -0
BEEBASM      := ../../hg/beebasm/beebasm.exe
GAME_SSD     := res/blank.ssd
OUTPUT_SSD   := jetpac-nula.ssd
MAIN_ASM     := main.asm
RM           := del

#
# Generated graphics
GFX_OBJECTS := $(shell $(PNG2BBC) -l gfxscript)

#
# Phony targets
.PHONY: all clean run

all: $(OUTPUT_SSD)

$(OUTPUT_SSD): $(MAIN_ASM) Makefile
	$(BEEBASM) -i $(MAIN_ASM) -di $(GAME_SSD) -do $(OUTPUT_SSD)


#$(GFX_OBJECTS): gfxscript res/sheet.png
#	$(PNG2BBC) gfxscript
#   not sure this offset is correct
#	$(SNAP) org/jet-pac fuel.bin 1184
#	$(SNAP) org/jet-pac platform.bin 7680
#	$(SNAP) org/jet-pac pickup1.bbc 512

gfx:
	$(PNG2BBC) gfxscript
#   not sure this offset is correct
#	$(SNAP) org/jet-pac fuel.bin 1184
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(handle-item-graphic)"
	$(SNAP) org/jet-pac platform.bin 7680
	$(SNAP) org/jet-pac pickup1.bbc 512

clean:
	$(RM) $(OUTPUT_SSD)
	$(RM) $(GFX_OBJECTS)

run:
	$(BEEBEM) $(BEEBEM_FLAGS) $(OUTPUT_SSD)
