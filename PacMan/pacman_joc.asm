.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "PAC-MAN",0
area_width EQU 800
area_height EQU 640
area DD 0

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

pacman equ 0
scor dd 0


symbol_width EQU 10
symbol_height EQU 20
forma_x equ 20
forma_y equ 20
pacman_x dd 30
pacman_y dd 30

latime_pacman equ 20
lungime_pacman equ 20

fantoma equ 0



include digits.inc
include letters.inc
include FORMA.inc
include fantoma1.inc
include fantoma2.inc
include fantoma3.inc
X_width EQU 40 ;dimensiune patrat din tabel
X_height EQU 39 ;

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y

make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters

	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 01CFF00h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 000000h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp


make_forma proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	lea esi, FORMA
	jmp simbol
	
simbol:
	mov ebx, forma_x
	mul ebx
	mov ebx, forma_y
	mul ebx
	add esi, eax
	mov ecx, forma_y
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, forma_y
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, forma_x
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0FFFF00h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 000000h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_forma endp



make_fantoma1 proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	lea esi, fantoma1_1
	jmp simbol
	
simbol:
	mov ebx, forma_x
	mul ebx
	mov ebx, forma_y
	mul ebx
	add esi, eax
	mov ecx, forma_y
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, forma_y
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, forma_x
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0FF0000h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 000000h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_fantoma1 endp


make_fantoma2 proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	lea esi, fantoma2_
	jmp simbol
	
simbol:
	mov ebx, forma_x
	mul ebx
	mov ebx, forma_y
	mul ebx
	add esi, eax
	mov ecx, forma_y
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, forma_y
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, forma_x
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0808000h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 000000h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_fantoma2 endp


make_fantoma3 proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	lea esi, fantoma3_
	jmp simbol
	
simbol:
	mov ebx, forma_x
	mul ebx
	mov ebx, forma_y
	mul ebx
	add esi, eax
	mov ecx, forma_y
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, forma_y
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, forma_x
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0CE00FFh
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 000000h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_fantoma3 endp



sterge_forma proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	lea esi, FORMA
	jmp simbol
	
simbol:
	mov ebx, forma_x
	mul ebx
	mov ebx, forma_y
	mul ebx
	add esi, eax
	mov ecx, forma_y
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, forma_y
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, forma_x
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0000000h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 000000h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
sterge_forma endp

sterge_forma_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call sterge_forma
	add esp, 16
endm







; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm


make_forma_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_forma
	add esp, 16
endm

make_fantoma1_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_fantoma1
	add esp, 16
endm

make_fantoma2_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_fantoma2
	add esp, 16
endm

make_fantoma3_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_fantoma3
	add esp, 16
endm

linie_orizontala macro x,y,len,color
local bucla_linie
mov eax,y
mov ebx,area_width
mul ebx
add eax,x
shl eax,2
add eax,area
mov ecx,len
bucla_linie:
mov dword ptr[eax], color
add eax,4
loop bucla_linie
ENDM

linie_verticala macro x,y,len,color
local bucla_l
mov eax,y
mov ebx, area_width
mul ebx
add eax,x
shl eax,2
add eax,area
mov ecx, len
bucla_l:
mov dword ptr[eax],color
add eax,area_width*4
loop bucla_l
endm



mancare macro x, y, latime
mov edi, x
add edi, latime

mov esi, y
add esi, latime

linie_orizontala x, y, latime, 0FFFF00h
linie_orizontala x, esi, latime, 0FFFF00h
linie_verticala x, y, latime, 0FFFF00h
linie_verticala edi, y, latime, 0FFFF00h

endm

