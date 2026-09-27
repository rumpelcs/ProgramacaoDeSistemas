#include <stdio.h>
#include "calculadora.h"

int main() {
    float num1, num2, resultado;
    int opcao;

    printf("===== CALCULADORA =====\n");

    printf("Digite o primeiro numero: ");
    scanf("%f", &num1);

    printf("Digite o segundo numero: ");
    scanf("%f", &num2);

    printf("\nEscolha a operacao:\n");
    printf("1 - Soma\n");
    printf("2 - Subtracao\n");
    printf("3 - Multiplicacao\n");
    printf("4 - Divisao\n");
    printf("Opcao: ");
    scanf("%d", &opcao);

    switch (opcao) {
        case 1:
            resultado = soma(num1, num2);
            printf("\nResultado: %.2f\n", resultado);
            break;

        case 2:
            resultado = subtracao(num1, num2);
            printf("\nResultado: %.2f\n", resultado);
            break;

        case 3:
            resultado = multiplicacao(num1, num2);
            printf("\nResultado: %.2f\n", resultado);
            break;

        case 4:
            if (num2 == 0) {
                printf("\nErro: nao e possivel dividir por zero!\n");
            } else {
                resultado = divisao(num1, num2);
                printf("\nResultado: %.2f\n", resultado);
            }
            break;

        default:
            printf("\nOpcao invalida!\n");
    }

    return 0;
}