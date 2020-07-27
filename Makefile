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
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-l1.bin\" \"bin/manlegs-l1.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-l2.bin\" \"bin/manlegs-l2.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-l3.bin\" \"bin/manlegs-l3.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-l4.bin\" \"bin/manlegs-l4.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-l5.bin\" \"bin/manlegs-l5.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-l6.bin\" \"bin/manlegs-l6.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-r1.bin\" \"bin/manlegs-r1.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-r2.bin\" \"bin/manlegs-r2.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-r3.bin\" \"bin/manlegs-r3.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-r4.bin\" \"bin/manlegs-r4.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-r5.bin\" \"bin/manlegs-r5.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/manlegs-r6.bin\" \"bin/manlegs-r6.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/platform.bin\" \"bin/platform.bbc\" 12 12)"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/items.bin\" \"bin/items.bbc\" 1 2)"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/test.bin\" \"bin/test.bbc\" 1 2)"
	$(SNAP) org/jet-pac bin/platform.bbc 7680
	$(SNAP) org/jet-pac bin/fuel.bbc 1152
	$(SNAP) org/jet-pac bin/mantop-l.bbc 11648
	$(SNAP) org/jet-pac bin/mantop-r.bbc 11520
	$(SNAP) org/jet-pac bin/manlegs-l1.bbc 1664
	$(SNAP) org/jet-pac bin/manlegs-l2.bbc 1728
	$(SNAP) org/jet-pac bin/manlegs-l3.bbc 1792
	$(SNAP) org/jet-pac bin/manlegs-l4.bbc 1856
	$(SNAP) org/jet-pac bin/manlegs-l5.bbc 1920
	$(SNAP) org/jet-pac bin/manlegs-l6.bbc 1984
	$(SNAP) org/jet-pac bin/manlegs-r1.bbc 1280
	$(SNAP) org/jet-pac bin/manlegs-r2.bbc 1344
	$(SNAP) org/jet-pac bin/manlegs-r3.bbc 1408
	$(SNAP) org/jet-pac bin/manlegs-r4.bbc 1472
	$(SNAP) org/jet-pac bin/manlegs-r5.bbc 1536
	$(SNAP) org/jet-pac bin/manlegs-r6.bbc 1600
	$(SNAP) org/jet-pac bin/items.bbc 512
	$(SNAP) org/jet-pac bin/test.bbc 12032

clean:
	$(RM) $(OUTPUT_SSD)
	$(RM) bin\*.*

run:
	$(BEEBEM) $(BEEBEM_FLAGS) $(OUTPUT_SSD)
