*=$0801

        ; Tokenized command 10 SYS 2064 (=$810)
        ; SYS that tells the C64 to execute the machine language subroutine at a specific address
        BYTE $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00,$00,$00


        sei     ; Disabling maskabke IRQs is necessary, so we can safely change the address
                ; of the interrupt service routine

        lda #%01111111  ; Disable both CIA interrupts
        sta CIAICR_DC0D
        sta CIANCR_DD0D

        lda CIAICR_DC0D ; Acknowledge both CIA interrupts (if there are any)
        lda CIANCR_DD0D
        

        ; Set own IRQ and NMI routines
        lda #<my_IRQ
        sta IRQRCA_FFFE

        lda #>my_IRQ
        sta IRQRCA_FFFE+1

        lda #<my_NMI
        sta NMIRCA_FFFA

        lda #>my_NMI
        sta NMIRCA_FFFA+1

        
        ; Swap out ROMs
        lda #$35        ; Kernal out, BASIC out
        sta R6510_0001
        
        ; Set memory screen address to $3400 (upper nibble - %1101)
        ; and character memory to $3800 (bit 1-3 = 111)
        lda VMCSB__D018
        and #%00000001  ; Reset upper 4 bits (nibble) and preserve bottom nibble value
        ora #%11011110  ; Set upper nibble
        sta VMCSB__D018

        ; Set VIC-II bank to bank 3 - $C000-$FFFF (bit 0 and 1: 00)
        lda CI2PRA_DD00
        and #%11111100
        ora #%00000000
        sta CI2PRA_DD00

        cli

        jsr copy_own_character_set      ; Copy multi-color ready charset to the
                                        ; final location $F800 
        
        jsr clear_screen                ; Clear screen
        
        ldx #<str_hello_world           ; Print "Hello World!"
        ldy #>str_hello_world
        jsr print_string_at_xy

        ldx #$00

@multi_color_loop                       ; Bit 3 of every multicolor character in color
                                        ; RAM has to be set to 1
        txa
        ora #%0001000
        ;and #%1110111
        sta COLOR_RAM + $19d,X

        inx                             ; Index in the string
        cpx #$10                        ; Length of 'Hello World!' 
        bne @multi_color_loop

        lda SCROLX_D016                 ; Set multicolor mode on
        ora #%00010000
        sta SCROLX_D016

; ----------------------------------------------------------
; Game loop
game_loop  
        
        ; Update the game state

        ; dec EXTCOL_D020 ; Change the border color

        ; Change the "Hello world!" color

        ldx #$00     
        

        ; Start busy waiting for raster line 251
        jsr wait_frame
        
        jmp game_loop          


; ----------------------------------------------------------
; Busy waiting for raster to reach line 251 ($FB)

wait_frame

        lda #$FB

@wait_frame1             ; If the game loop was finished too fast we should wait
        cmp RASTER_D012
        beq @wait_frame1

@wait_frame2         
        cmp RASTER_D012 ; Wait until the line is renderred
        bne @wait_frame2

        rts

; ----------------------------------------------------------
; NMI handler
my_NMI
        ;dec EXTCOL_D020 ; Change the border color
        rti

; ----------------------------------------------------------
; IRQ handler        
my_IRQ
        ;dec EXTCOL_D020 ; Change the border color
        rti


; ----------------------------------------------------------
; Data

str_hello_world

        byte 13,10
        text '0123456701234567'
        byte 0

character_set
        word $D800




 