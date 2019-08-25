
; ====================================================================
;
; Clear screen
; Input: 
;  N/A
; Uses: 
;  ZP_TMP_00, ZP_TMP_01
; Preserves: A, X, Y
; Cycles: 11700-12200
;
; ====================================================================

clear_screen_slow

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
; Cycles: ?
;
; ====================================================================

clear_screen

        sta @atemp+1            ; Preserve AXY
        stx @xtemp+1
        sty @ytemp+1

        lda #$20

        ldx #$00                ; Reset X counter (0-255)
        ldy #$04                ; Reset Y counter (1-4) = we need to fill 1024 characters
                                ; which is 4*256
        
@loop256
        sta SCREEN_MEMORY,X     ; Print 256 characters
        ;txa
        inx 
        bne @loop256            ; Wait until it crosses $FF

        dey                     ; Decrease Y 
        beq @loop256_end        ; Exit if we reach 0
        
        inc @loop256+2          ; Self-modifying code - with every 256 characters
        jmp @loop256            ; we increase screen RAM address MSB to $500, $600 and $700

@loop256_end

@atemp  lda #$00                ; Restore AXY 
@xtemp  ldx #$00
@ytemp  ldy #$00
        
        rts

; ====================================================================
;
; Print string at X,Y
; Input: 
;  X = LSB address
;  Y = MSB address
; Uses: 
;  ZP_TMP_00 - ZP_TMP_03
; Preserves: A, X, Y
; Cycles: 
;
; ====================================================================
print_string_at_xy

        sta @atemp+1            ; Preserve AXY
        stx @xtemp+1
        sty @ytemp+1


        stx ZP_TMP_00           ; Store address of the passed structure to ZP
        sty ZP_TMP_01
        
        ldx #<SCREEN_MEMORY     ; Store address of the screen memory to ZP
        stx ZP_TMP_02           

        ldx #>SCREEN_MEMORY
        stx ZP_TMP_03


        lda (ZP_TMP_00,Y)       ; Check if the first character of the string is not NULL
        cmp #$00                ; (string can have zero length)
        beq @print_end    

        ldy #$00                ; Modify screen memory address based 
        lda (ZP_TMP_00,Y)       ; on the X value first
        sta ZP_TMP_02

; ----------------------------------------------
; Compute memory screen address (i.e. offset from base memory address) 
; based on X and Y positions

        ldy #$01                ; Load Y position into X
        lda (ZP_TMP_00,Y)
        tax
        cpx #$00                ; If Y is 0 skip 'y_screen_address' 
        beq @y_screen_address_end   

        lda ZP_TMP_02           ; Load X position into A

@y_screen_address
        clc
        adc #$28                ; Increase position by 40 characters
        sta ZP_TMP_02

        bcc @y_screen_address_cnt; If there is carry increase MSB

        inc ZP_TMP_03

@y_screen_address_cnt

        dex
        bne @y_screen_address

@y_screen_address_end       


        lda ZP_TMP_02           ; Modify the sceen address in 'print' loop
        sta @print+1


        lda ZP_TMP_03
        sta @print+2


        ldy #$02                ; Y is used in indirect indexed addressing
                                ; Note - we skip first two bytes - X & Y position

        lda (ZP_TMP_00,Y)       ; Check if the first character is not NULL,
        ldx #$00                ; X is used in absolute indiredct adressing

; ----------------------------------------------
; Print loop
@print                      
        sta  SCREEN_MEMORY,X    ; Store character in screen memory        
        inx                     ; Note: the address was modified in above code

        iny
        lda (ZP_TMP_00,Y)       ; Load next character
        
        bne @print

@print_end

@atemp  lda #$00        ; Restore AXY 
@xtemp  ldx #$00
@ytemp  ldy #$00
        
        rts


; ====================================================================
;
; Copy 1024 characters from ROM ($D800) to RAM highest address ($F800)
; Input: 
;  N/A
; Uses: 
;  N/A
; Preserves: A, X, Y
; Cycles: 
;
; ====================================================================

copy_rom_character_set

        sei

        lda R6510_0001          ; Swap in character ROM to $D800
        sta ZP_TMP_00 
        lda #$31                ; No BASIC, no KERNAL, character ROM 
        sta R6510_0001

        ldx #$04
        ldy #$00
        
@copy256

@@character_rom_instr
        lda CHARACTER_ROM,Y

@@character_ram_instr
        sta CHARACTER_RAM,Y

        iny
        bne @copy256

        inc @@character_rom_instr+2     ; Modify the address of the character
        inc @@character_ram_instr+2     ; ROM and RAM MSB by 1 for every 256 characters
        
        dex
        
        bne @copy256

        lda ZP_TMP_00          ; Resume memory state back
        sta R6510_0001 
        cli

        rts
