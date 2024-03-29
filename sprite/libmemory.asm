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

ZP_PAR_00    = $0A      ; Subroutine parameters
ZP_PAR_01    = $0B     
ZP_PAR_02    = $0C    
ZP_PAR_03    = $0D    
ZP_PAR_04    = $0E 
ZP_PAR_05    = $0F

; ==============================================================================
; Own character set
; $1000-$13FF -> 1024 bytes
; ==============================================================================

; Note!! Temporarily it is on address to make .prg smaller and loading faster
CHARACTER_PRG  = $1000

*=$1000
 incbin character_set.bin

; ==============================================================================
; Own sprites
; $1400-? -> ? bytes
; ==============================================================================

SPRITE_PRG  = $1400

*=SPRITE_PRG
 incbin warrior.bin


; ==============================================================================
; Screen memory default location
; $F400-$F7E7
; ==============================================================================
SCREEN_MEMORY   = $F400  

; ==============================================================================
; Pointers ro rge 
; $F7F8-$F7FF
; ==============================================================================
SPRITE_PTR_MEMORY  = $F7F8

; ==============================================================================
; VIC-II SID, I/O, Color RAM or Character ROM
; $D000-$DFFF
; ==============================================================================

CHARACTER_ROM   = $D000

;  VIC-II Registers
SP0X___D000     = $D000 ; Sprite 0 X Position
SP0Y___D001     = $D001 ; Sprite 0 Y Position 
MSIGX__D010     = $D010 ; The MSB bit of each of 8 sprites X-positons  
RASTER_D012     = $D012 ; Raster Control Register
SPENA__D015     = $D015 ; Sprite Enable Register
SCROLX_D016     = $D016 ; Horizontal fine scrolling and control
VMCSB__D018     = $D018 ; Memory Control Register
SPMC___D01C     = $D01C ; Sprite Multicolor Register
EXTCOL_D020     = $D020 ; Border Color Register
BGCOL0_D021     = $D021 ; Background color
SPMC0__D025     = $D025 ; Sprite Multicolor Register (01 bit-pair)
SPMC1__D026     = $D026 ; Sprite Multicolor Register (11 bit-pair)
SP0COL_D027     = $D027 ; Sprite 0 Color Register    (10 bit-pair)

COLOR_RAM       = $D800 ; Address of 1000 bytes of color RAM

; CIA Registers
CIAICR_DC0D     = $DC0D ; CIA 1 Interrupt Control Register
CIANCR_DD0D     = $DD0D ; CIA 2 NMI Control Register
CI2PRA_DD00     = $DD00 ; Data Port Register A

; Sprite memory offset in bank-3 is 8kB => the very first sprite address
; is 8192/64 = 128 ($80)
SPRITE_RAM      = $E000 ; Sprite memory

CHARACTER_RAM   = $F800 ; Character RAM for bank 0 ($C000-$FFFF)

; ==============================================================================
; Hardware vectors
; $FFFA-$FFFF
; ==============================================================================
IRQRCA_FFFE     = $FFFE ; There is an address of IRQ address, when KERNAL is not used
NMIRCA_FFFA     = $FFFA ; There is an address of NMI routine address, when KERNAL is not used


; ==============================================================================
; 
;               ========>>>>>>>> MY MEMORY MAP <<<<<<<<========
;
; ==============================================================================

; $FFFF         +-------------------------------------------------
; $FFFA - $FFFF ¦ HW vectors: 8 bytes   
;               +-------------------------------------------------
; $F800 - $FFF9 | Character memory: 2040 bytes 
;               ¦
; $F800         +-------------------------------------------------
; $F7E8 - $F7FF ¦ Sprite pointers memory: 8 bytes
; $F7E8         +-------------------------------------------------
; $F7E8 - $F7F7 ¦ Free: 16 bytes
; $F7E8         +-------------------------------------------------
; $F400 - $F7E7 ¦ Screen memory: 1000 bytes
; $F400         +-------------------------------------------------
; $E000 - $F399 ¦ Sprite memory: 5120?? bytes
;               +-------------------------------------------------
; $E000         +-> Here starts mapped KERNAL ROM: 8192 bytes
;               +-------------------------------------------------
; $D000 - DFFF  | I/O (CIA, SID, VIC-II) + color RAM: 4096 bytes 
;               ¦ 
;               ¦ 
; $D000         +-------------------------------------------------
; $C000 - $CFFF ¦ Free: 4096 bytes
;               ¦ 
;               ¦ 
; $C000 (bank 3)+-------------------------------------------------
; 
; ....
; 
; $2C00         +-------------------------------------------------
;               | Custom multi-color character set: 1kB
;               |            
; $2800 - 2BFF  |         
; $2800         +-------------------------------------------------
;               | Application code: 8kB
;               |            
;               |         
; $0801 - $27FF |                    
; $0800         +-------------------------------------------------
;               |            
; ....          | ??        
;               |           
;               +-----------------------------------------------       
; $0002 - $00FF ¦ Zero page 
; $0002         +----------------------------------------------- 
; $0000 - $0001 | D6510, R6510
; $0000         +------------------------------------------------



; ==============================================================================
; 
;             ========>>>>>>>> MC COLOR TABLE <<<<<<<<========
;
; ==============================================================================

;Character:
;00 | Background (transparent) color | $D021
;01 | Shared color 1                 | $D022
;10 | Shared color 2                 | $D023                                                                       
;11 | Color RAM                      | $D800

;Note that colors must have set bit #3 to 1: XXXX1CCC, while high nibble remains unused


;Sprite:
;00 | Background (transparent) color | $D021
;01 | Shared color 1                 | $D025
;11 | Shared color 2                 | $D026                                                                       
;10 | Individual color               | $D027-$D02E
