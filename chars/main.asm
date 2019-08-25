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
        sta $01         ; Save ROM swap out
        
        ; Set memory screen address to $0400 (upper nibble - %0001)
        lda VMCSB__D018
        and #%00001111  ; Reset upper 4 bits (nibble) and preserve bottom nibble value
        ora #%00010000  ; Set upper nibble
        sta VMCSB__D018

        ; Set VIC-II bank to bank 0 - $0000-$3FFF (bit 0 and 1: 11)
        lda CI2PRA_DD00
        and #%11111100
        ora #%00000011
        sta CI2PRA_DD00

        cli

        
        jsr clear_screen        ; Clear screen
        
        ldx #<str_hello_world   ; Print "Hello World!"
        ldy #>str_hello_world
        jsr print_string_at_xy
        
        

; ----------------------------------------------------------
; Game loop
game_loop  
        
        ; Update the game state

        dec EXTCOL_D020 ; Change the border color
        ;lda #$20 
        ;inc $0400         
        

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
        text 'Hello World!'
        byte 0




 