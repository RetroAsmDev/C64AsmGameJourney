;compile to this filename
!to "line_opt.prg",cbm

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

WaitFrame 
          lda #251 ; Pre-load line index 251
          ldx #2   ; Pre-load color
Line251
          cmp RASTER_D012   
          bne Line251
          
          stx EXTCOL_D020
          
          lda #252 ; Pre-load line index 252
          ldx #14  ; Pre-load color (light blu = default color)
Line252        
          cmp RASTER_D012
          bne Line252 
          
          stx EXTCOL_D020
          rts
