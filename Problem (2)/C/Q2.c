#include <stdio.h>
#include <stdlib.h>

// Define the matrix size
#define ROWS 3
#define COLS 3

// Function prototypes
void swapColumns(int matrix[ROWS][COLS], int col1, int col2);
void printMatrix(int matrix[ROWS][COLS]);

int main()
{
    // Initialize the matrix with the same values as in the assembly
    int matrix[ROWS][COLS] = {
        {1, 2, 3},
        {1, 2, 3},
        {1, 2, 3}};

    // Column indices to swap (adjust for 0-based indexing)
    int col1 = 1; // Second column (index 1)
    int col2 = 2; // Third column (index 2)

    printf("Original matrix:\n");
    printMatrix(matrix);

    // Perform the column swap
    swapColumns(matrix, col1, col2);

    printf("Matrix after swapping columns %d and %d:\n", col1, col2);
    printMatrix(matrix);

    return 0;
}

// Function to swap columns in a matrix
void swapColumns(int matrix[ROWS][COLS], int col1, int col2)
{
    // Create temporary storage for the modified matrix
    int result[ROWS][COLS];

    // Calculate the remaining column (the one that's not being swapped)
    int remainingCol = 3 - (col1 + col2);

    // Copy and swap the columns
    for (int i = 0; i < ROWS; i++)
    {
        // Swap the specified columns
        result[i][col1] = matrix[i][col2];
        result[i][col2] = matrix[i][col1];

        // Copy the remaining column as is
        result[i][remainingCol] = matrix[i][remainingCol];
    }

    // Copy back to original matrix
    for (int i = 0; i < ROWS; i++)
    {
        for (int j = 0; j < COLS; j++)
        {
            matrix[i][j] = result[i][j];
        }
    }
}

// Function to print the matrix
void printMatrix(int matrix[ROWS][COLS])
{
    for (int i = 0; i < ROWS; i++)
    {
        for (int j = 0; j < COLS; j++)
        {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
    printf("\n");
}