// Shift Left Logical (SLL) 32-bit Module
// This module performs a logical left shift on a 32-bit input based on a 5-bit shift amount.

module sll_32bit(
    input [31:0] a, // 32-bit input a
    input [4:0] shamt, // 5-bit shift amount (0-31)
    output [31:0] result // 32-bit output result (a shifted left by shamt bits)
);
    // Intermediate wires for each stage of the shift
    // Each stage represents a different bit shift (1, 2, 4, 8, and 16 bits)
    wire [31:0] shift1, shift2, shift4, shift8, shift16;
    
    // 1 bit shift
    // If shamt[0] is 1, shift left by 1 bit and fill the least significant bit with 0
    assign shift1 = shamt[0] ? {a[30:0], 1'b0} : a;
    
    // 2 bit shift
    // If shamt[1] is 1, shift left by 2 bits and fill the least significant 2 bits with 0
    assign shift2 = shamt[1] ? {shift1[29:0], 2'b00} : shift1;
    
    // 4 bit shift
    // If shamt[2] is 1, shift left by 4 bits and fill the least significant 4 bits with 0
    assign shift4 = shamt[2] ? {shift2[27:0], 4'b0000} : shift2;
    
    // 8 bit shift
    // If shamt[3] is 1, shift left by 8 bits and fill the least significant 8 bits with 0
    assign shift8 = shamt[3] ? {shift4[23:0], 8'b00000000} : shift4;
    
    // 16 bit shift
    // If shamt[4] is 1, shift left by 16 bits and fill the least significant 16 bits with 0
    assign shift16 = shamt[4] ? {shift8[15:0], 16'b0000000000000000} : shift8;
    
    // Final result is the output of the last shift stage
    assign result = shift16;
endmodule