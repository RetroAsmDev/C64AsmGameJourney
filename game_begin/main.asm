;  VIC-II Registers
RASTER_D012     = $D012 ; VIC-II Raster Control Register
VMCSB__D018     = $D018 ; VIC-II Memory control Register
EXTCOL_D020     = $D020 ; VIC-II Border Color Register

; CIA Registers
CIAICR_DC0D     = $DC0D ; CIA 1 Interrupt Control Register
CIANCR_DD0D     = $DD0D ; CIA 2 NMI Control Register
CI2PRA_DD00     = $DD00 ; Data Port Register A

; IRQ/NMI routines addresses
IRQRKA_0314     = $0314 ; There is an address of IRQ routine, if KERNAL is used
IRQSAD_EA31     = $EA31 ; KERNAL routine we should jump to, if KERNAL is used   

IRQRCA_FFFE     = $FFFE ; There is an address of IRQ address, when KERNAL is not used
NMIRCA_FFFA     = $FFFA ; There is an address of NMI routine address, when KERNAL is not used


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
        
        ; Set memory screen address to $0400 (default anyway:)
        lda VMCSB__D018
        ora #%00010000
        sta VMCSB__D018

        ; Set VIC-II bank to bank 0 - $0000 (default anyway:)
        lda CI2PRA_DD00
        ora #%00000011
        sta CI2PRA_DD00

        cli

; ----------------------------------------------------------
; Game loop
GameLoop  
        
        ; Update the game state

        dec EXTCOL_D020 ; Change the border color
        inc $0400       

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
       ; dec EXTCOL_D020 ; Change the border color
        rti

; ----------------------------------------------------------
; IRQ handler        
MyIRQ
       ; dec EXTCOL_D020 ; Change the border color
        rti
 