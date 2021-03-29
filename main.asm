; Trabalho de Assembly: 8085
; Organizacao e Arquitetura de Computadores
; Nomes: Jhennifer Matias e Milena Fernandes
; Professor: Roderval Marcelino
; Descricao: 4 Timers de no maximo 9s com interrupcao
; para campeonatos de cubo magico 2x2

.define
    START       00H         ; porta de entrada do botao de start
    TIMER1      01H         ; porta de entrada do primeiro timer
    TIMER2      02H         ; porta de entrada do segundo timer
    TIMER3      03H         ; porta de entrada do terceiro timer
    TIMER4      04H         ; porta de entrada do quarto timer
    INTERRUP    05H         ; porta de entrada para interromper contagem

; dados para os numeros do display
.data 1000h
    DB 77H, 11H, 3EH, 6EH, 4DH, 6BH, 7BH, 46H, 7FH, 6FH

; primeira linha da tela de texto
.data E000H
    DB 50H, 72H, 69H, 6DH, 65H, 69H, 72H, 6FH, 20H, 63H, 75H, 62H, 6FH, 3AH, 00H, 73H

; segunda linha da tela de texto
.data E028H
    DB 53H, 65H, 67H, 75H, 6EH, 64H, 6FH, 20H, 63H, 75H, 62H, 6FH, 3AH, 00H, 73H

; terceira linha da tela de texto
.data E050H
    DB 54H, 65H, 72H, 63H, 65H, 69H, 72H, 6FH, 20H, 63H, 75H, 62H, 6FH, 3AH, 00H, 73H

; quarta linha da tela de texto
.data E078H
    DB 51H, 75H, 61H, 72H, 74H, 6FH, 20H, 63H, 75H, 62H, 6FH, 3AH, 00H, 73H

; linha de total da tela de texto
.data E0D7H
    DB 54H, 6FH, 74H, 61H, 6CH, 3AH, 00H, 00H, 73H

.org 0010h
COMECO:
    IN START                ; verifica botao start
    XRI 00H
    JZ COMECO               ; se nao esta pressionado, volta para comeco

    MVI H, 10H

R1:
    IN INTERRUP             ; nao inicia contagem enquanto interrupcao esta ativada
    XRI 00H
    JNZ R1
    MVI A, 11H              ; mostra numero do timer
    OUT 07H
    IN TIMER1               ; le numero para a primeira contagem
    CALL COMECA_CONTAGEM    ; inicia o timer
    IN TIMER1               ; obtem tempo real decorrido
    SUB L
    ADI 30H
    MVI H, E0H
    MVI L, 0EH
    MOV M, A                ; coloca tempo decorrido na tela de texto
    MVI A, FFH
    OUT 08H
R2:
    IN INTERRUP             ; nao inicia contagem enquanto interrupcao esta ativada
    XRI 00H
    JNZ R2
    MVI A, 3EH              ; mostra numero do timer
    OUT 07H
    IN TIMER2               ; le numero para a segunda contagem
    MVI H, 10H
    CALL COMECA_CONTAGEM    ; inicia o timer
    IN TIMER2               ; obtem tempo real decorrido
    SUB L
    ADI 30H
    MVI H, E0H
    MVI L, 35H
    MOV M, A                ; coloca tempo decorrido na tela de texto
    MVI A, FFH
    OUT 09H
R3:
    IN INTERRUP             ; nao inicia contagem enquanto interrupcao esta ativada
    XRI 00H
    JNZ R3
    MVI A, 6EH              ; mostra numero do timer
    OUT 07H
    IN TIMER3               ; le numero para a terceira contagem
    MVI H, 10H
    CALL COMECA_CONTAGEM    ; inicia o timer
    IN TIMER3               ; obtem tempo real decorrido
    SUB L
    ADI 30H
    MVI H, E0H
    MVI L, 5EH
    MOV M, A                ; coloca tempo decorrido na tela de texto
    MVI A, FFH
    OUT 0AH
R4:
    IN INTERRUP             ; nao inicia contagem enquanto interrupcao esta ativada
    XRI 00H
    JNZ R4
    MVI A, 4DH              ; mostra numero do timer
    OUT 07H                 
    IN TIMER4               ; le numero para a quarta contagem
    MVI H, 10H
    CALL COMECA_CONTAGEM    ; inicia o timer
    IN TIMER4               ; obtem tempo real decorrido
    SUB L
    ADI 30H
    MVI H, E0H
    MVI L, 84H
    MOV M, A                ; coloca tempo decorrido na tela de texto
    MVI A, FFH
    OUT 0BH
    JMP FIM                 ; fim do programa
; porta de entrada associada ao teclado eh 03H
; le numero total de segundos:

COMECA_CONTAGEM:

    MOV L, A                   ; M contem o endereco do numero de segundos inicial

    CALL LOOP
    RET


DELAY_UMS: 
	LXI B, 1000H
	DELAY: 
		DCX B
        MOV A, B
        ORA C
   		JNZ DELAY
        
    RET

LOOP: 
    MOV A, M                   ; passa para o acumulador o numero para o display
    OUT 00H                    ; mostra o numero de segundos faltantes
    CALL DELAY_UMS
    CALL DELAY_UMS
    IN INTERRUP                ; verifica se interrupcao foi ativada
    XRI 00H
    RNZ                        ; se sim, retorna
    DCR L                      ; decrementa endereco de memoria para ir para o proximo numero
    MOV A, M                   ; passa para o acumulador o numero para o display
    OUT 00H                    ; mostra o numero de segundos faltantes
    JNZ LOOP                   ; terminou de decrementar? 
    RET                        ; se sim, le o proximo numero

; le os segundos decorridos memoria e soma o total (em hex)
FIM:
    MVI A, 00H                 ; comeca com 0
    MVI H, E0H
    MVI L, 0EH                 ; atualiza endereco
    ADD M                      ; soma ao acumulador
    SBI 30H                    ; passa para binario puro
    MVI L, 35H                 ; atualiza endereco
    ADD M                      ; soma ao acumulador
    SBI 30H                    ; passa para binario puro
    MVI L, 5EH                 ; atualiza endereco
    ADD M                      ; soma ao acumulador
    SBI 30H                    ; passa para binario puro
    MVI L, 84H                 ; atualiza endereco
    ADD M                      ; soma ao acumulador
    SBI 30H                    ; passa para binario puro
    MVI L, DEH                 ; atualiza endereco para o total
    MVI B, 00H                 ; dezenas comecam com 0

; loop para a impressao: retira valor das dezenas e unidades (base decimal)
LOOP_IMP:
    SBI 0AH             ; subtrai 10 do numero hex
    JM IMP              ; termina loop se resultado for negativo
    INR B               ; se nao, incrementa dezenas
    JMP LOOP_IMP        ; realiza loop novamente

; final da impressao: coloca os valores das unidades e dezenas na tela de texto
IMP: 
    ADI 3AH             ; coma novamente os 10 mais 30h para transformar em ASCII
    MOV M, A            ; mostra na tela de texto
    MVI L, DDH
    MOV A, B            ; passa dezenas para acumulador
    ADI 30H             ; transforma em ascii
    MOV M, A            ; mostra na tela de texto

HLT
; PARA EXECUTAR: 
; DISPLAY 7-SEG EH PORTA 00H E 007 PARA MOSTRAR NUMERO DO TIMER
; FILEIRA DO PAINEL DE LEDS: 08H A 0BH
; INTERRUPTORES: ENTRADAS 00H A 05H (START + 4 TIMERS + INTERRUPCAO)