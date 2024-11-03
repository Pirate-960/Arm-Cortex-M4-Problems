#include <stdio.h>
#include <stdlib.h>

// Function to calculate the number of digits in a number
unsigned int countDigits(unsigned int num)
{
    unsigned int factor = 1;
    while (num > 0)
    {
        factor *= 10;
        num /= 10;
    }
    return factor;
}

// Function to calculate the sum based on the pattern
unsigned int calculateSum(unsigned int a, unsigned int n)
{
    unsigned int total = 0;      // Equivalent to r0
    unsigned int currentSum = 0; // Equivalent to r4
    unsigned int factor;         // Equivalent to r5

    // Calculate multiplication factor based on number of digits
    factor = countDigits(a);

    // Main loop - equivalent to the 'loop' label in assembly
    for (unsigned int i = 0; i < n; i++)
    {
        // Multiply and accumulate: r4 = (r4 * factor) + a
        currentSum = (currentSum * factor) + a;
        // Add to total: r0 = r0 + r4
        total += currentSum;
    }

    return total;
}

int main()
{
    // Initialize input values (equivalent to the DCD directive in assembly)
    unsigned int a = 45; // First input value
    unsigned int n = 3;  // Second input value

    // Calculate and print result
    unsigned int result = calculateSum(a, n);

    printf("Input values: a = %u, n = %u\n", a, n);
    printf("Result: %u\n", result);

    // Show the calculation pattern
    printf("\nCalculation pattern:\n");
    unsigned int currentSum = 0;
    unsigned int factor = countDigits(a);
    for (unsigned int i = 0; i < n; i++)
    {
        currentSum = (currentSum * factor) + a;
        printf("Step %u: %u\n", i + 1, currentSum);
    }

    return 0;
}