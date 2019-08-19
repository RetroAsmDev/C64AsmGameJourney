; ==============================================================================
; Zero page
; $00-$FF
; ==============================================================================
ZP_0         = $00      ; Reserved
ZP_1         = $01      ; Reserved

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
; Screen memory default location
; $0400-$0800
; ==============================================================================
SCREEN_MEMORY = $0400  

; ==============================================================================
; VIC-II SID, I/O, Color RAM or Character ROM
; $D000-$DFFF
; ==============================================================================

;  VIC-II Registers
RASTER_D012     = $D012 ; VIC-II Raster Control Register
VMCSB__D018     = $D018 ; VIC-II Memory control Register
EXTCOL_D020     = $D020 ; VIC-II Border Color Register

; CIA Registers
CIAICR_DC0D     = $DC0D ; CIA 1 Interrupt Control Register
CIANCR_DD0D     = $DD0D ; CIA 2 NMI Control Register
CI2PRA_DD00     = $DD00 ; Data Port Register A


; ==============================================================================
; Interrupt handlers addresses
; $FFFA-$FFFF
; ==============================================================================
IRQRCA_FFFE     = $FFFE ; There is an address of IRQ address, when KERNAL is not used
NMIRCA_FFFA     = $FFFA ; There is an address of NMI routine address, when KERNAL is not used


; IRQ/NMI routines addresses
;IRQRKA_0314     = $0314 ; There is an address of IRQ routine, if KERNAL is used
;IRQSAD_EA31     = $EA31 ; KERNAL routine we should jump to, if KERNAL is used   
