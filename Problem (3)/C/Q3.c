#include <stdio.h>
#include <stdint.h>

// Function to calculate parity for a given mask and data
uint16_t calculateParity(uint16_t data, uint16_t mask)
{
    uint16_t maskedData = data & mask;
    uint16_t parity = 0;

    // Count 1s in masked data
    while (maskedData != 0)
    {
        parity ^= (maskedData & 1);
        maskedData >>= 1;
    }

    return parity;
}

// Function to expand 8-bit data to 13-bit Hamming code
uint16_t expandToHamming(uint8_t input)
{
    uint16_t expanded = 0;

    // Place data bits in their positions
    // bit 7 to 12
    expanded |= ((input >> 7) & 1) << 12;
    // bit 6 to 11
    expanded |= ((input >> 6) & 1) << 11;
    // bit 5 to 10
    expanded |= ((input >> 5) & 1) << 10;
    // bit 4 to 9
    expanded |= ((input >> 4) & 1) << 9;
    // bit 3 to 7
    expanded |= ((input >> 3) & 1) << 7;
    // bit 2 to 6
    expanded |= ((input >> 2) & 1) << 6;
    // bit 1 to 5
    expanded |= ((input >> 1) & 1) << 5;
    // bit 0 to 3
    expanded |= (input & 1) << 3;

    // Define parity masks (equivalent to the LDR instructions in assembly)
    const uint16_t MASK_P1 = 0x0AA8; // Mask for parity bit 1
    const uint16_t MASK_P2 = 0x0CC8; // Mask for parity bit 2
    const uint16_t MASK_P4 = 0x10E0; // Mask for parity bit 4
    const uint16_t MASK_P8 = 0x1E00; // Mask for parity bit 8
    const uint16_t MASK_P0 = 0x1FFE; // Mask for overall parity

    // Calculate and set parity bits
    expanded |= calculateParity(expanded, MASK_P1) << 1; // p1
    expanded |= calculateParity(expanded, MASK_P2) << 2; // p2
    expanded |= calculateParity(expanded, MASK_P4) << 4; // p4
    expanded |= calculateParity(expanded, MASK_P8) << 8; // p8
    expanded |= calculateParity(expanded, MASK_P0);      // p0

    return expanded;
}

// Utility function to print binary representation
void printBinary(uint16_t num, int bits)
{
    printf("Binary (%d bits): ", bits);
    for (int i = bits - 1; i >= 0; i--)
    {
        printf("%d", (num >> i) & 1);
        if (i % 4 == 0)
            printf(" "); // Space every 4 bits for readability
    }
    printf("\n");
}

int main()
{
    // Original 8-bit input (0xB3 = 179 in decimal)
    uint8_t input = 0xB3;

    printf("Input byte (0x%02X):\n", input);
    printBinary(input, 8);

    // Expand to 13-bit Hamming code
    uint16_t hammingCode = expandToHamming(input);

    printf("\nHamming code (13-bit):\n");
    printf("Hexadecimal: 0x%04X\n", hammingCode);
    printBinary(hammingCode, 13);

    return 0;
}