	device zxspectrum128
	org	#6000
SnaStart:

obragen:
	ld hl,obratka
.l0	ld a,l
	ld b,8
.l1	rrca
	rl (hl)
	djnz .l1
	inc l
	jr nz,.l0

revespr:
	ld b,#60
	ld ix,exosprite2-1
	ld de,exosprite2
	ld h,high obratka
.l0:
	ld l,(ix+0)
	ld a,(hl)
	ld (de),a
	dec ix
	inc de
	djnz .l0



	ei
	xor a
	out (#fe),a
TheLoopa
	halt
	jr TheLoopa

	align #1000
exosprite:
	incbin "exxxolon.bin"
	display $-exosprite
exosprite2:
	align #1000
obratka

	savesna "reverse.sna",SnaStart