deseneaza_labirint macro
	linie_orizontala area_width,13,area_width,0FFH
	linie_orizontala area_width,14,area_width,0FFH
	linie_orizontala area_width,15,area_width,0FFH
	linie_orizontala area_width,474,area_width,0FFH
	linie_orizontala area_width,473,area_width,0FFH
	linie_orizontala area_width,472,area_width,0FFH
	linie_verticala 0,14,459, 0FFH
	linie_verticala 1,14,459, 0FFH
	linie_verticala 2,14,459, 0FFH
	linie_verticala 639,14,460, 0FFH
	linie_verticala 638,14,460, 0FFH
	linie_verticala 637,14,460, 0FFH
	linie_orizontala 10,19,295,0FFH
	linie_orizontala 10,20,295,0FFH
	linie_orizontala 10,21,295,0FFH
	linie_verticala 305, 19,30, 0FFH
	linie_verticala 306, 19,30, 0FFH
	linie_verticala 307, 19,30, 0FFH
	linie_orizontala 305,49,20,0FFH
	linie_orizontala 306,50,20,0FFH
	linie_orizontala 307,51,20,0FFH
	linie_verticala 325, 21,30, 0FFH
	linie_verticala 326, 20,30, 0FFH
	linie_verticala 327, 19,30, 0FFH
	linie_orizontala 327,21,304,0FFH
	linie_orizontala 326,20,304,0FFH
	linie_orizontala 325,19,304,0FFH
	linie_verticala 629, 19, 60, 0FFH
	linie_verticala 630, 20, 60, 0FFH
	linie_verticala 631, 21, 60, 0FFH
	linie_orizontala 575,81,57, 0FFH 
	linie_orizontala 574, 80, 57, 0FFH
	linie_orizontala 573, 79, 57, 0FFH
	linie_verticala 575, 79, 40, 0FFH
	linie_verticala 574, 80, 40, 0FFH
	linie_verticala 573, 81, 40, 0FFH
	linie_orizontala 575, 119, 57, 0FFH
	linie_orizontala 574, 120, 57, 0FFH
	linie_orizontala 573, 121, 57, 0FFH
	linie_verticala 629, 119,80,0FFH
	linie_verticala 630, 120,80,0FFH
	linie_verticala 631, 121,80,0FFH
    linie_orizontala 532, 201, 100, 0FFH
	linie_orizontala 531, 200, 100, 0FFH
	linie_orizontala 530, 199, 100, 0FFH
	linie_verticala 531, 199,50,0FFH
    linie_verticala 530, 200,50,0FFH
	linie_verticala 529, 201,50,0FFH
	linie_orizontala 529,251,100,0FFH
	linie_orizontala 530,250,100,0FFH
	linie_orizontala 531,249,100,0FFH
	linie_verticala 629,249, 90, 0FFH
	linie_verticala 630,250, 90, 0FFH
	linie_verticala 631,251, 90, 0FFH
	linie_orizontala 570, 341, 62, 0FFH
	linie_orizontala 570, 340, 62, 0FFH
	linie_orizontala 570, 339, 62, 0FFH
	linie_verticala 570, 339, 30, 0FFH
	linie_verticala 571, 339, 30, 0FFH
	linie_verticala 572, 339, 30, 0FFH
	linie_orizontala 570, 369,62, 0FFH
	linie_orizontala 570, 370,62, 0FFH
	linie_orizontala 570, 371,62, 0FFH
	linie_verticala 632, 369, 100, 0FFH
	linie_verticala 631, 369, 100, 0FFH
	linie_verticala 630, 369, 100, 0FFH
	linie_orizontala 10,470, 295, 0FFH
	linie_orizontala 10,469, 295, 0FFH
	linie_orizontala 10,468, 295, 0FFH
	linie_verticala 305, 441, 30, 0FFH
	linie_verticala 306, 441, 30, 0FFH
	linie_verticala 307, 441, 30, 0FFH
	linie_orizontala 305,441,23, 0FFH
	linie_orizontala 305,440,23, 0FFH
	linie_orizontala 305,439,23, 0FFH
	linie_verticala 325, 441,30, 0FFH
	linie_verticala 326, 441,30, 0FFH
	linie_verticala 327, 441,30, 0FFH
	linie_orizontala 327,470,306, 0FFH
	linie_orizontala 327,469,306, 0FFH
	linie_orizontala 327,468,306, 0FFH
	linie_verticala 10, 19, 60, 0FFH
	linie_verticala 9,19,60, 0FFH
	linie_verticala 8,19,60, 0FFH
	linie_orizontala 8, 79, 57, 0FFH
	linie_orizontala 8, 80,57,0FFH
	linie_orizontala 8, 81,57,0FFH
	linie_verticala 65, 79, 40, 0FFH
	linie_verticala 64, 79, 40, 0FFH
	linie_verticala 63, 79, 40, 0FFH
	linie_orizontala 8, 119,57, 0FFH
	linie_orizontala 8, 120,57, 0FFH
	linie_orizontala 8, 121,57, 0FFH
	linie_verticala 8, 121, 80, 0FFH
	linie_verticala 9, 121, 80, 0FFH
	linie_verticala 10, 121, 80, 0FFH
	linie_orizontala 8, 201, 100, 0FFH
	linie_orizontala 8, 200, 100, 0FFH
	linie_orizontala 8, 199, 100, 0FFH
	linie_verticala 108, 199, 50, 0FFH
	linie_verticala 109, 199, 50, 0FFH
	linie_verticala 110, 199, 50, 0FFH
	linie_orizontala 8,249, 102, 0FFH
	linie_orizontala 8,250, 102, 0FFH
	linie_orizontala 8,251, 102, 0FFH
	linie_verticala 8, 251, 90, 0FFH
	linie_verticala 9, 251, 90, 0FFH
	linie_verticala 10, 251, 90, 0FFH
	linie_orizontala 8, 341, 62, 0FFH
	linie_orizontala 8, 340, 62, 0FFH
	linie_orizontala 8, 339, 62, 0FFH
	linie_verticala 70, 339, 30, 0FFH
	linie_verticala 71, 339, 30, 0FFH
	linie_verticala 72, 339, 30, 0FFH
	linie_orizontala 8, 369, 64, 0FFH
	linie_orizontala 8, 370, 64, 0FFH
	linie_orizontala 8, 371, 64, 0FFH
	linie_verticala 8, 371,100, 0FFH
	linie_verticala 9, 371,100, 0FFH
	linie_verticala 10, 371,100, 0FFH
	linie_verticala 305, 125, 30, 0ffh
	linie_verticala 306, 125, 30, 0ffh
	linie_verticala 307, 125, 30, 0ffh
	linie_orizontala 305, 125, 20, 0ffh
	linie_orizontala 305, 126, 20, 0ffh
	linie_orizontala 305, 127, 20, 0ffh
	linie_verticala 325, 125, 30, 0ffh
	linie_verticala 324, 125, 30, 0ffh
	linie_verticala 323, 125, 30, 0ffh
	linie_orizontala 323, 155, 30, 0ffh
	linie_orizontala 323, 156, 30, 0ffh
	linie_orizontala 323, 157, 30, 0ffh
	linie_verticala 353, 155, 20, 0ffh
	linie_verticala 352, 155, 20, 0ffh
	linie_verticala 351, 155, 20, 0ffh
	linie_orizontala 323, 175, 30, 0ffh
	linie_orizontala 323, 174, 30, 0ffh
	linie_orizontala 323, 173, 30, 0ffh
	linie_verticala 323,175, 30, 0ffh
	linie_verticala 324,175, 30, 0ffh
	linie_verticala 325,175, 30, 0ffh
	linie_orizontala 305, 205, 20, 0ffh
	linie_orizontala 305, 204, 20, 0ffh
	linie_orizontala 305, 203, 20, 0ffh
	linie_verticala 305, 173, 30, 0ffh
	linie_verticala 306, 173, 30, 0ffh
	linie_verticala 307, 173, 30, 0ffh
	linie_orizontala 277,173,30, 0ffh 
	linie_orizontala 277,172,30, 0ffh 
	linie_orizontala 277,171,30, 0ffh 
	linie_verticala 277, 153,20,0ffh
	linie_verticala 278, 153,20,0ffh
	linie_verticala 279, 153,20,0ffh
	linie_orizontala 277, 153, 30,0ffh
	linie_orizontala 277, 154, 30,0ffh
	linie_orizontala 277, 155, 30,0ffh
	linie_verticala 200, 300, 30, 0ffh
	linie_verticala 201, 300, 30, 0ffh
	linie_verticala 202, 300, 30, 0ffh
	linie_orizontala 200, 300, 20,0ffh
	linie_orizontala 200, 301, 20,0ffh
	linie_orizontala 200, 302, 20,0ffh
	linie_verticala 220, 300, 30, 0ffh
	linie_verticala 219, 300, 30, 0ffh
	linie_verticala 218, 300, 30, 0ffh
	linie_orizontala 218, 330,30, 0ffh
	linie_orizontala 218, 331,30, 0ffh
	linie_orizontala 218, 332,30, 0ffh
	linie_verticala 248, 330, 20, 0ffh
	linie_verticala 247, 330, 20, 0ffh
	linie_verticala 246, 330, 20, 0ffh
	linie_orizontala 218, 350, 30, 0ffh
	linie_orizontala 218, 349, 30, 0ffh
	linie_orizontala 218, 348, 30, 0ffh
	linie_verticala 218, 348, 30, 0ffh
	linie_verticala 217, 348, 30, 0ffh
	linie_verticala 216, 348, 30, 0ffh
	linie_orizontala 198, 378, 20, 0ffh
	linie_orizontala 198, 377, 20, 0ffh
	linie_orizontala 198, 376, 20, 0ffh
	linie_verticala 198, 348, 30, 0ffh
	linie_verticala 199, 348, 30, 0ffh
	linie_verticala 200, 348, 30, 0ffh
	linie_orizontala 170,348, 30, 0ffh
	linie_orizontala 170,347, 30, 0ffh
	linie_orizontala 170,346, 30, 0ffh
	linie_verticala 170, 328, 20, 0ffh
	linie_verticala 171, 328, 20, 0ffh
	linie_verticala 172, 328, 20, 0ffh
	linie_orizontala 170, 328, 32, 0ffh
	linie_orizontala 170, 329, 32, 0ffh
	linie_orizontala 170, 330, 32, 0ffh
	linie_verticala 400, 300, 30,0ffh
	linie_verticala 401, 300, 30,0ffh
	linie_verticala 402, 300, 30,0ffh
	linie_orizontala 400, 300, 20, 0ffh
	linie_orizontala 400, 301, 20, 0ffh
	linie_orizontala 400, 302, 20, 0ffh
	linie_verticala 420, 300, 30, 0ffh
	linie_verticala 419, 300, 30, 0ffh
	linie_verticala 418, 300, 30, 0ffh
	linie_orizontala 418, 330, 30, 0ffh
	linie_orizontala 418, 331, 30, 0ffh
	linie_orizontala 418, 332, 30, 0ffh
	linie_verticala 448, 330, 20, 0ffh
	linie_verticala 447, 330, 20, 0ffh
	linie_verticala 446, 330, 20, 0ffh
	linie_orizontala 418, 350, 30, 0ffh
	linie_orizontala 418, 349, 30, 0ffh
	linie_orizontala 418, 348, 30, 0ffh
	linie_verticala 418, 348, 30, 0ffh 
	linie_verticala 417, 348, 30, 0ffh 
	linie_verticala 416, 348, 30, 0ffh 
	linie_orizontala 398, 378, 20, 0ffh
	linie_orizontala 398, 377, 20, 0ffh
	linie_orizontala 398, 376, 20, 0ffh
	linie_verticala 398, 348, 30, 0ffh
	linie_verticala 399, 348, 30, 0ffh
	linie_verticala 400, 348, 30, 0ffh
	linie_orizontala 370, 348, 30, 0ffh
    linie_orizontala 370, 347, 30, 0ffh
	linie_orizontala 370, 346, 30, 0ffh
	linie_verticala  370, 328, 20, 0ffh
	linie_verticala  371, 328, 20, 0ffh
    linie_verticala  372, 328, 20, 0ffh	
	linie_orizontala 370, 328, 32, 0ffh
	linie_orizontala 370, 329, 32, 0ffh
    linie_orizontala 370, 330, 32, 0ffh	
	linie_verticala 150, 70, 60, 0ffh
	linie_verticala 151, 70, 60, 0ffh
	linie_verticala 152, 70, 60, 0ffh
	linie_orizontala 150, 70, 30, 0ffh
	linie_orizontala 150, 71, 30, 0ffh
	linie_orizontala 150, 72, 30, 0ffh
	linie_verticala 180, 70, 30, 0ffh
	linie_verticala 179, 70, 30, 0ffh
	linie_verticala 178, 70, 30, 0ffh
	linie_orizontala 178, 100, 30, 0ffh
	linie_orizontala 178, 101, 30, 0ffh
	linie_orizontala 178, 102, 30, 0ffh
	linie_verticala 208, 100, 30, 0ffh
	linie_verticala 207, 100, 30, 0ffh
	linie_verticala 206, 100, 30, 0ffh
	linie_orizontala 150, 130, 60, 0ffh
	linie_orizontala 150, 129, 60, 0ffh
	linie_orizontala 150, 128, 60, 0ffh
	linie_verticala 490, 70, 60, 0ffh
	linie_verticala 489, 70, 60, 0ffh
	linie_verticala 488, 70, 60, 0ffh
	linie_orizontala 430, 130, 60, 0ffh
	linie_orizontala 430, 129, 60, 0ffh
	linie_orizontala 430, 128, 60, 0ffh
	linie_verticala 430,100,30,0ffh
	linie_verticala 429,100,30,0ffh
	linie_verticala 428,100,30,0ffh
	linie_orizontala 430, 100,30,0ffh
	linie_orizontala 430, 99,30,0ffh
	linie_orizontala 430, 98,30,0ffh
	linie_verticala 460,70,30,0ffh
	linie_verticala 459,70,30,0ffh
	linie_verticala 458,70,30,0ffh
	linie_orizontala 458,70,30,0ffh
	linie_orizontala 458,69,30,0ffh
	linie_orizontala 458,68,30,0ffh
	endm


; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 0
	push area
	call memset
	add esp, 12

		 mancare 50,50,5
		 mancare 70,50,5
		 mancare 90,50,5
     	  mancare 110,50,5
		   mancare 130,50,5
		    mancare 150,50,5
			 mancare 170,50,5
			  mancare 190,50,5
			   mancare 210,50,5
			    mancare 230,50,5
				 mancare 250,50,5
				  mancare 270,50,5
				   mancare 290,50,5
				   mancare 330,50,5
					  mancare 350,50,5
     	  mancare 370,50,5
		   mancare 390,50,5
		    mancare 410,50,5
			 mancare 430,50,5
			    mancare 450,50,5
				mancare 470,50,5
				  mancare 490,50,5
				   mancare 510,50,5
				    mancare 530,50,5
					 mancare 550,50,5
					  mancare 570,50,5
				   mancare 590,50,5
				   mancare 610,50,5
				 mancare 30,70,5
				 mancare 50,70,5
		 mancare 70,70,5
		 mancare 90,70,5
     	  mancare 110,70,5
		   mancare 130,70,5
		    mancare 190,70,5
			 mancare 210,70,5
			    mancare 230,70,5
				 mancare 250,70,5
				  mancare 270,70,5
				   mancare 290,70,5
				    mancare 310,70,5
					 mancare 330,70,5
		 mancare 350,70,5
     	  mancare 370,70,5
		   mancare 390,70,5
		    mancare 410,70,5
			 mancare 430,70,5
			    mancare 450,70,5
				  mancare 490,70,5
				   mancare 510,70,5
				    mancare 530,70,5
					 mancare 550,70,5
				  mancare 570,70,5
				   mancare 590,70,5
				    mancare 610,70,5
		 mancare 70,30,5
		 mancare 90,30,5
     	  mancare 110,30,5
		   mancare 130,30,5
		    mancare 150,30,5
			 mancare 170,30,5
			  mancare 190,30,5
			   mancare 210,30,5
			    mancare 230,30,5
				 mancare 250,30,5
				  mancare 270,30,5
				   mancare 290,30,5
				    mancare 330,30,5
		 mancare 350,30,5
     	  mancare 370,30,5
		   mancare 390,30,5
		    mancare 410,30,5
			 mancare 430,30,5
			    mancare 450,30,5
				mancare 470,30,5
				  mancare 490,30,5
				   mancare 510,30,5
				    mancare 530,30,5
					 mancare 550,30,5
				  mancare 570,30,5
				  mancare 590,30,5
				  mancare 610,30,5
				    mancare 70,90,5
		 mancare 90,90,5
     	  mancare 110,90,5
		   mancare 130,90,5
			   mancare 190,90,5
			   mancare 210,90,5
			    mancare 230,90,5
				 mancare 250,90,5
				  mancare 270,90,5
				   mancare 290,90,5
				   mancare 310,90,5
				    mancare 330,90,5
		 mancare 350,90,5
     	  mancare 370,90,5
		   mancare 390,90,5
		    mancare 410,90,5
			 mancare 430,90,5
			    mancare 450,90,5
				  mancare 490,90,5
				   mancare 510,90,5
				    mancare 530,90,5
					 mancare 550,90,5
					   mancare 70,110,5
		 mancare 90,110,5
     	  mancare 110,110,5
		   mancare 130,110,5
			   mancare 210,110,5
			    mancare 230,110,5
				 mancare 250,110,5
				  mancare 270,110,5
				   mancare 290,110,5
				   mancare 310,110,5
				    mancare 330,110,5
		 mancare 350,110,5
     	  mancare 370,110,5
		   mancare 390,110,5
		    mancare 410,110,5
				 mancare 490,110,5
				   mancare 510,110,5
				    mancare 530,110,5
					 mancare 550,110,5
					 mancare 30,130,5
					 mancare 50,130,5
					  mancare 70,130,5
		 mancare 90,130,5
     	  mancare 110,130,5
		   mancare 130,130,5
			   mancare 210,130,5
			    mancare 230,130,5
				 mancare 250,130,5
				  mancare 270,130,5
				   mancare 290,130,5
				   mancare 330,130,5
		 mancare 350,130,5
     	  mancare 370,130,5
		   mancare 390,130,5
		    mancare 410,130,5
				 mancare 490,130,5
				   mancare 510,130,5
				    mancare 530,130,5
					 mancare 550,130,5
					 mancare 570,130,5
					 mancare 590,130,5
					 mancare 610,130,5
					  mancare 30,150,5
					   mancare 50,150,5
					   mancare 70,150,5
		 mancare 90,150,5
     	  mancare 110,150,5
		   mancare 130,150,5
		   mancare 150,150,5
		   mancare 170,150,5
		   mancare 190,150,5
			   mancare 210,150,5
			    mancare 230,150,5
				 mancare 250,150,5
				  mancare 270,150,5
		 mancare 350,150,5
     	  mancare 370,150,5
		   mancare 390,150,5
		    mancare 410,150,5
			mancare 430,150,5
			mancare 450,150,5
			mancare 470,150,5
				 mancare 490,150,5
				   mancare 510,150,5
				    mancare 530,150,5
					 mancare 550,150,5
					 mancare 570,150,5
					 mancare 590,150,5
					 mancare 610,150,5
					 
					  mancare 30,170,5
					   mancare 50,170,5
					   mancare 70,170,5
		 mancare 90,170,5
     	  mancare 110,170,5
		   mancare 130,170,5
		   mancare 150,170,5
		   mancare 170,170,5
		   mancare 190,170,5
			   mancare 210,170,5
			    mancare 230,170,5
				 mancare 250,170,5
				  mancare 270,170,5
		 ;mancare 350,170,5
     	  mancare 370,170,5
		   mancare 390,170,5
		    mancare 410,170,5
			mancare 430,170,5
			mancare 450,170,5
			mancare 470,170,5
				 mancare 490,170,5
				   mancare 510,170,5
				    mancare 530,170,5
					 mancare 550,170,5
					 mancare 570,170,5
					 mancare 590,170,5
					 mancare 610,170,5
					 
					  mancare 30,190,5
					   mancare 50,190,5
					   mancare 70,190,5
		 mancare 90,190,5
     	  mancare 110,190,5
		   mancare 130,190,5
		   mancare 150,190,5
		   mancare 170,190,5
		   mancare 190,190,5
			   mancare 210,190,5
			    mancare 230,190,5
				 mancare 250,190,5
				  mancare 270,190,5
				  mancare 290,190,5
				  mancare 330,190,5
		 mancare 350,190,5
     	  mancare 370,190,5
		   mancare 390,190,5
		    mancare 410,190,5
			mancare 430,190,5
			mancare 450,190,5
			mancare 470,190,5
				 mancare 490,190,5
				   mancare 510,190,5
				    mancare 530,190,5
					 mancare 550,190,5
					 mancare 570,190,5
					 mancare 590,190,5
					 mancare 610,190,5
					 
					
		 
     	  mancare 110,210,5
		   mancare 130,210,5
		   mancare 150,210,5
		   mancare 170,210,5
		   mancare 190,210,5
			   mancare 210,210,5
			    mancare 230,210,5
				 mancare 250,210,5
				 mancare 270,210,5
				  mancare 290,210,5
				 mancare 310,210,5
				 mancare 330,210,5
		 mancare 350,210,5
     	  mancare 370,210,5
		   mancare 390,210,5
		    mancare 410,210,5
			mancare 430,210,5
			mancare 450,210,5
			mancare 470,210,5
				 mancare 490,210,5
				   mancare 510,210,5
				   
				     mancare 110,230,5
		   mancare 130,230,5
		   mancare 150,230,5
		   mancare 170,230,5
		   mancare 190,230,5
			   mancare 210,230,5
			    mancare 230,230,5
				 mancare 250,230,5
				 mancare 270,230,5
				  mancare 290,230,5
				 mancare 310,230,5
				 mancare 330,230,5
		 mancare 350,230,5
     	  mancare 370,230,5
		   mancare 390,230,5
		    mancare 410,230,5
			mancare 430,230,5
			mancare 450,230,5
			mancare 470,230,5
				 mancare 490,230,5
				   mancare 510,230,5
				   
				 mancare 110,250,5
		   mancare 130,250,5
		   mancare 150,250,5
		   mancare 170,250,5
		   mancare 190,250,5
			   mancare 210,250,5
			    mancare 230,250,5
				 mancare 250,250,5
				 mancare 270,250,5
				  mancare 290,250,5
				 mancare 310,250,5
				 mancare 330,250,5
		 mancare 350,250,5
     	  mancare 370,250,5
		   mancare 390,250,5
		    mancare 410,250,5
			mancare 430,250,5
			mancare 450,250,5
			mancare 470,250,5
				 mancare 490,250,5
				   mancare 510,250,5
				   
				
					mancare 30,270,5
					   mancare 50,270,5
					   mancare 70,270,5
		 mancare 90,270,5
     	  mancare 110,270,5
		   mancare 130,270,5
		   mancare 150,270,5
		   mancare 170,270,5
		   mancare 190,270,5
			   mancare 210,270,5
			    mancare 230,270,5
				 mancare 250,270,5
				  mancare 270,270,5
				  mancare 290,270,5
				  mancare 310,270,5
				  mancare 330,270,5
		 mancare 350,270,5
     	  mancare 370,270,5
		   mancare 390,270,5
		    mancare 410,270,5
			mancare 430,270,5
			mancare 450,270,5
			mancare 470,270,5
				 mancare 490,270,5
				   mancare 510,270,5
				    mancare 530,270,5
					 mancare 550,270,5
					 mancare 570,270,5
					 mancare 590,270,5
					 mancare 610,270,5
					 
					 mancare 30,290,5
					   mancare 50,290,5
					   mancare 70,290,5
		 mancare 90,290,5
     	  mancare 110,290,5
		   mancare 130,290,5
		   mancare 150,290,5
		   mancare 170,290,5
		   mancare 190,290,5
			   mancare 210,290,5
			    mancare 230,290,5
				 mancare 250,290,5
				  mancare 270,290,5
				  mancare 290,290,5
				  mancare 310,290,5
				  mancare 330,290,5
		 mancare 350,290,5
     	  mancare 370,290,5
		   mancare 390,290,5
		    mancare 410,290,5
			mancare 430,290,5
			mancare 450,290,5
			mancare 470,290,5
				 mancare 490,290,5
				   mancare 510,290,5
				    mancare 530,290,5
					 mancare 550,290,5
					 mancare 570,290,5
					 mancare 590,290,5
					 mancare 610,290,5
					 
					 mancare 30,310,5
					   mancare 50,310,5
					   mancare 70,310,5
		 mancare 90,310,5
     	  mancare 110,310,5
		   mancare 130,310,5
		   mancare 150,310,5
		   mancare 170,310,5
		   mancare 190,310,5
			   ; mancare 210,290,5
			    mancare 230,310,5
				 mancare 250,310,5
				  mancare 270,310,5
				  mancare 290,310,5
				  mancare 310,310,5
				  mancare 330,310,5
		 mancare 350,310,5
     	  mancare 370,310,5
		   mancare 390,310,5
		    ;mancare 410,290,5
			mancare 430,310,5
			mancare 450,310,5
			mancare 470,310,5
				 mancare 490,310,5
				   mancare 510,310,5
				    mancare 530,310,5
					 mancare 550,310,5
					 mancare 570,310,5
					 mancare 590,310,5
					 mancare 610,310,5
					 
					  mancare 30,330,5
					   mancare 50,330,5
					   mancare 70,330,5
		 mancare 90,330,5
     	  mancare 110,330,5
		   mancare 130,330,5
		   mancare 150,330,5
				  mancare 270,330,5
				  mancare 290,330,5
				  mancare 310,330,5
				  mancare 330,330,5
		 mancare 350,330,5
			mancare 450,330,5
			mancare 470,330,5
				 mancare 490,330,5
				   mancare 510,330,5
				    mancare 530,330,5
					 mancare 550,330,5
					 mancare 570,330,5
					 mancare 590,330,5
					 mancare 610,330,5
					 
		 
		 mancare 90,350,5
					  mancare 110,350,5
		   mancare 130,350,5
		   mancare 150,350,5
				  mancare 270,350,5
				  mancare 290,350,5
				  mancare 310,350,5
				  mancare 330,350,5
		 mancare 350,350,5
		 mancare 370,350,5
			mancare 450,350,5
			mancare 470,350,5
				 mancare 490,350,5
				   mancare 510,350,5
				    mancare 530,350,5
					 mancare 550,350,5
					 
		mancare 90,370,5		 
     	  mancare 110,370,5
		   mancare 130,370,5
		   mancare 150,370,5
		   mancare 170,370,5
		   mancare 190,370,5
			   ; mancare 210,290,5
			    mancare 230,370,5
				 mancare 250,370,5
				  mancare 270,370,5
				  mancare 290,370,5
				  mancare 310,370,5
				  mancare 330,370,5
		 mancare 350,370,5
     	  mancare 370,370,5
		   mancare 390,370,5
			mancare 430,370,5
			mancare 450,370,5
			mancare 470,370,5
				 mancare 490,370,5
				   mancare 510,370,5
				    mancare 530,370,5
					 mancare 550,370,5
					 
					  mancare 30,390,5
					   mancare 50,390,5
					   mancare 70,390,5
		 mancare 90,390,5
     	  mancare 110,390,5
		   mancare 130,390,5
		   mancare 150,390,5
		   mancare 170,390,5
		   mancare 190,390,5
			   mancare 210,390,5
			    mancare 230,390,5
				 mancare 250,390,5
				  mancare 270,390,5
				  mancare 290,390,5
				  mancare 310,390,5
				  mancare 330,390,5
		 mancare 350,390,5
     	  mancare 370,390,5
		   mancare 390,390,5
		    mancare 410,390,5
			mancare 430,390,5
			mancare 450,390,5
			mancare 470,390,5
				 mancare 490,390,5
				   mancare 510,390,5
				    mancare 530,390,5
					 mancare 550,390,5
					 mancare 570,390,5
					 mancare 590,390,5
					 mancare 610,390,5
					 
					  mancare 30,410,5
					   mancare 50,410,5
					   mancare 70,410,5
		 mancare 90,410,5
     	  mancare 110,410,5
		   mancare 130,410,5
		   mancare 150,410,5
		   mancare 170,410,5
		   mancare 190,410,5
			   mancare 210,410,5
			    mancare 230,410,5
				 mancare 250,410,5
				  mancare 270,410,5
				  mancare 290,410,5
				  mancare 310,410,5
				  mancare 330,410,5
		 mancare 350,410,5
     	  mancare 370,410,5
		   mancare 390,410,5
		    mancare 410,410,5
			mancare 430,410,5
			mancare 450,410,5
			mancare 470,410,5
				 mancare 490,410,5
				   mancare 510,410,5
				    mancare 530,410,5
					 mancare 550,410,5
					 mancare 570,410,5
					 mancare 590,410,5
					 mancare 610,410,5
					 
					   mancare 30,430,5
					   mancare 50,430,5
					   mancare 70,430,5
		 mancare 90,430,5
     	  mancare 110,430,5
		   mancare 130,430,5
		   mancare 150,430,5
		   mancare 170,430,5
		   mancare 190,430,5
			   mancare 210,430,5
			    mancare 230,430,5
				 mancare 250,430,5
				  mancare 270,430,5
				  mancare 290,430,5
				  mancare 310,430,5
				  mancare 330,430,5
		 mancare 350,430,5
     	  mancare 370,430,5
		   mancare 390,430,5
		    mancare 410,430,5
			mancare 430,430,5
			mancare 450,430,5
			mancare 470,430,5
				 mancare 490,430,5
				   mancare 510,430,5
				    mancare 530,430,5
					 mancare 550,430,5
					 mancare 570,430,5
					 mancare 590,430,5
					 mancare 610,430,5
					 
					 mancare 30,450,5
					   mancare 50,450,5
					   mancare 70,450,5
		 mancare 90,450,5
     	  mancare 110,450,5
		   mancare 130,450,5
		   mancare 150,450,5
		   mancare 170,450,5
		   mancare 190,450,5
			   mancare 210,450,5
			    mancare 230,450,5
				 mancare 250,450,5
				  mancare 270,450,5
				  mancare 290,450,5
				  ;mancare 310,450,5
				  mancare 330,450,5
		 mancare 350,450,5
     	  mancare 370,450,5
		   mancare 390,450,5
		    mancare 410,450,5
			mancare 430,450,5
			mancare 450,450,5
			mancare 470,450,5
				 mancare 490,450,5
				   mancare 510,450,5
				    mancare 530,450,5
					 mancare 550,450,5
					 mancare 570,450,5
					 mancare 590,450,5
					 mancare 610,450,5
				
				

				
					 
					 
				   
	
	
	
