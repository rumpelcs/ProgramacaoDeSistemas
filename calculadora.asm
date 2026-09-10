section .data

    menu db 10
         db "==========================", 10
         db "       CALCULADORA", 10
         db "==========================", 10
         db "1 - Soma", 10
         db "2 - Subtracao", 10
         db "3 - Multiplicacao", 10
         db "4 - Divisao", 10
         db "0 - Sair", 10
         db "Escolha: "

    menu_len equ $ - menu


    msg1 db "Digite o primeiro numero: "
    msg1_len equ $ - msg1

    msg2 db "Digite o segundo numero: "
    msg2_len equ $ - msg2

    msg_resultado db "Resultado: "
    msg_resultado_len equ $ - msg_resultado

    msg_zero db "Erro: divisao por zero!", 10
    msg_zero_len equ $ - msg_zero

    msg_invalido db "Opcao invalida!", 10
    msg_invalido_len equ $ - msg_invalido

    quebra db 10


section .bss

    escolha resb 2

    numero1 resb 32
    numero2 resb 32

    resultado resb 32


section .text

    global _main


_main:

menu_principal:

    ; Mostrar menu

    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, menu_len
    int 0x80

    ; Ler escolha

    mov eax, 3
    mov ebx, 0
    mov ecx, escolha
    mov edx, 2
    int 0x80

    ; Verificar escolha

    mov al, [escolha]

    cmp al, '0'
    je sair

    cmp al, '1'
    je soma

    cmp al, '2'
    je subtracao

    cmp al, '3'
    je multiplicacao

    cmp al, '4'
    je divisao

    jmp opcao_invalida

soma:

    call ler_numeros

    ; numero1 + numero2

    mov eax, [numero1]
    add eax, [numero2]

    ; Guardar resultado

    mov [resultado], eax

    jmp mostrar_resultado

subtracao:

    call ler_numeros

    ; numero1 - numero2

    mov eax, [numero1]
    sub eax, [numero2]

    ; Guardar resultado

    mov [resultado], eax

    jmp mostrar_resultado

multiplicacao:

    call ler_numeros

    ; numero1 * numero2

    mov eax, [numero1]
    imul eax, [numero2]

    ; Guardar resultado

    mov [resultado], eax

    jmp mostrar_resultado

divisao:

    call ler_numeros

    ; Verificar se numero2 == 0

    cmp dword [numero2], 0
    je divisao_zero

    ; EAX = numero1

    mov eax, [numero1]

    ; Preparar EDX:EAX para divisao

    cdq

    ; EAX / numero2

    idiv dword [numero2]

    ; Guardar quociente

    mov [resultado], eax

    jmp mostrar_resultado

ler_numeros:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, msg1_len
    int 0x80


    ; Ler texto

    mov eax, 3
    mov ebx, 0
    mov ecx, numero1
    mov edx, 32
    int 0x80


    ; Converter ASCII para inteiro

    mov esi, numero1

    call ascii_para_inteiro

    ; Resultado da conversao fica em EAX

    mov [numero1], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, msg2_len
    int 0x80

    ; Ler texto

    mov eax, 3
    mov ebx, 0
    mov ecx, numero2
    mov edx, 32
    int 0x80


    ; Converter ASCII para inteiro

    mov esi, numero2

    call ascii_para_inteiro

    ; Guardar numero

    mov [numero2], eax

    ret



; ==========================================================
; ASCII PARA INTEIRO
;
; Entrada:
; ESI = endereco da string
;
; Saida:
; EAX = numero inteiro
;
; Aceita:
;
; 123
; -123
; 0
; ==========================================================

ascii_para_inteiro:

    xor eax, eax        ; resultado = 0

    xor ebx, ebx        ; EBX = 0
    xor ecx, ecx

    ; Verificar sinal negativo

    mov bl, [esi]

    cmp bl, '-'
    jne converter_digitos

    ; Se for negativo

    inc esi

    mov ecx, 1          ; ECX = sinal negativo


converter_digitos:

    mov bl, [esi]

    ; Verificar ENTER

    cmp bl, 10
    je conversao_final

    ; Verificar fim

    cmp bl, 0
    je conversao_final

    ; Converter ASCII para numero

    sub bl, '0'

    ; EAX = EAX * 10

    imul eax, eax, 10

    ; EAX = EAX + digito

    add eax, ebx

    ; Proximo caractere

    inc esi

    jmp converter_digitos



conversao_final:

    ; Verificar se era negativo

    cmp ecx, 1
    jne conversao_positiva

    neg eax


conversao_positiva:

    ret

mostrar_resultado:

    ; Mostrar "Resultado: "

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_resultado
    mov edx, msg_resultado_len
    int 0x80


    ; Converter inteiro para ASCII

    mov eax, [resultado]

    mov edi, resultado

    call inteiro_para_ascii


    ; EAX = tamanho da string

    mov edx, eax

    ; ECX = endereco da string

    mov ecx, resultado


    ; Mostrar resultado

    mov eax, 4
    mov ebx, 1
    int 0x80


    ; Quebra de linha

    mov eax, 4
    mov ebx, 1
    mov ecx, quebra
    mov edx, 1
    int 0x80


    ; Voltar ao menu

    jmp menu_principal



; ==========================================================
; INTEIRO PARA ASCII
;
; Entrada:
; EAX = numero
; EDI = endereco do buffer
;
; Saida:
; EAX = tamanho da string
; ==========================================================

inteiro_para_ascii:

    ; Salvar registradores

    push ebx
    push ecx
    push edx
    push esi


    ; Verificar se o numero e negativo

    cmp eax, 0
    jge numero_positivo


    ; Colocar '-'

    mov byte [edi], '-'

    inc edi

    ; Transformar em positivo

    neg eax


numero_positivo:

    ; Caso especial: numero = 0

    cmp eax, 0
    jne converter_numero

    mov byte [edi], '0'

    mov eax, 1

    jmp fim_inteiro_ascii

converter_numero:

    xor ecx, ecx

    mov ebx, 10

dividir:

    xor edx, edx

    div ebx

    ; EDX possui o resto

    add dl, '0'

    push edx

    inc ecx

    cmp eax, 0

    jne dividir

    mov esi, ecx


escrever:

    pop edx

    mov [edi], dl

    inc edi

    loop escrever


    ; EAX = quantidade de caracteres

    mov eax, esi


fim_inteiro_ascii:

    ; Verificar se o numero original era negativo
    ; Se havia '-' precisamos adicionar 1 ao tamanho

    ; Neste ponto fica mais simples calcular pelo
    ; endereco final - inicio do buffer.

    ; Restaurar registradores

    pop esi
    pop edx
    pop ecx
    pop ebx

    ret

opcao_invalida:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_invalido
    mov edx, msg_invalido_len
    int 0x80

    jmp menu_principal

divisao_zero:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_zero
    mov edx, msg_zero_len
    int 0x80

    jmp menu_principal

sair:

    mov eax, 1
    mov ebx, 0
    int 0x80
