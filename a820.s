; Memory Locations:
; $7d80 - Mario Items
; $7da3 - Luigi Items
; $03dd - P-Speed
; $7ea0 - $7ea3 - Cooldowns
; $7ea4 - $7ea7- Cheat Settings
; $071f - Bank 1
; $0720 - Bank 2
; $ffbf - Bank Changing Subroutine

jsr $e240 ; Jump to the cheats
nop