evt_click:
	mov edi, area
	mov ecx, area_height
	mov ebx, [ebp+arg2]
	verificari:
	prima:
	cmp pacman_x,20
	je verifica_jos
	doi:
	cmp pacman_y,450
	je verifica_sus 
	trei:
	cmp pacman_x,610
	je verifica_stanga 
	patru:
	cmp pacman_x,20
	je verifica_dreapta
	cinci:
	cmp pacman_x,130
	jne verifica_dreapta
	cmp pacman_y, 70
	je verifica_stanga
	cmp pacman_y, 90
	je verifica_stanga
	cmp pacman_y, 110
	je verifica_stanga
	sase:
	cmp pacman_x,290
	jne verifica_dreapta
	cmp pacman_y,30
	je verifica_jos
	 ; cmp pacman_x,70
	 ; je verifica_dreapta
	; cmp pacman_y,90
	; je verifica_dreapta
	; cmp pacman_x,330
	; jne verifica_stanga
	; cmp pacman_y,30
	; je verifica_jos
	; cmp pacman_x,410
	; je verifica_stanga
	; cmp pacman_y, 110
	; je verifica_stanga
	; opt:
	; cmp pacman_x, 490 
	; jne verifica_sus
	; cmp pacman_y, 70
	; je verifica_sus
	; cmp pacman_y, 90
	; je verifica_sus
	; cmp pacman_y, 110
	; je verifica_sus
	; cmp pacman_x,190
	; je verifica_y
	; verifica_y:
	; cmp pacman_y,190
	; je game_over
	verifica_dreapta:
   cmp ebx, 370
   jnge verifica_stanga
   cmp ebx, 430
   jnle verifica_stanga
