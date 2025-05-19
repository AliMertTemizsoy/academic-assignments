// 32-bit Full Adder Module

module fulladder_32bit(
    input [31:0] a, // 32-bit input a
    input [31:0] b, // 32-bit input b
    input cin, // Carry input
    output [31:0] sum, // 32-bit sum output
    output cout // Carry output
);
    wire [32:0] temp_sum; // Temporary wire to hold the sum and carry out
    
    assign temp_sum = {1'b0, a} + {1'b0, b} + {32'b0, cin}; // Perform addition with carry
    // The first 32 bits are the sum, and the 33rd bit is the carry out  
    
    assign sum = temp_sum[31:0]; // Assign the lower 32 bits to sum
    assign cout = temp_sum[32]; // Assign the 33rd bit to cout (carry out)
endmodule