# Makefile for BBC Micro B JetPac NuLA Version
# 14 July 2020
#

BEEBEM       := C:/Dave/b2/b2_Debug
PNG2BBC      := ../png2bbc/png2bbc.exe
EMACS        := c:/Dave/Emacs-30.1/bin/emacs.exe
SNAP         := ../snap/snap.exe
BEEBEM_FLAGS := -b -0
BEEBASM      := ../beebasm/beebasm.exe
GAME_SSD     := res/blank.ssd
OUTPUT_SSD   := jetpac-nula.ssd
MAIN_ASM     := main.asm
LOGO_ASM     := logo.asm
RM           := del
CP           := copy

#
# Generated graphics
GFX_OBJECTS := $(shell $(PNG2BBC) -l gfxscript)

#
# Phony targets
.PHONY: all clean run gfx

all: $(OUTPUT_SSD)

$(OUTPUT_SSD): $(MAIN_ASM) $(LOGO_ASM) bin/game.pal Makefile loader.bas
	$(BEEBASM) -i $(MAIN_ASM) -di $(GAME_SSD) -do $(OUTPUT_SSD)

$(GFX_OBJECTS): gfxscript
	$(PNG2BBC) gfxscript

gfx:
	$(PNG2BBC) gfxscript
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/fuel.bin\" \"bin/fuel.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/items.bin\" \"bin/items.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/flames.bin\" \"bin/flames.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(reverse-graphic \"bin/explode.bin\" \"bin/explode.bbc\")"
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
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(remap-alien-colours \"bin/alien1.bin\" \"bin/alien1.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(remap-alien-colours \"bin/alien2.bin\" \"bin/alien2.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(remap-alien-colours \"bin/alien3.bin\" \"bin/alien3.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(remap-alien-colours \"bin/alien4.bin\" \"bin/alien4.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(remap-alien-colours \"bin/alien5.bin\" \"bin/alien5.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(remap-alien-colours \"bin/alien6.bin\" \"bin/alien6.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(remap-alien-colours \"bin/alien7.bin\" \"bin/alien7.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(remap-alien-colours \"bin/alien8.bin\" \"bin/alien8.bbc\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(create-new-alien-colour-tables \"bin/aliencol.bin\")"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(set-colour \"bin/game.pal\" 0 12 20 30)"
	$(CP) bin\game.pal.new bin\game.pal
	$(RM) bin\game.pal.new

#   Used to test player collision
#   -----------------------------
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/mantop-l.bin\" \"bin/mantop-l.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/mantop-r.bin\" \"bin/mantop-r.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-l1.bin\" \"bin/manlegs-l1.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-l2.bin\" \"bin/manlegs-l2.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-l3.bin\" \"bin/manlegs-l3.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-l4.bin\" \"bin/manlegs-l4.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-l5.bin\" \"bin/manlegs-l5.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-l6.bin\" \"bin/manlegs-l6.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-r1.bin\" \"bin/manlegs-r1.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-r2.bin\" \"bin/manlegs-r2.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-r3.bin\" \"bin/manlegs-r3.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-r4.bin\" \"bin/manlegs-r4.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-r5.bin\" \"bin/manlegs-r5.bbc\" 3 3)"
#	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(fill-graphic-with-colours \"bin/manlegs-r6.bin\" \"bin/manlegs-r6.bbc\" 3 3)"

	$(SNAP) org/jet-pac bin/platform.bin 7680 bin/jet-pac-nula
	$(SNAP) bin/jet-pac-nula bin/fuel.bbc 1152
	$(SNAP) bin/jet-pac-nula bin/mantop-l.bbc 11648
	$(SNAP) bin/jet-pac-nula bin/mantop-r.bbc 11520
	$(SNAP) bin/jet-pac-nula bin/manlegs-l1.bbc 1664
	$(SNAP) bin/jet-pac-nula bin/manlegs-l2.bbc 1728
	$(SNAP) bin/jet-pac-nula bin/manlegs-l3.bbc 1792
	$(SNAP) bin/jet-pac-nula bin/manlegs-l4.bbc 1856
	$(SNAP) bin/jet-pac-nula bin/manlegs-l5.bbc 1920
	$(SNAP) bin/jet-pac-nula bin/manlegs-l6.bbc 1984
	$(SNAP) bin/jet-pac-nula bin/manlegs-r1.bbc 1280
	$(SNAP) bin/jet-pac-nula bin/manlegs-r2.bbc 1344
	$(SNAP) bin/jet-pac-nula bin/manlegs-r3.bbc 1408
	$(SNAP) bin/jet-pac-nula bin/manlegs-r4.bbc 1472
	$(SNAP) bin/jet-pac-nula bin/manlegs-r5.bbc 1536
	$(SNAP) bin/jet-pac-nula bin/manlegs-r6.bbc 1600
	$(SNAP) bin/jet-pac-nula bin/items.bbc 512
	$(SNAP) bin/jet-pac-nula bin/flames.bbc 11776
	$(SNAP) bin/jet-pac-nula bin/explode.bbc 12544
#   Patch alien colour table
	$(SNAP) bin/jet-pac-nula bin/aliencol.bin 1056
#   Location of first alien
	$(SNAP) bin/jet-pac-nula bin/alien1.bbc 12032
	$(SNAP) bin/jet-pac-nula bin/alien4.bbc 12096
	$(SNAP) bin/jet-pac-nula bin/alien3.bbc 12160
	$(SNAP) bin/jet-pac-nula bin/alien2.bbc 12224
	$(SNAP) bin/jet-pac-nula bin/alien5.bbc 12288
	$(SNAP) bin/jet-pac-nula bin/alien6.bbc 12352
	$(SNAP) bin/jet-pac-nula bin/alien7.bbc 12416
	$(SNAP) bin/jet-pac-nula bin/alien8.bbc 12480

clean:
	$(RM) $(OUTPUT_SSD)
	$(RM) /Q bin\*.*

run:
	$(BEEBEM) $(BEEBEM_FLAGS) $(OUTPUT_SSD)
