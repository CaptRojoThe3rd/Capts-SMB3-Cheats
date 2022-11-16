; Memory Locations:
; $7d80 - Mario Items
; $7da3 - Luigi Items
; $03dd - P-Speed
; $7ea0 - $7ea3 - Cooldowns
; $7ea4 - $7ea7 - Cheat Settings
; $071f - Bank 1
; $0720 - Bank 2
; $ffbf - Bank Changing Subroutine
; $7e10-$7e7f - "ACE"

start:
    ; Button cooldowns (so the cheats aren't toggled every frame)
    dec_cooldowns:
        ldx #$ff
        cooldown_loop:
            inx
            cpx #4
            beq p_speed_cheat
            lda $7ea0,x
            cmp #0
            beq cooldown_loop
            dec $7ea0,x
            jmp cooldown_loop
    ; Infinite P-Speed cheat (SELECT + B on controller 1)
    p_speed_cheat:
        lda $7ea4
        cmp #1
        bne skip_p_speed_set
        lda #$7f
        sta $03dd
        lda #$ff
        sta $056e
        skip_p_speed_set:
        lda $17
        cmp #$60
        bne skip_p_speed_input
        lda $7ea0
        cmp #0
        bne skip_p_speed_input
        lda $7ea4
        eor #1
        sta $7ea4
        ldx #60
        stx $7ea0
        skip_p_speed_input:
    ; Invincibility cheat (SELECT + A on controller 1)
    invincibility_cheat:
        lda $7ea5
        cmp #1
        bne skip_invincibility_set
        lda #5
        sta $553
        skip_invincibility_set:
        lda $17
        cmp #$a0
        bne skip_invincibility_input
        lda $7ea1
        cmp #0
        bne skip_invincibility_input
        lda $7ea5
        eor #1
        sta $7ea5
        ldy #0 ; If invincibility is turned on, set it so player appears invincible on the map and the music will start
        sty $03f2
        cmp #1
        bne skip_invincibility_map
        sta $03f2
        skip_invincibility_map:
        ldx #60
        stx $7ea1
        skip_invincibility_input:
    ; Infinite time cheat
    infinite_time:
        ldx #0
        lda $bd
        cmp #$14
        beq skip_infinite_time
        lda $17
        and #$20
        cmp #$20
        beq skip_infinite_time
        lda #09
        sta $05ee
        sta $05ef
        sta $05f0
        skip_infinite_time:
    ; Change world number
    increase_world:
        lda $7ea3
        cmp #0
        bne skip_increase_world
        lda $17
        cmp #$18
        bne skip_increase_world
        lda #60
        sta $7ea3
        jsr $9080
        skip_increase_world:
    decrease_world:
        lda $7ea3
        cmp #0
        bne skip_decrease_world
        lda $17
        cmp #$14
        bne skip_decrease_world
        lda #60
        sta $7ea3
        dec $0727
        dec $0727
        jsr $9080
        skip_decrease_world:
    ; "ACE"
    lda #$60
    sta $7e80
    reset_ace:
        lda $17
        cmp #$b0
        bne reset_ace_end
        lda #$ea
        ldx #0
        stx $7e0f
        reset_ace_loop:
            sta $7e10,x
            inx
            cpx #$70
            bne reset_ace_loop
        stx $7e0f
        reset_ace_end:
    run_ace:
        lda $17
        cmp #$70
        bne end_run_ace
        jsr $7e10
        end_run_ace:
    add_to_ace:
        lda $17
        cmp #$31
        bne end_add_to_ace
        lda $7ea8
        cmp $f8
        beq end_add_to_ace
        lda $f8
        ldx $7e0f
        sta $7e10,x
        sta $7ea8
        inc $7e0f
        end_add_to_ace:
    lda $f8
    sta $7e90
    lda $17
    cmp #$11
    beq inc_add_to_ace
    lda #0
    sta $7ea6
    inc_add_to_ace:
        lda $17
        cmp #$11
        bne skip_inc_ace
        lda $7ea6
        cmp $17
        beq skip_inc_ace
        lda $17
        sta $7ea6
        ldx $7e0f
        dex
        inc $7e10,x
        skip_inc_ace:
    ; If ACE location is $70, reset it
    ldx $7e0f
    cpx #$70
    bne skip_reset_ace_location
    ldx #0
    stx $7e0f
    skip_reset_ace_location:
end:
    rts