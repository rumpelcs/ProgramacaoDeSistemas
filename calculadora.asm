section .data
    msg_num1    db "Digite o primeiro numero (0-9): ", 0
    len_num1    equ $ - msg_num1

    msg_num2    db "Digite o segundo numero (0-9): ", 0
    len_num2    equ $ - msg_num2

    msg_menu    db 10, "Escolha a operacao:", 10
                db "1. Soma (+)", 10
                db "2. Subtracao (-)", 10
                db "3. Multiplicacao (*)", 10
                db "4. Divisao (/)", 10
                db "Opcao: ", 0
    len_menu    equ $ - msg_menu

    msg_res     db 10, "Resultado: ", 0
    len_res     equ $ - msg_res

    msg_erro_div db 10, "Erro: Divisao por zero!", 10, 0
    len_erro_div equ $ - msg_erro_div

    msg_invalida db 10, "Opcao invalida!", 10, 0
    len_invalida equ $ - msg_invalida

    nova_linha  db 10, 0

section .bss
    num1        resb 2
    num2        resb 2
    opcao       resb 2
    resultado   resb 4

section .text
    global _start

_start:
    ; --- Pedir Primeiro Número ---
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_num1
    mov edx, len_num1
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 2          ; Lê o caractere e a quebra de linha
    int 0x80

    ; --- Pedir Segundo Número ---
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_num2
    mov edx, len_num2
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 2
    int 0x80

    ; --- Exibir Menu ---
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_menu
    mov edx, len_menu
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, opcao
    mov edx, 2
    int 0x80

    ; --- Converter ASCII para Inteiro ---
    mov al, [num1]
    sub al, '0'         ; Converte caractere ASCII ('0'-'9') para valor numérico
    mov bl, [num2]
    sub bl, '0'

    ; --- Selecionar Operação ---
    mov cl, [opcao]
    cmp cl, '1'
    je  op_soma
    cmp cl, '2'
    je  op_sub
    cmp cl, '3'
    je  op_mult
    cmp cl, '4'
    je  op_div

    ; Se a opção não for de 1 a 4:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_invalida
    mov edx, len_invalida
    int 0x80
    jmp fim

op_soma:
    add al, bl
    jmp exibir_resultado

op_sub:
    sub al, bl
    jmp exibir_resultado

op_mult:
    mul bl              ; Multiplica AL por BL (resultado vai para AX)
    jmp exibir_resultado

op_div:
    cmp bl, 0           ; Verifica se o divisor é zero
    je  erro_divisao

    mov ah, 0           ; Limpa AH para a divisão de 8 bits
    div bl              ; Divide AX por BL (quociente em AL, resto em AH)
    jmp exibir_resultado

erro_divisao:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_erro_div
    mov edx, len_erro_div
    int 0x80
    jmp fim

exibir_resultado:
    ; --- Converter Inteiro para ASCII ---
    add al, '0'
    mov [resultado], al

    ; Exibe a mensagem "Resultado: "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_res
    mov edx, len_res
    int 0x80

    ; Exibe o caractere do resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 1
    int 0x80

    ; Exibe uma nova linha
    mov eax, 4
    mov ebx, 1
    mov ecx, nova_linha
    mov edx, 1
    int 0x80

fim:
    ; --- Finalizar o Programa ---
    mov eax, 1          ; Syscall exit
    xor ebx, ebx        ; Código de retorno 0
    int 0x80
