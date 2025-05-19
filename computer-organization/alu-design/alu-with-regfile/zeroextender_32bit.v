// This module takes a 1-bit input and zero-extends it to a 32-bit output.
// The output will have the 1-bit input in the least significant bit position, and the rest of the bits will be zero.

module zeroextender_32bit(
    input i, // 1-bit input
    output [31:0] o // 32-bit output
);
    assign o = {31'b0, i}; // Zero-extend the 1-bit input to 32 bits
endmodule