muta_dreapta :
sterge_forma_macro pacman, area, pacman_x,pacman_y
mov ecx, pacman_x
add ecx, latime_pacman
mov pacman_x, ecx
inc scor
jmp final

verifica_stanga:
 cmp ebx, 260
   jnge verifica_jos
   cmp ebx, 310
 jnle verifica_jos

 muta_stanga :
sterge_forma_macro pacman, area, pacman_x,pacman_y
mov ecx, pacman_x
sub ecx, latime_pacman
mov pacman_x, ecx
inc scor
jmp final


verifica_jos:
cmp ebx, 180
   jnge verifica_sus
  cmp ebx, 200
   jnle verifica_sus
muta_jos :
sterge_forma_macro pacman, area, pacman_x,pacman_y
mov ecx, pacman_y
add ecx, lungime_pacman
mov pacman_y, ecx
inc scor
jmp final

verifica_sus:
cmp ebx, 100
   jnge final
  cmp ebx, 120
   jnle final
muta_sus :
sterge_forma_macro pacman, area, pacman_x,pacman_y
mov ecx, pacman_y
sub ecx, lungime_pacman
mov pacman_y, ecx
inc scor 
jmp final

game_over:
	  make_text_macro 'G',area,400,600
	 ; make_text_macro 'A',area,380,550
	 ; make_text_macro 'M',area,390,550
	 ; make_text_macro 'E',area,400,550
	 ; make_text_macro 'O',area,410,550
	 ; make_text_macro 'V',area,420,550
	 ; make_text_macro 'E',area,430,550
	 ; make_text_macro 'R',area,430,550


