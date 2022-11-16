; Memory Locations:
; $7d80 - Mario Items
; $7da3 - Luigi Items
; $03dd - P-Speed
; $0120 - Cooldowns
; $0130 - Cheat Settings
; $071f - Bank 1
; $0720 - Bank 2
; $ffd1 - Bank Changing Subroutine

start:
    txa ; Push the values of the registers on the stack
    pha
    tya
    pha
    lda $071f ; Old bank
    pha
    ldx #0
    stx $1c ; Code that was removed from $96ff
    ; Give Mario and Luigi every item
    lda #1
    item_loop:
        sta $7d80,x
        sta $7da3,x
        clc
        adc #1
        inx
        cpx #$0d
        bne item_loop
    ; Give Mario and Luigi infinite lives
    infinite_lives:
        lda #99
        sta $736
        sta $737
    ; Load PRG-25 and jump to the rest of the cheats
    lda #25
    sta $071f
    jsr $ffd1
    jsr $d530
end:
    pla ; Pull the values of the registers from the stack
    sta $071f ; Go back to old bank
    jsr $ffd1
    pla
    tay
    pla
    tax
    rts