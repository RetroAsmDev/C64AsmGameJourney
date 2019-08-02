;compile to this filename
!to "line.prg",cbm

RASTER_D012      = $D012
EXTCOL_D020      = $D020 

;this creates a basic start
*=$0801

          ; 10 SYS 2064 
          ; Tokenized command 10 SYS 2064 (=$810)
          ; SYS that tells the processor to execute the machine language subroutine at a specific address
          !byte $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00,$00,$00
          
          ; Here the game logic has to be done during the VBLANK interval 
GameLoop  
          
          jsr WaitFrame ; If the game logic is finished, go wait for next VBLANK
          jmp GameLoop          

!zone .Line251 
WaitFrame
          lda RASTER_D012 ; Check on line index electron beam is scanning
          cmp #$FB        ; Line 251
          beq .Line251     
          
          cmp #$FC        ; Line 252
          bne WaitFrame 
          
          lda #14
          sta EXTCOL_D020 ; Change color back to 14 = Light Blue (default C64 border color)
          rts
          
.Line251
          lda #2         
          sta EXTCOL_D020 ; Change color to red
          jmp WaitFrame