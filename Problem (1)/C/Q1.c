#include <stdio.h>

int main(void)
{
    int num1, num2;
    int sum = 0;
    int total = 0;

    printf("Enter the first number: ");
    scanf("%d", &num1);

    printf("Enter the second number: ");
    scanf("%d", &num2);

    for (int i = 0; i < num2; ++i)
    {
        printf("\n========================\n");
        printf("%d", sum);
        sum = sum * 10 + num1;
        total += sum;
        printf(" -> %d\n", sum);
        printf("Total: %d\n", total);
        printf("========================\n");
    }

    printf("Function Result: %d\n", total);
}