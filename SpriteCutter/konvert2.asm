	DEVICE ZXSPECTRUM128
	org #4000
	incbin "spr2.scr"

	org	#6000
SnaStart:
	ei
zaLOOP:
	call selectsprite

	call pushselsprite

	jr $

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

	ld bc,#fbfe
	in a,(c)
	rrca
	jp nc,dec_visota

	ld bc,#fdfe
	in a,(c)
	rrca
	jp nc,inc_visota

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
inc_visota
	ld a,(cur_visota+1)
	inc a
	halt
	halt
	halt
	ld (cur_visota+1),a
	jp selectsprite
dec_visota
	ld a,(cur_visota+1)
	cp 1
	jp z,selectsprite
	inc a
	halt
	halt
	halt
	ld (cur_visota+1),a
	jp selectsprite

pushselsprite
	ld b,10
.l0	halt
	djnz .l0

	ld a,(cur_x+1)
	ld l,a
	ld a,(cur_y+1)
	ld h,a
	call hl2scr

	ld a,(cur_len+1)
	ld (.l3+1),a

	ld a,(cur_visota+1)
	add a,a
	add a,a
	add a,a
	ld b,a
	ld de,#c000
.l1 push bc
	push hl
.l3	ld bc,#0000
	ldir
	pop hl
	INC H       ;стандартный даун
	LD A,H
	AND 7
	JR NZ,.l2
	LD A,L
	SUB #E0
	LD L,A
	JR NC,.l2
	LD A,H
	SUB 8
	LD H,A
.l2:
	pop bc
	djnz .l1

	ret


boxor:
cur_len:
	ld b,1
lll0:
	push hl
cur_visota:
	ld c,1
.l1:
	ld a,%01000001
	xor (hl)
	ld (hl),a
	ld de,#20
	add hl,de
	dec c
	jr nz,.l1
	pop hl
	inc l
	djnz lll0
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

	savesna "konvert2.sna",SnaStart