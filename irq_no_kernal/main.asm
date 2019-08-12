;  Registers
RASTER_D012     = $D012 ; VIC-II Raster Control Register
EXTCOL_D020     = $D020 ; VIC-II Border Color Register
CIAICR_DC0D     = $DC0D ; CIA 1 Interrupt Control Register

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

        ; Set own IRQ and NMI routines
        lda #<MyIRQ
        sta IRQRCA_FFFE ; Little-endian => the least significant byte on lower memory position

        lda #>MyIRQ
        sta IRQRCA_FFFE+1

        lda #<MyNMI
        sta NMIRCA_FFFA

        lda #>MyNMI
        sta NMIRCA_FFFA+1

        ; Swap out ROMs
        lda #$35        ; Kernal out, BASIC out
        sta $01         ; Save ROM swap out
        

        cli

; -----------------------------
; Game loop
GameLoop  
          
        jmp GameLoop          

; -----------------------------
; NMI handler
MyNMI
        rti

; -----------------------------
; IRQ handler        
MyIRQ
        dec EXTCOL_D020 ; Change the border color

        lda CIAICR_DC0D ; Acknowledge CIA 1
        rti
 