# Makefile for BBC Micro B JetPac NuLA Version
# 14 July 2020
#

BEEBEM       := C:/Dave/b2/b2_Debug
PNG2BBC      := ../png2bbc/Release/png2bbc.exe
EMACS        := c:/Dave/Emacs-27.1/bin/emacs.exe
SNAP         := ../snap/Release/snap.exe
BEEBEM_FLAGS := -b -0
BEEBASM      := ../beebasm/beebasm.exe
GAME_SSD     := res/blank.ssd
OUTPUT_SSD   := jetpac-nula.ssd
MAIN_ASM     := main.asm
RM           := del

#
# Generated graphics
GFX_OBJECTS := $(shell $(PNG2BBC) -l gfxscript)

#
# Phony targets
.PHONY: all clean run gfx

all: $(OUTPUT_SSD)

$(OUTPUT_SSD): $(MAIN_ASM) bin/pal.bin Makefile
	$(BEEBASM) -i $(MAIN_ASM) -di $(GAME_SSD) -do $(OUTPUT_SSD)

$(GFX_OBJECTS): gfxscript
	$(PNG2BBC) gfxscript

gfx:
	$(PNG2BBC) gfxscript
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/fuel.bin\" \"bin/fuel.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/mantop-l.bin\" \"bin/mantop-l.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/mantop-r.bin\" \"bin/mantop-r.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/platform.bin\" \"bin/platform.bbc\" 11 11)"
	$(SNAP) org/jet-pac bin/platform.bbc 7680
	$(SNAP) org/jet-pac bin/fuel.bbc 1152
	$(SNAP) org/jet-pac bin/mantop-l.bbc 11648
	$(SNAP) org/jet-pac bin/mantop-r.bbc 11520

clean:
	$(RM) $(OUTPUT_SSD)
	$(RM) bin\*.*

run:
	$(BEEBEM) $(BEEBEM_FLAGS) $(OUTPUT_SSD)
