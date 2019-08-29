; ==============================================================================
; Zero page
; $00-$FF
; ==============================================================================
D6510_0000   = $00      ; Reserved
R6510_0001   = $01      ; Reserved

ZP_TMP_00    = $02      ; Temporary variables
ZP_TMP_01    = $03     
ZP_TMP_02    = $04     
ZP_TMP_03    = $05     
ZP_TMP_04    = $06     
ZP_TMP_05    = $07     
ZP_TMP_06    = $08     
ZP_TMP_07    = $09     
ZP_TMP_08    = $A0

; ==============================================================================
; Own character set
; $2800-$2BFF
; ==============================================================================

; Note!! Temporarily it is on address to make .prg smaller and loading faster
*=$1000
 incbin character_set.bin

; ==============================================================================
; Screen memory default location
; $0400-$0800
; ==============================================================================
SCREEN_MEMORY   = $F400  

; ==============================================================================
; VIC-II SID, I/O, Color RAM or Character ROM
; $D000-$DFFF
; ==============================================================================

CHARACTER_ROM   = $D000

;  VIC-II Registers
RASTER_D012     = $D012 ; VIC-II Raster Control Register
SCROLX_D016     = $D016 ; VIC-II Horizontal fine scrolling and control
VMCSB__D018     = $D018 ; VIC-II Memory control Register
EXTCOL_D020     = $D020 ; VIC-II Border Color Register

COLOR_RAM       = $D800 ; Address of 1000 bytes of color RAM

; CIA Registers
CIAICR_DC0D     = $DC0D ; CIA 1 Interrupt Control Register
CIANCR_DD0D     = $DD0D ; CIA 2 NMI Control Register
CI2PRA_DD00     = $DD00 ; Data Port Register A


CHARACTER_RAM   = $F800 ; Character RAM for bank 0 ($C000-$FFFF)

; ==============================================================================
; Hardware vectors
; $FFFA-$FFFF
; ==============================================================================
IRQRCA_FFFE     = $FFFE ; There is an address of IRQ address, when KERNAL is not used
NMIRCA_FFFA     = $FFFA ; There is an address of NMI routine address, when KERNAL is not used


; IRQ/NMI routines addresses
;IRQRKA_0314     = $0314 ; There is an address of IRQ routine, if KERNAL is used
;IRQSAD_EA31     = $EA31 ; KERNAL routine we should jump to, if KERNAL is used   