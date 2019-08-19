
; ====================================================================
;
; Clear screen
; Input: 
;  N/A
; Uses: 
;  ZP_TMP_00, ZP_TMP_01
; Preserves: A, X, Y
; Cycles:
;
; ====================================================================

clrscr

        sta @atemp+1            ; Preserve AXY
        stx @xtemp+1
        sty @ytemp+1

        lda #<SCREEN_MEMORY     ; Memory screen LSB
        sta ZP_TMP_00

        lda #>SCREEN_MEMORY     ; Memory screen MSB
        sta ZP_TMP_01

        lda #$20

        ldy #$00        ; Reset Y counter (0-255)
        ldx #$04        ; Reset X counter (1-4) = we need to fill 1024 characters
                        ; which is 4*256
        
@loop256
        sta (ZP_TMP_00),y       ; Print 256 characters
        iny 
        bne @loop256            ; Wait until it crosses $FF

        dex                     ; Decrease X 
        beq @loop256_end
        
        inc ZP_TMP_01           ; With every 256 characters increase MSB:
        jmp @loop256            ; $400, $500, $600, $700

@loop256_end

@atemp  lda #$00        ; Restore AXY 
@xtemp  ldx #$00
@ytemp  ldy #$00
        
        rts


; ====================================================================
;
; Clear screen (fast)
; Input: 
;  N/A
; Uses: 
;  N/A
; Preserves: A, X, Y
; Cycles:
;
; ====================================================================

clrscr2

        sta @atemp+1            ; Preserve AXY
        stx @xtemp+1
        sty @ytemp+1

        lda #$20

        ldx #$00        ; Reset X counter (0-255)
        ldy #$03        ; Reset Y counter (1-4) = we need to fill 1024 characters
                        ; which is 4*256
        
@loop256
        sta SCREEN_MEMORY,X     ; Print 256 characters
        inx 
        bne @loop256            ; Wait until it crosses $FF

        dey                     ; Decrease Y 
        beq @loop256_end        ; Exit if we reach 0
        
        inc @loop256+2          ; Self-modifying code - with every 256 characters
        jmp @loop256            ; we increase screen RAM address MSB to $500, $600 and $700

@loop256_end

@atemp  lda #$00        ; Restore AXY 
@xtemp  ldx #$00
@ytemp  ldy #$00
        
        rts