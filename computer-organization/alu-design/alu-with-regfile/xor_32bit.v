// 32-bit XOR gate
// This module takes two 32-bit inputs and performs a bitwise XOR operation

module xor_32bit(
    input [31:0] a, // First 32-bit input
    input [31:0] b, // Second 32-bit input
    output [31:0] result // 32-bit output for the result of the XOR operation
);  
    assign result = a ^ b; // Perform bitwise XOR operation on the inputs
endmodule