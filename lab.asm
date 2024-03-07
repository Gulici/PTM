 ORG 0000H
 MOV 30H, #0aH 		;1 arg 8bit
 MOV 31H, #02H 		;2 arg 8bit
 MOV 40H, #0ffH 		;H 1 arg 16bit
 MOV 41H, #0H 		;L 1 arg 16bit
 MOV 42H, #0ffH  	;H 2 arg 16bit
 MOV 43H, #05H 		;L 2 arg 16bit 
 
 
 ;dodawanie 8bit
 MOV A, 30H 		; przeniesienie do akum. 1 arg
 MOV R0, #00H		; wyzerowanie rejestru na ew. przeniesienie -  czemu zeruje przy okazji komorke 0x00H?
 ADD A, 31H			; dodanie argumentow 
 JNC END_ADD1
 INC R0				; ew. zapisanie zapisanie przeniesienia - rejestry zapisywane w RAM?
 END_ADD1:
 MOV 33H, R0		; zapisanie wyniku do pamieci
 MOV 34H, A			; zapisanie przeniesienia do pamieci
 
 ;dodawanie 16b
 MOV R0, #41H 		; zapisanie adresu starszego bajtu arg1 - wskaznik 
 MOV R1, #43H		; zapisanie adresu starszego bajtu arg2	- wskaznik
 MOV A, @R0			; skopiowanie do akumulatora wartosci wskazywanej przez adres przechowywany w R0
 ADD A, @R1			; 
 MOV 46H, A			; zapisanie sumy mlodszych bitow do pamieci
 DEC R0
 DEC R1
 MOV A, @R0
 ADDC A, @R1
 MOV 45H, A
 JNC END_ADD2
 MOV 44H, #01
 END_ADD2:
 
 ;mnozenie 8b
 mov A, 30H
 mov B, 31H
 mul AB
 
 ;mnozenie 16b problem z 5 i 6 bajtem wyniku
 mov r0, 40H	;H1
 mov r1, 41H	;L1
 mov r2, 42H	;H2
 mov r3, 43H	;L2
 mov r4, #0		;r4-r5 rejestry na wynik
 mov r5, #0
 mov r6, #0
 mov r7, #0
 mov A, r1 		; L1 x L2
 mov B, r3
 mul AB
 mov r4, A		;0-7
 mov r5, B		;8-15
 mov A, r1		; L1 x H2
 mov B, r2
 mul AB
 add A, r5		;8-15
 mov r5, A
 mov r6, B		;16-23
 mov A, r0		; H1 x L2
 mov B, r3
 mul AB
 add A ,r5		;8-15
 mov r5, A
 mov A, B
 addc A, r6		;16-23
 jnc after3
 inc r7		 	; 24-32
 after3:
 mov A, r0		;H1 x H2
 mov B, r2
 mul AB
 add A, r6		;16-23
 mov r6, A
 mov A, B
 addc A, r7		;24-32
 mov r7, A
 
 
 ;dzielenie 8b
 mov A, 30H
 mov B, 31H
 div AB 			; A - wynik B - reszta
 
 
 
 ;operacje na tablicy
 mov 50H, #12		;inicjalizacja tablicy
 mov 51H, #01		
 mov 52H, #01
 mov 53H, #01
 mov 54H, #01
 mov 55H, #01
 mov 56H, #01
 mov 57H, #01
 mov 58H, #01
 mov 59H, #01
 mov 5aH, #01
 mov 5bH, #01
 mov 5cH, #01
 
 ;suma el. tab
 mov r0, 50H		;licznik
 mov r1, #51H		;r1 - wskaznik
 mov a, #0
 loop:
 add a, @r1
 inc r1
 djnz r0, loop
 mov r2, a
 
 
 ;NKB na BCD
 mov r1, #0 		;dlugosc tablicy
 mov DPTR, #8000h
 mov A, #248
 loop_bcd:
 mov B, #10
 div ab
 mov r0, a
 mov a, b
 movx @DPTR, a
 mov a, r0
 inc DPTR
 inc r1
 jnz loop_bcd
 
 ;BCD na asci
 mov DPTR, #8000h
 mov r0, #50H
 mov a, r1			; zachowanie dlugosci
 mov r3, a
 loop_asci1:		; pobranie wartosci do ram z xram
 movx a, @dptr
 mov @r0, a
 inc dptr
 inc r0
 djnz r1, loop_asci1
 mov r0, #50H
 loop_asci2:		; konwersja na asci 
 mov a, @r0
 add a, #30h
 movx @dptr, a
 inc r0
 inc dptr
 djnz r3, loop_asci2
 
 END
