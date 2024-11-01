#include <stdio.h>

int main(void)
{
    int num1, num2;
    int multiplyFactor = 1;
    int sum = 0;
    int total = 0;

    printf("Enter the first number: ");
    scanf("%d", &num1);

    printf("Enter the second number: ");
    scanf("%d", &num2);

    // Calculate multiplyFactor based on the number of digits in num1
    int temp = num1;
    while (temp > 0)
    {
        multiplyFactor *= 10;
        temp /= 10;
    }

    for (int i = 0; i < num2; ++i)
    {
        printf("\n========================\n");
        printf("%d", sum);
        // Shift `sum` and add `num1` as the next term in series
        sum = sum * multiplyFactor + num1; 
        total += sum;
        printf(" -> %d\n", sum);
        printf("Total: %d\n", total);
        printf("========================\n");
    }

    printf("Function Result: %d\n", total);
    return 0;
}
