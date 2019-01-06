	device zxspectrum48

	org #4000
	incbin "font2.scr"

	org	#6000
SnaStart:
	ld ix,#c000
	exx
	ld hl,#d000
	exx
zaLOOP:
	call currentprint

	call selectsprite

	call pushselsprite

	ld a,(curpr+1)
	inc a
	ld (curpr+1),a
	cp "["
	jr nz,zaLOOP
	jr $

currentprint:
	ld a,#16
	rst #10
	ld a,4
	rst #10
	ld a,4
	rst #10

	ld a,#10
	rst #10
	ld a,#07
	rst #10

	ld a,#11
	rst #10
	ld a,#00
	rst #10
curpr:
	ld a," "
	rst #10
	ret

selectsprite:
cur_y:
	ld h,0
cur_x:
	ld l,0
	call hl2scr
	call scr2attr
	call boxor
	halt
	ld a,(cur_x+1)
	ld l,a
	ld a,(cur_y+1)
	ld h,a
	call hl2scr
	call scr2attr
	call boxor

	ld bc,#effe
	in a,(c)
	rrca
	ret nc
	rrca
	jp nc,dec_y
	rrca
	jp nc,inc_y
	rrca
	jp nc,inc_x
	rrca
	jp nc,dec_x

	ld bc,#fefe
	in a,(c)
	rrca
	rrca
	jp nc,dec_len
	rrca
	jp nc,inc_len

	jr selectsprite
	ret

dec_len
	ld a,(cur_len+1)
	cp 1
	jp z,selectsprite
	dec a
	halt
	halt
	halt
	ld (cur_len+1),a
	jp selectsprite
inc_len
	ld a,(cur_len+1)
	inc a
	halt
	halt
	halt
	ld (cur_len+1),a
	jp selectsprite
dec_x
	ld a,(cur_x+1)
	or a
	jp z,selectsprite
	dec a
	halt
	halt
	halt
	ld (cur_x+1),a
	jp selectsprite
inc_x
	ld a,(cur_x+1)
	inc a
	halt
	halt
	halt
	ld (cur_x+1),a
	jp selectsprite
dec_y
	ld a,(cur_y+1)
	or a
	jp z,selectsprite
	dec a
	halt
	halt
	halt
	ld (cur_y+1),a
	jp selectsprite
inc_y
	ld a,(cur_y+1)
	inc a
	halt
	halt
	halt
	ld (cur_y+1),a
	jp selectsprite

pushselsprite
	ld b,10
.l0	halt
	djnz .l0

	exx
	ld (ix+00),l
	inc ix
	ld (ix+00),h
	inc ix
	ld a,(cur_len+1)
	ld (hl),a
	inc hl
	exx

	ld a,(cur_x+1)
	ld l,a
	ld a,(cur_y+1)
	ld h,a
	call hl2scr

	ld a,(cur_len+1)
	ld b,a
.l1	push bc
	push hl
	ld b,6
.l2	push bc
	push hl
	call finder

	ld a,c
	exx
	ld (hl),a
	inc hl
	exx

	pop hl
	ld a,l
	add #20
	ld l,a
	jr nc,.l3
	ld a,h
	add #8
	ld h,a
.l3	pop bc
	djnz .l2

	pop hl
	inc l
	pop bc
	djnz .l1
	ret

finder:
	ld (.l0+1),hl
	ld de,#f000
	ld c,0
.l0	ld hl,#face
	dup 7
	ld a,(de)
	cp (hl)
	jp nz,.l1
	inc h
	inc de
	edup
	ld a,(de)
	cp (hl)
	jp nz,.l1
	ret
.l1	inc c
	ld a,e
	and %11111000
	ld e,a
	ld hl,#8
	add hl,de
	ex de,hl
	jr .l0

boxor:
cur_len:
	ld b,2
.l0:
	push hl
	ld c,6
.l1:
	ld a,%01000111
	xor (hl)
	ld (hl),a
	ld de,#20
	add hl,de
	dec c
	jr nz,.l1
	pop hl
	inc l
	djnz .l0
	ret

hl2scr:
	ld  a,h
	rrca
	rrca
	rrca
	and #E0
	or  l
	ld  l,a
	ld  a,h
	and #18
	or  #40
	ld  h,a
	ret
scr2attr:
	ld  a,h
	rra
	rra
	rra
	and #03
	or  #58
	ld  h,a
	ret

	org #f000
fontile:
	incbin "fontile.bin"
	savesna "konvert2.sna",SnaStart