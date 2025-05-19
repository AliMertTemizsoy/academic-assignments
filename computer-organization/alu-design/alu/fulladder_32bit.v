// 32-bit Full Adder Module
// This module takes two 32-bit inputs and a carry-in bit, and produces a 32-bit sum and a carry-out bit

module fulladder_32bit(
    input [31:0] a, // First 32-bit input
    input [31:0] b, // Second 32-bit input
    input cin, // Carry-in bit
    output [31:0] sum, // 32-bit output for the sum
    output cout // Carry-out bit
);
    wire [32:0] temp_sum; // Temporary wire to hold the sum and carry-out
    
    assign temp_sum = {1'b0, a} + {1'b0, b} + {32'b0, cin}; // Perform addition of the inputs and carry-in
    assign sum = temp_sum[31:0]; // Assign the lower 32 bits of the result to sum
    assign cout = temp_sum[32]; // Assign the 33rd bit of the result to cout (carry-out)
endmodule