RASTER_D012     = $D012
EXTCOL_D020     = $D020 
IRQRAD_0314     = $0314
IRQSAD_EA31     = $EA31


*=$0801

        ; Tokenized command 10 SYS 2064 (=$810)
        ; SYS that tells the C64 to execute the machine language subroutine at a specific address
        BYTE $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00,$00,$00


        sei     ; Disabling maskabke IRQs is necessary, so we can safely change the address
                ; of the interrupt service routine

        lda #<MyIRQ
        sta IRQRAD_0314 ; Little-endian => the least significant byte on lower memory position

        lda #>MyIRQ
        sta IRQRAD_0314+1
        
        cli

GameLoop  
          
        jmp GameLoop          

        
MyIRQ
        dec EXTCOL_D020 ; Changge the border color
        jmp IRQSAD_EA31 ; Go to the KERNAL IRQ service routine
