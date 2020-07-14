# Makefile for BBC Micro B JetPac NuLA Version
# 14 July 2020
#

BEEBEM       := C:/Dave/b2/b2_Debug
BEEBEM_FLAGS := -0
BEEBASM      := ../../hg/beebasm/beebasm.exe
GAME_SSD     := Disc007-JetPac.ssd
OUTPUT_SSD   := jetpac-nula.ssd
MAIN_ASM     := main.asm
RM           := del

#
# Phony targets
.PHONY: all clean run

all: $(OUTPUT_SSD)

$(OUTPUT_SSD): $(MAIN_ASM) Makefile
	$(BEEBASM) -i $(MAIN_ASM) -di $(GAME_SSD) -do $(OUTPUT_SSD)

clean:
	$(RM) $(OUTPUT_SSD)

run:
	$(BEEBEM) $(BEEBEM_FLAGS) $(OUTPUT_SSD)
