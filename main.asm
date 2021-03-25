; Trabalho de Assembly: 8085
; Organizacao e Arquitetura de Computadores
; Nomes: Jhennifer Matias e Milena Fernandes
; Professor: Roderval Marcelino
; Descrição: 4 Timers de no maximo 9s
.define
    TIMER1 00H
    TIMER2 01H
    TIMER3 02H
    TIMER4 03H

.org 0010h

    MVI D, 00H      ; registrador D armazena número do timer atual

    LXI H, 1000H
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

    MVI A, 11H              ; mostra numero do timer
    OUT 07H
    IN TIMER1               ; le numero para a primeira contagem
    CALL COMECA_CONTAGEM    ; inicia o timer
    MVI A, 3EH              ; mostra numero do timer
    OUT 07H
    IN TIMER2               ; le numero para a segunda contagem
    CALL COMECA_CONTAGEM    ; inicia o timer
    MVI A, 6EH              ; mostra numero do timer
    OUT 07H
    IN TIMER3               ; le numero para a terceira contagem
    CALL COMECA_CONTAGEM    ; inicia o timer
    MVI A, 4DH              ; mostra numero do timer
    OUT 07H
    IN TIMER4               ; le numero para a quarta contagem
    CALL COMECA_CONTAGEM    ; inicia o timer
    JMP FIM                 ; fim do programa
; porta de entrada associada ao teclado eh 03H
; lê numero total de segundos:

COMECA_CONTAGEM:
    MOV B, A                   ; registrador B armazena quantos segundos faltam

    MOV L, A                   ; M contem o endereco do numero de segundos inicial

    CALL LOOP
    RET


DELAY_UMS: 
; FAZER ROTINA DE DELAY AQUI
    RET                        ; salta para continuacao do loop

LOOP: 
    MOV A, M                   ; passa para o acumulador o numero para o display
    OUT 00H                    ; mostra o numero de segundos faltantes
    CALL DELAY_UMS
    MOV A, B                   ; acumulador recebe numero de segundos faltantes
    DCR A                      ; decrementa o numero de segundos faltantes
    DCR L                      ; decrementa endereco de memoria para ir para o proximo numero
    MOV A, M                   ; passa para o acumulador o numero para o display
    OUT 00H                    ; mostra o numero de segundos faltantes
    JNZ LOOP                   ; terminou de decrementar? 
    RET                        ; se sim, le o proximo numero


FIM: 
    MOV A, M
    OUT 00H                  
; FAZER ROTINA DE FINALIZACAO AQUI

HLT
; PARA EXECUTAR: 
; DISPLAY 7-SEG EH PORTA 00H
; FILEIRA DO PAINEL DE LEDS: PORTA 10H A 13H
; INTERRUPTORES: ENTRADAS 00H A 03H