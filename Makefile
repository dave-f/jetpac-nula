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
.PHONY: all clean run gfx

all: $(OUTPUT_SSD)

$(OUTPUT_SSD): $(MAIN_ASM) Makefile
	$(BEEBASM) -i $(MAIN_ASM) -di $(GAME_SSD) -do $(OUTPUT_SSD)

gfx:
	$(PNG2BBC) gfxscript
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(handle-item-graphic)"
	$(EMACS) -batch -Q --eval="(package-initialize)" -l repack.el --eval="(handle-fuel-graphic)"
#	$(SNAP) org/jet-pac platform.bin 7680
#	$(SNAP) org/jet-pac pickup1.bbc 512
#	$(SNAP) org/jet-pac fuel.bbc 1152
	$(SNAP) org/jet-pac mantop.bin 11520
#   $(SNAP) org/jet-pac manbot.bin 1280
#	$(SNAP) org/jet-pac flame.bbc 11776
#   $(SNAP) org/jet-pac aliens.bin 12544

clean:
	$(RM) $(OUTPUT_SSD)
	$(RM) $(GFX_OBJECTS)

run:
	$(BEEBEM) $(BEEBEM_FLAGS) $(OUTPUT_SSD)