final :

	
evt_timer:
	inc counter
	


	
afisare_litere:
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, scor
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 400, 500
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 390, 500
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 380, 500
	
	;scriem un mesaj
	 make_text_macro 'P', area, 700, 50
	 make_text_macro 'A', area, 700, 80
	 make_text_macro 'C', area, 700, 110
	 make_text_macro 'M', area, 700, 140
	 make_text_macro 'A', area, 700, 170
	 make_text_macro 'N', area, 700, 200
	 
	 make_text_macro 'S' ,area, 100,550
	 make_text_macro 'U',area, 110,550
	 make_text_macro 'S',area,120,550
	 
	 make_text_macro 'J',area,180,550
	 make_text_macro 'O',area,190,550
	 make_text_macro 'S',area,200,550
	 
	 make_text_macro 'S',area,260,550
	 make_text_macro 'T',area,270,550
	 make_text_macro 'A',area,280,550
	 make_text_macro 'N',area,290,550
	 make_text_macro 'G',area,300,550
	 make_text_macro 'A',area,310,550
	 
	 make_text_macro 'D',area,370,550
	 make_text_macro 'R',area,380,550
	 make_text_macro 'E',area,390,550
	 make_text_macro 'A',area,400,550
	 make_text_macro 'P',area,410,550
	 make_text_macro 'T',area,420,550
	 make_text_macro 'A',area,430,550
	 
	 make_forma_macro pacman,area, pacman_x,pacman_y
	 deseneaza_labirint
	 make_fantoma1_macro fantoma,area, 200,200
	make_fantoma2_macro fantoma,area, 300,400
	make_fantoma3_macro fantoma, area, 550,100
	make_fantoma3_macro fantoma,area, 545,270
	  
	
	
	 
	
	 
	 
	 

final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	 push area
	 push area_height
	 push area_width
	 push offset window_title
	call BeginDrawing
	add esp, 16
	
	;terminarea programului
	push 0
	call exit
end start
