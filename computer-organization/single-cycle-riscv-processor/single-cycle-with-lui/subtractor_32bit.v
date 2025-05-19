// 32-bit Subtractor Module
// This module performs subtraction of two 32-bit numbers using 2's complement method.

module subtractor_32bit(
    input [31:0] a, // 32-bit input a
    input [31:0] b, // 32-bit input b
    output [31:0] difference, // 32-bit output difference (a - b)
    output cout // Carry out
);
    wire [31:0] b_complement; // Wire to hold the 2's complement of b
    
    // We calculate the 2's complement of b by inverting b and adding 1
    assign b_complement = ~b + 1'b1;
    
    // We use a 32-bit full adder to perform the subtraction
    fulladder_32bit sub(
        .a(a), // 32-bit input a
        .b(b_complement), // 32-bit input b (2's complement of b)
        .cin(1'b0), // Carry input (0 for subtraction)
        .sum(difference), // 32-bit sum output (result of a - b)
        .cout(cout) // Carry output
    );
endmodule