.org 0010h

MVI H, 10H
MVI L, 00H
MVI M, 77H      ; 77h resulta no numero 0 no display

INR L
MVI M, 11H      ; 11H resulta no numero 1 no display

INR L
MVI M, 3EH      ; 3EH resulta no numero 2 no display

INR L
MVI M, 6EH      ; 6EH resulta no numero 3 no display

INR L
MVI M, 4DH      ; 4DH resulta no numero 4 no display

INR L
MVI M, 6BH      ; 6BH resulta no numero 5 no display

INR L
MVI M, 7BH      ; 7BH resulta no numero 6 no display

INR L
MVI M, 46H      ; 46H resulta no numero 7 no display

INR L
MVI M, 7FH      ; 7FH resulta no numero 8 no display

INR L
MVI M, 6FH      ; 6FH resulta no numero 9 no display

; porta de entrada associada ao teclado eh 03H
; lê numero total de segundos:

IN 03H

SBI 30H         ; transforma numero inserido em binario puro
MOV B, A        ; registrador B armazena quantos segundos faltam

MOV L, A        ; M contem o endereco do numero de segundos inicial

JMP LOOP


DELAY_UMS: OUT 10H
; FAZER ROTINA DE DELAY AQUI
JMP 0045H                  ; salta para loop linha MOV A, B

LOOP: MOV A, M             ; passa para o acumulador o numero para o display
OUT 00H                    ; mostra o numero de segundos faltantes
JMP DELAY_UMS
MOV A, B                   ; acumulador recebe numero de segundos faltantes
DCR A                      ; decrementa o numero de segundos faltantes
DCR L                      ; decrementa endereco de memoria para ir para o proximo numero
JNZ LOOP
JMP FIM


FIM: OUT 00H
; FAZER ROTINA DE FINALIZACAO AQUI

HLT