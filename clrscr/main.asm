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
        lda #<MyIRQ
        sta IRQRCA_FFFE

        lda #>MyIRQ
        sta IRQRCA_FFFE+1

        lda #<MyNMI
        sta NMIRCA_FFFA

        lda #>MyNMI
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

        jsr clrscr2
        

        ;jmp  *  
        


; ----------------------------------------------------------
; Game loop
GameLoop  
        
        ; Update the game state

        dec EXTCOL_D020 ; Change the border color
        ;lda #$20 
        ;sta $A000       ; Screen memory address: $2000 = bank 0, $A000 = bank 2       
        

        ; Start busy waiting for raster line 251
        jsr WaitFrame
        
        jmp GameLoop          


; ----------------------------------------------------------
; Busy waiting for raster to reach line 251 ($FB)

WaitFrame

        lda #$FB

@WaitFrame1             ; If the game loop was finished too fast we should wait
        cmp RASTER_D012
        beq @WaitFrame1

@WaitFrame2         
        cmp RASTER_D012 ; Wait until the line is renderred
        bne @WaitFrame2

        rts

; ----------------------------------------------------------
; NMI handler
MyNMI
        ;dec EXTCOL_D020 ; Change the border color
        rti

; ----------------------------------------------------------
; IRQ handler        
MyIRQ
        ;dec EXTCOL_D020 ; Change the border color
        rti
 