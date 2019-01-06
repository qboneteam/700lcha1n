	device zxspectrum128

	org #4000
	incbin "font2.scr"

	org	#6000
SnaStart:
	ld hl,#4000
.l1	push hl
	call find
	pop hl
	inc l
	jr nz,.l0
	ld a,h
	add 8
	ld h,a
.l0 ld a,h
	cp #58
	jr nz,.l1

	jr $

find:
	ld a,1
tileaddr:
	ld de,tiles
	ld (tuthl+1),hl
	ld b,a
tuthl
	ld hl,#dead
	dup 7
		ld a,(de)
		cp (hl)
		jr nz,nepohozh
		inc h
		inc de
	edup
		ld a,(de)
		cp (hl)
		jr nz,nepohozh
	ret
nepohozh
	ld a,e
	and %11111000
	ld e,a
	ld hl,#08
	add hl,de
	ex de,hl
	djnz tuthl

	ld hl,(tuthl+1)
	dup 8
		ld a,(hl)
		ld (de),a
		inc h
		inc de
	edup
	ld a,(find+1)
	inc a
	ld (find+1),a

	ret





	org #c000
tiles:
	ds 8
	savesna "konvert.sna",SnaStart