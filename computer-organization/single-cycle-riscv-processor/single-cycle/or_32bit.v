// 32-bit OR operation module

module or_32bit(
    input [31:0] a, // 32-bit input a
    input [31:0] b, // 32-bit input b
    output [31:0] result // 32-bit output result
);
    assign result = a | b; // Performs bitwise OR operation on a and b
endmodule